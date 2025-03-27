import 'package:flutter/material.dart';
 import 'package:provider/provider.dart';
 import '../../provider/async_value.dart';
 import '../../provider/ride_pref_provider.dart';
 import '../../../model/ride/ride_pref.dart';
 import '../../theme/theme.dart';
 import '../../../utils/animations_util.dart';
 import '../rides/rides_screen.dart';
 import 'widgets/ride_pref_form.dart';
 import 'widgets/ride_pref_history_tile.dart';
 
 const String blablaHomeImagePath = 'assets/images/blabla_home.png';
 
 ///
 /// This screen allows user to:
 /// - Enter his/her ride preference and launch a search on it
 /// - Or select a last entered ride preferences and launch a search on it
 ///
 class RidePrefScreen extends StatelessWidget {
   const RidePrefScreen({Key? key}) : super(key: key);
 
   @override
   Widget build(BuildContext context) {
     // Access the provider
     final provider = context.watch<RidesPreferencesProvider>();
     final currentRidePreference = provider.currentRidePreference;
 
     return Scaffold(
       body: Stack(
         children: [
           // 1 - Background  Image
            BlaBackground(),
 
           // 2 - Foreground content
           Column(
             children: [
               const SizedBox(height: BlaSpacings.m),
               Text(
                 'Your pick of rides at low price',
                 style: BlaTextStyles.heading.copyWith(color: Colors.white),
               ),
               const SizedBox(height: 100),
               Container(
                 margin: const EdgeInsets.symmetric(horizontal: BlaSpacings.xxl),
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(16),
                 ),
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.stretch,
                   children: [
                     // 2.1 Display the Form to input the ride preferences
                     RidePrefForm(
                       initialPreference: currentRidePreference,
                       onSubmit: (RidePreference newPreference) {
                         // Call the provider method to update preference
                         context
                             .read<RidesPreferencesProvider>()
                             .setCurrentRidePreference(newPreference);
                         // Navigate to the rides screen (with a bottom to top animation)
                         Navigator.of(context).push(
                             AnimationUtils.createBottomToTopRoute(RidesScreen()));
                       },
                     ),
                     const SizedBox(height: BlaSpacings.m),
 
                     // 2.2 Optionally display a list of past preferences
                     _buildPastPreferences(provider.pastPreferences, context),
                   ],
                 ),
               ),
             ],
           ),
         ],
       ),
     );
   }
 
   Widget _buildPastPreferences(
     AsyncValue<List<RidePreference>> pastPreferences,
     BuildContext context,
   ) {
     // If the state is loading, return a BlaError with a ‘loading’ message
     if (pastPreferences.isloading) {
       return const Center(child: Text('Loading...'));
     }
     // If the state is error, return  a BlaError with a ‘No connection. Try later’ message
     else if (pastPreferences.isError) {
       return Center(child: Text('No connection. Try again later. Error: ${pastPreferences.error}'));
     }
     // If the state is success,  display  the screen as normal
     else if (pastPreferences.isSuccess) {
       return SizedBox(
         height: 200,
         child: ListView.builder(
           shrinkWrap: true,
           physics: const AlwaysScrollableScrollPhysics(),
           itemCount: pastPreferences.data!.length,
           itemBuilder: (ctx, index) => RidePrefHistoryTile(
             ridePref: pastPreferences.data![index],
             onPressed: () {
               context
                   .read<RidesPreferencesProvider>()
                   .setCurrentRidePreference(pastPreferences.data![index]);
               Navigator.of(context).push(
                 AnimationUtils.createBottomToTopRoute(RidesScreen()),
               );
             },
           ),
         ),
       );
      }
      else {
       return const Center(child: Text("")); // Handle initial state or empty state
      }
    }
  }

  class BlaBackground extends StatelessWidget {
   const BlaBackground({Key? key}) : super(key: key);
 
   @override
   Widget build(BuildContext context) {
     return SizedBox(
       width: double.infinity,
       height: 340,
       child: Image.asset(
         blablaHomeImagePath,
         fit: BoxFit.cover,
       ),
     );
   }
  }