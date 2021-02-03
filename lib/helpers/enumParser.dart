extension EnumParser on dynamic {
  T toEnum<T>(List<T> values) {
    return values.firstWhere(
        (e) => e.toString().toLowerCase().split(".").last == '$this'.toLowerCase(),
        orElse: () => null); //return null if not found
  }
}