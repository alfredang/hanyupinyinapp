import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            LearnView()
                .tabItem { Label("学习", systemImage: "book.fill") }
            PracticeHomeView()
                .tabItem { Label("练习", systemImage: "keyboard.fill") }
            FeedbackView()
                .tabItem { Label("反馈", systemImage: "bubble.left.and.bubble.right.fill") }
            AboutView()
                .tabItem { Label("关于", systemImage: "info.circle.fill") }
        }
        .tint(Theme.accent)
        .preferredColorScheme(.light)
    }
}

#Preview {
    MainTabView()
}
