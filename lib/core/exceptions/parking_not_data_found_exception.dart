class ParkingNotDataFoundException implements Exception {
  ParkingNotDataFoundException([this.message]);

  final String? message;
}
