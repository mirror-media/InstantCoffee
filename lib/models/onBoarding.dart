class OnBoarding {
  bool isOnBoarding;
  double left;
  double top;
  double width;
  double height;
  bool isNeedInkWell;
  Function function;

  OnBoarding({
    this.isOnBoarding,
    this.left,
    this.top,
    this.width,
    this.height,
    this.isNeedInkWell = false,
    this.function,
  });
}