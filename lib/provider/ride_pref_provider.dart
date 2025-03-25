import 'package:flutter/material.dart';
import '../repository/ride_preferences_repository.dart';
import '../model/ride/ride_pref.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentRidePreference;
  List<RidePreference> _pastRidePreferences = [];

  final RidePreferencesRepository repository;

  RidesPreferencesProvider({required this.repository}) {
    _fetchPastRidePreferences();
  }

  RidePreference? get currentRidePreference => _currentRidePreference;

  // fetch the past ride preferences from repo
  void _fetchPastRidePreferences() {
    try {
      _pastRidePreferences = repository.getPastPreferences();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void setCurrentRidePreference(RidePreference pref) {
    if (_currentRidePreference != pref) {
      _currentRidePreference = pref;
      _addPreference(pref);
      notifyListeners();
    }
  }

  // update all past pref
  void _addPreference(RidePreference preference) {
    if (!_pastRidePreferences.contains(preference)) {
      _pastRidePreferences.add(preference);
      repository.addPreference(preference);
    }
  }

  // past ride preferences returned in reverse order new to old
  List<RidePreference> get pastRidePreferences =>
      _pastRidePreferences.reversed.toList();
}