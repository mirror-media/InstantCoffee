class SlugBloc {
  String slug;

  SlugBloc(String inputSlug) {
    slug = inputSlug;
  }

  String getShareUrlFromSlug(bool isListeningWidget) {
    return isListeningWidget
      ? 'https://www.mirrormedia.mg/video/$slug/?utm_source=app&utm_medium=mmapp'
      : 'https://www.mirrormedia.mg/story/$slug/?utm_source=app&utm_medium=mmapp';
  }
}