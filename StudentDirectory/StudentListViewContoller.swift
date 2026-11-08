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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let subject {
            listView.students = store.students(matchingSubject: subject)
        } else {
            listView.students = store.students
        }
    }
}

#if DEBUG
import SwiftUI

#Preview {
    UINavigationController(rootViewController: StudentListViewController(store: StudentStore()))
}
#endif
