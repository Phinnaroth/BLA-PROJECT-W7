import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/ride/ride_pref.dart';
import '../../../provider/ride_pref_provider.dart';
import '../../../model/ride/ride_filter.dart';
import 'widgets/ride_pref_bar.dart';
import '../../../model/ride/ride.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import 'widgets/ride_pref_modal.dart';
import 'widgets/rides_tile.dart';
import '../../../service/rides_service.dart'; // Import your rides service

///
///   The Ride Selection screen allows user to select a ride, once ride preferences have been defined.
///   The screen also allow user to re-define the ride preferences and to activate some filters.
///
class RidesScreen extends StatelessWidget {
  const RidesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access the provider
    final provider = context.watch<RidesPreferencesProvider>();
    final currentPreference = provider.currentRidePreference;
    RideFilter currentFilter = RideFilter(); // You might want to manage this in the provider as well

    // Get matching rides (this logic might need adjustment based on how you want to handle filtering)
    List<Ride> matchingRides = _getMatchingRides(currentPreference, currentFilter);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: BlaSpacings.m,
          right: BlaSpacings.m,
          top: BlaSpacings.s,
        ),
        child: Column(
          children: [
            // Top search Search bar
            RidePrefBar(
              ridePreference: currentPreference!,
              onBackPressed: () {
                Navigator.of(context).pop();
              },
              onPreferencePressed: () async {
                // Open a modal to edit the ride preferences
                RidePreference? newPreference =
                    await Navigator.of(context).push<RidePreference>(
                  AnimationUtils.createTopToBottomRoute(
                    RidePrefModal(initialPreference: currentPreference),
                  ),
                );

                if (newPreference != null) {
                  // Update the current preference using the provider
                  context
                      .read<RidesPreferencesProvider>()
                      .setCurrentRidePreference(newPreference);
                }
              },
              onFilterPressed: () {
                // Handle filter logic here or call a provider method to update filter
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: matchingRides.length,
                itemBuilder: (ctx, index) => RideTile(
                  ride: matchingRides[index],
                  onPressed: () {
                    // Handle ride selection
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to get matching rides
  List<Ride> _getMatchingRides(RidePreference? preference, RideFilter filter) {
    if (preference == null) {
      return []; // Or handle the case where there's no preference
    }
    return RidesService.instance.getRidesFor(preference, filter);
  }
}