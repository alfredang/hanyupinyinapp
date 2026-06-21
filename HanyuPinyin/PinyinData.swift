import Foundation

// MARK: - Models

/// A single pinyin building block (声母 initial or 韵母 final) with an example.
struct PinyinUnit: Identifiable, Hashable {
    let symbol: String        // e.g. "b", "ang"
    let example: String       // example syllable, e.g. "bā"
    let exampleHanzi: String  // example character, e.g. "八"
    let exampleMeaning: String
    var id: String { symbol }
}

/// A prompt used in a typing practice session: show `prompt`, the user types `answer` (plain pinyin, no tones).
struct PinyinPrompt: Identifiable, Hashable {
    let prompt: String        // what is shown (hanzi, or a syllable with tone marks)
    let toned: String         // the toned pinyin (for showing the correct answer)
    let answer: String        // expected typed pinyin, lowercase, no tone marks, no spaces
    let meaning: String       // short gloss in 简体中文 / English
    var abbr: String = ""     // optional 简拼 shortcut (initials only), also accepted as correct
    var id: String { prompt + answer }
}

// MARK: - Data

enum PinyinData {

    // 23 声母 (initials)
    static let initials: [PinyinUnit] = [
        .init(symbol: "b", example: "bā", exampleHanzi: "八", exampleMeaning: "八 / eight"),
        .init(symbol: "p", example: "pá", exampleHanzi: "爬", exampleMeaning: "爬 / climb"),
        .init(symbol: "m", example: "mā", exampleHanzi: "妈", exampleMeaning: "妈 / mother"),
        .init(symbol: "f", example: "fā", exampleHanzi: "发", exampleMeaning: "发 / send"),
        .init(symbol: "d", example: "dà", exampleHanzi: "大", exampleMeaning: "大 / big"),
        .init(symbol: "t", example: "tā", exampleHanzi: "他", exampleMeaning: "他 / he"),
        .init(symbol: "n", example: "nǐ", exampleHanzi: "你", exampleMeaning: "你 / you"),
        .init(symbol: "l", example: "lè", exampleHanzi: "乐", exampleMeaning: "乐 / happy"),
        .init(symbol: "g", example: "gē", exampleHanzi: "哥", exampleMeaning: "哥 / brother"),
        .init(symbol: "k", example: "kàn", exampleHanzi: "看", exampleMeaning: "看 / look"),
        .init(symbol: "h", example: "hǎo", exampleHanzi: "好", exampleMeaning: "好 / good"),
        .init(symbol: "j", example: "jiā", exampleHanzi: "家", exampleMeaning: "家 / home"),
        .init(symbol: "q", example: "qù", exampleHanzi: "去", exampleMeaning: "去 / go"),
        .init(symbol: "x", example: "xué", exampleHanzi: "学", exampleMeaning: "学 / study"),
        .init(symbol: "zh", example: "zhōng", exampleHanzi: "中", exampleMeaning: "中 / middle"),
        .init(symbol: "ch", example: "chī", exampleHanzi: "吃", exampleMeaning: "吃 / eat"),
        .init(symbol: "sh", example: "shū", exampleHanzi: "书", exampleMeaning: "书 / book"),
        .init(symbol: "r", example: "rén", exampleHanzi: "人", exampleMeaning: "人 / person"),
        .init(symbol: "z", example: "zì", exampleHanzi: "字", exampleMeaning: "字 / character"),
        .init(symbol: "c", example: "cài", exampleHanzi: "菜", exampleMeaning: "菜 / dish"),
        .init(symbol: "s", example: "sān", exampleHanzi: "三", exampleMeaning: "三 / three"),
        .init(symbol: "y", example: "yī", exampleHanzi: "一", exampleMeaning: "一 / one"),
        .init(symbol: "w", example: "wǒ", exampleHanzi: "我", exampleMeaning: "我 / I"),
    ]

