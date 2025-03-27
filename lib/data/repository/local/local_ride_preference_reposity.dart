import 'dart:convert';

import 'package:W7/data/repository/ride_preferences_repository.dart';
import 'package:W7/model/ride/ride_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../dto/ride_preference_dto.dart';

class LocalRidePreferenceRepository extends RidePreferencesRepository{

  static const String _preferencesKey = "ride_preferences";

  @override
  Future<List<RidePreference>> getPastPreferences() async{
    // Get SharedPreferences instance 
    final prefs = await SharedPreferences.getInstance(); 
    // Get the string list form the key 
    final prefsList = prefs.getStringList(_preferencesKey) ?? []; 
    // Convert the string list to a list of RidePreferences – Using map() 
    return prefsList.map((json) => RidePreferenceDto.fromJson(jsonDecode(json))).toList(); 
  }
  
  @override
  Future<void> addPreference(RidePreference preference) async {
    final prefs = await SharedPreferences.getInstance();
    final preferences = await getPastPreferences();
    if (!preferences.contains(preference)) {
      preferences.add(preference);
      await prefs.setStringList(
        _preferencesKey,
        preferences.map((pref) => jsonEncode(RidePreferenceDto.toJson(pref))).toList(),
      );
    }
  }
  


  
  
}