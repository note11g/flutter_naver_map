# flutter_naver_map for Testing

## Unit Tests
```
// dir: flutter_naver_map
flutter test
```

## Integration test
```
// dir: flutter_naver_map/example

flutter devices
    >>> Found 2 connected devices:
    >>> sdk gphone64 arm64 (mobile) • emulator-5554                        • android-arm64  • Android 14 (API 34) (emulator)
    >>> iPhone 15 Pro (mobile)      • FBC3B1D9-EF6E-4A42-AE42-7A96F5F2F39C • ios            • com.apple.CoreSimulator.SimRuntime.iOS-17-2 (simulator)

flutter test integration_test/all_tests.dart -d <device-id>
```

## Update Golden Test Snapshots

can't on android. related issue: https://github.com/flutter/flutter/issues/103222
```
flutter test integration_test/all_tests.dart -d <device-id> --update-goldens
```