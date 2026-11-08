import UIKit
import SnapKit

final class StudentListViewController: UIViewController {
    private let store: StudentStore
    private let listView = StudentListView()

    init(store: StudentStore) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
        title = "Students"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported; use init(store:)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(listView)
        listView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listView.students = store.students
    }
}

#if DEBUG
import SwiftUI

#Preview {
    UINavigationController(rootViewController: StudentListViewController(store: StudentStore()))
}
#endif
