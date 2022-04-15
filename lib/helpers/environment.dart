import 'package:readr_app/configs/baseConfig.dart';
import 'package:readr_app/configs/devConfig.dart';
import 'package:readr_app/configs/stagingConfig.dart';
import 'package:readr_app/configs/prodConfig.dart';

enum BuildFlavor { development, staging, production }

class Environment {
  factory Environment() {
    return _singleton;
  }

  Environment._internal();

  static final Environment _singleton = Environment._internal();

  late BaseConfig config;

  initConfig(BuildFlavor buildFlavor) {
    config = _getConfig(buildFlavor);
  }

  BaseConfig _getConfig(BuildFlavor buildFlavor) {
    switch (buildFlavor) {
      case BuildFlavor.production:
        return ProdConfig();
      case BuildFlavor.staging:
        return StagingConfig();
      default:
        return DevConfig();
    }
  }
}