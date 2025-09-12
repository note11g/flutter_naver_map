// ignore_for_file: prefer_double_quotes

library legacy_flutter_naver_map;

import "dart:async";
import 'dart:developer' show log;
import 'dart:io' show File, Platform;
import 'dart:math' as math show Point, min, max, pi;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import "package:flutter_naver_map/legacy_src/initializer/flutter_naver_map_initializer.dart";
import 'package:flutter_naver_map/legacy_src/messaging/messaging.dart';
import "package:flutter_naver_map/legacy_src/util/custom_data_stream.dart";
import 'package:flutter_naver_map/legacy_src/util/image_util.dart';
import "package:flutter_naver_map/legacy_src/util/app_lifecycle_binder.dart";
import "package:flutter_naver_map/legacy_src/util/location/builtin/default_my_location_tracker.dart";
import 'package:flutter_naver_map/legacy_src/util/math.dart';
import 'package:flutter_naver_map/legacy_src/util/widget_to_image.dart';
import "package:flutter_naver_map/legacy_src/widget/elements/naver_logo_widget.dart";
import "package:meta/meta.dart";
import 'package:flutter_naver_map/legacy_src/widget/elements/util/canvas_util.dart';

export 'legacy_src/util/location/builtin/default_my_location_tracker.dart';
export 'legacy_src/util/location/builtin/default_my_location_tracker_platform_interface.dart'
    show NDefaultMyLocationTrackerPermissionStatus;
export 'package:flutter_naver_map/legacy_src/initializer/flutter_naver_map_initializer.dart';

/*
  --- controller ---
*/
part 'legacy_src/controller/map/controller.dart';

part 'legacy_src/controller/map/handler.dart';

part 'legacy_src/controller/map/sender.dart';

/*
  --- OverlayController ---
*/
part 'legacy_src/controller/overlay/overlay_controller.dart';

part 'legacy_src/controller/overlay/overlay_controller_impl.dart';

part 'legacy_src/type/map/overlay/overlay/overlay_handler.dart';

part 'legacy_src/type/map/overlay/overlay/overlay_sender.dart';

/*
  --- exceptions ---
*/
part 'legacy_src/exceptions/exceptions.dart';
/*
  --- initializer ---
*/

// part 'legacy_src/initializer/flutter_naver_map_initializer.dart';

part 'legacy_src/initializer/flutter_naver_map_legacy_initializer.dart';

part 'legacy_src/initializer/flutter_naver_map_legacy_initializer_impl.dart';
/*
  --- type ---
*/

part 'legacy_src/type/base/locale.dart';

part 'legacy_src/type/base/padding.dart';

part 'legacy_src/type/base/point.dart';

part 'legacy_src/type/base/size.dart';

part 'legacy_src/type/base/range.dart';

part 'legacy_src/type/map/camera/camera_position.dart';

part 'legacy_src/type/map/camera/camera_update.dart';

part 'legacy_src/type/map/enums.dart';

part 'legacy_src/type/map/geo/latlng.dart';

part 'legacy_src/type/map/geo/latlng_bounds.dart';

part 'legacy_src/type/map/indoor/indoor_level.dart';

part 'legacy_src/type/map/indoor/indoor_region.dart';

part 'legacy_src/type/map/indoor/indoor_zone.dart';

part 'legacy_src/type/map/indoor/selected_indoor.dart';

part 'legacy_src/type/map/info/overlay_info.dart';

part 'legacy_src/type/map/info/overlay_query.dart';

part 'legacy_src/type/map/info/pickable_info.dart';

part 'legacy_src/type/map/info/symbol_info.dart';

part 'legacy_src/type/map/map_options.dart';

part 'legacy_src/type/map/overlay/overlay/addable/addable.dart';

part 'legacy_src/type/map/overlay/overlay/addable/circle_overlay.dart';

part 'legacy_src/type/map/overlay/overlay/addable/ground_overlay.dart';

part 'legacy_src/type/map/overlay/overlay/addable/info_window.dart';

part 'legacy_src/type/map/overlay/overlay/addable/marker.dart';

part 'legacy_src/type/map/overlay/overlay/addable/marker_wrapper.dart';

part 'legacy_src/type/map/overlay/overlay/addable/path_overlay/arrow_head_path_overlay.dart';

part 'legacy_src/type/map/overlay/overlay/addable/path_overlay/multipart_path.dart';

part 'legacy_src/type/map/overlay/overlay/addable/path_overlay/multipart_path_overlay.dart';

part 'legacy_src/type/map/overlay/overlay/addable/path_overlay/path_overlay.dart';

part 'legacy_src/type/map/overlay/overlay/addable/polygon_overlay.dart';

part 'legacy_src/type/map/overlay/overlay/addable/polyline_overlay.dart';

part 'legacy_src/type/map/overlay/overlay/location_overlay.dart';

part 'legacy_src/type/map/overlay/overlay/overlay.dart';

part 'legacy_src/type/map/overlay/overlay_caption.dart';

part 'legacy_src/type/map/overlay/overlay_image.dart';

part 'legacy_src/type/map/overlay/clustering/cluster_options.dart';

part 'legacy_src/type/map/overlay/clustering/cluster_info.dart';

part 'legacy_src/type/map/overlay/clustering/cluster_merge_strategy.dart';

part 'legacy_src/type/map/overlay/clustering/cluster_marker.dart';

part 'legacy_src/type/map/overlay/clustering/clusterable_marker.dart';

/*
  --- widget ---
*/

part 'legacy_src/widget/map_widget.dart';

part 'legacy_src/widget/platform_view.dart';

part 'legacy_src/widget/elements/zoom_control_widget.dart';

part 'legacy_src/widget/elements/scale_bar_widget.dart';

part 'legacy_src/widget/elements/my_location_button_widget.dart';

/*
  --- util/location ---
*/

part 'legacy_src/util/location/my_location_tracker.dart';