    // Common 韵母 (finals)
    static let finals: [PinyinUnit] = [
        .init(symbol: "a", example: "mā", exampleHanzi: "妈", exampleMeaning: "妈 / mother"),
        .init(symbol: "o", example: "wǒ", exampleHanzi: "我", exampleMeaning: "我 / I"),
        .init(symbol: "e", example: "hē", exampleHanzi: "喝", exampleMeaning: "喝 / drink"),
        .init(symbol: "i", example: "yī", exampleHanzi: "一", exampleMeaning: "一 / one"),
        .init(symbol: "u", example: "wǔ", exampleHanzi: "五", exampleMeaning: "五 / five"),
        .init(symbol: "ü", example: "yú", exampleHanzi: "鱼", exampleMeaning: "鱼 / fish"),
        .init(symbol: "ai", example: "ài", exampleHanzi: "爱", exampleMeaning: "爱 / love"),
        .init(symbol: "ei", example: "bēi", exampleHanzi: "杯", exampleMeaning: "杯 / cup"),
        .init(symbol: "ui", example: "shuǐ", exampleHanzi: "水", exampleMeaning: "水 / water"),
        .init(symbol: "ao", example: "hǎo", exampleHanzi: "好", exampleMeaning: "好 / good"),
        .init(symbol: "ou", example: "gǒu", exampleHanzi: "狗", exampleMeaning: "狗 / dog"),
        .init(symbol: "iu", example: "liù", exampleHanzi: "六", exampleMeaning: "六 / six"),
        .init(symbol: "ie", example: "xiè", exampleHanzi: "谢", exampleMeaning: "谢 / thanks"),
        .init(symbol: "üe", example: "yuè", exampleHanzi: "月", exampleMeaning: "月 / moon"),
        .init(symbol: "er", example: "ér", exampleHanzi: "儿", exampleMeaning: "儿 / child"),
        .init(symbol: "an", example: "kàn", exampleHanzi: "看", exampleMeaning: "看 / look"),
        .init(symbol: "en", example: "mén", exampleHanzi: "门", exampleMeaning: "门 / door"),
        .init(symbol: "in", example: "xīn", exampleHanzi: "心", exampleMeaning: "心 / heart"),
        .init(symbol: "un", example: "lún", exampleHanzi: "轮", exampleMeaning: "轮 / wheel"),
        .init(symbol: "ang", example: "máng", exampleHanzi: "忙", exampleMeaning: "忙 / busy"),
        .init(symbol: "eng", example: "dēng", exampleHanzi: "灯", exampleMeaning: "灯 / lamp"),
        .init(symbol: "ing", example: "míng", exampleHanzi: "明", exampleMeaning: "明 / bright"),
        .init(symbol: "ong", example: "zhōng", exampleHanzi: "钟", exampleMeaning: "钟 / clock"),
    ]

    // 4 声调 (tones) — shown with the same vowel.
    static let tones: [(mark: String, name: String, desc: String)] = [
        ("mā 妈", "第一声 (阴平)", "高而平 — high & level"),
        ("má 麻", "第二声 (阳平)", "由低到高 — rising"),
        ("mǎ 马", "第三声 (上声)", "先降后升 — falling-rising"),
        ("mà 骂", "第四声 (去声)", "由高到低 — falling"),
    ]

    // Single 汉字 → pinyin (used by 音节 & 汉字 practice).
    static let characters: [PinyinPrompt] = [
        .init(prompt: "我", toned: "wǒ", answer: "wo", meaning: "I / me"),
        .init(prompt: "你", toned: "nǐ", answer: "ni", meaning: "you"),
        .init(prompt: "他", toned: "tā", answer: "ta", meaning: "he"),
        .init(prompt: "好", toned: "hǎo", answer: "hao", meaning: "good"),
        .init(prompt: "是", toned: "shì", answer: "shi", meaning: "to be"),
        .init(prompt: "不", toned: "bù", answer: "bu", meaning: "not"),
        .init(prompt: "人", toned: "rén", answer: "ren", meaning: "person"),
        .init(prompt: "大", toned: "dà", answer: "da", meaning: "big"),
        .init(prompt: "小", toned: "xiǎo", answer: "xiao", meaning: "small"),
        .init(prompt: "中", toned: "zhōng", answer: "zhong", meaning: "middle"),
        .init(prompt: "国", toned: "guó", answer: "guo", meaning: "country"),
        .init(prompt: "家", toned: "jiā", answer: "jia", meaning: "home"),
        .init(prompt: "学", toned: "xué", answer: "xue", meaning: "study"),
        .init(prompt: "爱", toned: "ài", answer: "ai", meaning: "love"),
        .init(prompt: "水", toned: "shuǐ", answer: "shui", meaning: "water"),
        .init(prompt: "火", toned: "huǒ", answer: "huo", meaning: "fire"),
        .init(prompt: "天", toned: "tiān", answer: "tian", meaning: "sky"),
        .init(prompt: "地", toned: "dì", answer: "di", meaning: "earth"),
        .init(prompt: "上", toned: "shàng", answer: "shang", meaning: "up"),
        .init(prompt: "下", toned: "xià", answer: "xia", meaning: "down"),
        .init(prompt: "吃", toned: "chī", answer: "chi", meaning: "eat"),
        .init(prompt: "喝", toned: "hē", answer: "he", meaning: "drink"),
        .init(prompt: "看", toned: "kàn", answer: "kan", meaning: "look"),
        .init(prompt: "听", toned: "tīng", answer: "ting", meaning: "listen"),
        .init(prompt: "说", toned: "shuō", answer: "shuo", meaning: "speak"),
        .init(prompt: "走", toned: "zǒu", answer: "zou", meaning: "walk"),
        .init(prompt: "书", toned: "shū", answer: "shu", meaning: "book"),
        .init(prompt: "字", toned: "zì", answer: "zi", meaning: "character"),
        .init(prompt: "鱼", toned: "yú", answer: "yu", meaning: "fish"),
        .init(prompt: "月", toned: "yuè", answer: "yue", meaning: "moon"),
    ]

