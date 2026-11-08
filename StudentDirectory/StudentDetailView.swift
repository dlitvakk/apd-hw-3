import UIKit
import SnapKit

final class StudentDetailView: UIView {
    private let scrollView = UIScrollView()

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .fill
        return stack
    }()

    private let avatarImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 60
        view.tintColor = .secondaryLabel
        view.backgroundColor = .secondarySystemBackground
        view.isAccessibilityElement = false
        return view
    }()

    private let avatarContainer = UIView()

    private let nameLabel = StudentDetailView.makeLabel(style: .title1, alignment: .center)
    private let idLabel = StudentDetailView.makeLabel(style: .caption1, color: .secondaryLabel, alignment: .center)
    private let ageLabel = StudentDetailView.makeLabel(style: .body)
    private let gradeLabel = StudentDetailView.makeLabel(style: .body)
    private let scholarshipLabel = StudentDetailView.makeLabel(style: .body)
    private let subjectsTitleLabel = StudentDetailView.makeLabel(style: .body)

    private let subjectsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
        return stack
    }()

    var onSubjectTap: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        accessibilityIdentifier = "studentDetails"
        setUpLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported; build the view in code")
    }

    private static func font(for style: UIFont.TextStyle) -> UIFont {
        let base = UIFont.preferredFont(forTextStyle: style)
        let descriptor = base.fontDescriptor.withDesign(.rounded) ?? base.fontDescriptor
        let custom = UIFont(descriptor: descriptor, size: base.pointSize)
        return UIFontMetrics(forTextStyle: style).scaledFont(for: custom)
    }

    private static func makeLabel(
        style: UIFont.TextStyle,
        color: UIColor = .label,
        alignment: NSTextAlignment = .natural
    ) -> UILabel {
        let label = UILabel()
        label.font = font(for: style)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = color
        label.textAlignment = alignment
        label.numberOfLines = 0
        return label
    }

    private func setUpLayout() {
        addSubview(scrollView)
        scrollView.addSubview(contentStack)

        avatarContainer.addSubview(avatarImageView)
        [avatarContainer, nameLabel, idLabel, ageLabel, gradeLabel, scholarshipLabel, subjectsTitleLabel, subjectsStack]
            .forEach(contentStack.addArrangedSubview)

        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }

        contentStack.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide).inset(20)
            $0.width.equalTo(scrollView.frameLayoutGuide).offset(-40)
        }

        avatarImageView.snp.makeConstraints {
            $0.size.equalTo(120)
            $0.centerX.top.bottom.equalToSuperview()
        }
    }

    func configure(with student: Student) {
        avatarImageView.image = UIImage(named: student.avatarName)
            ?? UIImage(systemName: "person.crop.circle.fill")
        nameLabel.text = student.name
        idLabel.text = "ID: \(student.id.uuidString)"
        ageLabel.text = "Age: \(student.age)"
        gradeLabel.text = String(format: "Average grade: %.1f", student.averageGrade)
        scholarshipLabel.text = "Scholarship holder: \(student.isScholarshipHolder ? "Yes" : "No")"
        subjectsTitleLabel.text = student.subjects.isEmpty ? "Subjects: none" : "Subjects:"
        setSubjects(student.subjects)
    }

    private func setSubjects(_ subjects: [String]) {
        subjectsStack.arrangedSubviews.forEach {
            subjectsStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        for subject in subjects {
            subjectsStack.addArrangedSubview(makeSubjectButton(subject))
        }
    }

    private func makeSubjectButton(_ subject: String) -> UIButton {
        var configuration = UIButton.Configuration.plain()
        configuration.title = subject
        configuration.baseForegroundColor = UIColor(red: 0.59375, green: 0.3125, blue: 0.4453125, alpha: 1.0)
        configuration.image = UIImage(
            systemName: "circle.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 6)
        )
        configuration.imagePlacement = .leading
        configuration.imagePadding = 10
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 12)
        configuration.titleLineBreakMode = .byWordWrapping
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
            var attributes = attributes
            attributes.font = StudentDetailView.font(for: .body)
            return attributes
        }

        let button = UIButton(configuration: configuration)
        button.contentHorizontalAlignment = .leading
        button.accessibilityIdentifier = "subjectButton.\(subject)"
        button.accessibilityLabel = "Subject \(subject)"
        button.accessibilityHint = "Shows students who take this subject"
        button.addAction(UIAction { [weak self] _ in
            self?.onSubjectTap?(subject)
        }, for: .touchUpInside)
        return button
    }
}
