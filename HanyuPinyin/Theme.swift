import SwiftUI

/// Brand theme tokens. White theme — light background with a warm red accent
/// inspired by traditional Chinese red. Reference these tokens everywhere,
/// never raw `Color` literals, so a re-theme is a one-file change.
enum Theme {
    /// Primary accent — key buttons, active states, tab tint. (China red)
    static let accent = Color(red: 0.886, green: 0.118, blue: 0.180)
    /// Secondary accent — links, selected chips.
    static let secondary = Color(red: 0.078, green: 0.45, blue: 0.78)
    /// Success / correct state.
    static let success = Color(red: 0.13, green: 0.62, blue: 0.36)
    /// Error / wrong state.
    static let error = Color(red: 0.85, green: 0.20, blue: 0.18)
    /// Highlight — tone marks, badges.
    static let highlight = Color(red: 0.95, green: 0.62, blue: 0.10)

    /// App background — clean near-white.
    static let background = Color(red: 0.97, green: 0.97, blue: 0.98)
    /// Card / elevated surface — pure white.
    static let card = Color.white
    /// Subtle fills, chips.
    static let surface = Color(red: 0.94, green: 0.94, blue: 0.96)

    /// Primary text — explicit dark ink for AA contrast on the off-white bg.
    static let ink = Color(red: 0.10, green: 0.11, blue: 0.13)
    /// Secondary text.
    static let mutedInk = Color(red: 0.42, green: 0.44, blue: 0.48)
}

extension View {
    /// Reusable white card surface: rounded, soft shadow.
    func appCard(padding: CGFloat = 16) -> some View {
        self
            .padding(padding)
            .background(Theme.card, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: .black.opacity(0.05), radius: 8, y: 3)
    }
}
