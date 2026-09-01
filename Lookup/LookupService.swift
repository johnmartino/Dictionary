//
//  LookupService.swift
//  lookup
//
//  Created by John Martino on 9/1/26.
//

import Foundation

class LookupService {
    private let host = "https://englishdictionaryapi.com"
    private let lookupPath = "/api/v1/words/"
    
    func lookup(word: String) async throws -> DictionaryEntry {
        guard let url = URL(string: "\(host)\(lookupPath)\(word)") else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        let json = try JSONDecoder().decode(DictionaryEntry.self, from: data)
        return json
    }
}
