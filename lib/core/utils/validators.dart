import 'package:flutter/material.dart';

import '../constants/app_constants.dart';



class Validators {
  static String? isValidInput(String? input) {
    if (input == null || input.isEmpty) {
      return 'Required Field';
    } else {
      return null;
    }
  }

  static String? isValidateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Please type your email.';
    }

    if (RegExp(AppConstants.emailValidatorRegExp).hasMatch(email)) {
      return null;
    } else {
      return 'Please enter a valid email';
    }
  }

  static String? isPasswordValid(String? password, [int minLength = 8]) {
    /* const pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
    final regExp = RegExp(pattern);*/
    if (password == null || password.isEmpty) {
      return 'Please type your password.';
    }
    // bool hasMinLength = password.length >= minLength;

    //TODO: Discuss whether the password field required regex validation and min length validation or not
    /* if (!hasMinLength) {
      return 'Invalid  Password. Try Again!';
    }
    if (!regExp.hasMatch(password)) {
      return 'Invalid  Password. Try Again!';
    }*/

    // if (!password.contains("@") || !password.contains("!")) {
    //   return 'Password must include @ ! such elements';
    // }
    return null;
  }

  static String? validateAndSignIn(String? email, String? password,
      [int minLength = 8]) {
    bool hasMinLength = password?.length == minLength;
    if (RegExp(AppConstants.emailValidatorRegExp).hasMatch(email!) &&
        hasMinLength) {
      return 'Log In Success';
    }

    if (!RegExp(AppConstants.emailValidatorRegExp).hasMatch(email) &&
        !hasMinLength) {
      return 'please enter email and password in valid format';
    }
    if (RegExp(AppConstants.emailValidatorRegExp).hasMatch(email) &&
        !hasMinLength) {
      return 'please enter password in valid format';
    }
    if (!RegExp(AppConstants.emailValidatorRegExp).hasMatch(email) &&
        hasMinLength) {
      return 'please enter email in valid format';
    }
    return null;
  }

  static String? validateConfirmPassword(String? password, String? cPassword,
      [int minLength = 8]) {
    bool hasMinLength = password?.length == minLength;
    if (password == cPassword && hasMinLength) {
      return 'Password Match';
    } else if (password == cPassword && !hasMinLength) {
      return 'Your password must be at least 8 alphanumeric length.';
    } else if (password != cPassword && hasMinLength) {
      return 'Password not match';
    } else if (password != cPassword && !hasMinLength) {
      return 'password not matched and less than 8 alphanumeric length';
    }
    return null;
  }

  static String? validateAndSignUp(
      String? email, String? password, String? cPassword,
      [int minLength = 8]) {
    bool hasMinLength = password?.length == minLength;
    if (RegExp(AppConstants.emailValidatorRegExp).hasMatch(email!) &&
        password == cPassword &&
        hasMinLength) {
      return 'Sign up successful';
    }

    if (RegExp(AppConstants.emailValidatorRegExp).hasMatch(email) &&
        password == cPassword &&
        !hasMinLength) {
      return 'Your password must be at least 8 alphanumeric length.';
    }
    if (RegExp(AppConstants.emailValidatorRegExp).hasMatch(email) &&
        password != cPassword &&
        hasMinLength) {
      return 'Password not match';
    }
    if (RegExp(AppConstants.emailValidatorRegExp).hasMatch(email) &&
        password != cPassword &&
        !hasMinLength) {
      return 'password not matched and less than 8 alphanumeric length';
    }
    return null;
  }

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
