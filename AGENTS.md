# Repository Guidelines

## Project Structure & Module Organization

This repository contains a small Swift command-line dictionary client. Application code lives in `Lookup/`:

- `main.swift` is the executable entry point and demonstrates a lookup.
- `LookupService.swift` builds requests to `englishdictionaryapi.com` and decodes responses.
- `DictionaryEntry.swift` defines the `Codable` response model and nested entry types.

`Dictionary.xcodeproj/` contains the Xcode project for the `lookup` target. Keep generated build products and user-specific Xcode state out of source control. There is currently no test target or assets directory; add tests under a dedicated `LookupTests/` target when introducing test coverage.

## Build, Test, and Development Commands

- `open Dictionary.xcodeproj` opens the project in Xcode for local development and debugging.
- `xcodebuild -project Dictionary.xcodeproj -scheme lookup -configuration Debug build` performs a command-line debug build.
- `xcodebuild -project Dictionary.xcodeproj -scheme lookup -configuration Release build` verifies an optimized release build.
- `xcodebuild -project Dictionary.xcodeproj -scheme lookup test` runs tests after a test target is added and included in the scheme.

The executable performs a live network request, so manual runs require internet access and availability of the external dictionary API.

## Coding Style & Naming Conventions

Follow standard Swift conventions and use four-space indentation. Name types in `UpperCamelCase` and methods, properties, and local variables in `lowerCamelCase`. Prefer immutable `let` values, explicit access control where useful, and small types with a single responsibility. Keep API transport logic in `LookupService` and response shapes in model files. Run Xcode's **Editor > Structure > Re-Indent** before submitting; no separate formatter or linter is currently configured.

## Testing Guidelines

Use XCTest for new automated tests. Name test files after the subject, such as `LookupServiceTests.swift`, and test methods by behavior, such as `testLookupDecodesSuccessfulResponse()`. Avoid depending on the live API in unit tests; inject a URL-loading dependency or use fixtures for deterministic success, decoding-error, and network-error cases.

## Commit & Pull Request Guidelines

Git history is not available in this checkout. Use short, imperative commit subjects (for example, `Handle malformed lookup responses`) and keep each commit focused. Pull requests should explain the behavior change, list validation commands, and link relevant issues. Include console output for CLI behavior changes and call out API schema or deployment-target changes explicitly.
