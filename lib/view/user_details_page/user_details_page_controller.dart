import 'package:get/get.dart';
import '../../core/enums/view_state.dart';
import '../../models/user_model.dart';

class UserDetailsPageController extends GetxController {
  ViewState state = ViewState.loading;
  User? user;
  String message = '';

  void loadUser(User u) {
    state = ViewState.loading;
    update();

    Future.delayed(const Duration(seconds: 2), () {
      try {
        user = u;
        state = ViewState.complete;
        update();
      } catch (e) {
        state = ViewState.error;
        message = 'Failed to load user data.';
        update();
      }
    });
  }
}
