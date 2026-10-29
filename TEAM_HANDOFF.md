# Team work and commit plan

Rohan: `ReddyR1105`. Het: `het1406`. Track: Undergraduate.

## Rohan's branch
Branch: `rohan/form-and-integration`.
Own `lib/screens/signup_page.dart` in Activity 10, `lib/screens/signup_screen.dart` in Activity 11, `lib/validators.dart`, and `lib/widgets/local_tips.dart`.
Completed repository update: password Done submits Part 1 and opens the Part 2 date picker; tests verify both paths. Android build versions now match the installed JDK 25 toolchain. Unit/widget checks and an Android end-to-end test have passed. The update is recorded on Rohan’s branch and main.

## Het's branch
Branch: `het/screens-and-evidence`.
Own Activity 11 `lib/screens/welcome_screen.dart`, `lib/screens/success_screen.dart`, screen lifecycle tests, screenshots, and the report review.
Run the full flow, review typewriter/confetti disposal, make a real screen or accessibility improvement, and add evidence for it. Suggested message: `Improve welcome and celebration accessibility with tests`.

## Shared finish
Each person clones the same repositories from their own account, makes their branch, runs `flutter analyze` and `flutter test`, and pushes it. Review each other's diff and merge after checks pass. Rebuild both APKs after the final merge so they match the source. Update contribution descriptions with work actually completed. Both members rehearse the form, tip state machine, route stack, and controller disposal.

```sh
git clone https://github.com/ReddyR1105/mad4360-activity11.git
cd mad4360-activity11
git switch -c YOUR_BRANCH
# Make and test your own changes, then stage only those files.
git add PATHS_YOU_CHANGED
git commit -m "Describe your real change"
git push -u origin YOUR_BRANCH
```

Do not copy the placeholders literally. Do not create empty changes merely to inflate participation, backdate commits, or assign another person's author identity.
