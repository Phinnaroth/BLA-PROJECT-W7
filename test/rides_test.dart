
import 'package:W7/model/location/locations.dart';
import 'package:W7/model/ride/ride.dart';
import 'package:W7/model/ride/ride_pref.dart';
import 'package:W7/repository/mock/mock_rides_repository.dart';
import 'package:W7/service/rides_service.dart';

void main() {
  // 1 - Create a  ride services
  RidesService.initialize(MockRidesRepository());

  // FAKE LOCATIONS
  Location battambang = Location(name: "Battambang", country: Country.cambodia);

  Location siemReap = Location(name: "Siem Reap", country: Country.cambodia);

  // 2 - Create a ride preference
  RidePreference pref = RidePreference(
    departure: battambang,
    departureDate: DateTime.now(),
    arrival: siemReap,
    requestedSeats: 1,
  );

  List<Ride> availableRides = RidesService.instance.getRidesFor(pref, null);

  print(availableRides);
}
