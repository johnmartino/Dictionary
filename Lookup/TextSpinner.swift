import Foundation

final class TextSpinner {
    private let frames = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"]
    private var animationTask: Task<Void, Never>?

    func start(message: String) {
        guard animationTask == nil else { return }

        let frames = frames
        animationTask = Task {
            var frameIndex = 0

            while !Task.isCancelled {
                Self.write("\r\u{001B}[2K\(message) \(frames[frameIndex % frames.count])")
                frameIndex += 1

                do {
                    try await Task.sleep(for: .milliseconds(100))
                } catch {
                    break
                }
            }
        }
    }

    func stop() {
        animationTask?.cancel()
        animationTask = nil
        Self.write("\r\u{001B}[2K")
    }

    private static func write(_ text: String) {
        FileHandle.standardOutput.write(Data(text.utf8))
    }
}
