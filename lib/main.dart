import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/common/theme.dart';
import 'package:sakhatyla/favorite/favorite_list.dart';
import 'package:sakhatyla/home/home.dart';
import 'package:sakhatyla/locator.dart';
import 'package:sakhatyla/home/view/home.dart';
import 'package:sakhatyla/services/api/api.dart';
import 'package:sakhatyla/services/database/database.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Саха Тыла',
      theme: appTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => Main(),
      },
    );
  }
}

class Main extends StatefulWidget {

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Саха Тыла"),
      ),
      body: Container(
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => HomeBloc(
                api: locator<ApiClient>(),
                database: locator<AppDatabase>(),
                currentItem: () { return _selectedIndex; },
                onItemTapped: _onItemTapped
            ))
          ],
          child: _selectedIndex == 0 ? Home() : FavoriteList(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Сүрүн',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Тылларым',
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
