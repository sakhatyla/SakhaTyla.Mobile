import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakhatyla/favorite/favorite.dart';
import 'package:sakhatyla/home/home.dart';
import 'package:sakhatyla/locator.dart';
import 'package:sakhatyla/main/bloc/main_bloc.dart';
import 'package:sakhatyla/main/bloc/main_event.dart';
import 'package:sakhatyla/main/bloc/main_state.dart';
import 'package:sakhatyla/services/api/api.dart';
import 'package:sakhatyla/services/database/database.dart';

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainBloc(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeBloc(
              api: locator<ApiClient>(),
              database: locator<AppDatabase>(),
              mainBloc: BlocProvider.of<MainBloc>(context),
            ),
          ),
          BlocProvider(
            create: (context) => FavoriteBloc(
              database: locator<AppDatabase>(),
            )..add(Load()),
          ),
        ],
        child: BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Саха Тыла"),
              ),
              body: Container(
                child: state.selectedIndex == 0 ? Home() : FavoriteList(),
              ),
              bottomNavigationBar: BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: 'Поиск',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.star),
                    label: 'Избранное',
                  )
                ],
                currentIndex: state.selectedIndex,
                onTap: (value) {
                  BlocProvider.of<MainBloc>(context)
                      .add(ChangeSelectedIndex(value));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
