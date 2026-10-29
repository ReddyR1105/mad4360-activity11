# The Haunted Creature Registry
Activity 11 extends the Activity 10 form into a three-screen haunted registry. Track: Undergraduate, shared build only. Neither graduate extension is included.

Repository: https://github.com/ReddyR1105/mad4360-activity11
Part 1 base: https://github.com/ReddyR1105/mad4360-activity10

## Architecture and navigation
`main.dart` starts the app and sets its theme. `WelcomeScreen`, `SignupScreen`, and `SuccessScreen` live in separate files under `lib/screens/`. The original Part 1 validators and local-tip widget are retained in focused reusable files.

The foyer uses `Navigator.push`, giving `[Foyer, Lab]`. Valid submission uses `Navigator.pushReplacement`, giving `[Foyer, Ballroom]`. System Back returns to the foyer; it does not reopen the submitted lab. The brief's statement about “no back from the Ballroom” is interpreted as no back to the submitted form, consistent with its route-stack example.

Name and creature type travel through required `SuccessScreen` constructor parameters. Name/email/password controllers, date, visibility, and creature selection belong to the signup State. Changing viewport orientation rebuilds the layout without replacing that State. Popping the lab destroys its State; re-entering starts fresh. `dispose` releases every text controller and the confetti controller. Async callbacks check `mounted` before touching the UI.

## UI enhancements
A typewriter title, custom moonlit gradient, green accent, scrollable layouts, and descriptive companion copy unify the screens. Password visibility, a required date between January 1 1920 and today, all five required creature choices, a two-second loading state, and confetti are implemented. The button disables during loading.

## Recorded verification
Static analysis reported no issues. Seven automated tests passed across unit/widget and screenshot evidence tests. They covered original validators, local tips, required errors, the tip UI failure/retry path, date boundaries, simulated portrait-to-landscape resize with state preserved, personalized success, loading-button disablement, replacement navigation, and fresh form state after returning to the foyer. Screenshots are actual Flutter widget-test renders, not emulator captures. `test/evidence_test.dart` generates the screenshots and five-row date result table.

| Date input | Expected | Observed in picker widget test |
|---|---|---|
| 1920-01-01 | Accept | Accepted |
| 2008-01-01 | Accept | Accepted |
| 2026-10-29 | Accept | Accepted |
| 2026-10-30 | Reject | Inline error, picker stays open |
| 1919-12-31 | Reject | Inline error, picker stays open |

Dates above reflect the October 29 2026 run. The test computes today and tomorrow dynamically on later runs.

## Ghost Hunt responses
### The Poltergeist Field
The signup screen keeps the name and password in controllers, while visibility, birth date, and creature selection are fields on its State. The widget test changed the viewport from portrait to landscape after entering a name, showing the password, choosing January 1 2008, and selecting Ghost; all four values stayed intact. This happens because the same signup State remains mounted during the layout change, while leaving the lab destroys it. If a future version loses values after rotation, the first fix is to keep controllers and selections out of `build`; restoring after a full app restart would require a separate restoration design. This is a simulated viewport rotation, so a physical/emulator rotation still needs to be checked.

### The Clairvoyant Ghost
The picker test tried the lower boundary, a post-1990 date, today, tomorrow, and a date before the lower boundary. The current picker accepted January 1 1920, January 1 2008, and October 29 2026, then rejected October 30 2026 and December 31 1919 with inline errors. A `lastDate` of 1990 would fail both the 2008 and today rows, making the bug visible immediately. The screenshots and `date-results.txt` come from the actual picker widget test rather than a predicted table.

## Bug and fix record
The first navigation test used `pumpAndSettle` on the confetti screen and timed out because celebration animation kept scheduling frames. The test now advances a fixed amount of simulated time before checking the success text and Back behavior. This fixes test synchronization without removing the animation.

## Remaining team checks
Run on an Android phone/emulator, verify the on-screen keyboard at a small size, rotate the device, check all five creature choices interactively, double-tap during loading, and verify confetti behavior. Automated checks are not presented as those manual observations. Both students must make and defend their own contributions. The provided brief expects four roles; Rohan and Het should confirm that a two-person group is accepted.

## Team
Rohan (`ReddyR1105`) and Het (`het1406`). Track: Undergraduate.

Planned responsibilities: Rohan reviews the signup form, validators, offline tips, and integration. Het reviews welcome/success screens, animation lifecycle, and testing evidence. These are assigned responsibilities, not a claim that both students have already completed or committed their review. Each student must make and explain their own changes from their own GitHub account.

