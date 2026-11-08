# HW3 Student Plan

## Approach

**MVC boundary.** `Student`, `StudentStore` and `StudentSeedData` are the Model and contain no UIKit. Custom `UIView` subclasses (`StudentListView`, `StudentCell`, the detail view) are the View: they only display data and report taps through closures (`onSelect`, `onSubjectTap`). `UIViewController` subclasses are the Controllers: they read from the store, feed data to their view, and handle navigation.

**One shared `StudentStore`.** `SceneDelegate` creates a single `StudentStore()` and injects it through each controller's `init(store:)`. Every controller passes that same instance to the next controller it pushes (detail, subject-filtered list). Views never create or mutate the store, and no controller keeps its own authoritative array. Controllers re-read the store in `viewWillAppear` so visible state stays fresh.

**Reuse of lecture components.** UI is code-based (no storyboard/XIB), laid out with SnapKit, with views built as closure-initialised properties as in the lecture and UI1 practice. A custom view class is embedded in a view controller with SnapKit. The same list view is reused for the full list and the subject-filtered list; only its data source differs (`store.students` vs `store.students(matchingSubject:)`).

**Subject filtering tests.** Model tests on `StudentStore.students(matchingSubject:)` check exact case-sensitive matching, store order, and an unknown subject returning an empty array. UI tests tap a `subjectButton.<subject>` and assert the pushed list shows only matching students and uses the subject as its title.

**UI / accessibility decisions.** Required identifiers: `studentList`, `studentCell.<student-id>`, `studentDetails`, `subjectButton.<subject>`. All text uses `UIFont.preferredFont(forTextStyle:)` with `adjustsFontForContentSizeCategory = true` and wraps instead of truncating. Cells use automatic row height. Avatars and scholarship status have meaningful accessibility labels. Avatar loading falls back to a system image, and no user input is force-unwrapped.

## Milestones

- [x] Student list and reusable cell
- [x] Detail screen and navigation
- [x] Subject-filtered list
- [x] Unit and UI tests
- [x] Optional add/edit/delete bonus, if attempted
- [x] Local verification and CI review
- [x] Final diff and evidence review

## Verification plan

Focused tests run per milestone (for example `-only-testing:StudentDirectoryTests` for model/store tests, then `-only-testing:StudentDirectoryUITests` for flows). Final command, exactly as in the README:

```bash
xcodebuild -project StudentDirectory.xcodeproj -scheme StudentDirectory -destination 'platform=iOS Simulator,name=iPhone 17' test
```

The local result and the GitHub Actions result are recorded separately in `AGENT_WORKLOG.md`.