import UIKit
import SnapKit

final class StudentListView: UIView {
    var students: [Student] = [] {
        didSet { tableView.reloadData() }
    }

    var onSelect: ((Student) -> Void)?
    var onDelete: ((Student) -> Void)?

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 88
        table.accessibilityIdentifier = "studentList"
        table.register(StudentCell.self, forCellReuseIdentifier: StudentCell.reuseIdentifier)
        return table
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        tableView.dataSource = self
        tableView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported; build the view in code")
    }
}

extension StudentListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        students.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: StudentCell.reuseIdentifier,
            for: indexPath
        ) as? StudentCell else {
            return UITableViewCell()
        }
        cell.configure(with: students[indexPath.row])
        return cell
    }
}

extension StudentListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onSelect?(students[indexPath.row])
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let student = students[indexPath.row]
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            self?.onDelete?(student)
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
}
