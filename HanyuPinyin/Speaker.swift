import AVFoundation
import SwiftUI

enum VoiceGender: String, CaseIterable, Identifiable {
    case female, male
    var id: String { rawValue }
    var label: String { self == .female ? "女声" : "男声" }
    var englishLabel: String { self == .female ? "Female" : "Male" }
}

/// Speaks Chinese text aloud with the correct pronunciation (and tones) using a
/// Chinese voice. The user can pick a female or male voice in Settings; the
/// chosen gender is honoured here and reflected accurately in the UI.
final class Speaker: ObservableObject {
    static let shared = Speaker()

    private let synth = AVSpeechSynthesizer()
    private let femaleVoice: AVSpeechSynthesisVoice?
    private let maleVoice: AVSpeechSynthesisVoice?

    /// Persisted user choice. Defaults to female (the classic zh-CN Ting-Ting voice).
    @AppStorage("voiceGender") var gender: String = VoiceGender.female.rawValue

    private init() {
        let zh = AVSpeechSynthesisVoice.speechVoices().filter {
            $0.language.hasPrefix("zh-CN") || $0.language.hasPrefix("zh-Hans")
        }
        femaleVoice = Speaker.pick(zh, gender: .female)
        maleVoice = Speaker.pick(zh, gender: .male)
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: [])
        try? AVAudioSession.sharedInstance().setActive(true)
    }

    /// Which genders actually have an installed Chinese voice on this device.
    var availableGenders: [VoiceGender] {
        var out: [VoiceGender] = []
        if femaleVoice != nil { out.append(.female) }
        if maleVoice != nil { out.append(.male) }
        return out.isEmpty ? [.female] : out
    }

    /// True only if a distinct voice for that gender is actually installed.
    func isAvailable(_ g: VoiceGender) -> Bool {
        g == .female ? femaleVoice != nil : maleVoice != nil
    }

    private var currentVoice: AVSpeechSynthesisVoice? {
        let wanted = VoiceGender(rawValue: gender) ?? .female
        if wanted == .male, let m = maleVoice { return m }
        if wanted == .female, let f = femaleVoice { return f }
        // Fall back to whatever Chinese voice exists.
        return femaleVoice ?? maleVoice ?? AVSpeechSynthesisVoice(language: "zh-CN")
    }

    /// Speak a Chinese word/character with the correct pronunciation.
    func speak(_ text: String, rate: Float = 0.45) {
        let clean = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !clean.isEmpty else { return }
        if synth.isSpeaking { synth.stopSpeaking(at: .immediate) }
        let u = AVSpeechUtterance(string: clean)
        u.voice = currentVoice
        u.rate = rate
        u.pitchMultiplier = (VoiceGender(rawValue: gender) == .male) ? 0.92 : 1.05
        synth.speak(u)
    }

    /// Pick the best installed Chinese voice for a gender.
    private static func pick(_ voices: [AVSpeechSynthesisVoice], gender: VoiceGender) -> AVSpeechSynthesisVoice? {
        // Known names: Ting-Ting / Sin-ji are female; Li-mu / Yu-shu are male (when downloaded).
        let femaleNames = ["ting", "sin-ji", "mei-jia"]
        let maleNames = ["li-mu", "yu-shu", "pan", "han"]
        if #available(iOS 17.0, *) {
            let g: AVSpeechSynthesisVoiceGender = gender == .female ? .female : .male
            let byGender = voices.filter { $0.gender == g }
                .sorted { $0.quality.rawValue > $1.quality.rawValue }
            if let v = byGender.first { return v }
        }
        let names = gender == .female ? femaleNames : maleNames
        if let v = voices.first(where: { vo in names.contains { vo.name.lowercased().contains($0) } }) {
            return v
        }
        return nil
    }
}
