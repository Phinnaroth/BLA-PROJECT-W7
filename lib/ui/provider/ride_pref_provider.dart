import 'package:flutter/material.dart';

import '../../../model/ride/ride_pref.dart';
import '../../data/repository/ride_preferences_repository.dart';
import 'async_value.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentRidePreference;

  final RidePreferencesRepository repository;

  RidesPreferencesProvider({required this.repository}) {
    _fetchPastRidePreferences();
  }

  RidePreference? get currentRidePreference => _currentRidePreference;

  // wrap past preferences with async value
  late AsyncValue<List<RidePreference>> pastPreferences;

  // fetch the past ride preferences from repo
  Future<void> _fetchPastRidePreferences() async{
     // 1-  Handle loading 
    pastPreferences = AsyncValue.loading(); 
    notifyListeners(); 

    try { 
    // 2   Fetch data 
    List<RidePreference> pastPrefs = await repository.getPastPreferences();

    // 3  Handle success
    pastPreferences = AsyncValue.success(pastPrefs);
    
    // 4  Handle error 
    } catch (error) {
      pastPreferences = AsyncValue.error(error);
    } 
    notifyListeners(); 
  }

  void setCurrentRidePreference(RidePreference pref){
      _currentRidePreference = pref;
      notifyListeners();
  }

  // update all past pref
  Future<void> addPreference(RidePreference preference) async {
    await repository.addPreference(preference);
    _fetchPastRidePreferences(); 
    notifyListeners();
  }
}