    // Common 词语 (words) → pinyin (no spaces, no tones), used by 词语 practice.
    static let words: [PinyinPrompt] = [
        .init(prompt: "你好", toned: "nǐ hǎo", answer: "nihao", meaning: "hello"),
        .init(prompt: "谢谢", toned: "xiè xie", answer: "xiexie", meaning: "thanks"),
        .init(prompt: "中国", toned: "zhōng guó", answer: "zhongguo", meaning: "China"),
        .init(prompt: "学习", toned: "xué xí", answer: "xuexi", meaning: "to study"),
        .init(prompt: "老师", toned: "lǎo shī", answer: "laoshi", meaning: "teacher"),
        .init(prompt: "学生", toned: "xué sheng", answer: "xuesheng", meaning: "student"),
        .init(prompt: "朋友", toned: "péng you", answer: "pengyou", meaning: "friend"),
        .init(prompt: "电脑", toned: "diàn nǎo", answer: "diannao", meaning: "computer"),
        .init(prompt: "手机", toned: "shǒu jī", answer: "shouji", meaning: "phone"),
        .init(prompt: "汉语", toned: "hàn yǔ", answer: "hanyu", meaning: "Chinese"),
        .init(prompt: "拼音", toned: "pīn yīn", answer: "pinyin", meaning: "pinyin"),
        .init(prompt: "今天", toned: "jīn tiān", answer: "jintian", meaning: "today"),
        .init(prompt: "明天", toned: "míng tiān", answer: "mingtian", meaning: "tomorrow"),
        .init(prompt: "时间", toned: "shí jiān", answer: "shijian", meaning: "time"),
        .init(prompt: "工作", toned: "gōng zuò", answer: "gongzuo", meaning: "work"),
        .init(prompt: "吃饭", toned: "chī fàn", answer: "chifan", meaning: "to eat"),
        .init(prompt: "喝水", toned: "hē shuǐ", answer: "heshui", meaning: "drink water"),
        .init(prompt: "健康", toned: "jiàn kāng", answer: "jiankang", meaning: "health"),
        .init(prompt: "食品", toned: "shí pǐn", answer: "shipin", meaning: "food"),
        .init(prompt: "北京", toned: "běi jīng", answer: "beijing", meaning: "Beijing"),
        .init(prompt: "上海", toned: "shàng hǎi", answer: "shanghai", meaning: "Shanghai"),
        .init(prompt: "喜欢", toned: "xǐ huan", answer: "xihuan", meaning: "to like"),
        .init(prompt: "漂亮", toned: "piào liang", answer: "piaoliang", meaning: "pretty"),
        .init(prompt: "高兴", toned: "gāo xìng", answer: "gaoxing", meaning: "happy"),
        .init(prompt: "再见", toned: "zài jiàn", answer: "zaijian", meaning: "goodbye"),
    ]

    // 长句 (sentences) for fast-typing practice. `abbr` is the 简拼 first-letter shortcut —
    // both the full pinyin and the shortcut are accepted, to teach fast input.
    static let sentences: [PinyinPrompt] = [
        .init(prompt: "你好吗", toned: "nǐ hǎo ma", answer: "nihaoma",
              meaning: "How are you?", abbr: "nhm"),
        .init(prompt: "我爱你", toned: "wǒ ài nǐ", answer: "woaini",
              meaning: "I love you", abbr: "wan"),
        .init(prompt: "谢谢你", toned: "xiè xie nǐ", answer: "xiexieni",
              meaning: "Thank you", abbr: "xxn"),
        .init(prompt: "我是学生", toned: "wǒ shì xué sheng", answer: "woshixuesheng",
              meaning: "I am a student", abbr: "wsxs"),
        .init(prompt: "今天天气好", toned: "jīn tiān tiān qì hǎo", answer: "jintiantianqihao",
              meaning: "The weather is nice today", abbr: "jttqh"),
        .init(prompt: "我喜欢学中文", toned: "wǒ xǐ huan xué zhōng wén", answer: "woxihuanxuezhongwen",
              meaning: "I like learning Chinese", abbr: "wxhxzw"),
        .init(prompt: "中国很大", toned: "zhōng guó hěn dà", answer: "zhongguohenda",
              meaning: "China is very big", abbr: "zghd"),
        .init(prompt: "明天见", toned: "míng tiān jiàn", answer: "mingtianjian",
              meaning: "See you tomorrow", abbr: "mtj"),
        .init(prompt: "请问多少钱", toned: "qǐng wèn duō shao qián", answer: "qingwenduoshaoqian",
              meaning: "How much is it?", abbr: "qwdsq"),
        .init(prompt: "我们一起去", toned: "wǒ men yì qǐ qù", answer: "womenyiqiqu",
              meaning: "Let's go together", abbr: "wmyqq"),
    ]
}
