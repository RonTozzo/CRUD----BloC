import 'package:crud_bloc/pages/home/home_bloc/home_bloc.dart';
import 'package:crud_bloc/pages/home/home_bloc/home_event.dart';
import 'package:crud_bloc/pages/home/home_bloc/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'pages/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: BlocProvider<HomeBloc>(
        create: (BuildContext blocContext) =>
            HomeBloc(HomeLoadingState())..add(HomeFetchList()),
        child: HomePage(),
      ),
    );
  }
}
