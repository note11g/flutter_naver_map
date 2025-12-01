import "dart:convert" show jsonDecode;
import "dart:io";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_naver_map/flutter_naver_map.dart";

class NMapInfoDialog extends StatefulWidget {
  final NaverMapController? naverMapController;

  const NMapInfoDialog({super.key, this.naverMapController});

  @override
  State<NMapInfoDialog> createState() => _NMapInfoDialogState();
}

class _NMapInfoDialogState extends State<NMapInfoDialog> {
  final ValueNotifier<String> _version = ValueNotifier<String>("");
  final ValueNotifier<Map<String, String>> _dependencies =
      ValueNotifier<Map<String, String>>({});
  final currentYear = DateTime.now().year;

  static final ValueNotifier<String?> _naverMapVersion = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _getVersionInfo().then((version) {
      if (version != null) {
        _version.value = version.packageVersion;
        _dependencies.value = Platform.isIOS
            ? version.nativeVersion.iosDependencies
            : version.nativeVersion.androidDependencies;
      }
    });
    if (_naverMapVersion.value == null) {
      FlutterNaverMap().getNativeMapSdkVersion().then((version) {
        if (version != null) _naverMapVersion.value = version;
      });
    }
  }

  static Future<_VersionInfo?> _getVersionInfo() async {
    final fileContent =
        await rootBundle.loadString("packages/flutter_naver_map/version.json");
    if (fileContent.isNotEmpty) {
      try {
        final json = await Future(() => jsonDecode(fileContent));
        final versionInfo = _VersionInfo.fromJson(json as Map<String, dynamic>);
        return versionInfo;
      } catch (e) {
        debugPrint("Error parsing version.json: $e");
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: switch (Theme.of(context).brightness) {
          Brightness.dark => Colors.grey.shade900,
          Brightness.light => Colors.white,
        },
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        shape: ShapeBorder.lerp(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            1.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Stack(children: [
            Padding(
                padding: const EdgeInsets.only(
                    top: 24, left: 14, right: 14, bottom: 8),
                child: Column(children: [
                  ValueListenableBuilder(
                      valueListenable: _version,
                      builder: (context, fMapVersion, child) => _versionInfo(
                          title: "flutter_naver_map",
                          version: fMapVersion,
                          description: "Copyright © 2023-$currentYear note11g\n"
                              "This library is licensed under the BSD-3-Clause License.")),
                  const SizedBox(height: 14),
                  ValueListenableBuilder(
                      valueListenable: _naverMapVersion,
                      builder: (context, version, child) {
                        return _versionInfo(
                            title:
                                "Naver Map ${Platform.isIOS ? "iOS" : "Android"} SDK",
                            version: version ?? "Unknown",
                            description:
                                "Copyright © 2018-$currentYear NAVER Corp.\nAll rights reserved.");
                      }),
                ])),
            Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                    splashRadius: 24,
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop())),
          ]),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(children: [
                IntrinsicHeight(
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                      // todo: showLegend is not support on iOS Platform currently.
                      if (Platform.isAndroid)
                        Expanded(
                            child: _buttons(
                                title: "범례",
                                engTitle: "Legend",
                                onTap: () =>
                                    widget.naverMapController?.openLegend())),
                      if (Platform.isAndroid)
                        Container(
                          width: 1,
                          color: _dividerColor,
                          margin: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      Expanded(
                          child: _buttons(
                              title: "법적 공지 / 정보 제공처",
                              engTitle: "Legal Notice / Info Providers",
                              onTap: () =>
                                  widget.naverMapController?.openLegalNotice()))
                    ])),
                const Divider(thickness: 1, height: 1, color: _dividerColor),
                _buttons(
                    title: "오픈소스 라이선스",
                    engTitle: "Open Source Licence",
                    onTap: () =>
                        widget.naverMapController?.openMapOpenSourceLicense()),
              ])),
        ]));
  }

  Widget _versionInfo({
    required String title,
    required String version,
    required String description,
  }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 14 * -0.02)),
            const SizedBox(width: 6),
            Text("version $version",
                style: const TextStyle(
                    fontSize: 10,
                    color: _descriptionColor,
                    letterSpacing: 10 * -0.02)),
          ]),
      const SizedBox(height: 6),
      Text(description,
          style: const TextStyle(
              fontSize: 10,
              color: _descriptionColor,
              letterSpacing: 10 * -0.02)),
    ]);
  }

  Widget _buttons(
      {required String title,
      required String engTitle,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      Platform.isIOS ? FontWeight.w600 : FontWeight.w500,
                  letterSpacing: 13 * -0.02)),
          const SizedBox(height: 2),
          Text(engTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: _descriptionColor,
                letterSpacing: 10 * -0.02,
              )),
        ]),
      ),
    );
  }

  static const _descriptionColor = Color(0xFF808080);
  static const _dividerColor = Color(0x42808080);
}

class _VersionInfo {
  final String packageVersion;
  final _NativeDependencyVersion nativeVersion;

  _VersionInfo({
    required this.packageVersion,
    required this.nativeVersion,
  });

  factory _VersionInfo.fromJson(Map<String, dynamic> json) {
    return _VersionInfo(
      packageVersion: json["package_version"] as String,
      nativeVersion: _NativeDependencyVersion.fromJson(
          json["native_dependency_version"] as Map<String, dynamic>),
    );
  }

  @override
  String toString() {
    return "{Package Version: $packageVersion, Native Version: $nativeVersion}";
  }
}

class _NativeDependencyVersion {
  final Map<String, String> androidDependencies;
  final Map<String, String> iosDependencies;

  _NativeDependencyVersion({
    required this.androidDependencies,
    required this.iosDependencies,
  });

  factory _NativeDependencyVersion.fromJson(Map<String, dynamic> json) {
    return _NativeDependencyVersion(
      androidDependencies: (json["android"] as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, v as String)),
      iosDependencies: (json["ios"] as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, v as String)),
    );
  }

  @override
  String toString() {
    return "{Android: $androidDependencies, iOS: $iosDependencies}";
  }
}
