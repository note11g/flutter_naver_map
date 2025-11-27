part of "../../../flutter_naver_map.dart";

/// 줌 레벨을 컨트롤할 수 있는 위젯입니다.
class NaverMapZoomControlWidget extends StatelessWidget {
  final NaverMapController? mapController;
  final bool nightMode;
  final double roundness;
  final double size;

  const NaverMapZoomControlWidget({
    super.key,
    required this.mapController,
    this.roundness = 2,
    this.size = 44,
    this.nightMode = false,
  });

  Color get buttonColor => nightMode ? Colors.grey.shade900 : Colors.white;
  Color get iconColor =>
      nightMode ? Colors.grey.shade200 : Colors.grey.shade800;
  Color get dividerColor =>
      nightMode ? Colors.grey.shade700 : Colors.grey.shade200;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(roundness),
        color: buttonColor,
        elevation: 1,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          baseWidget(icon: Icons.add, action: zoomIn),
          _divider(),
          baseWidget(icon: Icons.remove, action: zoomOut),
        ]),
      ),
    );
  }

  Widget _divider() => Container(width: size, height: 1.6, color: dividerColor);

  Widget baseWidget({required IconData icon, required VoidCallback action}) {
    return SizedBox(
      width: size,
      height: size,
      child: InkWell(
        onTap: mapController != null ? action : null,
        child: Icon(icon, size: 24, color: iconColor),
      ),
    );
  }

  void zoomIn() => zoomBy(1);

  void zoomOut() => zoomBy(-1);

  // animation 도중에 조작하여도, 정수 값의 줌 레벨을 보장하기 위해 반올림 사용
  void zoomBy(int delta) async {
    if (mapController == null) return;
    final nowZoomLevel =
        await mapController!.getCameraPosition().then((cp) => cp.zoom);
    final update = NCameraUpdate.withParams(
        zoom: (nowZoomLevel.round() + delta).toDouble())
      ..setReason(NCameraUpdateReason.control)
      ..setAnimation(duration: const Duration(milliseconds: 300));
    mapController?.updateCamera(update);
  }
}
