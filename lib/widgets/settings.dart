import 'package:earth_queke/global/globals.dart';
import 'package:earth_queke/model/settings_model.dart';
import 'package:earth_queke/view_models/queke_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/preferences_service.dart';

class SettingsWidget extends StatefulWidget {

 const SettingsWidget({Key? key}) : super(key: key);

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}
const double _kItemExtent = 32.0;

class _SettingsWidgetState extends State<SettingsWidget> {

  EarthQuakeViewModel? earthQuakeViewModel;
  final _preferencesService = PreferencesService();

  List city =[
    "Adana","Adıyaman", "Afyon", "Agrı", "Amasya", "Ankara", "Antalya", "Artvın",
    "Aydın", "Balıkesır","Bılecık", "Bıngöl", "Bıtlıs", "Bolu", "Burdur", "Bursa", "Canakkale",
    "Cankırı", "Corum","Denızlı","Dıyarbakır", "Edırne", "Elazıg", "Erzıncan", "Erzurum ", "Eskısehır",
    "Gazıantep", "Gıresun","Gumushane", "Hakkarı", "Hatay", "Isparta", "Mersın", "Istanbul", "Izmır",
    "Kars", "Kastamonu", "Kayserı","Kırklarelı", "Kırsehır", "Kocaelı", "Konya", "Kütahya ", "Malatya",
    "Manısa", "Kahramanmaras", "Mardın", "Mugla", "Mus", "Nevsehır", "Nıgde", "Ordu", "Rıze", "Sakarya",
    "Samsun", "Sıırt", "Sınop", "Sıvas", "Tekırdag", "Tokat", "Trabzon  ", "Tuncelı", "Sanlıurfa", "Usak",
    "Van", "Yozgat", "Zonguldak", "Aksaray", "Bayburt ", "Karaman", "Kırıkkale", "Batman", "Sırnak",
    "Bartın", "Ardahan", "Igdır", "Yalova", "Karabuk ", "Kılıs", "Osmanıye ", "Duzce"
  ];

  List mag =[1.0,1.2,1.3,1.4,1.5,1.6,1.7,1.8,1.9,2.0,2.1,2.2,2.3,2.4,
    2.5,2.6,2.7,2.8,2.9,3.0,3.1,3.2,3.3,3.4,3.5,3.6,3.7,3.8,3.9,4.0,4.1,4.2,4.3,4.4,4.5,4.6,4.7,4.8,4.9,5.0,5.1,5.2,
    5.3,5.4,5.5,5.6,5.7,5.8,5.9,6.0,6.1,6.2,6.3,6.4,6.5,6.6,6.7,6.8,6.9,7.0,7.1,7.2,7.3,7.4,7.5];

  int _selectedCity = 0;
  int _selectedMag = 0;
  bool _swihFilter = false;
  bool _viewFiltered= false;

