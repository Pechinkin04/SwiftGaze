//
//  SettingsView.swift
//  Swift Gaze
//
//  Created by Александр Печинкин on 20.06.2024.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    
    @Environment(\.openURL) var openURL
    
    @State private var isShareSheetShowing = false
    @State private var shareApp = "https://apps.apple.com/app/swift-gaze/id6504806399"
    @State private var policy = "https://www.termsfeed.com/live/80fccef0-15bf-4e51-8805-c5c201b97d77"
    
    init() {
            //Use this if NavigationBarTitle is with Large Font
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.bgDark.ignoresSafeArea()
//                Color.bgDark.edgesIgnoringSafeArea(.top)
                
                VStack(spacing: 20) {
                    
                    Button {
                        isShareSheetShowing.toggle()
                    } label: {
                        ButtonSettingsView(text: "Share app",
                                           systImg: "square.and.arrow.up.fill")
                    }
                    .sheet(isPresented: $isShareSheetShowing, onDismiss: {
                        print("Share sheet dismissed")
                    }) {
                        ShareSheet(activityItems: [shareApp])
                    }
                    
                    Button {
                        SKStoreReviewController.requestReview()
                    } label: {
                        ButtonSettingsView(text: "Rate Us",
                                           systImg: "star.fill")
                    }
                    
                    Button {
                        openURL(URL(string: policy)!)
                    } label: {
                        ButtonSettingsView(text: "Usage Policy",
                                           systImg: "doc.text.fill")
                    }
                    
                    Spacer()
                    
                }
                .padding()
            }
            
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct ButtonSettingsView: View {
    
    var text: String
    var systImg: String
    
    var body: some View {
        HStack {
            Text(text)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.textBlack)
            
            Spacer()
            
            Image(systemName: systImg)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
                .foregroundColor(.buttonNormal)
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 24)
        .background(Color.textWhite)
        .cornerRadius(12)
    }
}
