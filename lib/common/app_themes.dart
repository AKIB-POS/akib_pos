import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppThemes {
  //static final ThemeData appTheme = ThemeData()
  //static final ThemeData appTheme = ThemeData()
  static BoxDecoration bottomBoxDecorationDialog = BoxDecoration(
    color: Colors.white,
    borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(10),
      bottomRight: Radius.circular(10),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        spreadRadius: 2,
        blurRadius: 5,
        offset: const Offset(0, -2),
      ),
    ],
  );

  static final elevatedBUttonPrimaryStyle = ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryMain,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      overlayColor: Colors.white);

  static final outlineButtonPrimaryStyle = OutlinedButton.styleFrom(
    side: BorderSide(color: AppColors.primaryMain),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
    padding: const EdgeInsets.symmetric(vertical: 12),
    overlayColor: Colors.white
  );

  static BoxDecoration bottomShadow = BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.1),
        spreadRadius: 1,
        blurRadius: 1,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration topBoxDecorationDialog = BoxDecoration(
    color: Colors.white,
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(8),
      topRight: Radius.circular(8),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        spreadRadius: 2,
        blurRadius: 5,
        offset: const Offset(0, 2),
      ),
    ],
  );
  static BoxDecoration allBoxDecorationDialog = BoxDecoration(
    color: Colors.white,
    borderRadius: const BorderRadius.all(Radius.circular(10)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        spreadRadius: 2,
        blurRadius: 5,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static InputDecoration inputDecorationStyle = InputDecoration(
    hintStyle: AppTextStyle.bodyInput.copyWith(color: AppColors.textGrey500),
    filled: true,
    focusColor: AppColors.primaryMain,
    hoverColor: AppColors.primaryMain,
    fillColor: AppColors.fillColorInput,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(
        color: AppColors.borderColorInput,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(
        color: AppColors.borderColorInput,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(
        color: AppColors.primaryMain,
      ),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );
}
