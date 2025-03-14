import 'dart:convert';
import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_share/models/user_profile.dart';
import 'package:ride_share/services/storage_service.dart';
import 'package:ride_share/utils/constants/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  // Controllers for form fields, i.e. EditProfileForm()
  final usernameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final homeAddressController = TextEditingController();
  final workAddressController = TextEditingController();
  final facebookController = TextEditingController();
  final instagramController = TextEditingController();
  final twitterController = TextEditingController();
  final bioController = TextEditingController();

  final RxMap<String, String> userInfo = <String, String>{}.obs;
  var selectedImage = Rx<File?>(null);
  var userProfile = Rxn<UserProfile>();
  var isLoading = false.obs;
  var errorMessage = <String, dynamic>{}.obs;

  @override
  void onInit() {
    // Load dummy profile data
    loadDummyProfile();
    super.onInit();
  }

  // Load dummy profile data
  void loadDummyProfile() {
    isLoading(true);

    // Create dummy profile
    userProfile.value = UserProfile(
      id: '1',
      firstName: 'Alex',
      lastName: 'Morgan',
      username: 'alex_morgan',
      email: 'alex.morgan@example.com',
      mobileNumber: '+254 712 345 678',
      profilePicture: 'https://randomuser.me/api/portraits/men/22.jpg',
      dateJoined: '2023-01-15',
      facebookHandle: 'alex.morgan',
      instagramHandle: 'alex_morgan',
      twitterHandle: '@alex_morgan',
      workAddress: 'Westlands Business Park',
      homeAddress: 'Kilimani, Nairobi',
      bio:
          'Software developer and tech enthusiast. I love traveling and sharing rides with interesting people. Always up for a good conversation during commutes!',
    );

    // Populate form controllers with dummy data
    usernameController.text = userProfile.value?.username ?? '';
    mobileNumberController.text = userProfile.value?.mobileNumber ?? '';
    homeAddressController.text = userProfile.value?.homeAddress ?? '';
    workAddressController.text = userProfile.value?.workAddress ?? '';
    facebookController.text = userProfile.value?.facebookHandle ?? '';
    instagramController.text = userProfile.value?.instagramHandle ?? '';
    twitterController.text = userProfile.value?.twitterHandle ?? '';
    bioController.text = userProfile.value?.bio ?? '';

    isLoading(false);
  }

  @override
  void onClose() {
    usernameController.dispose();
    mobileNumberController.dispose();
    homeAddressController.dispose();
    workAddressController.dispose();
    facebookController.dispose();
    instagramController.dispose();
    twitterController.dispose();
    bioController.dispose();
    super.onClose();
  }

  // Fetch user profile (now just reloads dummy data)
  Future<void> fetchuserProfile() async {
    isLoading(true);

    try {
      // Simulate API delay
      await Future.delayed(Duration(seconds: 1));

      // Load dummy profile
      loadDummyProfile();
    } catch (e) {
      errorMessage({
        'title': 'Error',
        'message': 'Failed to load profile: $e',
        'type': ContentType.failure,
      });
    } finally {
      isLoading(false);
    }
  }

  // Method to pick an image from gallery
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
      update(); // Refresh UI after picking the image
    } else {
      errorMessage({
        'title': 'Oops!',
        'message': 'Please select an image file.',
        'type': ContentType.warning,
      });
    }
  }

  // Update profile (simulated)
  Future<void> updateProfile() async {
    isLoading(true);

    try {
      // Simulate API delay
      await Future.delayed(Duration(seconds: 1));

      // Update the profile with form values
      userProfile.value = UserProfile(
        id: userProfile.value?.id ?? '1',
        firstName: userProfile.value?.firstName ?? 'Alex',
        lastName: userProfile.value?.lastName ?? 'Morgan',
        username: usernameController.text,
        email: userProfile.value?.email ?? 'alex.morgan@example.com',
        mobileNumber: mobileNumberController.text,
        profilePicture: userProfile.value?.profilePicture ??
            'https://randomuser.me/api/portraits/men/22.jpg',
        dateJoined: userProfile.value?.dateJoined ?? '2023-01-15',
        facebookHandle: facebookController.text,
        instagramHandle: instagramController.text,
        twitterHandle: twitterController.text,
        workAddress: workAddressController.text,
        homeAddress: homeAddressController.text,
        bio: bioController.text,
      );

      // Show success message
      Get.snackbar(
        'Success',
        'Profile updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate back
      Get.back();
    } catch (e) {
      errorMessage({
        'title': 'Error',
        'message': 'Failed to update profile: $e',
        'type': ContentType.failure,
      });
    } finally {
      isLoading(false);
    }
  }
}
