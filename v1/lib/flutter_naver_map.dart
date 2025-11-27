// ignore_for_file: prefer_double_quotes

library flutter_naver_map;

import "dart:async";
import 'dart:developer' show log;
import 'dart:io' show File, Platform;
import 'dart:math' as math show Point, min, max, pi;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import "package:flutter_naver_map/src/initializer/flutter_naver_map_initializer.dart";
import 'package:flutter_naver_map/src/messaging/messaging.dart';
import "package:flutter_naver_map/src/util/custom_data_stream.dart";
import 'package:flutter_naver_map/src/util/image_util.dart';
import "package:flutter_naver_map/src/util/app_lifecycle_binder.dart";
import "package:flutter_naver_map/src/util/location/builtin/default_my_location_tracker.dart";
import 'package:flutter_naver_map/src/util/math.dart';
import 'package:flutter_naver_map/src/util/widget_to_image.dart';
import "package:flutter_naver_map/src/widget/elements/naver_logo_widget.dart";
import "package:meta/meta.dart";
import 'package:flutter_naver_map/src/widget/elements/util/canvas_util.dart';

export 'src/util/location/builtin/default_my_location_tracker.dart';
export 'src/util/location/builtin/default_my_location_tracker_platform_interface.dart'
    show NDefaultMyLocationTrackerPermissionStatus;
export 'package:flutter_naver_map/src/initializer/flutter_naver_map_initializer.dart';

/*
  --- controller ---
*/
part 'src/controller/map/controller.dart';

part 'src/controller/map/handler.dart';

part 'src/controller/map/sender.dart';

/*
  --- OverlayController ---
*/
part 'src/controller/overlay/overlay_controller.dart';

part 'src/controller/overlay/overlay_controller_impl.dart';

part 'src/type/map/overlay/overlay/overlay_handler.dart';

part 'src/type/map/overlay/overlay/overlay_sender.dart';

/*
  --- exceptions ---
*/
part 'src/exceptions/exceptions.dart';
/*
  --- initializer ---
*/

// part 'src/initializer/flutter_naver_map_initializer.dart';

part 'src/initializer/flutter_naver_map_legacy_initializer.dart';

part 'src/initializer/flutter_naver_map_legacy_initializer_impl.dart';
/*
  --- type ---
*/

part 'src/type/base/locale.dart';

part 'src/type/base/padding.dart';

part 'src/type/base/point.dart';

part 'src/type/base/size.dart';

part 'src/type/base/range.dart';

part 'src/type/map/camera/camera_position.dart';

part 'src/type/map/camera/camera_update.dart';

part 'src/type/map/enums.dart';

part 'src/type/map/geo/latlng.dart';

part 'src/type/map/geo/latlng_bounds.dart';

part 'src/type/map/indoor/indoor_level.dart';

part 'src/type/map/indoor/indoor_region.dart';

part 'src/type/map/indoor/indoor_zone.dart';

part 'src/type/map/indoor/selected_indoor.dart';

part 'src/type/map/info/overlay_info.dart';

part 'src/type/map/info/overlay_query.dart';

part 'src/type/map/info/pickable_info.dart';

part 'src/type/map/info/symbol_info.dart';

part 'src/type/map/map_options.dart';

part 'src/type/map/overlay/overlay/addable/addable.dart';

part 'src/type/map/overlay/overlay/addable/circle_overlay.dart';

part 'src/type/map/overlay/overlay/addable/ground_overlay.dart';

part 'src/type/map/overlay/overlay/addable/info_window.dart';

part 'src/type/map/overlay/overlay/addable/marker.dart';

part 'src/type/map/overlay/overlay/addable/marker_wrapper.dart';

part 'src/type/map/overlay/overlay/addable/path_overlay/arrow_head_path_overlay.dart';

part 'src/type/map/overlay/overlay/addable/path_overlay/multipart_path.dart';

part 'src/type/map/overlay/overlay/addable/path_overlay/multipart_path_overlay.dart';

part 'src/type/map/overlay/overlay/addable/path_overlay/path_overlay.dart';

part 'src/type/map/overlay/overlay/addable/polygon_overlay.dart';

part 'src/type/map/overlay/overlay/addable/polyline_overlay.dart';

part 'src/type/map/overlay/overlay/location_overlay.dart';

part 'src/type/map/overlay/overlay/overlay.dart';

part 'src/type/map/overlay/overlay_caption.dart';

part 'src/type/map/overlay/overlay_image.dart';

part 'src/type/map/overlay/clustering/cluster_options.dart';

part 'src/type/map/overlay/clustering/cluster_info.dart';

part 'src/type/map/overlay/clustering/cluster_merge_strategy.dart';

part 'src/type/map/overlay/clustering/cluster_marker.dart';

part 'src/type/map/overlay/clustering/clusterable_marker.dart';

/*
  --- widget ---
*/

part 'src/widget/map_widget.dart';

part 'src/widget/platform_view.dart';

part 'src/widget/elements/zoom_control_widget.dart';

part 'src/widget/elements/scale_bar_widget.dart';

part 'src/widget/elements/my_location_button_widget.dart';

/*
  --- util/location ---
*/

part 'src/util/location/my_location_tracker.dart';
