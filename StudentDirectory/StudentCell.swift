import UIKit
import SnapKit

final class StudentCell: UITableViewCell {
    static let reuseIdentifier = "StudentCell"

    private let avatarImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 28
        view.tintColor = .secondaryLabel
        view.backgroundColor = .secondarySystemBackground
        return view
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()

    private let ageLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()

    private let gradeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()

    private let scholarshipLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()

    private let textStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported; build the cell in code")
    }

    private func setUpLayout() {
        accessoryType = .disclosureIndicator

        [nameLabel, ageLabel, gradeLabel, scholarshipLabel].forEach(textStack.addArrangedSubview)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(textStack)

        avatarImageView.snp.makeConstraints {
            $0.leading.equalTo(contentView.layoutMarginsGuide)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(56)
            $0.top.greaterThanOrEqualTo(contentView.layoutMarginsGuide)
            $0.bottom.lessThanOrEqualTo(contentView.layoutMarginsGuide)
        }

        textStack.snp.makeConstraints {
            $0.leading.equalTo(avatarImageView.snp.trailing).offset(12)
            $0.trailing.equalTo(contentView.layoutMarginsGuide)
            $0.top.bottom.equalTo(contentView.layoutMarginsGuide)
        }
    }

    func configure(with student: Student) {
        nameLabel.text = student.name
        ageLabel.text = "Age: \(student.age)"
        gradeLabel.text = String(format: "Average grade: %.1f", student.averageGrade)
        scholarshipLabel.text = student.isScholarshipHolder ? "Scholarship holder" : "No scholarship"
        scholarshipLabel.textColor = student.isScholarshipHolder ? .systemGreen : UIColor(red: 0.82, green: 0.53, blue: 0.59, alpha: 1.0)

        avatarImageView.image = UIImage(named: student.avatarName)
            ?? UIImage(systemName: "person.crop.circle.fill")

        accessibilityIdentifier = "studentCell.\(student.id.uuidString)"
        avatarImageView.isAccessibilityElement = false
        accessibilityLabel = [
            student.name,
            "age \(student.age)",
            String(format: "average grade %.1f", student.averageGrade),
            student.isScholarshipHolder ? "scholarship holder" : "no scholarship"
        ].joined(separator: ", ")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        accessibilityIdentifier = nil
    }
}
