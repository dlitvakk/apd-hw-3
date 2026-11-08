import UIKit
import SnapKit

/// Displays every field of a student. It only shows data; it never touches the store.
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
    private let subjectsLabel = StudentDetailView.makeLabel(style: .body)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        accessibilityIdentifier = "studentDetails"
        setUpLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported; build the view in code")
    }

    /// Single place to change the screen's font. Rounded design here; swap for any
    /// `UIFont` while keeping `UIFontMetrics` so text still follows Dynamic Type.
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
        [avatarContainer, nameLabel, idLabel, ageLabel, gradeLabel, scholarshipLabel, subjectsLabel]
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
        subjectsLabel.text = student.subjects.isEmpty
            ? "Subjects: none"
            : "Subjects: " + student.subjects.joined(separator: ", ")
        // Milestone 3 replaces the subjects label with tappable subject buttons.
    }
}
