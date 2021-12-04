import 'package:get_it/get_it.dart';
import 'package:sakhatyla/services/api/api.dart';
import 'package:sakhatyla/services/database/database.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => ApiClient());
  locator.registerLazySingleton(() => AppDatabase());
}
