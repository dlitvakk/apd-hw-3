import XCTest
@testable import StudentDirectory

final class StudentStoreTests: XCTestCase {
    private func makeStore() -> StudentStore {
        StudentStore(students: StudentSeedData.students)
    }

    private func id(_ number: Int) -> UUID {
        UUID(uuidString: String(format: "00000000-0000-0000-0000-%012d", number))!
    }

    func testSeedDataHasTenStudentsWithUniqueIDs() {
        let students = makeStore().students
        XCTAssertEqual(students.count, 10)
        XCTAssertEqual(Set(students.map(\.id)).count, 10)
    }

    func testSubjectFilterKeepsOnlyMatchingStudentsInStoreOrder() {
        let result = makeStore().students(matchingSubject: "Algorithms")
        XCTAssertEqual(result.map(\.id), [id(1), id(2), id(3), id(5), id(7)])
        XCTAssertTrue(result.allSatisfy { $0.subjects.contains("Algorithms") })
    }

    func testSubjectFilterIsCaseSensitive() {
        let store = makeStore()
        XCTAssertTrue(store.students(matchingSubject: "algorithms").isEmpty)
        XCTAssertTrue(store.students(matchingSubject: "MATH").isEmpty)
        XCTAssertEqual(store.students(matchingSubject: "Math").count, 3)
    }

    func testUnknownSubjectReturnsNoStudentsAndDoesNotChangeStore() {
        let store = makeStore()
        XCTAssertTrue(store.students(matchingSubject: "Chemistry").isEmpty)
        XCTAssertEqual(store.students, StudentSeedData.students)
    }

    func testAddStudentUsesRequiredDefaults() throws {
        let store = makeStore()
        try store.addStudent(name: "New Student", age: 19)

        XCTAssertEqual(store.students.count, 11)
        let added = try XCTUnwrap(store.students.last)
        XCTAssertEqual(added.name, "New Student")
        XCTAssertEqual(added.age, 19)
        XCTAssertEqual(added.averageGrade, 0)
        XCTAssertFalse(added.isScholarshipHolder)
        XCTAssertTrue(added.subjects.isEmpty)
        XCTAssertEqual(added.avatarName, "avatar-default")
        XCTAssertFalse(StudentSeedData.students.map(\.id).contains(added.id))
    }

    func testInvalidAddIsRejectedWithoutMutation() {
        let store = makeStore()
        XCTAssertThrowsError(try store.addStudent(name: "   ", age: 20)) {
            XCTAssertEqual($0 as? StudentStoreError, .blankName)
        }
        XCTAssertThrowsError(try store.addStudent(name: "Valid", age: 0)) {
            XCTAssertEqual($0 as? StudentStoreError, .nonPositiveAge)
        }
        XCTAssertThrowsError(try store.addStudent(name: "Valid", age: -3))
        XCTAssertEqual(store.students, StudentSeedData.students)
    }

    func testUpdateChangesOnlyNameAndAge() throws {
        let store = makeStore()
        let original = try XCTUnwrap(store.students.first)

        try store.updateStudent(id: original.id, name: "Ada King", age: 36)

        let updated = try XCTUnwrap(store.students.first)
        XCTAssertEqual(updated.name, "Ada King")
        XCTAssertEqual(updated.age, 36)
        XCTAssertEqual(updated.id, original.id)
        XCTAssertEqual(updated.averageGrade, original.averageGrade)
        XCTAssertEqual(updated.isScholarshipHolder, original.isScholarshipHolder)
        XCTAssertEqual(updated.subjects, original.subjects)
        XCTAssertEqual(updated.avatarName, original.avatarName)
    }

    func testUnknownIDDoesNotMutateOnUpdateOrDelete() {
        let store = makeStore()
        let unknown = UUID()

        XCTAssertThrowsError(try store.updateStudent(id: unknown, name: "Ghost", age: 30)) {
            XCTAssertEqual($0 as? StudentStoreError, .unknownID(unknown))
        }
        XCTAssertThrowsError(try store.deleteStudent(id: unknown)) {
            XCTAssertEqual($0 as? StudentStoreError, .unknownID(unknown))
        }
        XCTAssertEqual(store.students, StudentSeedData.students)
    }

    func testDeleteRemovesStudentFromSubjectResultsToo() throws {
        let store = makeStore()
        try store.deleteStudent(id: id(1))

        XCTAssertEqual(store.students.count, 9)
        XCTAssertFalse(store.students.contains { $0.id == id(1) })
        XCTAssertEqual(store.students(matchingSubject: "Design").map(\.id), [id(6), id(8), id(9)])
    }
}
