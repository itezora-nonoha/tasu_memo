import 'package:flutter/foundation.dart';

class PlatformUtils {
  static bool get isDesktop => !kIsWeb && (defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux);
}
