import 'package:fl_nynberapp/src/blocs/auth_bloc.dart';
import 'package:fl_nynberapp/src/resources/login_page.dart';
import 'package:flutter/material.dart';

class MyApp extends InheritedWidget {
  final AuthBloc auth;
  final Widget child;

  MyApp(this.auth, this.child) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    print("vào đây 1");
    // TODO: implement updateShouldNotify
    return false;
  }

  static MyApp of(BuildContext context) {
    print("vào đây 2");
    return context.dependOnInheritedWidgetOfExactType<MyApp>();
  }
}
