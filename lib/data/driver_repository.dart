import 'driver_model.dart';

class DriverRepository {
  static final Map<String, Driver> _drivers = {
    "YY456862": Driver(
      id: "YY456862",
      name: "Saddam Khoso",
      dob: "15/03/1980",
      expiry: "28/02/2028",
      photo: "assets/profile.jpg",
      approved: true,
    ),

    "NOT12345": Driver(
      id: "NOT12345",
      name: "Unknown Driver",
      dob: "-",
      expiry: "-",
      photo: "assets/profile.jpg",
      approved: false,
    ),
  };

  static Driver? getDriver(String badgeId) {
    return _drivers[badgeId];
  }
}
