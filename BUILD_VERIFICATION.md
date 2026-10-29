# Build verification

ARM64 release APK built and its Android signature verified. Seven automated tests passed and static analysis found no issues. Screenshots are real widget-test renders; physical-device tests remain for the team.

Flutter release assembly completed, but the subprocess returned an invalid-handle status during sandbox shutdown. Gradle packaged the completed ARM64 outputs successfully using `assembleRelease -x compileFlutterBuildRelease`. Standard builds outside this sandbox use `flutter build apk --release`.

APK: Activity11_Haunted_Registry.apk
Architecture: arm64-v8a. Rebuild for an Intel/x86 Android emulator.
SHA-256: f0fbdda9dcfcec0bfbc80fefc63dbfc55cd721acb6ba7b63099db57955d78e74
