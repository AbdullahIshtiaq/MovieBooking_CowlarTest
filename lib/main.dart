import 'package:cowlar_entry_test_app/constants.dart';
import 'package:cowlar_entry_test_app/presentation/watch_screen.dart';
import 'package:cowlar_entry_test_app/presentation/dashboard_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'logic/cubits/movies_cubits/movies_cubit.dart';
import 'logic/cubits/movies_cubits/movies_state.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MoviesCubit(),
      child: MaterialApp(
        title: 'Cowlar Entry Test App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Poppins',
          primarySwatch: Colors.blue,
        ),
        home: BlocBuilder<MoviesCubit, MoviesState>(
          buildWhen: (oldState, newState) {
            return oldState is MoviesInitialState;
          },
          builder: (context, state) {
            return const MyHomePage();
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 1;

  final List<Widget> _tabs = [
    const DashboardScreen(),
    WatchScreen(),
    const DashboardScreen(),
    const DashboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        extendBody: true,
        backgroundColor: bgGrey,
        appBar: null,
        body: _tabs[_currentIndex],
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: navBarColor,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              selectedItemColor: Colors.white,
              unselectedItemColor: const Color(0xFF827D88),
              onTap: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.square_grid_2x2_fill),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.play_rectangle_fill),
                  label: 'Watch',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.collections_solid),
                  label: 'Media Library',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.list_dash),
                  label: 'More',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
