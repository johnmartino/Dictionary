import Foundation

private let maximumLineWidth = 80
private let boldText = "\u{001B}[1m"
private let secondaryColor = "\u{001B}[38;5;245m"
private let resetColor = "\u{001B}[0m"

func print(_ entry: DictionaryEntry) {
    print("\(boldText)\(entry.word)\(resetColor)")
    print()

    for (groupIndex, partOfSpeech) in entry.partsOfSpeech.enumerated() {
        print(partOfSpeech.partOfSpeech.capitalized)

        for (senseIndex, sense) in partOfSpeech.senses.enumerated() {
            let numberPrefix = "    \(senseIndex + 1). "
            let definitionContinuationPrefix = String(repeating: " ", count: numberPrefix.count)
            printWrapped(
                sense.definition,
                firstLinePrefix: numberPrefix,
                continuationPrefix: definitionContinuationPrefix
            )

            let exampleLabel = "e.g., "
            let exampleLabelSpaces = String(repeating: " ", count: exampleLabel.count)
            if let example = sense.example {
                printWrapped(
                    "\(exampleLabel)\(example)",
                    firstLinePrefix: definitionContinuationPrefix,
                    continuationPrefix: definitionContinuationPrefix + exampleLabelSpaces,
                    color: secondaryColor
                )
            }
        }

        if groupIndex < entry.partsOfSpeech.count - 1 {
            print()
        }
    }

    if let etymology = entry.etymology, !etymology.isEmpty {
        print()
        print("Etymology")
        printWrapped(
            etymology,
            firstLinePrefix: "    ",
            continuationPrefix: "    "
        )
    }

    printRelatedWords(entry.synonyms, heading: "Synonyms")
    printRelatedWords(entry.antonyms, heading: "Antonyms")
}

private func printRelatedWords(_ words: [String], heading: String) {
    guard !words.isEmpty else { return }

    print()
    print(heading)
    printWrapped(
        words.joined(separator: ", "),
        firstLinePrefix: "    ",
        continuationPrefix: "    "
    )
}

private func printWrapped(_ text: String, firstLinePrefix: String, continuationPrefix: String, color: String = "") {
    let availableFirstLineWidth = maximumLineWidth - firstLinePrefix.count
    let availableContinuationWidth = maximumLineWidth - continuationPrefix.count
    let lines = wrappedLines(
        in: text,
        firstLineWidth: availableFirstLineWidth,
        continuationWidth: availableContinuationWidth
    )

    for (lineIndex, line) in lines.enumerated() {
        let prefix = lineIndex == 0 ? firstLinePrefix : continuationPrefix
        print("\(color)\(prefix)\(line)\(color.isEmpty ? "" : resetColor)")
    }
}

private func wrappedLines(in text: String, firstLineWidth: Int, continuationWidth: Int) -> [String] {
    let words = text.split(whereSeparator: { $0.isWhitespace })
    guard !words.isEmpty else { return [""] }

    var lines: [String] = []
    var currentLine = ""
    var currentLineWidth = firstLineWidth

    for word in words {
        let word = String(word)
        let separator = currentLine.isEmpty ? "" : " "

        if !currentLine.isEmpty && currentLine.count + separator.count + word.count > currentLineWidth {
            lines.append(currentLine)
            currentLine = word
            currentLineWidth = continuationWidth
        } else {
            currentLine += separator + word
        }
    }

    if !currentLine.isEmpty {
        lines.append(currentLine)
    }

    return lines
}

func usage() {
    print("usage: lookup <word>")
}

if let word = CommandLine.arguments.dropFirst().first, !word.isEmpty {
    let service = LookupService()
    let spinner = TextSpinner()
    spinner.start(message: "Looking up \(word)")

    do {
        let entry = try await service.lookup(word: word)
        spinner.stop()
        print(entry)
    } catch {
        spinner.stop()
        print(error.localizedDescription)
    }
} else {
    usage()
}
