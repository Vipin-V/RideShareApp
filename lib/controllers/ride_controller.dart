import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_share/common/widgets/custom_snackbar.dart';
import '../models/ride.dart';
import '../services/ride_service.dart';

class RideController extends GetxController {
  var availableRides =
      <Ride>[].obs; // Observable list of available ridesdestination
  var bookedRides = <Ride>[].obs; // Observable list of booked rides
  var isLoading = false.obs; // Loading state

  final RideService _rideService = RideService();

  @override
  void onInit() {
    // Load dummy data instead of fetching from API
    loadDummyData();
    super.onInit();
  }

  // Load dummy data for testing
  void loadDummyData() {
    // Add dummy booked rides
    bookedRides.assignAll([
      Ride(
        id: '1',
        driverName: 'John Smith',
        driverProfilePic: 'https://randomuser.me/api/portraits/men/32.jpg',
        vehicleType: 'SUV',
        vehicleModel: 'Toyota RAV4',
        vehiclePlate: 'KBZ 123A',
        availableSeats: 3,
        departureLocation: 'Central Business District',
        destination: 'Westlands',
        departureTime: '2023-08-15T08:30:00',
        pricePerSeat: 350,
        passengers: [
          Passenger(
              name: 'Alice Johnson',
              profilePic: 'https://randomuser.me/api/portraits/women/44.jpg',
              pickupPoint: 'City Hall'),
          Passenger(
              name: 'Bob Williams',
              profilePic: 'https://randomuser.me/api/portraits/men/46.jpg',
              pickupPoint: 'National Archives'),
        ],
      ),
      Ride(
        id: '2',
        driverName: 'Sarah Davis',
        driverProfilePic: 'https://randomuser.me/api/portraits/women/22.jpg',
        vehicleType: 'Sedan',
        vehicleModel: 'Honda Accord',
        vehiclePlate: 'KCY 456B',
        availableSeats: 2,
        departureLocation: 'Kilimani',
        destination: 'Upperhill',
        departureTime: '2023-08-16T17:15:00',
        pricePerSeat: 250,
        passengers: [
          Passenger(
              name: 'You',
              profilePic: 'https://randomuser.me/api/portraits/men/22.jpg',
              pickupPoint: 'Yaya Centre'),
        ],
      ),
    ]);

    // Add dummy available rides
    availableRides.assignAll([
      Ride(
        id: '3',
        driverName: 'Michael Brown',
        driverProfilePic: 'https://randomuser.me/api/portraits/men/55.jpg',
        vehicleType: 'Hatchback',
        vehicleModel: 'Volkswagen Golf',
        vehiclePlate: 'KDG 789C',
        availableSeats: 3,
        departureLocation: 'Westlands',
        destination: 'Mombasa Road',
        departureTime: '2023-08-15T07:45:00',
        pricePerSeat: 300,
        passengers: [],
      ),
      Ride(
        id: '4',
        driverName: 'Emily Wilson',
        driverProfilePic: 'https://randomuser.me/api/portraits/women/33.jpg',
        vehicleType: 'Sedan',
        vehicleModel: 'Toyota Camry',
        vehiclePlate: 'KBN 234D',
        availableSeats: 4,
        departureLocation: 'Karen',
        destination: 'CBD',
        departureTime: '2023-08-15T16:30:00',
        pricePerSeat: 400,
        passengers: [],
      ),
      Ride(
        id: '5',
        driverName: 'David Lee',
        driverProfilePic: 'https://randomuser.me/api/portraits/men/42.jpg',
        vehicleType: 'SUV',
        vehicleModel: 'Nissan X-Trail',
        vehiclePlate: 'KCZ 567E',
        availableSeats: 5,
        departureLocation: 'Lavington',
        destination: 'Thika Road',
        departureTime: '2023-08-16T08:00:00',
        pricePerSeat: 350,
        passengers: [],
      ),
    ]);

    isLoading(false);
  }

  // Fetches available rides for a given destination
  Future<void> fetchAvailableRides(String destination) async {
    isLoading(true); // Show loading indicator
    try {
      // For demo purposes, just reload the dummy data with a delay
      await Future.delayed(Duration(seconds: 1));
      // If search term is provided, filter the rides
      if (destination.isNotEmpty) {
        availableRides.assignAll(availableRides
            .where((ride) => ride.destination
                .toLowerCase()
                .contains(destination.toLowerCase()))
            .toList());
      } else {
        // Reload dummy data
        loadDummyData();
      }
    } finally {
      isLoading(false); // Hide loading indicator
    }
  }

  // Fetches rides booked by the current user
  Future<void> fetchBookedRides() async {
    isLoading(true);
    try {
      // For demo purposes, just reload the dummy data with a delay
      await Future.delayed(Duration(seconds: 1));
      // Dummy data is already loaded in onInit
    } catch (e) {
      throw Exception("Error fetching booked rides: $e");
    } finally {
      isLoading(false);
    }
  }

  // Books a ride and updates booked rides list
  Future<void> bookRide(String rideId) async {
    isLoading(true);
    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    // Find the ride in available rides
    final rideToBook = availableRides.firstWhere((ride) => ride.id == rideId);

    // Add passenger to the ride
    final bookedRide = Ride(
      id: rideToBook.id,
      driverName: rideToBook.driverName,
      driverProfilePic: rideToBook.driverProfilePic,
      vehicleType: rideToBook.vehicleType,
      vehicleModel: rideToBook.vehicleModel,
      vehiclePlate: rideToBook.vehiclePlate,
      availableSeats: rideToBook.availableSeats - 1,
      departureLocation: rideToBook.departureLocation,
      destination: rideToBook.destination,
      departureTime: rideToBook.departureTime,
      pricePerSeat: rideToBook.pricePerSeat,
      passengers: [
        ...rideToBook.passengers,
        Passenger(
            name: 'You',
            profilePic: 'https://randomuser.me/api/portraits/men/22.jpg',
            pickupPoint: 'Default Pickup'),
      ],
    );

    // Add to booked rides
    bookedRides.add(bookedRide);

    // Remove from available rides
    availableRides.removeWhere((ride) => ride.id == rideId);

    isLoading(false);

    // Show success message
    Get.snackbar(
      'Success',
      'Ride booked successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
