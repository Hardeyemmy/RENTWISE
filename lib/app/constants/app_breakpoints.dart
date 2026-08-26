class AppBreakpoints {
  const AppBreakpoints._();

  static const double mobile = 800;
  static const double tablet = 1100;

  static bool isMobile(double width) {
    return width < mobile;
  }

  static bool isTablet(double width) {
    return width >= mobile && width < tablet;
  }

  static bool isDesktop(double width) {
    return width >= tablet;
  }
}
