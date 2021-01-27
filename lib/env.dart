import 'package:meta/meta.dart';
import 'package:readr_app/models/baseConfig.dart';

enum BuildFlavor { production, development }

BuildEnvironment get env => _env;
BuildEnvironment _env;

class BuildEnvironment {
  /// The backend server.
  final BaseConfig baseConfig;
  final BuildFlavor flavor;

  BuildEnvironment._init({this.flavor, this.baseConfig});

  /// Sets up the top-level [env] getter on the first call only.
  static void init({@required flavor, @required baseConfig}) =>
      _env ??= BuildEnvironment._init(flavor: flavor, baseConfig: baseConfig);
}