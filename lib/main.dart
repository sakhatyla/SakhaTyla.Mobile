import 'package:flutter/material.dart';
import 'package:sakhatyla/common/theme.dart';
import 'package:sakhatyla/locator.dart';
import 'package:sakhatyla/home/view/home.dart';

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
  const Main();

  @override
  State<Main> createState() => MainState();
}

class MainState extends State<Main> {
  int _selectedIndex = 0;
  List<Widget> _screens = <Widget>[
    Home(),
    Text('Тылларым'),
  ];

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
      body: _screens[_selectedIndex],
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
