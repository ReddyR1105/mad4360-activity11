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
Static analysis reported no issues. Eight automated unit/widget tests passed across unit/widget and screenshot evidence tests. They covered original validators, local tips, required errors, the tip UI failure/retry path, date boundaries, simulated portrait-to-landscape resize with state preserved, personalized success, loading-button disablement, replacement navigation, and fresh form state after returning to the foyer. The original screenshots are Flutter widget-test renders; `evidence/emulator/` adds genuine Android captures. `verification/android_flow.dart.txt` contains the Android test source. The verification script runs it in a separate temporary app copy, keeping the native test plugin out of the release app. `test/evidence_test.dart` generates the screenshots and five-row date result table.

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
The signup screen keeps the name and password in controllers, while visibility, birth date, and creature selection are fields on its State. The widget test changed the viewport from portrait to landscape after entering a name, showing the password, choosing January 1 2008, and selecting Ghost; all four values stayed intact. This happens because the same signup State remains mounted during the layout change, while leaving the lab destroys it. If a future version loses values after rotation, the first fix is to keep controllers and selections out of `build`; restoring after a full app restart would require a separate restoration design. A separate Android integration test also performed a real orientation change and verified the same four values.

### The Clairvoyant Ghost
The picker test tried the lower boundary, a post-1990 date, today, tomorrow, and a date before the lower boundary. The current picker accepted January 1 1920, January 1 2008, and October 29 2026, then rejected October 30 2026 and December 31 1919 with inline errors. A `lastDate` of 1990 would fail both the 2008 and today rows, making the bug visible immediately. The screenshots and `date-results.txt` come from the actual picker widget test rather than a predicted table.

## Bug and fix record
The first navigation test used `pumpAndSettle` on the confetti screen and timed out because celebration animation kept scheduling frames. The test now advances a fixed amount of simulated time before checking the success text and Back behavior. This fixes test synchronization without removing the animation.

## Android emulator verification
The automated Android integration test passed on Pixel 4a API 37.1. It verified required-field errors, all five creature selections, actual portrait/landscape rotation with name, visibility, date and creature preserved, loading-button disablement, personalized success, Back to the foyer, a fresh empty form, and tip failure/retry recovery. Screenshots in `evidence/emulator/` are actual Android captures. The separate five-row date-boundary screenshots remain widget-test renders.

Run the device test with:
```sh
.\verification\run_android_checks.ps1 -DeviceId DEVICE_ID
```

The password keyboard Done action dismisses the keyboard and opens the birthday picker. A dedicated widget test verifies it.

## Team demo
Rohan's code and build work is complete in his repository account. Each student still needs to understand the flow and explain their own contribution live. Het's own review/change commit must come from his account. The brief lists four roles, so confirm the two-person team is accepted. No physical-phone or airplane-mode check is claimed.

## Team
Rohan (`ReddyR1105`) and Het (`het1406`). Track: Undergraduate.

Rohan’s repository work covers the form, validation, local tips, keyboard shortcuts, build configuration, and verification. The keyboard workflow update is recorded on `rohan/form-and-integration` and integrated into `main`. Het’s assigned area is the welcome/success screens, animation lifecycle, and evidence review; his individual contribution must be committed from `het1406`.

## Run and build
Install Flutter and Android SDK tools. Use JDK 25 with the checked-in Gradle 9.3.1 / Android Gradle Plugin 9.1.0 configuration, matching the installed Flutter 3.47 toolchain. The Android app targets API 36.

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

## Code explanations for the demo
### Rohan
1. The tip button calls `_load`, which clears old messages, sets loading, and waits for the local service. Success displays the preset label and tip; failure displays an error and Retry. The retry path requests the same deterministic tip without the failure flag.
2. Validation and guidance have different jobs. `Form.validate()` checks whether the entered values meet the form rules. The tip service offers general advice without receiving any entered values, so it cannot accidentally treat advice as approval.

### Het
1. The helper intentionally receives no name, email, or password. Its result depends only on the fixed category and the deliberate failure flag. This keeps personal information outside the guidance feature and makes tests repeatable.
2. Loading and error states need to be tested separately from success. The widget test taps the failure switch, observes a loading indicator and Retry, then verifies that Retry displays a preset tip. Both students should be able to trace these code paths during the demo.

## Contribution history
Do not change Git author settings to impersonate a teammate. Each teammate should clone the repository, create their own branch, make a substantive reviewed change, run checks, and push using their own account. See `TEAM_HANDOFF.md` for the division of work. Inviting a collaborator alone does not establish participation.
