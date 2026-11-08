import UIKit
import SnapKit

final class StudentDetailViewController: UIViewController {
    private let store: StudentStore
    private let studentID: UUID
    private let detailView = StudentDetailView()

    init(store: StudentStore, studentID: UUID) {
        self.store = store
        self.studentID = studentID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported; use init(store:studentID:)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        view.addSubview(detailView)
        detailView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }

        detailView.onSubjectTap = { [weak self] subject in
            guard let self else { return }
            let filtered = StudentListViewController(store: self.store, subject: subject)
            self.navigationController?.pushViewController(filtered, animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let student = store.students.first(where: { $0.id == studentID }) else {
            navigationController?.popViewController(animated: false)
            return
        }
        title = student.name
        detailView.configure(with: student)
    }
}

#if DEBUG
import SwiftUI

#Preview {
    let store = StudentStore()
    return UINavigationController(
        rootViewController: StudentDetailViewController(
            store: store,
            studentID: store.students[0].id
        )
    )
}
#endif
