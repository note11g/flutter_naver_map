import 'camera_update_test.dart';
import 'clustering_test.dart';
import 'now_camera_position_test.dart';
import 'overlay_test.dart';
import 'widget_to_image_test.dart';

/// golden tests command:
/// ```
/// flutter test integration_test/all_tests.dart -d <device>  --update-goldens
/// ```
void main() {
  cameraUpdateTests();
  overlayTests();
  nowCameraPositionTests();
  widgetToImageTests();
  clusteringTests();
}
