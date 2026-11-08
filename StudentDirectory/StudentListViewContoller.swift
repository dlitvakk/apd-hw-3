import UIKit
import SnapKit

final class StudentListViewController: UIViewController {
    private let store: StudentStore
    private let subject: String?
    private let listView = StudentListView()

    init(store: StudentStore, subject: String? = nil) {
        self.store = store
        self.subject = subject
        super.init(nibName: nil, bundle: nil)
        title = subject ?? "Students"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported; use init(store:)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(listView)
        listView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }

        listView.onSelect = { [weak self] student in
            guard let self else { return }
            let detail = StudentDetailViewController(store: self.store, studentID: student.id)
            self.navigationController?.pushViewController(detail, animated: true)
        }

        listView.onDelete = { [weak self] student in
            guard let self else { return }
            do {
                try self.store.deleteStudent(id: student.id)
            } catch {
          
            }
            self.reload()
        }

        if subject == nil {
            let add = UIBarButtonItem(
                systemItem: .add,
                primaryAction: UIAction { [weak self] _ in self?.presentAddForm() }
            )
            add.accessibilityIdentifier = "addStudentButton"
            add.accessibilityLabel = "Add student"
            navigationItem.rightBarButtonItem = add
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }

    private func reload() {
        if let subject {
            listView.students = store.students(matchingSubject: subject)
        } else {
            listView.students = store.students
        }
    }

    private func presentAddForm() {
        let form = StudentFormViewController(title: "Add Student") { [weak self] name, age in
            guard let self else { return }
            try self.store.addStudent(name: name, age: age)
            self.reload()
        }
        present(UINavigationController(rootViewController: form), animated: true)
    }
}

#if DEBUG
import SwiftUI

#Preview {
    UINavigationController(rootViewController: StudentListViewController(store: StudentStore()))
}
#endif
