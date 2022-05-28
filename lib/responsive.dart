import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget dekstop;

  const Responsive(
      {Key? key,
      required this.mobile,
      required this.tablet,
      required this.dekstop})
      : super(key: key);

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 650;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 650 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDekstop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return dekstop;
        } else if (constraints.maxWidth > 650 && constraints.maxWidth < 1200) {
          return tablet;
        } else {
          return mobile;
        }
      },
    );
  }
}
