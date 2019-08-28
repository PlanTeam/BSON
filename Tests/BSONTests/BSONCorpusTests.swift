import Foundation
import XCTest
import BSON

final class BSONCorpusTests: XCTestCase {
    func testTopLevel() {
        let doc0 = Document(bytes: [0x0f,0x00,0x00,0x00,0x10,0x24,0x6b,0x65,0x79,0x00,0x2a,0x00,0x00,0x00,0x00])
        let doc1 = Document(bytes: [0x3f,0x00,0x00,0x00,0x02,0x24,0x72,0x65,0x67,0x65,0x78,0x00,0x0c,0x00,0x00,0x00,0x6e,0x6f,0x74,0x2d,0x61,0x2d,0x72,0x65,0x67,0x65,0x78,0x00,0x02,0x24,0x6f,0x70,0x74,0x69,0x6f,0x6e,0x73,0x00,0x02,0x00,0x00,0x00,0x69,0x00,0x02,0x24,0x62,0x61,0x6e,0x61,0x6e,0x61,0x00,0x05,0x00,0x00,0x00,0x70,0x65,0x65,0x6c,0x00,0x00])
        let doc2 = Document(bytes: [0x1a,0x00,0x00,0x00,0x02,0x24,0x62,0x69,0x6e,0x61,0x72,0x79,0x00,0x08,0x00,0x00,0x00,0x61,0x62,0x63,0x64,0x65,0x66,0x67,0x00,0x00])
        
        XCTAssert(doc0.validate().isValid)
        XCTAssert(doc1.validate().isValid)
        XCTAssert(doc2.validate().isValid)
        
        XCTAssertEqual(doc0.keys, ["$key"])
        XCTAssertEqual(doc0["$key"] as? Int32, 42)

        XCTAssertEqual(doc1.keys, ["$regex", "$options", "$banana"])
        XCTAssertEqual(doc1["$regex"] as? String, "not-a-regex")
        XCTAssertEqual(doc1["$options"] as? String, "i")
        XCTAssertEqual(doc1["$banana"] as? String, "peel")


        XCTAssertEqual(doc2.keys, ["$binary"])
        XCTAssertEqual(doc2["$binary"] as? String, "abcdefg")
        
        assertInvalid(Document(bytes: [0x01,0x00,0x00,0x00,0x00]))
        assertInvalid(Document(bytes: [0x04,0x00,0x00,0x00,0x00]))
        assertInvalid(Document(bytes: [0x05,0x00,0x00,0x00]))
        assertInvalid(Document(bytes: [0x05,0x00,0x00,0x00,0x01]))
        assertInvalid(Document(bytes: [0x05,0x00,0x00,0x00,0xFF]))
        assertInvalid(Document(bytes: [0x05,0x00,0x00,0x00,0x70]))
        assertInvalid(Document(bytes: [0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00]))
        assertInvalid(Document(bytes: [0x12,0x00,0x00,0x00,0x02,0x66,0x6F,0x6F,0x00,0x04,0x00,0x00,0x00,0x62,0x61,0x72]))
        assertInvalid(Document(bytes: [0x13,0x00,0x00,0x00,0x02,0x66,0x6F,0x6F,0x00,0x04,0x00,0x00,0x00,0x62,0x61,0x72,0x00,0x00]))
        assertInvalid(Document(bytes: [0x11,0x00,0x00,0x00,0x02,0x66,0x6F,0x6F,0x00,0x04,0x00,0x00,0x00,0x62,0x61,0x72,0x00,0x00]))
        assertInvalid(Document(bytes: [0x07,0x00,0x00,0x00,0x00,0x00,0x00]))
        assertInvalid(Document(bytes: [0x07,0x00,0x00,0x00,0x80,0x00,0x00]))
        assertInvalid(Document(bytes: [0x12,0x00,0x00,0x00,0x02,0x66,0x6F]))
    }
//
//    func testTimestamp() {
//        let doc = Document(bytes: [0x10,0x00,0x00,0x00,0x11,0x61,0x00,0x2A,0x00,0x00,0x00,0x15,0xCD,0x5B,0x07,0x00])
//        
//        guard let a = Timestamp(lossy: doc["a"]) else {
//            XCTFail()
//            return
//        }
//        
//        XCTAssertEqual(a.timestamp, 123456789)
//        XCTAssertEqual(a.increment, 42)
//        
//        XCTAssertFalse(Document(bytes: [0x0f,0x00,0x00,0x00,0x11,0x61,0x00,0x2A,0x00,0x00,0x00,0x15,0xCD,0x5B,0x00]).validate().isValid)
//    }
    
    func testString() {
        let doc0 = Document(bytes: [0x0D,0x00,0x00,0x00,0x02,0x61,0x00,0x01,0x00,0x00,0x00,0x00,0x00])
        let doc1 = Document(bytes: [0x0E,0x00,0x00,0x00,0x02,0x61,0x00,0x02,0x00,0x00,0x00,0x62,0x00,0x00])
        let doc2 = Document(bytes: [0x19,0x00,0x00,0x00,0x02,0x61,0x00,0x0D,0x00,0x00,0x00,0x61,0x62,0x61,0x62,0x61,0x62,0x61,0x62,0x61,0x62,0x61,0x62,0x00,0x00])
        let doc3 = Document(bytes: [0x19,0x00,0x00,0x00,0x02,0x61,0x00,0x0D,0x00,0x00,0x00,0xC3,0xA9,0xC3,0xA9,0xC3,0xA9,0xC3,0xA9,0xC3,0xA9,0xC3,0xA9,0x00,0x00])
        let doc4 = Document(bytes: [0x19,0x00,0x00,0x00,0x02,0x61,0x00,0x0D,0x00,0x00,0x00,0xE2,0x98,0x86,0xE2,0x98,0x86,0xE2,0x98,0x86,0xE2,0x98,0x86,0x00,0x00])
        let doc5 = Document(bytes: [0x19,0x00,0x00,0x00,0x02,0x61,0x00,0x0D,0x00,0x00,0x00,0x61,0x62,0x00,0x62,0x61,0x62,0x00,0x62,0x61,0x62,0x61,0x62,0x00,0x00])
        
        XCTAssert(doc0.validate().isValid)
        XCTAssertEqual(doc0["a"] as? String, "")
        
        XCTAssert(doc1.validate().isValid)
        XCTAssertEqual(doc1["a"] as? String, "b")
        
        XCTAssert(doc2.validate().isValid)
        XCTAssertEqual(doc2["a"] as? String, "abababababab")
        
        XCTAssert(doc3.validate().isValid)
        XCTAssertEqual(doc3["a"] as? String, "\u{00e9}\u{00e9}\u{00e9}\u{00e9}\u{00e9}\u{00e9}")
        
        XCTAssert(doc4.validate().isValid)
        XCTAssertEqual(doc4["a"] as? String, "\u{2606}\u{2606}\u{2606}\u{2606}")
        
        XCTAssert(doc5.validate().isValid)
        XCTAssertEqual(doc5["a"] as? String, "ab\u{0000}bab\u{0000}babab")
        
        XCTAssertFalse(Document(bytes: [0x0C,0x00,0x00,0x00,0x02,0x61,0x00,0x00,0x00,0x00,0x00,0x00]).validate().isValid)
        XCTAssertFalse(Document(bytes: [0x0C,0x00,0x00,0x00,0x02,0x61,0x00,0xFF,0xFF,0xFF,0xFF,0x00]).validate().isValid)
        XCTAssertFalse(Document(bytes: [0x10,0x00,0x00,0x00,0x02,0x61,0x00,0x05,0x00,0x00,0x00,0x62,0x00,0x62,0x00,0x00]).validate().isValid)
        XCTAssertFalse(Document(bytes: [0x12,0x00,0x00,0x00,0x02,0x00,0xFF,0xFF,0xFF,0x00,0x66,0x6F,0x6F,0x62,0x61,0x72,0x00,0x00]).validate().isValid)
        XCTAssertFalse(Document(bytes: [0x10,0x00,0x00,0x00,0x02,0x61,0x00,0x04,0x00,0x00,0x00,0x61,0x62,0x63,0xFF,0x00]).validate().isValid)
        XCTAssertFalse(Document(bytes: [0x0E,0x00,0x00,0x00,0x02,0x61,0x00,0x01,0x00,0x00,0x00,0x00,0x00,0x00]).validate().isValid)
    }
    
