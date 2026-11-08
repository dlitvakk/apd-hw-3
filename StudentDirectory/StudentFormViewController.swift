import UIKit
import SnapKit

extension StudentStoreError {
    var userMessage: String {
        switch self {
        case .blankName: return "Name can't be blank."
        case .nonPositiveAge: return "Age must be greater than 0."
        case .unknownID: return "This student no longer exists."
        }
    }
}

final class StudentFormViewController: UIViewController {
    private let onSubmit: (String, Int) throws -> Void
    private let initialName: String
    private let initialAge: Int?

    private let nameField: UITextField = {
        let field = UITextField()
        field.placeholder = "Name"
        field.borderStyle = .roundedRect
        field.font = .preferredFont(forTextStyle: .body)
        field.adjustsFontForContentSizeCategory = true
        field.autocapitalizationType = .words
        field.accessibilityIdentifier = "studentNameField"
        return field
    }()

    private let ageField: UITextField = {
        let field = UITextField()
        field.placeholder = "Age"
        field.borderStyle = .roundedRect
        field.font = .preferredFont(forTextStyle: .body)
        field.adjustsFontForContentSizeCategory = true
        field.keyboardType = .numberPad
        field.accessibilityIdentifier = "studentAgeField"
        return field
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .systemRed
        label.numberOfLines = 0
        label.accessibilityIdentifier = "formErrorLabel"
        return label
    }()

    init(
        title: String,
        name: String = "",
        age: Int? = nil,
        onSubmit: @escaping (String, Int) throws -> Void
    ) {
        self.initialName = name
        self.initialAge = age
        self.onSubmit = onSubmit
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported; use init(title:name:age:onSubmit:)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            systemItem: .cancel,
            primaryAction: UIAction { [weak self] _ in self?.dismiss(animated: true) }
        )
        navigationItem.leftBarButtonItem?.accessibilityIdentifier = "cancelStudentButton"

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            systemItem: .save,
            primaryAction: UIAction { [weak self] _ in self?.save() }
        )
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "saveStudentButton"

        nameField.text = initialName
        ageField.text = initialAge.map(String.init)

        let stack = UIStackView(arrangedSubviews: [nameField, ageField, errorLabel])
        stack.axis = .vertical
        stack.spacing = 12
        view.addSubview(stack)
        stack.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

    private func save() {
        let name = nameField.text ?? ""
        guard let age = Int((ageField.text ?? "").trimmingCharacters(in: .whitespaces)) else {
            errorLabel.text = "Enter a valid age."
            return
        }
        do {
            try onSubmit(name, age)
            dismiss(animated: true)
        } catch let error as StudentStoreError {
            errorLabel.text = error.userMessage
        } catch {
            errorLabel.text = "Something went wrong. Please try again."
        }
    }
}
