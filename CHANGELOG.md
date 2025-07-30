## 1.4.1+1
- Fix README.md


## 1.4.1
### Fix
- [iOS] Fix `NSRangeException` when logo is not removed on iOS ([Fix #341](https://github.com/note11g/flutter_naver_map/issues/341))
- [Android] Fix access at uninitialized variable NaverMapView.naverMapControlSender ([Fix #340](https://github.com/note11g/flutter_naver_map/issues/340))
- [All Platform] Fix crash when user tapped symbol and using customStyle at the same time ([Fix #339](https://github.com/note11g/flutter_naver_map/issues/339))
- [iOS, XCode Build] Fix Swift Version support issue under 6.1 ([PR #338](https://github.com/note11g/flutter_naver_map/pull/338))

### Update
- [All Platform] **Update Naver Map SDK to 3.22.1**


## 1.4.0

### Breaking Change
- [All Platform, Not Working Impact] **Migrated built-in location tracking to be widget-based.** ([PR #322](https://github.com/note11g/flutter_naver_map/pull/322))
  - The `locationButtonEnable` option in `NaverMapViewOptions` has been removed and replaced with the `NMyLocationButtonWidget`.
  - Location tracking APIs are now provided through the `NMyLocationTracker`.
  - NaverMapController.setLocationTrackingMode(NLocationTrackingMode)'s return type change from `Future<void>` to `void`
  - `Future<NLocationTrackingMode> NaverMapController.getLocationTrackingMode()` api exposing change to `NLocationTrackingMode NaverMapController.locationTrackingMode` getter
  - change `color.alpha` on `NLocationOverlay.defaultCircleColor` 24% to 8%
- [All Platform, Not Working Impact] **Migrated ScaleBar to be a widget.** ([Fix #297](https://github.com/note11g/flutter_naver_map/issues/297), [PR #319](https://github.com/note11g/flutter_naver_map/pull/319))
  - The `scaleBarEnable` option in `NaverMapViewOptions` has been removed and replaced with the `NMapScaleBarWidget`.
- [All Platform] The `showControls` argument in `NaverMapController.takeSnapshot` has been removed as it is no longer supported by the native SDK since version 1.4.0.

### Add (New Features)
- [All Platform] Support custom style with `NaverMapViewOptions.customStyle` ([PR #308](https://github.com/note11g/flutter_naver_map/pull/308))
- [All Platform] add new api `iconAlpha`, `subIconAlpha`, `setIconAlpha`, `setSubIconAlpha` on `NLocationOverlay`
- [All Platform] **Added a new built-in location tracking API, `NDefaultMyLocationTracker`.**
  - This provides the `NMyLocationTracker` interface, allowing users to implement custom location tracking logic.
- [All Platform] Added `NaverMap.onMapLoaded` and `NaverMap.onMapLongTapped` callbacks. ([PR #315](https://github.com/note11g/flutter_naver_map/pull/315))
- [All Platform] Added `NPolygonOverlay.outlinePattern` feature from Naver Map SDK 3.21.0. ([PR #317](https://github.com/note11g/flutter_naver_map/pull/317))
- [iOS] Added support for Swift Package Manager (SPM). ([Resolve #281](https://github.com/note11g/flutter_naver_map/issues/281), [PR #320](https://github.com/note11g/flutter_naver_map/pull/320))

### Update
- [All Platform] **Update Naver Map SDK to 3.22.0** ([PR #329](https://github.com/note11g/flutter_naver_map/pull/329))
- [All Platform] Improved `NOverlayImage.fromWidget` to automatically detect the widget's size with `null` value. ([Resolve #304](https://github.com/note11g/flutter_naver_map/issues/304))
- [All Platform] Improved `NLocationTrackingMode.noFollow` to track the current location's bearing. ([PR #323](https://github.com/note11g/flutter_naver_map/pull/323))

### Fix
- [All Platform] `NaverMapViewOptions.extend` was not applied to the map dynamically.
- [All Platform] Fix NLocale.countryCode support is missing (Fix [#325](https://github.com/note11g/flutter_naver_map/issues/325), [PR #328](https://github.com/note11g/flutter_naver_map/pull/328))
- [iOS] Fixed an issue where `contentsPadding` was not applied to the scale bar. ([Fix #297](https://github.com/note11g/flutter_naver_map/issues/297), [PR #319](https://github.com/note11g/flutter_naver_map/pull/319))
- [iOS] Updated the InfoWindow UI to match the Android version. ([Fix #229](https://github.com/note11g/flutter_naver_map/issues/229))
- [All Platform] Fixed a `LateInitializationError` that occurred when `NChannelWrapper` was disposed before initialization. ([Fix #312](https://github.com/note11g/flutter_naver_map/issues/312))
- [Dev] fix melos detect flutter_naver_map as a mono-repo package ([Resolve #310](https://github.com/note11g/flutter_naver_map/issues/310))


## 1.3.1
- [All Platform, Update] change naver map sdk version to 3.21.0
- [All Platform, Add] **Add new auth api `FlutterNaverMap().init`** ([#291](https://github.com/note11g/flutter_naver_map/issues/291)), Add detail exception classes. (with sealed class)
- [All Platform, Remove] Deprecate `NaverMapSdk.instance.initialize` (changed to Legacy. see [here](https://www.ncloud.com/support/notice/guide/1930))
- [All Platform, Fix] Fix Memory Leak ([#299](https://github.com/note11g/flutter_naver_map/pull/299) [#275](https://github.com/note11g/flutter_naver_map/issues/275))
- [All Platform, Fix] Fix NClusterableMarker sometimes not running _set method ([#276](https://github.com/note11g/flutter_naver_map/issues/276))
- [Android, Fix] Fix appCompat with gradle transitive dependency issue ([#225](https://github.com/note11g/flutter_naver_map/issues/225))

## 1.3.0+1
[Chore] fix readme document link broken

## 1.3.0
- [Chore] **Release 1.3.0**
- [All Platform] **Add ClusterableMarker & Clustering Features**
- [All Platform] **change naver map sdk version to 3.19.1(Android) & 3.19.0(iOS)**
- [All Platform] Add `NRange` API which is used for zoom range.
- [All Platform] Support Webp Image format for `NOverlayImage`
- [All Platform] Add `NCameraUpdateReason.contentPadding` triggered by onCameraChange when `NaverMapViewOptions.contentPadding` changed
- [Chore] Update README.MD

## 1.3.0-beta.4
- [Fix] fix runtime cast failed by setOnTapListener on `ClusterableMarker` or `NClusterMarker` ([ebdb0ba](https://github.com/note11g/flutter_naver_map/commit/ebdb0badf3a638c5171987ccd7bc734215424e4e))

## 1.3.0-beta.3
- [Chore] Fix Incompatible issue with Flutter 3.22.0

## 1.3.0-beta.2
- [Chore] Update README.MD (fix link broken)

## 1.3.0-beta.1
- [All Platform] **change naver map sdk version to 3.19.1(Android) & 3.19.0(iOS)**
- [All Platform] Add ClusterableMarker & Clustering Features
- [All Platform] Add `NRange` API which is used for zoom range.
- [All Platform] Support Webp Image format for `NOverlayImage`
- [All Platform] Add `NCameraUpdateReason.contentPadding` triggered by onCameraChange when `NaverMapViewOptions.contentPadding` changed
- [Chore] Update README.MD

## 1.2.3+1
- [iOS] Update podspec file
- [Chore] Update README.MD

## 1.2.3
- [All Platform] **change naver map sdk version to 3.18.0(Android) & 3.18.1(iOS) + No additional features (feature add will be in 1.3.0)**
- [All Platform] **change minimum flutter sdk version to 3.22.0**
- [All Platform] Fix: fix Set type doesn't supported on NPayload (issue: [#217](https://github.com/note11g/flutter_naver_map/issues/217), PR: [#219](https://github.com/note11g/flutter_naver_map/issues/219))
- [Chore] update NOverlayImage.fromWidget api description

## 1.2.2+flutter3.22
- [All Platform] support flutter 3.22 (if you using under 3.22, using `flutter_naver_map 1.2.2`)

## 1.2.2
### Fix
- [Android] Fix Only One Start Frame from Android TextureView Doesn't Copied to Flutter Platform View(TLHC) (issue: [#195](https://github.com/note11g/flutter_naver_map/issues/195), PR: [#212](https://github.com/note11g/flutter_naver_map/pull/212))
- [All Platform] Fix LateInitializationError when Widget disposed before onMapReady (issue: [#197](https://github.com/note11g/flutter_naver_map/issues/197))

### Improve
- [All Platform] Add / Improve APIs
  - Add: Add `NLocationOverlay.defaultIcon`, `defaultSubIcon`, `faceModeSubIcon`
  - Improve: Change return type of method `NaverMapController.getLocationOverlay` to non-async (Future<NLocationOverlay> -> double)
  - Improve: migrate `NOverlay`, `NAddableOverlay`, `NPickableInfo` Abstract Class to Sealed Class
  - AddForTesting: Add NaverMap.forceHybridComposition, forceGLSurfaceView for testing
- [Android] Apply migrate about android gradle plugin update (issue: [#198](https://github.com/note11g/flutter_naver_map/issues/198))
- [All Platform] Change to no such overlay assertion instead NPE when delete overlay with info (issue: [#192](https://github.com/note11g/flutter_naver_map/issues/192))
- [API Reference] Add API Reference about most of the APIs. (PR: [#193](https://github.com/note11g/flutter_naver_map/pull/193))


## 1.2.1
### Improve
- [All Platform] Add / Improve APIs
  - Add: Add `NCameraPosition.copyWith` method.
### Fix
- [Android] Fix PlatformView Issue for Android 13~14(>=API 33) (issue: [#189](https://github.com/note11g/flutter_naver_map/issues/189))
- [iOS] Fix `NOverlayImage.fromAssetImage` Size issue. (issue: [#91](https://github.com/note11g/flutter_naver_map/issues/91), PR: [#185](https://github.com/note11g/flutter_naver_map/pull/185))

## 1.2.0

### Improve
- [All Platform] Add / Improve APIs
  - Add property `NaverMapController.nowCameraPosition` as a experimental api which type is `NCameraPosition` (non-async)
  - Add method `NCameraUpdate.setReason`
  - Change return type of method `NaverMapController.getMeterPerDp` 
      & `NaverMapController.getMeterPerDpAtLatitude` to non-async (Future<double> -> double)
  - Change `NCameraUpdate.setAnimation` to have non-null parameters with default values
  - Change property type `NaverMapViewOptions.initialCameraPosition` to non-nullable type

### Breaking Change
- [Flutter] Change support minimum Flutter SDK Version to 3.19.0, Dart 3.0.0 

### Fix
- [Android] Change Platform View display mode to TLHC (related issue [#152](https://github.com/note11g/flutter_naver_map/issues/152))
- [Android] Change Flutter Render View to SurfaceView at Android 11~13 (related issue [#152](https://github.com/note11g/flutter_naver_map/issues/152))

## 1.1.2

### Improve
- [Android] Improve Performance Using TextureView as FlutterView's Renderer only on android 11~13. (related issue [#152](https://github.com/note11g/flutter_naver_map/issues/152))

### Fix
- [All Platform] NMarker.setIcon(null) cause Crash. (issue: [#167](https://github.com/note11g/flutter_naver_map/issues/167), PR: [#168](https://github.com/note11g/flutter_naver_map/issues/168), [#169](https://github.com/note11g/flutter_naver_map/issues/169))
- [iOS] NaverMapViewOptions.buildingHeight cause Crash (issue: [#158](https://github.com/note11g/flutter_naver_map/issues/158), PR: [#161](https://github.com/note11g/flutter_naver_map/issues/161))
- [All Platform] using NOverlayImage.fromWidget with stful widget cause memory leak because of un-disposing.

## 1.1.1

### Improve
- [All Platform] Improve: NOverlayImage.fromWidget delete Image Widget support with assertion.
- [Example] Improve: All Examples Improve

### Fix
- [All Platform] Fix: InfoWindow.onMarker not attached successfully (issue: [#154](https://github.com/note11g/flutter_naver_map/issues/154), PR: [#156](https://github.com/note11g/flutter_naver_map/pull/156))
- [Android] Fix: black screen caused by flutter 3.16.0~ & android 6.0~9.0 (SDK 23~28) (issue: [#135](https://github.com/note11g/flutter_naver_map/issues/135), PR: [#153](https://github.com/note11g/flutter_naver_map/pull/153))
- [Android] Fix: MapWidget ignore navigator stack issue android 6.0~13.0 (SDK 23~33) (issue: [#56](https://github.com/note11g/flutter_naver_map/issues/56), Temp Fix PR: [#151](https://github.com/note11g/flutter_naver_map/pull/151))

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
- [iOS] Fix `NOverlayImage` Size issue. (issue: [#91](https://github.com/note11g/flutter_naver_map/issues/91), [#130](https://github.com/note11g/flutter_naver_map/issues/130), PR: [#138](https://github.com/note11g/flutter_naver_map/pull/138), [#126](https://github.com/note11g/flutter_naver_map/pull/126))
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
