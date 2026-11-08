import XCTest

final class StudentDirectoryFlowUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    private func cellID(_ number: Int) -> String {
        "studentCell." + String(format: "00000000-0000-0000-0000-%012d", number)
    }

    private func cell(_ number: Int) -> XCUIElement {
        app.cells[cellID(number)]
    }

    func testListShowsStudentsTitleAndSeedRows() {
        XCTAssertTrue(app.navigationBars["Students"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.tables["studentList"].exists)
        XCTAssertTrue(cell(1).exists)
        XCTAssertTrue(cell(2).exists)
        XCTAssertTrue(cell(1).label.contains("Ada Lovelace"))
    }

    func testTappingRowPushesDetailWithStudentFields() {
        XCTAssertTrue(cell(1).waitForExistence(timeout: 5))
        cell(1).tap()

        XCTAssertTrue(app.descendants(matching: .any)["studentDetails"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Ada Lovelace"].exists)
        XCTAssertTrue(app.staticTexts["Age: 20"].exists)
        XCTAssertTrue(app.staticTexts["Average grade: 97.5"].exists)
        XCTAssertTrue(app.staticTexts["Scholarship holder: Yes"].exists)
        XCTAssertTrue(app.buttons["subjectButton.Algorithms"].exists)
        XCTAssertTrue(app.buttons["subjectButton.Math"].exists)
        XCTAssertTrue(app.buttons["subjectButton.Design"].exists)
    }

    func testBackButtonReturnsFromDetailToList() {
        XCTAssertTrue(cell(1).waitForExistence(timeout: 5))
        cell(1).tap()
        XCTAssertTrue(app.descendants(matching: .any)["studentDetails"].waitForExistence(timeout: 5))

        app.navigationBars.buttons.element(boundBy: 0).tap()

        XCTAssertTrue(app.navigationBars["Students"].waitForExistence(timeout: 5))
        XCTAssertTrue(cell(1).exists)
    }

    func testSubjectButtonShowsOnlyMatchingStudentsWithSubjectTitle() {
        XCTAssertTrue(cell(1).waitForExistence(timeout: 5))
        cell(1).tap()
        let math = app.buttons["subjectButton.Math"]
        XCTAssertTrue(math.waitForExistence(timeout: 5))
        math.tap()

        XCTAssertTrue(app.navigationBars["Math"].waitForExistence(timeout: 5))
        // Math students: Ada (1), Katherine (4), Donald (7).
        XCTAssertTrue(cell(1).exists)
        XCTAssertTrue(cell(4).exists)
        XCTAssertTrue(cell(7).exists)
        // Grace (3) takes Programming and Algorithms only.
        XCTAssertFalse(cell(3).exists)
        XCTAssertFalse(cell(2).exists)
    }

    func testFilteredRowOpensThatStudentsDetails() {
        XCTAssertTrue(cell(1).waitForExistence(timeout: 5))
        cell(1).tap()
        let physics = app.buttons["subjectButton.Math"]
        XCTAssertTrue(physics.waitForExistence(timeout: 5))
        physics.tap()
        XCTAssertTrue(cell(4).waitForExistence(timeout: 5))
        cell(4).tap()

        XCTAssertTrue(app.descendants(matching: .any)["studentDetails"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Katherine Johnson"].exists)
    }
}
