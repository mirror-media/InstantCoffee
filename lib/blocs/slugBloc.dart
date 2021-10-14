import 'package:readr_app/env.dart';

class SlugBloc {
  String slug;

  SlugBloc(String inputSlug) {
    slug = inputSlug;
  }

  String getShareUrlFromSlug(bool isListeningWidget) {
    return isListeningWidget
      ? '${env.baseConfig.mirrorMediaDomain}/video/$slug/?utm_source=app&utm_medium=mmapp'
      : '${env.baseConfig.mirrorMediaDomain}/story/$slug/?utm_source=app&utm_medium=mmapp';
  }
}