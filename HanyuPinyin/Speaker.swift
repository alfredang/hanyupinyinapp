import AVFoundation
import SwiftUI

/// Speaks Chinese text aloud with the correct pronunciation (and tones) using a
/// Chinese **female** voice (Ting-Ting / zh-CN). Native, offline, App Store-safe.
final class Speaker: ObservableObject {
    static let shared = Speaker()

    private let synth = AVSpeechSynthesizer()
    /// Best available Chinese female voice, resolved once.
    private let voice: AVSpeechSynthesisVoice? = Speaker.bestChineseVoice()

    @Published private(set) var speakingText: String? = nil

    private init() {
        configureSession()
    }

    /// Speak a Chinese word/character with the correct pronunciation.
    /// `rate` ~0.45 is slightly slower than default for clearer learning.
    func speak(_ text: String, rate: Float = 0.45) {
        let clean = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !clean.isEmpty else { return }
        if synth.isSpeaking { synth.stopSpeaking(at: .immediate) }

        let u = AVSpeechUtterance(string: clean)
        u.voice = voice
        u.rate = rate
        u.pitchMultiplier = 1.05
        u.postUtteranceDelay = 0.05
        synth.speak(u)
    }

    private func configureSession() {
        // .playback so pronunciation is audible even with the ring/silent switch on.
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: [])
        try? AVAudioSession.sharedInstance().setActive(true)
    }

    /// Prefer a known Chinese female voice; fall back to any zh-CN voice.
    private static func bestChineseVoice() -> AVSpeechSynthesisVoice? {
        let voices = AVSpeechSynthesisVoice.speechVoices()
        let zh = voices.filter { $0.language.hasPrefix("zh-CN") || $0.language.hasPrefix("zh-Hans") }
        // Ting-Ting is the classic zh-CN female voice; otherwise prefer female gender,
        // then enhanced/premium quality, then any Chinese voice.
        if let ting = zh.first(where: { $0.name.localizedCaseInsensitiveContains("ting") }) {
            return ting
        }
        if #available(iOS 17.0, *), let female = zh.first(where: { $0.gender == .female }) {
            return female
        }
        if let best = zh.sorted(by: { $0.quality.rawValue > $1.quality.rawValue }).first {
            return best
        }
        return AVSpeechSynthesisVoice(language: "zh-CN")
    }
}
