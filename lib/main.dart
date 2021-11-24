import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'pages/home_bloc/home_bloc.dart';
import 'pages/home_bloc/home_event.dart';
import 'pages/home_bloc/home_state.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: BlocProvider<HomeBloc>(
        create: (BuildContext blocContext) =>
            HomeBloc(HomeLoadingState())..add(HomeFetchList()),
        child: const HomePage(),
      ),
    );
  }
}
