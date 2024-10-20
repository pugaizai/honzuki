import 'package:flutter/material.dart';

final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF607D8B), // 深灰色作为主要强调色
      primaryContainer: Color(0xFF455A64), // 更深的灰色作为次要强调色
      secondary: Color(0xFF78909C), // 稍浅的灰色作为次要颜色
      onSurface: Color(0xFFE0E0E0), // 浅灰色，用于文本
      surface: Color(0xFF121212), // 深灰色，稍微柔和的黑色背景
      outline: Color(0xFF3A3A3A), // 深灰色轮廓
    ));
