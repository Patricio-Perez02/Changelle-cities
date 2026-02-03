//
//  StringExtensionsTests.swift
//  Challenge-CitiesTests
//

import Testing
@testable import Challenge_Cities

/// Tests for String+Extensions normalized() and flagEmoji().
struct StringExtensionsTests {

    @Test("normalized removes diacritics")
    func testNormalizedRemovesDiacritics() async throws {
        #expect("Zürich".normalized() == "zurich")
        #expect("São Paulo".normalized() == "sao paulo")
        #expect("Ñoño".normalized() == "nono")
    }

    @Test("normalized is case-insensitive")
    func testNormalizedCaseInsensitive() async throws {
        #expect("HELLO".normalized() == "hello")
        #expect("World".normalized() == "world")
    }

    @Test("normalized trims whitespace")
    func testNormalizedTrimsWhitespace() async throws {
        #expect("  Paris  ".normalized() == "paris")
        #expect("\nLondon\t".normalized() == "london")
    }

    @Test("flagEmoji converts country code to flag")
    func testFlagEmoji() async throws {
        let usFlag = "US".flagEmoji()
        #expect(usFlag.count == 2)
        #expect(usFlag.unicodeScalars.count == 2)
    }

    @Test("flagEmoji handles single character")
    func testFlagEmojiSingleChar() async throws {
        let flag = "A".flagEmoji()
        #expect(flag.count == 1)
    }
}
