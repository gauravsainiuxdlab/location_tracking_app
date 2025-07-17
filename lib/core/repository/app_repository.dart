
import '../network/api_impl.dart';
import 'package:get_it/get_it.dart';
final injector = GetIt.instance;
class AppRepository {
  final ApiImpl _apiImpl = injector<ApiImpl>();
  //
  // Future<dynamic> addUser({
  //   required String email,
  //   required String password,
  //   required String userName,
  //   required String Name,
  //   required String DeviceId,
  //   required String DeviceName,
  // }) =>
  //     _apiImpl.addUser(
  //         email: email, password: password, userName: userName, Name: Name, DeviceId: DeviceId, DeviceName: DeviceName);
  //
  // Future<dynamic> login({
  //   required String email,
  //   required String password,
  //   required String deviceId,
  // }) =>
  //     _apiImpl.login(
  //       email: email,
  //       password: password, deviceId: deviceId,
  //     );

  // Future<dynamic> getUsers() =>
  //     _apiImpl.getUsers();


}
