# HW3 Agent Worklog

AI tool used: Claude (Anthropic), via the Claude desktop app, on 2026-11-08.
Claude had no Xcode in its environment, so it never compiled or ran the code;
every build and test result below comes from my own local runs.

| Date | Tool/task | Student review | Evidence |
| --- | --- | --- | --- |
| 2026-11-08 | Claude: reviewed my plan and drafted the MVC/shared-store section of `PLAN.md` | Read the draft against `TASKS_AND_GRADES.md`; kept my original milestones unchanged and used the lecture/UI1 code-based UIKit + SnapKit style | `PLAN.md` diff |
| 2026-11-08 | Claude: milestone 1, list screen (`StudentCell`, `StudentListView`, `StudentListViewController`, `SceneDelegate`) | Read every file; checked the store is created once in `SceneDelegate` and injected via `init(store:)`; ran on the simulator | Commit diff; simulator run |
| 2026-11-08 | Claude: milestone 2, detail screen and push navigation | Checked all `Student` fields are shown and that standard back works; changed the layout (centered avatar/name) and font myself | Commit diff; simulator run |
| 2026-11-08 | Claude: milestone 3, tappable subjects and filtered list | Verified the filter uses `students(matchingSubject:)` (exact, case-sensitive, store order) and the title is the subject; changed subject buttons to pink bullet points | Commit diff; UI test `testSubjectButtonShowsOnlyMatchingStudentsWithSubjectTitle` |
| 2026-11-08 | Claude: milestone 4 tests (9 store unit tests, 5 UI tests) | Read each assertion against the seed data; first UI run failed 5/5 (see debugging row), passed after the fix | Local test output (5 UI tests, 0 failures) |
| 2026-11-08 | Claude: debugging a black screen at launch | Console prints showed `app launched` but no `configuration requested`, so the scene was never created; Claude's first suggestion (`delegateClass` in the app delegate) was not enough on its own. Fixed by registering the scene configuration in the target's Info tab; adding rows with empty values then crashed, so I deleted the empty Class Name and Storyboard Name rows | Console output; Info tab screenshot |
| 2026-11-08 | Claude: bonus add/edit/delete (`StudentFormViewController`, list/detail changes, 2 unit + 4 UI tests) | Checked the form shows the store's validation errors and stays open, unknown IDs and invalid input do not mutate state, and visible state refreshes after each change | Commit diff; test output |

## Final review

- Agent/tool disclosure: Claude (Anthropic) generated first drafts of the code, tests and `PLAN.md`. I reviewed, built and ran everything locally, and made my own edits to layout, fonts and colors.
- Accepted and rejected/revised recommendations:
    - Revised (my idea): I planned for each view controller to instantiate a custom view that creates its own `StudentStore`. Claude pointed out this creates multiple stores and fails the "one shared store" rule. We kept my custom-view-in-controller structure but create one store in `SceneDelegate` and inject it through each controller's initializer.
    - Revised (agent suggestion): Claude suggested reordering the milestones to put model tests first. I rejected this and kept my original milestone order.
    - Revised (agent suggestion): Claude's `delegateClass` fix for the black screen did not solve it alone; the scene manifest had to be set in the Info tab.
    - Accepted: injecting the store through `init(store:)`, reusing one list controller for the full and filtered lists, and deleting through the shared store with a reload after each mutation.
- Run in Xcode (Product → Test, scheme StudentDirectory, iPhone 17 simulator, 2026-11-08): 24 tests passed, 0 failed.
- CI URL/status: <paste the GitHub Actions run URL and its status; a local pass is not proof CI passed>
- Known limitation or remaining risk: UI tests use `waitForExistence(timeout:)` and depend on simulator keyboard behavior; data is in memory only, so added/edited/deleted students reset on relaunch.