## Run and build
Install Flutter and Android SDK tools. Use JDK 21 with the checked-in Gradle 8.14 / Android Gradle Plugin 8.11.1 configuration. The Android app targets API 36.

```sh
flutter pub get
flutter analyze
flutter test
flutter run
flutter build apk --release
```

APK output: `build/app/outputs/flutter-apk/app-release.apk`. This classroom release uses the template's debug signing key; it is not a Play Store release. If needed, `flutter build apk --debug` is the allowed fallback.

## Privacy and local tips
The app has no backend or account database. It never saves profile fields or passwords. `LocalTipService.getTip` accepts only a simulated-failure flag and has no access to form controllers. The fixed category `password_help` selects the first tip in its fixed local list, so the result is deterministic and less than 240 characters. A loading indicator appears first. Turn on **Simulate next tip failure**, then request a tip to reproduce an error; **Retry** clears the simulated failure and loads the normal tip. Tips cannot approve signup. No runtime network calls are implemented; release manifests have no INTERNET permission.

## Personal explanations to review before the demo
### Rohan
1. The tip button calls `_load`, which clears old messages, sets loading, and waits for the local service. Success displays the preset label and tip; failure displays an error and Retry. The retry path requests the same deterministic tip without the failure flag.
2. Validation and guidance have different jobs. `Form.validate()` checks whether the entered values meet the form rules. The tip service offers general advice without receiving any entered values, so it cannot accidentally treat advice as approval.

### Het
1. The helper intentionally receives no name, email, or password. Its result depends only on the fixed category and the deliberate failure flag. This keeps personal information outside the guidance feature and makes tests repeatable.
2. Loading and error states need to be tested separately from success. The widget test taps the failure switch, observes a loading indicator and Retry, then verifies that Retry displays a preset tip. Each student should personalize these explanations after running and reviewing their assigned code.

## Contribution history
Do not change Git author settings to impersonate a teammate. Each teammate should clone the repository, create their own branch, make a substantive reviewed change, run checks, and push using their own account. See `TEAM_HANDOFF.md` for the division of work. Inviting a collaborator alone does not establish participation.

## Het’s verified contribution — October 29, 2026

Het Jani (`het1406`) and Rohan Reddy (`ReddyR1105`), undergraduate team. This contribution is AI-assisted and based on Rohan's published shared starting point, commit `3f9bb2f`; it preserves the existing form, validators, offline service, theme, and required `userName` / `creatureType` constructor interface.

Actual changes in Het's session: the welcome title now grows instead of clipping within a fixed height, small display labels are centered, and the celebration screen uses the foyer's gradient and a safe area. A new 320-pixel / 150%-text check exposed an overflowing creature dropdown; setting `isExpanded: true` fixes that integration issue. New tests check welcome accessibility, confetti play/disposal, and two full submission/Back cycles. No author identity was changed and no Rohan commits were generated by this session. Student personal review, cross-review, and demo practice still need to be completed and described truthfully.

Latest verification uses Flutter 3.47.7 / Dart 3.13.5 and JDK 21. Analysis passed, the combined suite passed 11 tests with one opt-in capture test skipped, and that capture test passed separately with `EVIDENCE_FONT` supplied. `evidence/het/` holds fresh logs, the reproduced constructor error and fix, and the initial integration failures. `test/evidence_test.dart` also refreshed the existing date and viewport screenshots. Screenshots under `evidence/screenshots/widget-*` are actual Flutter widget-test renders of this integrated version, not device captures. APK build output and device-check status are recorded in the included logs and handoff.

The new navigation test waits for a bounded route transition, including a final frame to dispose the outgoing route. Waiting for all confetti frames with `pumpAndSettle` is inappropriate because the package updates particles using wall-clock time. The initial enlarged-text failure and transition timing failure are preserved in `integrated-first-tests.log`.

Reproduce the new screenshots with:

```sh
EVIDENCE_FONT=/absolute/path/to/flutter/bin/cache/artifacts/material_fonts/Roboto-Regular.ttf flutter test test/het_capture_test.dart --reporter expanded
```

Word report: `docs/Het_Jani_Activity11_Ghost_Hunt.docx`, with Ghost Hunt C (navigation) and D (constructor conflict), each supported by actual artifacts. Constructor examples use `.dart.txt` to avoid intentionally failing normal app analysis; copy to a temporary `.dart` file to reproduce the diagnostic. Reflections are guidance for student review, not invented personal experiences.
