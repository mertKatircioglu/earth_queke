import 'package:earth_queke/data/earth_queke_api_client.dart';
import 'package:earth_queke/view_models/queke_view_model.dart';
import 'package:get_it/get_it.dart';

import 'data/queke_repository.dart';

GetIt locator = GetIt.instance;

void setupLocator(){
  locator.registerLazySingleton(() =>EartQukeApiClient());
  locator.registerLazySingleton(() =>QuekeRepository());
  locator.registerFactory(() =>EarthQuakeViewModel());
}