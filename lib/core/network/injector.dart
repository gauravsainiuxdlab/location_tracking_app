import 'package:get_it/get_it.dart';
import '../repository/app_repository.dart';
import 'api_impl.dart';


final injector = GetIt.instance;

void setupLocator() {
  injector.registerLazySingleton<ApiImpl>(() => ApiImpl());
  injector.registerLazySingleton<AppRepository>(() => AppRepository());
}
