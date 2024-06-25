import SwiftUI
import WebKit
import CoreLocation

struct ContentViewUser: View {
    @AppStorage("isOnboardingUserCompleted") private var isOnboardingUserCompleted: Bool = false
    @AppStorage("isFirstWebOpen") private var isFirstWebOpen: Bool = true
    @AppStorage("urlString") private var urlString: String = "https://www.google.com"
    @State private var url: URL?
    @State private var showWebView: Bool = false
    
    @State private var isScreenRecordingDetected = false
    
    
    @EnvironmentObject var networkManager: NetworkManager

    var body: some View {
        ZStack {
            Group {
                if isOnboardingUserCompleted {
                    if let url = url {
                        WebView(url: url, showWebView: $showWebView, isFirstWebOpen: $isFirstWebOpen, urlString: $urlString)
                            .edgesIgnoringSafeArea(.bottom)
                            .onAppear {
                                checkTimeout()
                            }
                            .onAppear{
                                CLLocationManager().requestWhenInUseAuthorization()
                            }
                    } else {
                        LoaderView(isReview: false)
                            .onAppear {
                                fetchRemoteConfig()
                            }
                    }
                } else {
                    OnBoardingView(isOnboardingCompleted: $isOnboardingUserCompleted, isReview: false)
                        .background(Color.black)
                }
            }
            // Затемнение экрана
            if isScreenRecordingDetected {
                Color.black
                    .edgesIgnoringSafeArea(.all)
            }

        }
        .onReceive(NotificationCenter.default.publisher(for: UIScreen.capturedDidChangeNotification)) { _ in
            self.isScreenRecordingDetected = true
        }
    }

    private func fetchRemoteConfig() {
        DispatchQueue.main.async {
            networkManager.fetchData {
                
                print(networkManager.financeData)
                
                if let finData = networkManager.financeData {
                    updateURL(from: finData)
                } else {
                    print("Config not fetched, using stored URL")
                    url = URL(string: urlString)
                }
            }
        }
    }
    
//    private func fetchRemoteConfig() {
//        let remoteConfig = RemoteConfig.remoteConfig()
//        let settings = RemoteConfigSettings()
//        settings.minimumFetchInterval = 0
//        remoteConfig.configSettings = settings
//
//        remoteConfig.fetch { status, error in
//            if status == .success {
//                print("Config fetched")
//                remoteConfig.activate { _, _ in
//                    updateURL(from: remoteConfig)
//                }
//            } else {
//                print("Config not fetched, using stored URL")
//                url = URL(string: urlString)
//            }
//        }
//    }
//
//    private func updateURL(from remoteConfig: RemoteConfig) {
//        let changeURLForAll = remoteConfig.configValue(forKey: "isChangeAllURL").boolValue
//        if changeURLForAll, let urlLink = remoteConfig.configValue(forKey: "url_link").stringValue {
//            print("Change URL-----------")
//            url = URL(string: urlLink)
//            isFirstWebOpen = false
//            urlString = urlLink
//        } else if isFirstWebOpen, let urlLink = remoteConfig.configValue(forKey: "url_link").stringValue {
//            print("First Open-----------")
//            url = URL(string: urlLink)
//            isFirstWebOpen = false
//            urlString = urlLink
//        } else {
//            print("Open old-----------")
//            url = URL(string: urlString)
//        }
//    }
    
    private func updateURL(from financeData: ResponseDataFinanse) {
        if financeData.isChangeAllURL == "true" {
            print("Change URL-----------")
            url = URL(string: financeData.url_link)
            isFirstWebOpen = false
            urlString = financeData.url_link
        } else if isFirstWebOpen {
            print("First Open-----------")
            url = URL(string: financeData.url_link)
            isFirstWebOpen = false
            urlString = financeData.url_link
        } else {
            print("Open old-----------")
            url = URL(string: urlString)
        }
    }

    private func checkTimeout() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            if !showWebView && isFirstWebOpen {
                url = URL(string: urlString)
                isFirstWebOpen = true
            }
        }
    }
}

#Preview {
    ContentViewUser()
}

struct WebView: UIViewRepresentable {
    var url: URL
    @Binding var showWebView: Bool
    @Binding var isFirstWebOpen: Bool
    @Binding var urlString: String
    
    @EnvironmentObject var networkManager: NetworkManager

    func makeCoordinator() -> Coordinator {
        Coordinator(self, showWebView: $showWebView, isFirstWebOpen: $isFirstWebOpen, urlString: $urlString)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        var loadStartTime: Date?
        @Binding var showWebView: Bool
        @Binding var isFirstWebOpen: Bool
        @Binding var urlString: String
        @EnvironmentObject var networkManager: NetworkManager

        init(_ parent: WebView, showWebView: Binding<Bool>, isFirstWebOpen: Binding<Bool>, urlString: Binding<String>) {
            self.parent = parent
            self._showWebView = showWebView
            self._isFirstWebOpen = isFirstWebOpen
            self._urlString = urlString
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            loadStartTime = Date()
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            HTTPCookieStorage.shared.cookies?.forEach { cookie in
                webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
            }
            if let startTime = loadStartTime, Date().timeIntervalSince(startTime) <= 6 {
                showWebView = true
            }
            urlString = webView.url?.absoluteString ?? urlString
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            if isFirstWebOpen {
                fetchRemoteConfig()
                isFirstWebOpen = false
            }
        }

        private func fetchRemoteConfig() {
            if let finData = networkManager.financeData {
                self.parent.url = URL(string: finData.url_link)!
            } else {
                print("Config not fetched, using stored URL")
            }
        }
        
//        private func fetchRemoteConfig() {
//            let remoteConfig = RemoteConfig.remoteConfig()
//            let settings = RemoteConfigSettings()
//            settings.minimumFetchInterval = 0
//            remoteConfig.configSettings = settings
//
//            remoteConfig.fetch { status, error in
//                if status == .success {
//                    print("Config fetched")
//                    remoteConfig.activate { _, _ in
//                        if let urlLink = remoteConfig.configValue(forKey: "url_link").stringValue {
//                            self.parent.url = URL(string: urlLink)!
//                        }
//                    }
//                } else {
//                    print("Config not fetched")
//                }
//            }
//        }
    }
}
