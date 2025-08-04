import 'package:convenient_test_dev/convenient_test_dev.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_naver_map_example/main_test.dart';

import 'camera_update_test.dart';
import 'clustering_test.dart';
import 'now_camera_position_test.dart';
import 'overlay_test.dart';
import 'widget_to_image_test.dart';


void main() {
  convenientTestMain(MyConvenientTestSlot(), () {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Run all tests
    cameraUpdateTests();
    overlayTests();
    nowCameraPositionTests();
    widgetToImageTests();
    clusteringTests();
  });
}

class MyConvenientTestSlot extends ConvenientTestSlot {
  @override
  Future<void> appMain(AppMainExecuteMode mode) async {
    await mainWithTest(mode.name);
  }

  @override
  BuildContext? getNavContext(ConvenientTest t) =>
      MyApp.navigatorKey.currentContext;
}