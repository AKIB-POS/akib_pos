import 'package:flutter/material.dart';

String truncateText(String text,int maxCharacterLength) {
    if (text.length > maxCharacterLength) {
      return text.substring(0, maxCharacterLength) + '...';
    } else {
      return text;
    }
  }

  bool isLandscape(BuildContext context){
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return width > height;
  }