import SwiftUI

struct MainTabView: View {
    
    @AppStorage("isOnboardingCompleted") private var isOnboardingCompleted: Bool = false
    @State var tabSelected = 0
    
    @State var shedule: [Record]
    @State var categories: [CategoryRecord]
    
    var body: some View {
        if isOnboardingCompleted {
            TabView(selection: $tabSelected) {
                SheduleView(shedule: $shedule,
                            categories: $categories)
                .tabItem { Image(systemName: "scroll.fill") }.tag(0)
                
                TasksView(shedule: $shedule,
                          categories: $categories)
                    .tabItem { Image(systemName: "hands.sparkles.fill") }.tag(1)
                SettingsView()
                    .tabItem { Image(systemName: "gearshape.fill") }.tag(2)
            }
            .onAppear() {
                        UITabBar.appearance().barTintColor = UIColor(.pink)
                        UITabBar.appearance().backgroundColor = UIColor(.white)
                UITabBar.appearance().unselectedItemTintColor = UIColor(named: "buttonDisabledColor")
                    }
        } else {
            OnBoardingView(isOnboardingCompleted: $isOnboardingCompleted, isReview: true)
        }
    }
}

#Preview {
    MainTabView(shedule: MockData.shedule,
                categories: MockData.categories)
}
