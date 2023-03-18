import 'package:earth_queke/global/globals.dart';
import 'package:earth_queke/model/panic_persons.dart';
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
  Future<PanicPersonModel> getPanicPersonSettings() async{
    sharedPreferences = await SharedPreferences.getInstance();
    final name1 = sharedPreferences!.getString('name1') ?? '';
    final name2 = sharedPreferences!.getString('name2') ?? '';
    final name3 = sharedPreferences!.getString('name3') ?? '';
    final tel1 = sharedPreferences!.getInt('tel1')?? 0;
    final tel2 = sharedPreferences!.getInt('tel1')?? 0;
    final tel3 = sharedPreferences!.getInt('tel1')?? 0;
    final isActive = sharedPreferences!.getBool('isActive') ?? false;
    return PanicPersonModel(name1: name1, name3: name3, name2: name2, tel1: tel1,tel2: tel2,tel3: tel3,isActive: isActive);
  }


  Future savePanicPerson(PanicPersonModel model) async{
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString('name1', model.name1);
    await sharedPreferences!.setString('name2', model.name2);
    await sharedPreferences!.setString('name3', model.name3);
    await sharedPreferences!.setInt('tel1', model.tel1);
    await sharedPreferences!.setInt('tel2', model.tel2);
    await sharedPreferences!.setInt('tel3', model.tel3);
    await sharedPreferences!.setBool('isActive', model.isActive);
    print("Ayarlar Kaydedildi");
  }

}