    func testTest() {
        var doc = Document()
        doc["a"] = "b"
        print(doc.makeData().map {
            return "0x" + String($0, radix: 16, uppercase: true)
        }.joined(separator: ", "))
    }
    
//    func testRegex() {
//        let doc0 = Document(bytes: [0x0A,0x00,0x00,0x00,0x0B,0x61,0x00,0x00,0x00,0x00])
//        let doc1 = Document(bytes: [0x0D,0x00,0x00,0x00,0x0B,0x61,0x00,0x61,0x62,0x63,0x00,0x00,0x00])
//        let doc2 = Document(bytes: [0x0F,0x00,0x00,0x00,0x0B,0x61,0x00,0x61,0x62,0x63,0x00,0x69,0x6D,0x00,0x00])
//        let doc3 = Document(bytes: [0x11,0x00,0x00,0x00,0x0B,0x61,0x00,0x61,0x62,0x2F,0x63,0x64,0x00,0x69,0x6D,0x00,0x00])
//        let doc4 = Document(bytes: [0x10,0x00,0x00,0x00,0x0B,0x61,0x00,0x61,0x62,0x63,0x00,0x6D,0x69,0x78,0x00,0x00])
//        
//        XCTAssert(doc0.validate().isValid)
//        XCTAssert(doc1.validate().isValid)
//        XCTAssert(doc2.validate().isValid)
//        XCTAssert(doc3.validate().isValid)
//        XCTAssert(doc4.validate().isValid)
//        
//        guard let regex0 = doc0["a"] as? RegularExpression else {
//            XCTFail()
//            return
//        }
//        
//        guard let regex1 = doc1["a"] as? RegularExpression else {
//            XCTFail()
//            return
//        }
//        
//        guard let regex2 = doc2["a"] as? RegularExpression else {
//            XCTFail()
//            return
//        }
//        
//        guard let regex3 = doc3["a"] as? RegularExpression else {
//            XCTFail()
//            return
//        }
//        
//        guard let regex4 = doc4["a"] as? RegularExpression else {
//            XCTFail()
//            return
//        }
//        
//        XCTAssertEqual(regex0.pattern, "")
//        XCTAssertEqual(regex1.pattern, "abc")
//        XCTAssertEqual(regex2.pattern, "abc")
//        XCTAssertEqual(regex3.pattern, "ab/cd")
//        XCTAssertEqual(regex4.pattern, "abc")
//        
//        XCTAssertEqual(regex0.makeOptions(), "")
//        XCTAssertEqual(regex1.makeOptions(), "")
//        XCTAssertEqual(regex2.makeOptions(), "im")
//        XCTAssertEqual(regex3.makeOptions(), "im")
//        XCTAssertEqual(regex4.makeOptions(), "imx")
//        
//        XCTAssertFalse(Document(bytes: [0x0F,0x00,0x00,0x00,0x0B,0x61,0x00,0x61,0x00,0x63,0x00,0x69,0x6D,0x00,0x00]).validate().isValid)
//        XCTAssertFalse(Document(bytes: [0x10,0x00,0x00,0x00,0x0B,0x61,0x00,0x61,0x62,0x63,0x00,0x69,0x00,0x6D,0x00,0x00]).validate().isValid)
//    }
//    
    func testObjectId() throws {
        let doc0 = Document(bytes: [0x14,0x00,0x00,0x00,0x07,0x61,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00])
        let doc1 = Document(bytes: [0x14,0x00,0x00,0x00,0x07,0x61,0x00,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x00])
        let doc2 = Document(bytes: [0x14,0x00,0x00,0x00,0x07,0x61,0x00,0x56,0xE1,0xFC,0x72,0xE0,0xC9,0x17,0xE9,0xC4,0x71,0x41,0x61,0x00])
        
        XCTAssert(doc0.validate().isValid)
        XCTAssert(doc1.validate().isValid)
        XCTAssert(doc2.validate().isValid)
        
        XCTAssertEqual(doc0["a"] as? ObjectId, ObjectId("000000000000000000000000"))
        XCTAssertEqual(doc1["a"] as? ObjectId, ObjectId("ffffffffffffffffffffffff"))
        XCTAssertEqual(doc2["a"] as? ObjectId, ObjectId("56e1fc72e0c917e9c4714161"))
        
        XCTAssertFalse(Document(bytes: [0x12,0x00,0x00,0x00,0x07,0x61,0x00,0x56,0xE1,0xFC,0x72,0xE0,0xC9,0x17,0xE9,0xC4,0x71]).validate().isValid)
    }
//
//    func testNull() {
//        let doc = Document(bytes: [0x08,0x00,0x00,0x00,0x0A,0x61,0x00,0x00])
//        XCTAssert(doc.validate().isValid)
//        XCTAssertNotNil(doc["a"] as? Null)
//    }
//    
//    func testMinKey() {
//        let doc = Document(bytes: [0x08,0x00,0x00,0x00,0xFF,0x61,0x00,0x00])
//        XCTAssert(doc.validate().isValid)
//        XCTAssertNotNil(doc["a"] as? MinKey)
//    }
//    
//    func testMaxKey() {
//        let doc = Document(bytes: [0x08,0x00,0x00,0x00,0x7F,0x61,0x00,0x00])
//        XCTAssert(doc.validate().isValid)
//        XCTAssertNotNil(doc["a"] as? MaxKey)
//    }
    
