import 'package:readr_app/configs/baseConfig.dart';
import 'package:readr_app/configs/devConfig.dart';
import 'package:readr_app/configs/prodConfig.dart';

enum BuildFlavor { production, development }

class Environment {
  factory Environment() {
    return _singleton;
  }

  Environment._internal();

  static final Environment _singleton = Environment._internal();

  BaseConfig config;

  initConfig(BuildFlavor buildFlavor) {
    config = _getConfig(buildFlavor);
  }

  BaseConfig _getConfig(BuildFlavor buildFlavor) {
    switch (buildFlavor) {
      case BuildFlavor.production:
        return ProdConfig();
      default:
        return DevConfig();
    }
  }
}