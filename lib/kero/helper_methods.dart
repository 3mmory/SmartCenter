import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future navigateTo(Widget page) async {
  return await Navigator.of(navigatorKey.currentContext!).push(MaterialPageRoute(builder:
      (context) => page,
  ));
}