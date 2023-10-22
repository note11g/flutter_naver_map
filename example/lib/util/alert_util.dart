import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import '../design/theme.dart';

class AlertUtil {
  static void openAlert(
    String title, {
    required BuildContext context,
    Color? toastColor,
    Color? textColor,
  }) {
    toastColor ??= getColorTheme(context).onBackground;
    textColor ??= getColorTheme(context).background;

    showToast(
      title,
      context: context,
      textStyle: getTextTheme(context).titleSmall?.copyWith(color: textColor),
      backgroundColor: toastColor.withOpacity(0.92),
      toastHorizontalMargin: 24,
      position:
          const StyledToastPosition(align: Alignment.bottomCenter, offset: 36),
      animation: StyledToastAnimation.fade,
      reverseAnimation: StyledToastAnimation.fade,
      animDuration: const Duration(milliseconds: 300),
    );
  }

  static void openErrorAlert(String title, {required BuildContext context}) {
    openAlert(
      title,
      context: context,
      toastColor: Colors.red.shade700,
      textColor: Colors.white,
    );
  }

  static void openAlertIfResultTrue(String title,
      {required BuildContext context,
      required Future<bool> Function() callback}) {
    void openToast() => openErrorAlert(title, context: context);

    callback.call().then((open) {
      if (open) openToast();
    });
  }

  AlertUtil._();
}
