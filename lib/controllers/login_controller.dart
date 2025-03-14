import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_share/services/storage_service.dart';
import 'auth_controller.dart';

class LoginController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var isLoading = false.obs;
  var errorMessage = <String, dynamic>{}.obs;

  Future<void> login() async {
    isLoading(true);

    // Create dummy auth data
    final dummyAuthData = {
      'access_token': 'dummy_token',
      'user_id': '1',
      'username': 'demouser',
      'email': 'demo@example.com',
    };

    // Save dummy user info in local storage
    await StorageService.saveUserInfo(dummyAuthData);

    // Short delay to simulate loading
    await Future.delayed(Duration(milliseconds: 500));

    isLoading(false);

    // Navigate to home screen
    Get.offAllNamed('/home');
  }
}
