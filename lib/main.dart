import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'src/App.dart';

void main() {
  timeAgo.setLocaleMessages('vi', timeAgo.ViMessages());
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(App());
}

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}