    func testInt() {
        let doc0 = Document(bytes: [0x10,0x00,0x00,0x00,0x12,0x61,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x80,0x00])
        let doc1 = Document(bytes: [0x10,0x00,0x00,0x00,0x12,0x61,0x00,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x7F,0x00])
        let doc2 = Document(bytes: [0x10,0x00,0x00,0x00,0x12,0x61,0x00,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x00])
        let doc3 = Document(bytes: [0x10,0x00,0x00,0x00,0x12,0x61,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00])
        let doc4 = Document(bytes: [0x10,0x00,0x00,0x00,0x12,0x61,0x00,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00])
        
        XCTAssert(doc0.validate().isValid)
        XCTAssert(doc1.validate().isValid)
        XCTAssert(doc2.validate().isValid)
        XCTAssert(doc3.validate().isValid)
        XCTAssert(doc4.validate().isValid)
        
        XCTAssertEqual(doc0["a"] as? Int, -9223372036854775808)
        XCTAssertEqual(doc1["a"] as? Int, 9223372036854775807)
        XCTAssertEqual(doc2["a"] as? Int, -1)
        XCTAssertEqual(doc3["a"] as? Int, 0)
        XCTAssertEqual(doc4["a"] as? Int, 1)
    }
    
    func testInt32() {
        let doc0 = Document(bytes: [0x0C,0x00,0x00,0x00,0x10,0x69,0x00,0x00,0x00,0x00,0x80,0x00])
        let doc1 = Document(bytes: [0x0C,0x00,0x00,0x00,0x10,0x69,0x00,0xFF,0xFF,0xFF,0x7F,0x00])
        let doc2 = Document(bytes: [0x0C,0x00,0x00,0x00,0x10,0x69,0x00,0xFF,0xFF,0xFF,0xFF,0x00])
        let doc3 = Document(bytes: [0x0C,0x00,0x00,0x00,0x10,0x69,0x00,0x00,0x00,0x00,0x00,0x00])
        let doc4 = Document(bytes: [0x0C,0x00,0x00,0x00,0x10,0x69,0x00,0x01,0x00,0x00,0x00,0x00])
        
        assertValid(doc0)
        assertValid(doc1)
        assertValid(doc2)
        assertValid(doc3)
        assertValid(doc4)
        
        XCTAssertEqual(doc0["i"] as? Int32, -2147483648)
        XCTAssertEqual(doc1["i"] as? Int32, 2147483647)
        XCTAssertEqual(doc2["i"] as? Int32, -1)
        XCTAssertEqual(doc3["i"] as? Int32, 0)
        XCTAssertEqual(doc4["i"] as? Int32, 1)
    }

//    // Modified version of the BSON multitype test without deprecated types
//    func testMultiType() {
//        let doc = Document(bytes: [0xf4,0x01,0x00,0x00,0x07,0x5f,0x69,0x64,0x00,0x57,0xe1,0x93,0xd7,0xa9,0xcc,0x81,0xb4,0x02,0x74,0x98,0xb5,0x02,0x53,0x74,0x72,0x69,0x6e,0x67,0x00,0x07,0x00,0x00,0x00,0x73,0x74,0x72,0x69,0x6e,0x67,0x00,0x10,0x49,0x6e,0x74,0x33,0x32,0x00,0x2a,0x00,0x00,0x00,0x12,0x49,0x6e,0x74,0x36,0x34,0x00,0x2a,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x01,0x44,0x6f,0x75,0x62,0x6c,0x65,0x00,0xf6,0x28,0x5c,0x8f,0xc2,0x35,0x45,0x40,0x05,0x42,0x69,0x6e,0x61,0x72,0x79,0x00,0x10,0x00,0x00,0x00,0x03,0xa3,0x4c,0x38,0xf7,0xc3,0xab,0xed,0xc8,0xa3,0x78,0x14,0xa9,0x92,0xab,0x8d,0xb6,0x05,0x42,0x69,0x6e,0x61,0x72,0x79,0x55,0x73,0x65,0x72,0x44,0x65,0x66,0x69,0x6e,0x65,0x64,0x00,0x05,0x00,0x00,0x00,0x80,0x01,0x02,0x03,0x04,0x05,0x0d,0x43,0x6f,0x64,0x65,0x00,0x0e,0x00,0x00,0x00,0x66,0x75,0x6e,0x63,0x74,0x69,0x6f,0x6e,0x28,0x29,0x20,0x7b,0x7d,0x00,0x0f,0x43,0x6f,0x64,0x65,0x57,0x69,0x74,0x68,0x53,0x63,0x6f,0x70,0x65,0x00,0x1b,0x00,0x00,0x00,0x0e,0x00,0x00,0x00,0x66,0x75,0x6e,0x63,0x74,0x69,0x6f,0x6e,0x28,0x29,0x20,0x7b,0x7d,0x00,0x05,0x00,0x00,0x00,0x00,0x03,0x53,0x75,0x62,0x64,0x6f,0x63,0x75,0x6d,0x65,0x6e,0x74,0x00,0x12,0x00,0x00,0x00,0x02,0x66,0x6f,0x6f,0x00,0x04,0x00,0x00,0x00,0x62,0x61,0x72,0x00,0x00,0x04,0x41,0x72,0x72,0x61,0x79,0x00,0x28,0x00,0x00,0x00,0x10,0x30,0x00,0x01,0x00,0x00,0x00,0x10,0x31,0x00,0x02,0x00,0x00,0x00,0x10,0x32,0x00,0x03,0x00,0x00,0x00,0x10,0x33,0x00,0x04,0x00,0x00,0x00,0x10,0x34,0x00,0x05,0x00,0x00,0x00,0x00,0x11,0x54,0x69,0x6d,0x65,0x73,0x74,0x61,0x6d,0x70,0x00,0x01,0x00,0x00,0x00,0x2a,0x00,0x00,0x00,0x0b,0x52,0x65,0x67,0x65,0x78,0x00,0x70,0x61,0x74,0x74,0x65,0x72,0x6e,0x00,0x00,0x09,0x44,0x61,0x74,0x65,0x74,0x69,0x6d,0x65,0x45,0x70,0x6f,0x63,0x68,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x09,0x44,0x61,0x74,0x65,0x74,0x69,0x6d,0x65,0x50,0x6f,0x73,0x69,0x74,0x69,0x76,0x65,0x00,0xff,0xff,0xff,0x7f,0x00,0x00,0x00,0x00,0x09,0x44,0x61,0x74,0x65,0x74,0x69,0x6d,0x65,0x4e,0x65,0x67,0x61,0x74,0x69,0x76,0x65,0x00,0x00,0x00,0x00,0x80,0xff,0xff,0xff,0xff,0x08,0x54,0x72,0x75,0x65,0x00,0x01,0x08,0x46,0x61,0x6c,0x73,0x65,0x00,0x00,0x03,0x44,0x42,0x52,0x65,0x66,0x00,0x3d,0x00,0x00,0x00,0x02,0x24,0x72,0x65,0x66,0x00,0x0b,0x00,0x00,0x00,0x63,0x6f,0x6c,0x6c,0x65,0x63,0x74,0x69,0x6f,0x6e,0x00,0x07,0x24,0x69,0x64,0x00,0x57,0xfd,0x71,0xe9,0x6e,0x32,0xab,0x42,0x25,0xb7,0x23,0xfb,0x02,0x24,0x64,0x62,0x00,0x09,0x00,0x00,0x00,0x64,0x61,0x74,0x61,0x62,0x61,0x73,0x65,0x00,0x00,0xff,0x4d,0x69,0x6e,0x6b,0x65,0x79,0x00,0x7f,0x4d,0x61,0x78,0x6b,0x65,0x79,0x00,0x0a,0x4e,0x75,0x6c,0x6c,0x00,0x00])
//        
//        XCTAssert(doc.validate().isValid)
//        
//        XCTAssertEqual(doc.keys, ["_id", "String", "Int32", "Int64", "Double", "Binary", "BinaryUserDefined", "Code", "CodeWithScope", "Subdocument", "Array", "Timestamp", "Regex", "DatetimeEpoch", "DatetimePositive", "DatetimeNegative", "True", "False", "DBRef", "Minkey", "Maxkey", "Null"])
//    }
//     
//    func testArray() {
//        let doc0 = Document(bytes: [0x0D,0x00,0x00,0x00,0x04,0x61,0x00,0x05,0x00,0x00,0x00,0x00,0x00])
//        let doc1 = Document(bytes: [0x14,0x00,0x00,0x00,0x04,0x61,0x00,0x0C,0x00,0x00,0x00,0x10,0x30,0x00,0x0A,0x00,0x00,0x00,0x00,0x00])
//        let doc2 = Document(bytes: [0x13,0x00,0x00,0x00,0x04,0x61,0x00,0x0B,0x00,0x00,0x00,0x10,0x00,0x0A,0x00,0x00,0x00,0x00,0x00])
//        let doc3 = Document(bytes: [0x15,0x00,0x00,0x00,0x04,0x61,0x00,0x0D,0x00,0x00,0x00,0x10,0x61,0x62,0x00,0x0A,0x00,0x00,0x00,0x00,0x00])
//        
//        XCTAssert(doc0.validate().isValid)
//        XCTAssert(doc1.validate().isValid)
//        XCTAssert(doc2.validate().isValid)
//        XCTAssert(doc3.validate().isValid)
//        
//        guard let arr0 = doc0["a"] as? Document else {
//            XCTFail()
//            return
//        }
//        
//        guard let arr1 = doc1["a"] as? Document else {
//            XCTFail()
//            return
//        }
//        
//        guard let arr2 = doc2["a"] as? Document else {
//            XCTFail()
//            return
//        }
//        
//        guard let arr3 = doc3["a"] as? Document else {
//            XCTFail()
//            return
//        }
//        
//        XCTAssert(arr0.validatesAsArray())
//        XCTAssert(arr1.validatesAsArray())
//        XCTAssert(arr2.validatesAsArray())
//        XCTAssert(!arr3.validatesAsArray())
//        
//        XCTAssertEqual(arr0.count, 0)
//        
//        XCTAssertEqual(arr1[0] as? Int32, 10)
//        
//        XCTAssertEqual(arr2.first?.value as? Int32, 10)
//        
//        XCTAssertEqual(arr3.first?.value as? Int32, 10)
//        
//        XCTAssertFalse(Document(bytes: [0x14,0x00,0x00,0x00,0x04,0x61,0x00,0x0D,0x00,0x00,0x00,0x10,0x30,0x00,0x0A,0x00,0x00,0x00,0x00,0x00]).validate().isValid)
//        XCTAssertFalse(Document(bytes: [0x14,0x00,0x00,0x00,0x04,0x61,0x00,0x0B,0x00,0x00,0x00,0x10,0x30,0x00,0x0A,0x00,0x00,0x00,0x00,0x00]).validate().isValid)
//        XCTAssertFalse(Document(bytes: [0x1A,0x00,0x00,0x00,0x04,0x66,0x6F,0x6F,0x00,0x10,0x00,0x00,0x00,0x02,0x30,0x00,0x05,0x00,0x00,0x00,0x62,0x61,0x7A,0x00,0x00,0x00]).validate().isValid)
//    }
    
