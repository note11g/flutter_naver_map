import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class CircleMapPage extends StatefulWidget {
  @override
  _CircleMapPageState createState() => _CircleMapPageState();
}

class _CircleMapPageState extends State<CircleMapPage> {
  Completer<NaverMapController> _controller = Completer();

  List<CircleOverlay> _circles = [];
  double _sliderValue = 40.0;

  int? _selectedCircleIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: <Widget>[
          NaverMap(
            onMapCreated: _onMapCreated,
            circles: _circles,
            initLocationTrackingMode: LocationTrackingMode.Follow,
            onMapTap: _onMapTap,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 32),
              child: Container(
                padding: EdgeInsets.all(8),
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 3,
                      )
                    ]),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("반지름"),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Slider.adaptive(
                        value: _sliderValue,
                        onChanged: _onSliderChange,
                        onChangeEnd: _onSliderChangeEnd,
                        min: 1.0,
                        max: 100.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onMapCreated(NaverMapController controller) {
    _controller.complete(controller);
  }

  void _onMapTap(LatLng latLng) {
    if (_selectedCircleIndex != null) {
      _circles[_selectedCircleIndex!].color = Colors.black.withOpacity(0.3);
    }
    String id = DateTime.now().toIso8601String();
    _circles.add(CircleOverlay(
      overlayId: id,
      center: latLng,
      radius: _sliderValue,
      onTap: _onCircleTap,
      color: Colors.blueAccent.withOpacity(0.3),
      outlineColor: Colors.black,
      outlineWidth: 1,
    ));
    _selectedCircleIndex = _circles.length - 1;
    setState(() {});
  }

  void _onSliderChange(double value) {
    setState(() {
      _sliderValue = value;
    });
  }

  void _onCircleTap(String overlayId) {
    if (_selectedCircleIndex != null) {
      _circles[_selectedCircleIndex!].color = Colors.black.withOpacity(0.3);
    }

    for (int i = 0; i < _circles.length; i++) {
      if (_circles[i].overlayId == overlayId) {
        _selectedCircleIndex = i;
        setState(() {
          _sliderValue = _circles[i].radius;
          _circles[i].color = Colors.blueAccent.withOpacity(0.3);
        });
        break;
      }
    }
  }

  void _onSliderChangeEnd(double value) {
    if (_selectedCircleIndex != null) {
      setState(() {
        _circles[_selectedCircleIndex!].radius = value;
      });
    }
  }
}
