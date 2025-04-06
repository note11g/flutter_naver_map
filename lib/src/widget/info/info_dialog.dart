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
  final ValueNotifier<String> _naverMapVersion = ValueNotifier<String>("");

  @override
  void initState() {
    super.initState();
    _getPluginVersion().then((version) => _version.value = version ?? "");
    _getNaverMapVersion()
        .then((version) => _naverMapVersion.value = version ?? "");
  }

  static Future<String?> _getPluginVersion() async {
    final fileContent =
        await rootBundle.loadString("packages/flutter_naver_map/pubspec.yaml");

    if (fileContent.isNotEmpty) {
      String versionStr = fileContent.substring(
          fileContent.indexOf("version:"), fileContent.length);
      versionStr = versionStr.substring(0, versionStr.indexOf("\n"));
      return versionStr
          .substring(versionStr.indexOf(":") + 1, versionStr.length)
          .trim();
    }
    return null;
  }

  static Future<String?> _getNaverMapVersion() async {
    // todo
    return "3.21.0";
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                          description: "Copyright © 2023-2025 note11g\n"
                              "This library is licensed under the BSD-3-Clause License.")),
                  const SizedBox(height: 14),
                  ValueListenableBuilder(
                      valueListenable: _naverMapVersion,
                      builder: (context, naverSdkVer, child) => _versionInfo(
                          title:
                              "Naver Map ${Platform.isIOS ? "iOS" : "Android"} SDK",
                          version: naverSdkVer,
                          description:
                              "Copyright © 2018-2025 NAVER Corp.\nAll rights reserved.")),
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
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
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
  static const _dividerColor = Color(0xFFD9D9D9);
}
