import XCTest

final class StudentDirectoryMutationUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    private func cell(_ number: Int) -> XCUIElement {
        app.cells["studentCell." + String(format: "00000000-0000-0000-0000-%012d", number)]
    }

    private func cell(containing text: String) -> XCUIElement {
        app.cells.matching(NSPredicate(format: "label CONTAINS %@", text)).firstMatch
    }

    private func replaceText(in field: XCUIElement, with text: String) {
        field.tap()
        let current = field.value as? String ?? ""
        if !current.isEmpty {
            field.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: current.count))
        }
        field.typeText(text)
    }

    func testAddingValidStudentShowsNewRowInList() {
        XCTAssertTrue(app.buttons["addStudentButton"].waitForExistence(timeout: 5))
        app.buttons["addStudentButton"].tap()

        let name = app.textFields["studentNameField"]
        XCTAssertTrue(name.waitForExistence(timeout: 5))
        replaceText(in: name, with: "Test Newcomer")
        replaceText(in: app.textFields["studentAgeField"], with: "19")
        app.buttons["saveStudentButton"].tap()

        XCTAssertTrue(app.navigationBars["Students"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.tables["studentList"].exists)
        app.tables["studentList"].swipeUp()
        XCTAssertTrue(cell(containing: "Test Newcomer").waitForExistence(timeout: 5))
    }

    func testAddingBlankNameShowsErrorAndKeepsFormOpen() {
        XCTAssertTrue(app.buttons["addStudentButton"].waitForExistence(timeout: 5))
        app.buttons["addStudentButton"].tap()

        let age = app.textFields["studentAgeField"]
        XCTAssertTrue(age.waitForExistence(timeout: 5))
        replaceText(in: age, with: "20")
        app.buttons["saveStudentButton"].tap()

        XCTAssertTrue(app.staticTexts["Name can't be blank."].waitForExistence(timeout: 5))
        XCTAssertTrue(app.textFields["studentNameField"].exists)
    }

    func testEditingStudentUpdatesDetailScreen() {
        XCTAssertTrue(cell(1).waitForExistence(timeout: 5))
        cell(1).tap()
        XCTAssertTrue(app.buttons["editStudentButton"].waitForExistence(timeout: 5))
        app.buttons["editStudentButton"].tap()

        let name = app.textFields["studentNameField"]
        XCTAssertTrue(name.waitForExistence(timeout: 5))
        replaceText(in: name, with: "Ada King")
        replaceText(in: app.textFields["studentAgeField"], with: "36")
        app.buttons["saveStudentButton"].tap()

        XCTAssertTrue(app.staticTexts["Age: 36"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Ada King"].exists)
    }

    func testSwipeToDeleteRemovesStudentFromList() {
        XCTAssertTrue(cell(1).waitForExistence(timeout: 5))
        cell(1).swipeLeft()
        XCTAssertTrue(app.buttons["Delete"].waitForExistence(timeout: 5))
        app.buttons["Delete"].tap()

        XCTAssertTrue(cell(2).waitForExistence(timeout: 5))
        XCTAssertFalse(cell(1).exists)
    }
}
