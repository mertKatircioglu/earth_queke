import 'package:earth_queke/global/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/settings_model.dart';

class PreferencesService{
  Future saveSettings(Settings settings) async{
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString('city', settings.city);
    await sharedPreferences!.setDouble('mag', settings.mag);
    await sharedPreferences!.setBool('swich', settings.swich);
    await sharedPreferences!.setBool('viewFilter', settings.viewFilter);
    print("Ayarlar Kaydedildi");
  }

  Future<Settings> getSettings() async{
    sharedPreferences = await SharedPreferences.getInstance();
    final city = sharedPreferences!.getString('city') ?? '';
    final currentCity = sharedPreferences!.getString('currentCity') ?? '';
    final mag = sharedPreferences!.getDouble('mag')?? 0.0;
    final swich = sharedPreferences!.getBool('swich') ?? false;
    final viewFilter = sharedPreferences!.getBool('viewFilter')?? false;
    return Settings(city: city,mag: mag,swich: swich,viewFilter: viewFilter,currentCity: currentCity);
  }
}