    func testBoolean() {
        let doc0 = Document(bytes: [0x09,0x00,0x00,0x00,0x08,0x62,0x00,0x01,0x00])
        let doc1 = Document(bytes: [0x09,0x00,0x00,0x00,0x08,0x62,0x00,0x00,0x00])
        
        XCTAssert(doc0.validate().isValid)
        XCTAssert(doc1.validate().isValid)
        
        XCTAssertEqual(doc0["b"] as? Bool, true)
        XCTAssertEqual(doc1["b"] as? Bool, false)
        
        XCTAssertFalse(Document(bytes: [0x09,0x00,0x00,0x00,0x08,0x62,0x00,0x02,0x00]).validate().isValid)
        XCTAssertFalse(Document(bytes: [0x09,0x00,0x00,0x00,0x08,0x62,0x00,0xFF,0x00]).validate().isValid)
    }
    
    func testDouble() {
        let doc0 = Document(bytes: [0x10,0x00,0x00,0x00,0x01,0x64,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xF0,0x3F,0x00])
        let doc1 = Document(bytes: [0x10,0x00,0x00,0x00,0x01,0x64,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xF0,0xBF,0x00])
        let doc2 = Document(bytes: [0x10,0x00,0x00,0x00,0x01,0x64,0x00,0x00,0x00,0x00,0x00,0x80,0x00,0xF0,0x3F,0x00])
        let doc3 = Document(bytes: [0x10,0x00,0x00,0x00,0x01,0x64,0x00,0x00,0x00,0x00,0x00,0x80,0x00,0xF0,0xBF,0x00])
        let doc4 = Document(bytes: [0x10,0x00,0x00,0x00,0x01,0x64,0x00,0x00,0x80,0x7c,0xa1,0xa9,0xa0,0x12,0x42,0x00])
        let doc5 = Document(bytes: [0x10,0x00,0x00,0x00,0x01,0x64,0x00,0x00,0x80,0x7c,0xa1,0xa9,0xa0,0x12,0xc2,0x00])
        let doc6 = Document(bytes: [0x10,0x00,0x00,0x00,0x01,0x64,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00])
        let doc7 = Document(bytes: [0x10,0x00,0x00,0x00,0x01,0x64,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x80,0x00])
        let doc8 = Document(bytes: [0x10,0x00,0x00,0x00,0x01,0x64,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xF8,0x7F,0x00])
        let doc9 = Document(bytes: [0x10,0x00,0x00,0x00,0x01,0x64,0x00,0x12,0x00,0x00,0x00,0x00,0x00,0xF8,0x7F,0x00])
        let doc10 = Document(bytes: [0x10,0x00,0x00,0x00,0x01,0x64,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xF0,0x7F,0x00])
        let doc11 = Document(bytes: [0x10,0x00,0x00,0x00,0x01,0x64,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xF0,0xFF,0x00])
        
        XCTAssert(doc0.validate().isValid)
        XCTAssert(doc1.validate().isValid)
        XCTAssert(doc2.validate().isValid)
        XCTAssert(doc3.validate().isValid)
        XCTAssert(doc4.validate().isValid)
        XCTAssert(doc5.validate().isValid)
        XCTAssert(doc6.validate().isValid)
        XCTAssert(doc7.validate().isValid)
        XCTAssert(doc8.validate().isValid)
        XCTAssert(doc9.validate().isValid)
        XCTAssert(doc10.validate().isValid)
        XCTAssert(doc11.validate().isValid)
        
        XCTAssertEqual(doc0["d"] as? Double, 1.0)
        XCTAssertEqual(doc1["d"] as? Double, -1.0)
        XCTAssertEqual(doc2["d"] as? Double, 1.0001220703125)
        XCTAssertEqual(doc3["d"] as? Double, -1.0001220703125)
        XCTAssertEqual(doc4["d"] as? Double, 2.0001220703125e10)
        XCTAssertEqual(doc5["d"] as? Double, -2.0001220703125e10)
        XCTAssertEqual(doc6["d"] as? Double, 0.0)
        XCTAssertEqual(doc7["d"] as? Double, -0.0)
        XCTAssert((doc8["d"] as? Double)?.isNaN == true)
        XCTAssert((doc9["d"] as? Double)?.isNaN == true)
        XCTAssertEqual(doc10["d"] as? Double, Double.infinity)
        XCTAssertEqual(doc11["d"] as? Double, -Double.infinity)
        
        XCTAssertFalse(Document(bytes: [0x0B,0x00,0x00,0x00,0x01,0x64,0x00,0x00,0x00,0xF0,0x3F,0x00]).validate().isValid)
    }
    
//    func testDocument() {
//        let doc0 = Document(bytes: [0x0D,0x00,0x00,0x00,0x03,0x78,0x00,0x05,0x00,0x00,0x00,0x00,0x00])
//        let doc1 = Document(bytes: [0x15,0x00,0x00,0x00,0x03,0x78,0x00,0x0D,0x00,0x00,0x00,0x02,0x00,0x02,0x00,0x00,0x00,0x62,0x00,0x00,0x00])
//        let doc2 = Document(bytes: [0x16,0x00,0x00,0x00,0x03,0x78,0x00,0x0E,0x00,0x00,0x00,0x02,0x61,0x00,0x02,0x00,0x00,0x00,0x62,0x00,0x00,0x00])
//        
//        XCTAssert(doc0.validate().isValid)
//        XCTAssert(doc1.validate().valid)
//        XCTAssert(doc2.validate().valid)
//        
//        XCTAssertEqual(doc0.count, 1)
//        XCTAssertEqual(doc1.count, 1)
//        XCTAssertEqual(doc2.count, 1)
//        
//        XCTAssertEqual(Document(lossy: doc0["x"])?.count, 0)
//        XCTAssertEqual(Document(lossy: doc1["x"])?.count, 1)
//        XCTAssertEqual(Document(lossy: doc2["x"])?.count, 1)
//        
//        XCTAssertEqual(Document(lossy: doc0["x"])?.count, 0)
//        XCTAssertEqual(Document(lossy: doc1["x"])?[""] as? String, "b")
//        XCTAssertEqual(Document(lossy: doc2["x"])?["a"] as? String, "b")
//        
//        XCTAssertFalse(Document(bytes: [0x18,0x00,0x00,0x00,0x03,0x66,0x6F,0x6F,0x00,0x0F,0x00,0x00,0x00,0x10,0x62,0x61,0x72,0x00,0xFF,0xFF,0xFF,0x7F,0x00,0x00]).validate().valid)
//        XCTAssertFalse(Document(bytes: [0x15,0x00,0x00,0x00,0x03,0x66,0x6F,0x6F,0x00,0x0A,0x00,0x00,0x00,0x08,0x62,0x61,0x72,0x00,0x01,0x00,0x00]).validate().valid)
//        XCTAssertFalse(Document(bytes: [0x1C,0x00,0x00,0x00,0x03,0x66,0x6F,0x6F,0x00,0x12,0x00,0x00,0x00,0x02,0x62,0x61,0x72,0x00,0x05,0x00,0x00,0x00,0x62,0x61,0x7A,0x00,0x00,0x00]).validate().valid)
//    }
//    
//    func testDateTime() {
//        let doc0 = Document(bytes: [0x10,0x00,0x00,0x00,0x09,0x61,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00])
//        let doc1 = Document(bytes: [0x10,0x00,0x00,0x00,0x09,0x61,0x00,0xC4,0xD8,0xD6,0xCC,0x3B,0x01,0x00,0x00,0x00])
//        let doc2 = Document(bytes: [0x10,0x00,0x00,0x00,0x09,0x61,0x00,0xC4,0x3C,0xE7,0xB9,0xBD,0xFF,0xFF,0xFF,0x00])
//        
//        XCTAssert(doc0.validate().valid)
//        XCTAssert(doc1.validate().valid)
//        XCTAssert(doc2.validate().valid)
//        
//        XCTAssertEqual(doc0["a"] as? Date, Date(timeIntervalSince1970: 0))
//        XCTAssertEqual(doc1["a"] as? Date, Date(timeIntervalSince1970: 1356351330.500))
//        XCTAssertEqual(doc2["a"] as? Date, Date(timeIntervalSince1970: -284643869.500))
//        
//        XCTAssertFalse(Document(bytes: [0x0C,0x00,0x00,0x00,0x09,0x61,0x00,0x12,0x34,0x56,0x78,0x00]).validate().valid)
//    }
//    
//    func testBinary() {
//        let doc0 = Document(bytes: [0x0D,0x00,0x00,0x00,0x05,0x78,0x00,0x00,0x00,0x00,0x00,0x00,0x00])
//        let doc1 = Document(bytes: [0x0F,0x00,0x00,0x00,0x05,0x78,0x00,0x02,0x00,0x00,0x00,0x00,0xFF,0xFF,0x00])
//        let doc2 = Document(bytes: [0x0F,0x00,0x00,0x00,0x05,0x78,0x00,0x02,0x00,0x00,0x00,0x01,0xFF,0xFF,0x00])
//        let doc3 = Document(bytes: [0x13,0x00,0x00,0x00,0x05,0x78,0x00,0x06,0x00,0x00,0x00,0x02,0x02,0x00,0x00,0x00,0xff,0xff,0x00])
//        let doc4 = Document(bytes: [0x1D,0x00,0x00,0x00,0x05,0x78,0x00,0x10,0x00,0x00,0x00,0x03,0x73,0xFF,0xD2,0x64,0x44,0xB3,0x4C,0x69,0x90,0xE8,0xE7,0xD1,0xDF,0xC0,0x35,0xD4,0x00])
//        let doc5 = Document(bytes: [0x1D,0x00,0x00,0x00,0x05,0x78,0x00,0x10,0x00,0x00,0x00,0x04,0x73,0xFF,0xD2,0x64,0x44,0xB3,0x4C,0x69,0x90,0xE8,0xE7,0xD1,0xDF,0xC0,0x35,0xD4,0x00])
//        let doc6 = Document(bytes: [0x1D,0x00,0x00,0x00,0x05,0x78,0x00,0x10,0x00,0x00,0x00,0x05,0x73,0xFF,0xD2,0x64,0x44,0xB3,0x4C,0x69,0x90,0xE8,0xE7,0xD1,0xDF,0xC0,0x35,0xD4,0x00])
//        let doc7 = Document(bytes: [0x0F,0x00,0x00,0x00,0x05,0x78,0x00,0x02,0x00,0x00,0x00,0x80,0xFF,0xFF,0x00])
//        
//        XCTAssert(doc0.validate().valid)
//        XCTAssert(doc1.validate().valid)
//        XCTAssert(doc2.validate().valid)
//        XCTAssert(doc3.validate().valid)
//        XCTAssert(doc4.validate().valid)
//        XCTAssert(doc5.validate().valid)
//        XCTAssert(doc6.validate().valid)
//        XCTAssert(doc7.validate().valid)
//        
//        XCTAssertEqual((doc0["x"] as? Binary)?.data, Data())
//        XCTAssertEqual((doc0["x"] as? Binary)?.subtype.rawValue, 0x00)
//        
//        XCTAssertEqual((doc1["x"] as? Binary)?.data, Data([0xFF,0xFF]))
//        XCTAssertEqual((doc1["x"] as? Binary)?.subtype.rawValue, 0x00)
//        
//        XCTAssertEqual((doc2["x"] as? Binary)?.data, Data([0xFF,0xFF]))
//        XCTAssertEqual((doc2["x"] as? Binary)?.subtype.rawValue, 0x01)
//        
//        XCTAssertEqual((doc3["x"] as? Binary)?.data, Data([0x02,0x00,0x00,0x00,0xff,0xff]))
//        XCTAssertEqual((doc3["x"] as? Binary)?.subtype.rawValue, 0x02)
//        
//        XCTAssertEqual((doc4["x"] as? Binary)?.data, Data([0x73,0xFF,0xD2,0x64,0x44,0xB3,0x4C,0x69,0x90,0xE8,0xE7,0xD1,0xDF,0xC0,0x35,0xD4]))
//        XCTAssertEqual((doc4["x"] as? Binary)?.subtype.rawValue, 0x03)
//        
//        XCTAssertEqual((doc5["x"] as? Binary)?.data, Data([0x73,0xFF,0xD2,0x64,0x44,0xB3,0x4C,0x69,0x90,0xE8,0xE7,0xD1,0xDF,0xC0,0x35,0xD4]))
//        XCTAssertEqual((doc5["x"] as? Binary)?.subtype.rawValue, 0x04)
//        
//        XCTAssertEqual((doc6["x"] as? Binary)?.data, Data([0x73,0xFF,0xD2,0x64,0x44,0xB3,0x4C,0x69,0x90,0xE8,0xE7,0xD1,0xDF,0xC0,0x35,0xD4]))
//        XCTAssertEqual((doc6["x"] as? Binary)?.subtype.rawValue, 0x05)
//        
//        XCTAssertEqual((doc7["x"] as? Binary)?.data, Data([0xFF,0xFF]))
//        XCTAssertEqual((doc7["x"] as? Binary)?.subtype.rawValue, 0x80)
//        
//        XCTAssertFalse(Document(bytes: [0x1D,0x00,0x00,0x00,0x05,0x78,0x00,0xFF,0x00,0x00,0x00,0x05,0x73,0xFF,0xD2,0x64,0x44,0xB3,0x4C,0x69,0x90,0xE8,0xE7,0xD1,0xDF,0xC0,0x35,0xD4,0x00]).validate().valid)
//        XCTAssertFalse(Document(bytes: [0x0D,0x00,0x00,0x00,0x05,0x78,0x00,0xFF,0xFF,0xFF,0xFF,0x00,0x00]).validate().valid)
//        
//        // TODO: Support old code?
////        XCTAssertFalse(Document(bytes: [0x13,0x00,0x00,0x00,0x05,0x78,0x00,0x06,0x00,0x00,0x00,0x02,0x03,0x00,0x00,0x00,0xFF,0xFF,0x00]).validate().valid)
////        XCTAssertFalse(Document(bytes: [0x13,0x00,0x00,0x00,0x05,0x78,0x00,0x06,0x00,0x00,0x00,0x02,0x01,0x00,0x00,0x00,0xFF,0xFF,0x00]).validate().valid)
////        XCTAssertFalse(Document(bytes: [0x13,0x00,0x00,0x00,0x05,0x78,0x00,0x06,0x00,0x00,0x00,0x02,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x00]).validate().valid)
//    }
//    
//    func testCode() {
//        let doc0 = Document(bytes: [0x0D,0x00,0x00,0x00,0x0D,0x61,0x00,0x01,0x00,0x00,0x00,0x00,0x00])
//        let doc1 = Document(bytes: [0x0E,0x00,0x00,0x00,0x0D,0x61,0x00,0x02,0x00,0x00,0x00,0x62,0x00,0x00])
//        let doc2 = Document(bytes: [0x19,0x00,0x00,0x00,0x0D,0x61,0x00,0x0D,0x00,0x00,0x00,0x61,0x62,0x61,0x62,0x61,0x62,0x61,0x62,0x61,0x62,0x61,0x62,0x00,0x00])
//        let doc3 = Document(bytes: [0x19,0x00,0x00,0x00,0x02,0x61,0x00,0x0D,0x00,0x00,0x00,0xC3,0xA9,0xC3,0xA9,0xC3,0xA9,0xC3,0xA9,0xC3,0xA9,0xC3,0xA9,0x00,0x00])
//        let doc4 = Document(bytes: [0x19,0x00,0x00,0x00,0x02,0x61,0x00,0x0D,0x00,0x00,0x00,0xE2,0x98,0x86,0xE2,0x98,0x86,0xE2,0x98,0x86,0xE2,0x98,0x86,0x00,0x00])
//        let doc5 = Document(bytes: [0x19,0x00,0x00,0x00,0x02,0x61,0x00,0x0D,0x00,0x00,0x00,0x61,0x62,0x00,0x62,0x61,0x62,0x00,0x62,0x61,0x62,0x61,0x62,0x00,0x00])
//        
//        XCTAssert(doc0.validate().valid)
//        XCTAssert(doc1.validate().valid)
//        XCTAssert(doc2.validate().valid)
//        XCTAssert(doc3.validate().valid)
//        XCTAssert(doc4.validate().valid)
//        XCTAssert(doc5.validate().valid)
//        
//        XCTAssertEqual((doc0["a"] as? JavascriptCode)?.code, "")
//        XCTAssertEqual((doc1["a"] as? JavascriptCode)?.code, "b")
//        XCTAssertEqual((doc2["a"] as? JavascriptCode)?.code, "abababababab")
//        
//        // This is valid BSON, but these tests use String rather than JavascriptCode. So comment them, they're irrelevant
////        XCTAssertEqual((doc3["a"] as? JavascriptCode)?.code, "\u{00e9}\u{00e9}\u{00e9}\u{00e9}\u{00e9}\u{00e9}")
////        XCTAssertEqual((doc4["a"] as? JavascriptCode)?.code, "\u{2606}\u{2606}\u{2606}\u{2606}\u{2606}")
////        XCTAssertEqual((doc5["a"] as? JavascriptCode)?.code, "ab\u{0000}bab\u{0000}babab")
//        
//        XCTAssertFalse(Document(bytes: [0x0C,0x00,0x00,0x00,0x02,0x61,0x00,0x00,0x00,0x00,0x00,0x00]).validate().valid)
//        XCTAssertFalse(Document(bytes: [0x0C,0x00,0x00,0x00,0x02,0x61,0x00,0xFF,0xFF,0xFF,0xFF,0x00]).validate().valid)
//        XCTAssertFalse(Document(bytes: [0x10,0x00,0x00,0x00,0x02,0x61,0x00,0x05,0x00,0x00,0x00,0x62,0x00,0x62,0x00,0x00]).validate().valid)
//        XCTAssertFalse(Document(bytes: [0x12,0x00,0x00,0x00,0x02,0x00,0xFF,0xFF,0xFF,0x00,0x66,0x6F,0x6F,0x62,0x61,0x72,0x00,0x00]).validate().valid)
//        XCTAssertFalse(Document(bytes: [0x10,0x00,0x00,0x00,0x02,0x61,0x00,0x04,0x00,0x00,0x00,0x61,0x62,0x63,0xFF,0x00]).validate().valid)
//        XCTAssertFalse(Document(bytes: [0x0E,0x00,0x00,0x00,0x02,0x61,0x00,0x01,0x00,0x00,0x00,0x00,0x00,0x00]).validate().valid)
//        
//        // Not out problem, we don't do UTF-8 validation
////        XCTAssertFalse(Document(bytes: [0x0E,0x00,0x00,0x00,0x02,0x61,0x00,0x02,0x00,0x00,0x00,0xE9,0x00,0x00]).validate().valid)
//    }
//    
//    func testCodeWithScope() {
//        let doc0 = Document(bytes: [0x16,0x00,0x00,0x00,0x0F,0x61,0x00,0x0E,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x00,0x05,0x00,0x00,0x00,0x00,0x00])
//        let doc1 = Document(bytes: [0x1A,0x00,0x00,0x00,0x0F,0x61,0x00,0x12,0x00,0x00,0x00,0x05,0x00,0x00,0x00,0x61,0x62,0x63,0x64,0x00,0x05,0x00,0x00,0x00,0x00,0x00])
//        let doc2 = Document(bytes: [0x1D,0x00,0x00,0x00,0x0F,0x61,0x00,0x15,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x00,0x0C,0x00,0x00,0x00,0x10,0x78,0x00,0x01,0x00,0x00,0x00,0x00,0x00])
//        let doc3 = Document(bytes: [0x21,0x00,0x00,0x00,0x0F,0x61,0x00,0x19,0x00,0x00,0x00,0x05,0x00,0x00,0x00,0x61,0x62,0x63,0x64,0x00,0x0C,0x00,0x00,0x00,0x10,0x78,0x00,0x01,0x00,0x00,0x00,0x00,0x00])
//        let doc4 = Document(bytes: [0x1A,0x00,0x00,0x00,0x0F,0x61,0x00,0x12,0x00,0x00,0x00,0x05,0x00,0x00,0x00,0xC3,0xA9,0x00,0x64,0x00,0x05,0x00,0x00,0x00,0x00,0x00])
//        
//        XCTAssert(doc0.validate().valid)
//        XCTAssert(doc1.validate().valid)
//        XCTAssert(doc2.validate().valid)
//        XCTAssert(doc3.validate().valid)
//        XCTAssert(doc4.validate().valid)
//        
//        XCTAssertEqual((doc0["a"] as? JavascriptCode)?.code, "")
//        XCTAssertEqual((doc0["a"] as? JavascriptCode)?.scope, [:])
//        
//        XCTAssertEqual((doc1["a"] as? JavascriptCode)?.code, "abcd")
//        XCTAssertEqual((doc1["a"] as? JavascriptCode)?.scope, [:])
//        
//        XCTAssertEqual((doc2["a"] as? JavascriptCode)?.code, "")
//        XCTAssertEqual((doc2["a"] as? JavascriptCode)?.scope, ["x": Int32(1)])
//        
//        XCTAssertEqual((doc3["a"] as? JavascriptCode)?.code, "abcd")
//        XCTAssertEqual((doc3["a"] as? JavascriptCode)?.scope, ["x": Int32(1)])
//        
//        XCTAssertEqual((doc4["a"] as? JavascriptCode)?.code, "\u{00e9}\u{0000}d")
//        XCTAssertEqual((doc4["a"] as? JavascriptCode)?.scope, [:])
//        
//        XCTAssertFalse(Document(bytes: [0x28,0x00,0x00,0x00,0x0F,0x61,0x00,0x00,0x00,0x00,0x00,0x05,0x00,0x00,0x00,0x61,0x62,0x63,0x64,0x00,0x13,0x00,0x00,0x00,0x10,0x78,0x00,0x01,0x00,0x00,0x00,0x10,0x79,0x00,0x01,0x00,0x00,0x00,0x00,0x00]).validate().valid)
//        XCTAssertFalse(Document(bytes: [0x28,0x00,0x00,0x00,0x0F,0x61,0x00,0xFF,0xFF,0xFF,0xFF,0x05,0x00,0x00,0x00,0x61,0x62,0x63,0x64,0x00,0x13,0x00,0x00,0x00,0x10,0x78,0x00,0x01,0x00,0x00,0x00,0x10,0x79,0x00,0x01,0x00,0x00,0x00,0x00,0x00]).validate().valid)
//        XCTAssertFalse(Document(bytes: [0x16,0x00,0x00,0x00,0x0F,0x61,0x00,0x0D,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x00,0x05,0x00,0x00,0x00,0x00,0x00]).validate().valid)
//        XCTAssertFalse(Document(bytes: [0x28,0x00,0x00,0x00,0x0F,0x61,0x00,0x1F,0x00,0x00,0x00,0x05,0x00,0x00,0x00,0x61,0x62,0x63,0x64,0x00,0x13,0x00,0x00,0x00,0x10,0x78,0x00,0x01,0x00,0x00,0x00,0x10,0x79,0x00,0x01,0x00,0x00,0x00,0x00,0x00]).validate().valid)
//        XCTAssertFalse(Document(bytes: [0x28,0x00,0x00,0x00,0x0F,0x61,0x00,0x21,0x00,0x00,0x00,0x05,0x00,0x00,0x00,0x61,0x62,0x63,0x64,0x00,0x13,0x00,0x00,0x00,0x10,0x78,0x00,0x01,0x00,0x00,0x00,0x10,0x79,0x00,0x01,0x00,0x00,0x00,0x00,0x00]).validate().valid)
//        XCTAssertFalse(Document(bytes: [0x28,0x00,0x00,0x00,0x0F,0x61,0x00,0xFF,0x00,0x00,0x00,0x05,0x00,0x00,0x00,0x61,0x62,0x63,0x64,0x00,0x13,0x00,0x00,0x00,0x10,0x78,0x00,0x01,0x00,0x00,0x00,0x10,0x79,0x00,0x01,0x00,0x00,0x00,0x00,0x00]).validate().valid)
//// TODO: Fix validation       XCTAssertFalse(Document(bytes: [0x28,0x00,0x00,0x00,0x0F,0x61,0x00,0x20,0x00,0x00,0x00,0x04,0x00,0x00,0x00,0x61,0x62,0x63,0x64,0x00,0x13,0x00,0x00,0x00,0x10,0x78,0x00,0x01,0x00,0x00,0x00,0x10,0x79,0x00,0x01,0x00,0x00,0x00,0x00,0x00]).validate().valid)
//// TODO: Fix validation       XCTAssertFalse(Document(bytes: [0x28,0x00,0x00,0x00,0x0F,0x61,0x00,0x20,0x00,0x00,0x00,0x06,0x00,0x00,0x00,0x61,0x62,0x63,0x64,0x00,0x13,0x00,0x00,0x00,0x10,0x78,0x00,0x01,0x00,0x00,0x00,0x10,0x79,0x00,0x01,0x00,0x00,0x00,0x00,0x00]).validate().valid)
//        XCTAssertFalse(Document(bytes: [0x28,0x00,0x00,0x00,0x0F,0x61,0x00,0x21,0x00,0x00,0x00,0x05,0x00,0x00,0x00,0x61,0x62,0x63,0x64,0x00,0x13,0x00,0x00,0x00,0x10,0x78,0x00,0x01,0x00,0x00,0x00,0x10,0x79,0x00,0x01,0x00,0x00,0x00,0x00,0x00]).validate().valid)
//        XCTAssertFalse(Document(bytes: [0x28,0x00,0x00,0x00,0x0F,0x61,0x00,0xFF,0x00,0x00,0x00,0x05,0x00,0x00,0x00,0x61,0x62,0x63,0x64,0x00,0x13,0x00,0x00,0x00,0x10,0x78,0x00,0x01,0x00,0x00,0x00,0x10,0x79,0x00,0x01,0x00,0x00,0x00,0x00,0x00]).validate().valid)
//        // TODO: Fix validation       XCTAssertFalse(Document(bytes: [0x28,0x00,0x00,0x00,0x0F,0x61,0x00,0x20,0x00,0x00,0x00,0x04,0x00,0x00,0x00,0x61,0x62,0x63,0x64,0x00,0x13,0x00,0x00,0x00,0x10,0x78,0x00,0x01,0x00,0x00,0x00,0x10,0x79,0x00,0x01,0x00,0x00,0x00,0x00,0x00]).validate().valid)
//        
//    }
}


