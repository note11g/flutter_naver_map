import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class PathMapPage extends StatefulWidget {
  @override
  _PathMapPageState createState() => _PathMapPageState();
}

class _PathMapPageState extends State<PathMapPage> {
  static const MODE_ADD = 0xF1;
  static const MODE_REMOVE = 0xF2;
  static const MODE_NONE = 0xF3;
  int _currentMode = MODE_NONE;

  Completer<NaverMapController> _controller = Completer();
  List<Marker> _markers = [];
  List<LatLng> _coordinates = [
    LatLng(37.563153, 126.962190),
    LatLng(37.564152, 126.963319),
  ];

  double _sliderValue = 1.0;
  int _width = 10;

  @override
  void initState() {
    _coordinates.forEach((point) {
      _markers.add(Marker(
        markerId: point.json.toString(),
        position: point,
        onMarkerTab: _onMarkerTap,
      ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: <Widget>[
            _controlPanel(),
            _naverMap(),
          ],
        ),
      ),
    );
  }

  _controlPanel() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // 추가
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _currentMode = MODE_ADD),
              child: Container(
                decoration: BoxDecoration(
                    color:
                        _currentMode == MODE_ADD ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.black)),
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(right: 8),
                child: Text(
                  '추가',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        _currentMode == MODE_ADD ? Colors.white : Colors.black,
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
                    color: _currentMode == MODE_REMOVE
                        ? Colors.black
                        : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.black)),
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(right: 8),
                child: Text(
                  '삭제',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _currentMode == MODE_REMOVE
                        ? Colors.white
                        : Colors.black,
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
                  color:
                      _currentMode == MODE_NONE ? Colors.black : Colors.white,
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
    );
  }

  _naverMap() {
    return Expanded(
      child: Stack(
        children: <Widget>[
          NaverMap(
            onMapCreated: _onMapCreated,
            onMapTap: _onMapTap,
            markers: _markers,
            pathOverlays: {
              PathOverlay(
                PathOverlayId('path'),
                _coordinates,
                width: _width,
                color: Colors.red,
                outlineColor: Colors.white,
              )
            },
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 40, horizontal: 36),
              padding: EdgeInsets.all(8),
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)]),
              child: Slider.adaptive(
                value: _sliderValue,
                onChanged: _onChangeSlider,
                onChangeEnd: _onSliderChangeEnd,
                min: 0.1,
                max: 2.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================== method ==========================

  void _onMapCreated(NaverMapController controller) {
    _controller.complete(controller);
    controller.moveCamera(
        CameraUpdate.fitBounds(
          LatLngBounds.fromLatLngList(_coordinates),
          padding: 48,
        ),
        animationDuration: 0);
  }

  void _onMapTap(LatLng latLng) {
    if (_currentMode == MODE_ADD) {
      _markers.add(Marker(
        markerId: latLng.json.toString(),
        position: latLng,
        onMarkerTab: _onMarkerTap,
      ));
      _coordinates.add(latLng);
      setState(() {});
    }
  }

  void _onMarkerTap(Marker marker, Map<String, int> iconSize) {
    if (_currentMode == MODE_REMOVE && _coordinates.length > 2) {
      setState(() {
        _coordinates.remove(marker.position);
        _markers.removeWhere((m) => m.markerId == marker.markerId);
      });
    }
  }

  void _onChangeSlider(double value) {
    setState(() {
      _sliderValue = value;
    });
  }

  void _onSliderChangeEnd(double value) {
    setState(() {
      _width = (value * 10).floor();
    });
  }
}
