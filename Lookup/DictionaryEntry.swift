//
//  DictionaryEntry.swift
//  lookup
//
//  Created by John Martino on 9/1/26.
//

import Foundation

struct DictionaryEntry: Codable {
    let word: String
    let forms: [String]
    let etymology: String?
    let headlineExpansion: String?
    let hyphenation: String?
    let pronunciation: PronunciationEntry?
    let partsOfSpeech: [PosGroup]
    let synonyms: [String]
    let antonyms: [String]
    let hypernyms: [String]
    let hyponyms: [String]
    let meronyms: [String]
    let holonyms: [String]
    let derived: [String]
    let related: [String]
    let coordinateTerms: [String]
    let descendants: [DescendantEntry]
}

struct PosGroup: Codable {
    let partOfSpeech: String
    let senses: [SenseEntry]
}

struct SenseEntry: Codable {
    let definition: String
    let example: String?
}

struct PronunciationEntry: Codable {
    let ipa: String?
    let enpr: String?
    let rhymes: String?
    let audioUrl: String?
}

struct DescendantEntry: Codable {
    let lang: String
    let word: String
}
