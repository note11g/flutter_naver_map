import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class PolygonMap extends StatefulWidget {
  @override
  _PolygonMapState createState() => _PolygonMapState();
}

class _PolygonMapState extends State<PolygonMap>
    with SingleTickerProviderStateMixin {
  bool _isAdding = false;

  Completer<NaverMapController> _controller = Completer();
  late AnimationController _animationController;
  late Animation<Color?> _colorTwin;
  late Animation<double> _rotation;

  List<Marker> _markers = [];
  List<PolygonOverlay> _polygon = [];

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    )..addListener(() {
        setState(() {});
      });
    _colorTwin = ColorTween(
      begin: Colors.indigoAccent,
      end: Colors.redAccent,
    ).animate(_animationController);
    _rotation =
        Tween<double>(begin: 0.625, end: 0.0).animate(_animationController);

    _polygon.add(PolygonOverlay(
      'default polygon',
      [
        LatLng(37.56823358823172, 126.9838688358965),
        LatLng(37.56507279644869, 126.98367937726825),
        LatLng(37.56488686334351, 126.97757159196705),
        LatLng(37.56770441524463, 126.97814898969123),
      ],
      holes: [
        [
          LatLng(37.56701846799908, 126.97985252649414),
          LatLng(37.567087551633634, 126.9804335687986),
          LatLng(37.566366008290366, 126.98161502148443),
          LatLng(37.56585171249225, 126.97966852976435),
        ]
      ],
      outlineColor: Colors.indigoAccent,
      outlineWidth: 6,
      color: Colors.black54,
      onTap: _onPolygonTap,
    ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: _fab(),
      body: Stack(
        children: <Widget>[
          NaverMap(
            onMapCreated: _onMapCreated,
            onMapTap: _onMapTapped,
            polygons: _polygon,
            markers: _markers,
            initialCameraPosition: CameraPosition(
                target: LatLng(37.56595018951271, 126.97728338254345)),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(left: 16, top: 48),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
                ),
                child: Text(
                  '우측 하단의 버튼을 누르면 입력모드로 전환됩니다.\n'
                  '입력모드에서 지도를 탭하면 마커가 생성됩니다. \n'
                  '3개 이상의 마커를 입력하고 \n다시 우측 하단 버튼을 누르면 폴리곤이 생성됩니다.',
                  style: TextStyle(
                      fontSize: 12,
                      height: 1.2,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          _toFullScreen(),
        ],
      ),
    );
  }

  // 마지막 폴리곤으로 영역잡는 버튼
  _toFullScreen() {
    if (_polygon.isEmpty) {
      return SizedBox();
    } else {
      final current = _polygon.last;
      return Align(
        alignment: Alignment.bottomLeft,
        child: SafeArea(
          top: false,
          child: GestureDetector(
            onTap: () => _onTapFullScreen(current),
            child: Container(
              width: 60,
              height: 60,
              margin: EdgeInsets.only(left: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).primaryColor,
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(5, 5),
                        blurRadius: 5,
                        color: Colors.black26)
                  ]),
              child: Center(
                child: Icon(
                  Icons.fullscreen,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  _fab() {
    return FloatingActionButton(
      onPressed: _onPressFab,
      backgroundColor: _colorTwin.value,
      child: RotationTransition(
        turns: _rotation,
        child: Icon(Icons.clear),
      ),
    );
  }

  // fab on click listener
  void _onPressFab() {
    if (!_isAdding) {
      _animationController.forward();
    } else {
      _animationController.reverse();
      // 완료
      if (_markers.length >= 3) {
        _polygon.add(PolygonOverlay(
          DateTime.now().millisecondsSinceEpoch.toString(),
          _markers.map((e) => e.position!).toList(),
          color: Colors.transparent,
          outlineWidth: 3,
          outlineColor: Colors.redAccent,
        ));
      }
      _markers.clear();
    }
    setState(() {
      _isAdding = !_isAdding;
    });
  }

  // 지도 생성 콜백
  void _onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }

  // 지도 탭 콜백
  void _onMapTapped(LatLng latLng) {
    if (!_isAdding) return;
    setState(() {
      _markers.add(Marker(
        markerId: latLng.toString(),
        position: latLng,
      ));
    });
  }

  void _onPolygonTap(String polygonOverlayId) {
    print('$polygonOverlayId tapped!!');
  }

  /// 마지막 폴리곤으로 화면 맞춤
  _onTapFullScreen(PolygonOverlay current) async {
    final coordinates = current.coordinates;
    final controller = await _controller.future;
    controller.moveCamera(
      CameraUpdate.fitBounds(
        LatLngBounds.fromLatLngList(coordinates),
        padding: 16,
      ),
    );
  }
}
