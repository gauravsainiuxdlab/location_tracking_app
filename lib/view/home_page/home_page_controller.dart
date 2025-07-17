import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../core/helper/app_logger.dart';
import '../../core/network/data_state.dart';
import '../../core/repository/app_repository.dart';
import '../../models/user_model.dart';

enum ViewState { loading, empty, complete, error }

class HomePageController extends GetxController {
  final AppRepository _appRepository = injector<AppRepository>();
  TextEditingController searchController=TextEditingController();
  ViewState state = ViewState.loading;
  List<User> users = [];
  List<User> allUsers = [];
  String errorMessage = '';


  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }


   filterUsers(String query) {
    if (query.isEmpty) {
      users=allUsers;
      update();
    } else {
      users = allUsers.where((user) {
        return user.name.toLowerCase().contains(query) ||
            user.username.toLowerCase().contains(query) ||
            user.email.toLowerCase().contains(query);
      }).toList();
      update();
    }
  }
}
