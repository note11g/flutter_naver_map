## 1.1.1

### Fix

- [Android] Fix MapWidget ignore navigator stack issue android 6.0~13.0 (SDK 23~33) (issue: [#56](https://github.com/note11g/flutter_naver_map/issues/56), Temp Fix PR: [#151](https://github.com/note11g/flutter_naver_map/pull/151))

## 1.1.0+1
- Update Readme & Apply Dart formatting

## 1.1.0
### Improve
- [All Platform] Add method `controller.forceRefresh` & Update Naver Map SDK version to 3.17.0 (issue: [#116](https://github.com/note11g/flutter_naver_map/issues/116), PR: [#139](https://github.com/note11g/flutter_naver_map/pull/139))
- [All Platform] Add `controller.getMeterPerDpAtLatitude`, deprecated parameter `controller.getMeterPerDp.latitude`, `controller.getMeterPerDp.zoom` (issue: [#85](https://github.com/note11g/flutter_naver_map/issues/85), PR: [#129](https://github.com/note11g/flutter_naver_map/pull/129), [#125](https://github.com/note11g/flutter_naver_map/pull/125))

### Breaking Change
- [Android] Change support minimum SDK Version to 6.0 (SDK 23) 

### Fix
- [Android] Fix Temporary black screen caused by flutter 3.16.0 & android 6.0~9.0 (SDK 23~28) (issue: [#135](https://github.com/note11g/flutter_naver_map/issues/135), Temp Fix PR: [#148](https://github.com/note11g/flutter_naver_map/pull/148))
- [All Platform] Fix `NOverlay.onTapListener` is called even when it's not registered by `NOverlay.setOnTapListener` (issue: [#96](https://github.com/note11g/flutter_naver_map/issues/96), PR: [#147](https://github.com/note11g/flutter_naver_map/pull/147))
- [All Platform] Fix `NAddableOverlay` cannot be used concurrently on multiple map widgets (issue: [#128](https://github.com/note11g/flutter_naver_map/issues/128), PR: [#146](https://github.com/note11g/flutter_naver_map/pull/146))
- [All Platform] Fix `NAddableOverlay` continues to reference the `OverlayController` of the map even after being removed (issue: [#127](https://github.com/note11g/flutter_naver_map/issues/127), PR: [#146](https://github.com/note11g/flutter_naver_map/pull/146))
- [All Platform] Fix common overlay options were not applied before overlay was added to the map (issue: [#115](https://github.com/note11g/flutter_naver_map/issues/115), PR: [#144](https://github.com/note11g/flutter_naver_map/pull/144))
- [All Platform] Fix `NLocationOverlay.setSubIcon(null)` Cause NPE (issue: [#142](https://github.com/note11g/flutter_naver_map/issues/142), PR: [#143](https://github.com/note11g/flutter_naver_map/pull/143))
- [iOS] Fix NOverlayImage Size issue. (issue: [#91](https://github.com/note11g/flutter_naver_map/issues/91), [#130](https://github.com/note11g/flutter_naver_map/issues/130), PR: [#138](https://github.com/note11g/flutter_naver_map/pull/138), [#126](https://github.com/note11g/flutter_naver_map/pull/126))
- [iOS] Fix the Camera Bearing issue. (issue: [#101](https://github.com/note11g/flutter_naver_map/issues/101), PR: [#110](https://github.com/note11g/flutter_naver_map/pull/110))

## 1.0.2
- support flutter 3.10.0 ([#89](https://github.com/note11g/flutter_naver_map/issues/89))
- fix bug ([#93](https://github.com/note11g/flutter_naver_map/issues/93))

## 1.0.1
- fix bug ([#73](https://github.com/note11g/flutter_naver_map/issues/73))
- NOverlayInfo Constructor is now public

## 1.0.0
- stable release

## 1.0.0-dev.10
- fix bugs ([#69](https://github.com/note11g/flutter_naver_map/issues/69))
- internal refactoring (code/struct improvement)
- add [docs](https://note11.dev/flutter_naver_map/)

## 1.0.0-dev.9
- fix bugs ([#51](https://github.com/note11g/flutter_naver_map/issues/51), [#53](https://github.com/note11g/flutter_naver_map/issues/53), [#54](https://github.com/note11g/flutter_naver_map/issues/54), [#55](https://github.com/note11g/flutter_naver_map/issues/55), [#60](https://github.com/note11g/flutter_naver_map/issues/60))
- add `NaverMapViewOptions.copyWith`

## 1.0.0-dev.8
- fix Android Memory Leak issue ([#47](https://github.com/note11g/flutter_naver_map/issues/47))

## 1.0.0-dev.7
- fix iOS Memory Leak issue ([#47](https://github.com/note11g/flutter_naver_map/issues/47))

## 1.0.0-dev.6
- fix bugs ([#45](https://github.com/note11g/flutter_naver_map/issues/45), [Unreported bug](https://github.com/note11g/flutter_naver_map/commit/b7c93bcf0dbabd838773014bc16b8e8d5be50170))

## 1.0.0-dev.5
- changed spec (`NOverlay`, `NLocationOverlay`, `NaverMapController.pickAll`, ...etc)

## 1.0.0-dev.4
- fix bugs ([#34](https://github.com/note11g/flutter_naver_map/issues/34), [#35](https://github.com/note11g/flutter_naver_map/issues/35))

## 1.0.0-dev.3
- change using flutter's default type
- delete `NaverMapController.isDestroyed`
- delete `NaverMapViewOptions.useGLSurfaceView`
- fix readme

## 1.0.0-dev.2
- support play-services-location 21.0.1

## 1.0.0-dev.1
- Initial dev preview release
