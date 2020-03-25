import Foundation

struct ItalianAlphabetCounter {
    static let letters = [
        "a", "b", "c", "d", "e", "f", "g",
        "h", "i", "l", "m", "n", "o", "p",
        "q", "r", "s", "t", "u", "v", "z",
    ]

    var counter: [String: Int] = [
        "a": 0, "b": 0, "c": 0, "d": 0, "e": 0, "f": 0, "g": 0,
        "h": 0, "i": 0, "l": 0, "m": 0, "n": 0, "o": 0, "p": 0,
        "q": 0, "r": 0, "s": 0, "t": 0, "u": 0, "v": 0, "z": 0,
    ]
}
