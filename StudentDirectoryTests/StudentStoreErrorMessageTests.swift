import XCTest
@testable import StudentDirectory

final class StudentStoreErrorMessageTests: XCTestCase {
    func testEachStoreErrorHasADistinctUserMessage() {
        let messages = [
            StudentStoreError.blankName.userMessage,
            StudentStoreError.nonPositiveAge.userMessage,
            StudentStoreError.unknownID(UUID()).userMessage
        ]
        XCTAssertEqual(Set(messages).count, 3)
        XCTAssertTrue(messages.allSatisfy { !$0.isEmpty })
    }

    func testValidationErrorsMapToTheStoreErrorsTheFormDisplays() {
        let store = StudentStore(students: StudentSeedData.students)
        do {
            try store.addStudent(name: "", age: 20)
            XCTFail("Expected blank name to be rejected")
        } catch let error as StudentStoreError {
            XCTAssertEqual(error.userMessage, "Name can't be blank.")
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
        do {
            try store.addStudent(name: "Valid", age: 0)
            XCTFail("Expected non-positive age to be rejected")
        } catch let error as StudentStoreError {
            XCTAssertEqual(error.userMessage, "Age must be greater than 0.")
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
        XCTAssertEqual(store.students.count, 10)
    }
}
