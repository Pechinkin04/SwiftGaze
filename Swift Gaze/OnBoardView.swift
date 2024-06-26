import SwiftUI
import StoreKit

struct OnBoardingView: View {
    
    @State private var currentPage: Int = 0
    @Binding public var isOnboardingCompleted: Bool
    var isReview: Bool
    let pushNotificationManager = PushNotificationManager()
    
    var body: some View {
        ZStack {
            OnBoardingCards(currentPage: $currentPage, isReview: isReview)
            
            VStack {
                Spacer()
                
                VStack {
                    
                    if isReview {
                        if currentPage == 0 {
                            Text("All cases in one place")
                                .font(.title)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                        } else if currentPage == 1 {
                            Text("Control your tasks with one click")
                                .font(.title)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                        }
                    } else {
                        if currentPage == 0 {
                            Text("Increase your earnings")
                                .font(.title)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                        } else if currentPage == 1 {
                            Text("Rate our app in the AppStore")
                                .font(.title)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                        }
                    }
            
                    HStack() {
                        if currentPage < 2 {
                            HStack(spacing: 8) {
                                ForEach(0..<2) { index in
                                    Rectangle()
                                        .frame(width: 10, height: 10)
                                        .rotationEffect(.degrees(45))
                                        .foregroundColor(index == currentPage ? Color.buttonNormal : Color.buttonDisabled)
                                        .padding(4)
                                }
                            }
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity)
                        }
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                if isReview {
                                    if currentPage < 1 {
                                        currentPage += 1
                                    } else {
                                        isOnboardingCompleted = true
                                    }
                                } else {
                                    if currentPage == 0 {
                                        currentPage += 1
                                    } else if currentPage == 1 {
                                        SKStoreReviewController.requestReview()
                                        currentPage += 1
                                    } else {
                                        Task {
                                            let _ = try? await pushNotificationManager.registerForNotifications()
                                            
                                        }
                                        isOnboardingCompleted = true
                                    }
                                }
                            }
                        } label: {
                            Text("Next")
                                .font(.body)
                                .fontWeight(.semibold)
                                .frame(height: 56)
                                .frame(maxWidth: .infinity)
                                .background(Color.buttonNormal)
                                .cornerRadius(12)
                                .padding()
                                .foregroundColor(.white)
                            
                        }
                    }
                }
                .padding(24)
//                .padding(.horizontal, 24)
//                .padding(.top, 24)
                .padding(.bottom, 18)
                .background(Color.textWhite)
                .cornerRadius(20)
            }
        }
    }
}

#Preview {
    OnBoardingView(isOnboardingCompleted: .constant(false), isReview: true)
}


struct OnBoardingCards: View {
    
    @Binding var currentPage: Int
    var isReview: Bool
    
    var body: some View {
        Group {
            OnboardingCard(imageName: isReview ? "onBoard1" : "onBoard1User")
                .offset(x: CGFloat(0 * Int(UIScreen.main.bounds.width) - currentPage * Int(UIScreen.main.bounds.width)))
            OnboardingCard(imageName: isReview ? "onBoard2" : "onBoard2User")
                .offset(x: CGFloat(1 * Int(UIScreen.main.bounds.width) - currentPage * Int(UIScreen.main.bounds.width)))
            if !isReview {
                OnboardingCard(imageName: "onBoard3User")
                    .offset(x: CGFloat(2 * Int(UIScreen.main.bounds.width) - currentPage * Int(UIScreen.main.bounds.width)))
            }
        }
//        .frame(height: 100)
    }
}

struct OnboardingCard: View {
    var imageName: String
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
        }
        .ignoresSafeArea()
    }
}
