import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_naver_map_example/widget_marker.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

enum MarkerType {
  basic,
  asset,
  file,
  byteArray,
}

class MarkerMapPage extends StatefulWidget {
  @override
  _MarkerMapPageState createState() => _MarkerMapPageState();
}

class _MarkerMapPageState extends State<MarkerMapPage> {
  static const MODE_ADD = 0xF1;
  static const MODE_REMOVE = 0xF2;
  static const MODE_NONE = 0xF3;

  MarkerType markerType = MarkerType.basic;
  int _currentMode = MODE_NONE;

  WidgetsToImageController imageController = WidgetsToImageController();
  Completer<NaverMapController> _controller = Completer();
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Stack(
          children: [
            _naverMap(),
            _controlPanel(),
          ],
        ),
      ),
    );
  }

  _controlPanel() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // 추가
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _currentMode = MODE_ADD),
                  child: Container(
                    decoration: BoxDecoration(
                        color: _currentMode == MODE_ADD ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.black)),
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.only(right: 8),
                    child: Text(
                      '추가',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _currentMode == MODE_ADD ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),

              // 삭제
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _currentMode = MODE_REMOVE),
                  child: Container(
                    decoration: BoxDecoration(
                        color: _currentMode == MODE_REMOVE ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.black)),
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.only(right: 8),
                    child: Text(
                      '삭제',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _currentMode == MODE_REMOVE ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),

              // none
              GestureDetector(
                onTap: () => setState(() => _currentMode = MODE_NONE),
                child: Container(
                  decoration: BoxDecoration(
                      color: _currentMode == MODE_NONE ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.black)),
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    Icons.clear,
                    color: _currentMode == MODE_NONE ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ],
          ),
          _currentMode == MODE_ADD ? _markerPanel() : SizedBox.shrink(),
        ],
      ),
    );
  }

  _markerPanel() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () => setState(() => markerType = MarkerType.basic),
              child: Container(
                decoration: BoxDecoration(
                    color: markerType == MarkerType.basic ? Colors.blue : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.blue)),
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(right: 8),
                child: Text(
                  '기본 마커',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: markerType == MarkerType.basic ? Colors.white : Colors.blue,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            GestureDetector(
              onTap: () => setState(() => markerType = MarkerType.asset),
              child: Container(
                decoration: BoxDecoration(
                    color: markerType == MarkerType.asset ? Colors.blue : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.blue)),
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(right: 8),
                child: Text(
                  '커스텀(Asset) 마커',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: markerType == MarkerType.asset ? Colors.white : Colors.blue,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            GestureDetector(
              onTap: () => setState(() => markerType = MarkerType.byteArray),
              child: Container(
                decoration: BoxDecoration(
                    color: markerType == MarkerType.byteArray ? Colors.blue : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.blue)),
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(right: 8),
                child: Text(
                  '커스텀(byteArray) 마커',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: markerType == MarkerType.byteArray ? Colors.white : Colors.blue,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            GestureDetector(
              onTap: () => setState(() => markerType = MarkerType.file),
              child: Container(
                decoration: BoxDecoration(
                    color: markerType == MarkerType.file ? Colors.blue : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.blue)),
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(right: 8),
                child: Text(
                  '커스텀(File) 마커',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: markerType == MarkerType.file ? Colors.white : Colors.blue,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _naverMap() {
    return Stack(
      children: [
        /// 마커로 그릴 위젯을 설정
        WidgetsToImage(
          controller: imageController,
          child: WidgetMarker(),
        ),

        /// 마커로 그릴 위젯을 숨기기 위해서 하얀 배경을 그려줌
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
        ),
        NaverMap(
          onMapCreated: _onMapCreated,
          onMapTap: _onMapTap,
          markers: _markers,
          initLocationTrackingMode: LocationTrackingMode.Follow,
        ),
      ],
    );
  }

  // ================== method ==========================

  void _onMapCreated(NaverMapController controller) {
    _controller.complete(controller);
  }

  void _onMapTap(LatLng latLng) {
    switch (markerType) {
      case MarkerType.basic:
        _onMapTapDefault(latLng);
        break;
      case MarkerType.asset:
        _onMapTapAsset(latLng);
        break;
      case MarkerType.file:
        _onMapTapFile(latLng);
        break;
      case MarkerType.byteArray:
        _onMapTapByteArray(latLng);
        break;
    }
  }

  /// default marker
  void _onMapTapDefault(LatLng latLng) {
    if (_currentMode == MODE_ADD) {
      _markers.add(Marker(
        markerId: DateTime.now().toIso8601String(),
        position: latLng,
        infoWindow: '테스트',
        onMarkerTab: _onMarkerTap,
      ));
      setState(() {});
    }
  }

  /// 커스텀 위젯 -> assets
  void _onMapTapAsset(LatLng latLng) async {
    var overlayImage = await OverlayImage.fromAssetImage(assetName: 'icon/marker.png');

    _markers.add(Marker(
        markerId: DateTime.now().toIso8601String(),
        position: latLng,
        captionText: "커스텀 아이콘",
        captionColor: Colors.indigo,
        captionTextSize: 20.0,
        alpha: 0.8,
        captionOffset: 30,
        icon: overlayImage,
        anchor: AnchorPoint(0.5, 1),
        width: 45,
        height: 45,
        infoWindow: '인포 윈도우',
        onMarkerTab: _onMarkerTap));

    setState(() {});
  }

  /// 커스텀 위젯 -> file
  void _onMapTapFile(LatLng latLng) async {
    var path = '';

    if (path.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('파일의 경로를 소스에 직접 입력 후 시도 하세요')));
      return;
    }

    File file = File(path);

    try {
      var overlayImage = OverlayImage.fromImageFile(file);

      _markers.add(Marker(
          markerId: DateTime.now().toIso8601String(),
          position: latLng,
          captionText: "커스텀 아이콘",
          captionColor: Colors.indigo,
          captionTextSize: 20.0,
          alpha: 0.8,
          captionOffset: 30,
          icon: overlayImage,
          anchor: AnchorPoint(0.5, 1),
          width: 45,
          height: 45,
          infoWindow: '인포 윈도우',
          onMarkerTab: _onMarkerTap));

      setState(() {});
    } catch (e) {}
  }

  /// 위젯 -> byteArray
  void _onMapTapByteArray(LatLng latLng) async {
    final bytes = await imageController.capture();

    var overlayImage = OverlayImage.fromByteArray(bytes!);

    _markers.add(Marker(
        markerId: DateTime.now().toIso8601String(),
        position: latLng,
        captionText: "커스텀 아이콘2",
        captionColor: Colors.indigo,
        captionTextSize: 20.0,
        alpha: 0.8,
        captionOffset: 30,
        icon: overlayImage,
        anchor: AnchorPoint(0.5, 1),
        width: 100,
        height: 60,
        infoWindow: '인포 윈도우',
        onMarkerTab: _onMarkerTap));

    setState(() {});
  }

  void _onMarkerTap(Marker? marker, Map<String, int?> iconSize) {
    int pos = _markers.indexWhere((m) => m.markerId == marker?.markerId);
    setState(() {
      _markers[pos].captionText = '선택됨';
    });
    if (_currentMode == MODE_REMOVE) {
      setState(() {
        _markers.removeWhere((m) => m.markerId == marker?.markerId);
      });
    }
  }
}