  var getSharedCity;
  var getSharedMag;
  bool getSharedSwich = false;

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          // The Bottom margin is provided to align the popup above the system navigation bar.
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          // Provide a background color for the popup.
          color: CupertinoColors.systemBackground.resolveFrom(context),
          // Use a SafeArea widget to avoid system overlaps.
          child: SafeArea(
            top: false,
            child: child,
          ),
        ));
  }


  void getSharedPrefs() async{
    final settings = await _preferencesService.getSettings();
    setState(() {
      getSharedCity = settings.city;
      getSharedSwich = settings.swich;
      _viewFiltered = settings.viewFilter;
      getSharedMag = settings.mag;
    });
  }

  void _saveSettings(String city, double mag, bool swich, bool viewFilter){
  final newSettings = Settings(city, mag, swich, viewFilter);
  _preferencesService.saveSettings(newSettings);
  }


  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon:const Icon(Icons.arrow_back, color: kPrymaryColor),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        backgroundColor: kBackGroundColor,
        elevation: 0,
        centerTitle: true,
        title:const Text(
          "Ayarlar",
           style: TextStyle(
             color: kPrymaryColor,
             fontSize: 18
           ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20,),
          Visibility(
            visible: !_viewFiltered,
            child: Padding(
              padding:const EdgeInsets.symmetric(horizontal: 18),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                elevation: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 1),
                    Container(
                      height: 50,
                      child:const Center(
                        child: Text("Filtrelemeyi Aktif Et", style: TextStyle(fontSize: 14),),
                      ),
                    ),
                    Switch.adaptive(
                        value:  _swihFilter,
                        onChanged: (newValue) {
                      setState(() {
                        _swihFilter = newValue;
                      });
                        })

                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 100,),
           Visibility(
             visible: !_viewFiltered,
             child: Padding(
                padding:const EdgeInsets.symmetric(horizontal: 18),
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              elevation: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 1),
                  Container(
                    height: 50,
                    child:const Center(
                      child: Text("Takip etmek istediğiniz şehri seçiniz", style: TextStyle(fontSize: 14),),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => _showDialog(
                          CupertinoPicker(
                            magnification: 1.22,
                            squeeze: 1.2,
                            useMagnifier: true,
                            itemExtent: _kItemExtent,
                            onSelectedItemChanged: (int selectedItem) {
                              setState(() {
                                _selectedCity = selectedItem;
                              });
                            },
                            children:
                            List<Widget>.generate(city.length, (int index) {
                              return Center(
                                child: Text(
                                  city[index],
                                ),
                              );
                            }),
                          ),
                        ),
                        // This displays the selected fruit name.
                        child: Row(
                          children: [
                            Text(
                              city[_selectedCity],
                              style: const TextStyle(
                                fontSize: 14.0,
                                color:  Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 10,),
                             const Icon(Icons.arrow_drop_down, color: Colors.blue,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ),
          ),
           ),
          const SizedBox(height: 20,),
          Visibility(
            visible: !_viewFiltered,
            child: Padding(
              padding:const EdgeInsets.symmetric(horizontal: 18),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                elevation: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 1),
                    Container(
                      height: 50,
                      child:const Center(
                        child: Text("Kaç şiddeti ve üstü depremler getirilsin?", style: TextStyle(fontSize: 14),),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => _showDialog(
                            CupertinoPicker(
                              magnification: 1.22,
                              squeeze: 1.2,
                              useMagnifier: true,
                              itemExtent: _kItemExtent,
                              onSelectedItemChanged: (int selectedItem) {
                                setState(() {
                                  _selectedMag = selectedItem;
                                });
                              },
                              children:
                              List<Widget>.generate(mag.length, (int index) {
                                return Center(
                                  child: Text(
                                    mag[index].toString(),

                                  ),
                                );
                              }),
                            ),
                          ),
                          // This displays the selected fruit name.
                          child: Row(
                            children: [
                              Text(
                               mag[_selectedMag].toString(),
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color:Colors.blue
                                ),
                              ),
                              const SizedBox(width: 10,),
                               const Icon(Icons.arrow_drop_down, color: Colors.blue,),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20,),
          Visibility(
            visible: _viewFiltered,
            child: Padding(
              padding:const EdgeInsets.symmetric(horizontal: 18),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                elevation: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 5),
                    Expanded(
                      child: Container(
                        height: 50,
                        child:const Center(
                          child: Text("Seçilen Filtre: ", style: TextStyle(fontSize: 14),),
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          getSharedCity ?? "",
                          style: const TextStyle(
                            fontSize: 14.0,
                            color:  Colors.blue,
                          ),
                        ),
                        Text(
                          getSharedMag.toString(),
                          style: const TextStyle(
                            fontSize: 14.0,
                            color:  Colors.blue,
                          ),
                        ),
                        Padding(padding:const EdgeInsets.symmetric(horizontal: 18),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                            onPressed: () async{
                                sharedPreferences = await SharedPreferences.getInstance();
                                sharedPreferences!.clear();
                                setState(() {
                                  _viewFiltered = false;
                                  _swihFilter = false;
                                });
                                Fluttertoast.showToast(msg: "Filtre Kaldırıldı", toastLength: Toast.LENGTH_LONG);

                            },
                            child:const Text( "Filtreyi Kaldır",
                              style: TextStyle(color: Colors.white),),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20,),
          Visibility(
            visible: !_viewFiltered,
            child: Padding(padding:const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  backgroundColor: kPrymaryColor,
                ),
                onPressed: () async{
                    if(_swihFilter == true){
                      _saveSettings(city[_selectedCity].toString(),mag[_selectedMag],true, true);
                      Fluttertoast.showToast(msg: "Ayarlar Kaydedildi", toastLength: Toast.LENGTH_LONG).whenComplete(() {
                        Navigator.pop(context, true);
                      });
                    }else{
                      Fluttertoast.showToast(msg: "Lütfen filtrelemeyi etkinleştirin.", toastLength: Toast.LENGTH_LONG);

                    }
                },
                child:const Text( "Kaydet",
                  style: TextStyle(color: Colors.white),),
              ),
            ),
            ),
          )

        ],
      ),
      bottomNavigationBar:Container(
        height: 100,
        child: const Center(
          child: Text("Tek sevdiğim İlayda için", style: TextStyle(fontSize: 10,fontWeight: FontWeight.w300, color: Colors.blueAccent),),
        ),
      ),
    );
  }
}
