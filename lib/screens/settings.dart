import 'package:earth_queke/global/globals.dart';
import 'package:earth_queke/model/panic_persons.dart';
import 'package:earth_queke/model/settings_model.dart';
import 'package:earth_queke/view_models/queke_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkish/turkish.dart';
import '../services/preferences_service.dart';
import '../widgets/custom_error_dialog.dart';


class SettingsWidget extends StatefulWidget {

 const SettingsWidget({Key? key}) : super(key: key);

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}
const double _kItemExtent = 32.0;

class _SettingsWidgetState extends State<SettingsWidget> {
  EarthQuakeViewModel earthQuakeViewModel = EarthQuakeViewModel();
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
  bool _filterSwitch = false;
  bool _panicButtonSwitch = false;
  bool _viewFiltered= false;
  String? currentCity ='';
  String? name1 ='';
  String? name2 ='';
  String? name3 ='';
  double searchFieldSize = 100;
  TextEditingController _name1Controller = TextEditingController();
  TextEditingController _name2Controller = TextEditingController();
  TextEditingController _name3Controller = TextEditingController();
  TextEditingController _phone1Controller = TextEditingController();
  TextEditingController _phone2Controller = TextEditingController();
  TextEditingController _phone3Controller = TextEditingController();
  var getSharedCity;
  var getSharedMag;
  bool getSharedSwich = false;
  bool getSharedSwichPanic = false;

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
    final panic = await _preferencesService.getPanicPersonSettings();
    setState(() {
      getSharedCity = settings.city;
      getSharedSwich = settings.swich;
      _viewFiltered = settings.viewFilter;
      getSharedMag = settings.mag;
      currentCity = settings.currentCity!.toTitleCaseTr();
      getSharedSwichPanic = panic.isActive;
      name1 = panic.name1;
      name2 = panic.name2;
      name3 = panic.name3;
    });
  }

  Future _saveSettings(String city, double mag, bool swich, bool viewFilter) async{
  final newSettings = Settings(city:city,mag: mag,swich: swich,viewFilter: viewFilter);
 await _preferencesService.saveSettings(newSettings);
  }

  Future _savePanicPersons(String name1, String name2, String name3, int tel1, int tel2, int tel3) async{
    final newSettings = PanicPersonModel(name1: name1,name2: name2,
      name3: name3,tel1: tel1,tel2: tel2,tel3:tel3, isActive: true);
    await _preferencesService.savePanicPerson(newSettings);
  }


  @override
  void initState() {
    super.initState();
    getSharedPrefs();

  }

  Future<void> formValidation() async{
      if (_phone1Controller.text.length < 10 &&
          _phone2Controller.text.length < 10 &&
          _phone3Controller.text.length < 10) {
        showDialog(context: context,
            builder: (c) {
              return CustomErrorDialog(
                message: "Telefon numarası 10 karakterden kısa olamaz.",);
            });
      } else {
        if (_name1Controller.text.isNotEmpty &&
            _name2Controller.text.isNotEmpty &&
            _name3Controller.text.isNotEmpty) {

          _savePanicPersons(_name1Controller.text.trim(), _name2Controller.text.trim(), _name3Controller.text.trim(),
          int.parse(_phone1Controller.text), int.parse(_phone2Controller.text), int.parse(_phone3Controller.text)
          ).whenComplete(() {
            getSharedPrefs();
            MotionToast.success(
              title:  const Text("Tebrikler!"),
              description:  const Text("Kaydınız başarıyla yapılmıştır."),
            ).show(context);
          });
          setState(() {
            getSharedSwichPanic = true;
            _panicButtonSwitch = false;
          });
          //authSellerAndSignUp();
        } else {
          showDialog(context: context,
              builder: (c) {
                return CustomErrorDialog(
                  message: "İsim alanı boş bırakılamaz.",);
              });
        }
      }


  }


  @override
  Widget build(BuildContext context) {
    earthQuakeViewModel = Provider.of<EarthQuakeViewModel>(context);

    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Scaffold(
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          child:const Center(
                            child: Text("Profil Bilgileri", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
                          ),
                        ),
                        authUser.currentUser!.photoURL.toString() !=null?
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Image.network(authUser.currentUser!.photoURL.toString(), width: 80, height: 80,),
                        ):Container(),
                        Text('Merhaba\n${authUser.currentUser!.displayName}', textAlign: TextAlign.center,),
                        const SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.email_outlined, size: 12,),
                            const SizedBox(width: 2,),
                            Text('${authUser.currentUser!.email}', style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12),),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(thickness: 0.5, color: Colors.amber,),
                Visibility(
                  visible: !getSharedSwichPanic,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 50,
                                child: const Center(
                                  child: Text("Panik Butonu Aktif Et",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
                                ),
                              ),
                              Switch.adaptive(
                                  value:  _panicButtonSwitch,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _panicButtonSwitch = newValue;
                                    });
                                  })
                            ],
                          ),
                          const Text("Bu özellik, belirleyeceğiniz 3 kişiye ve kolluk kuvvetlerine konum bilgilerinizi ve durumunuzu sms olarak gönderir.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 10),
                          ),
                          Visibility(
                            visible: _panicButtonSwitch,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  Flexible(
                                    flex:2,
                                    child: TextFormField(
                                      controller: _name1Controller,
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        focusColor: Colors.white,
                                        //add prefix icon
                                        prefixIcon: const Icon(
                                          Icons.person,
                                          color: Colors.grey,
                                        ),

                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),

                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                          const BorderSide(color: Colors.amber, width: 1.0),
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        fillColor: Colors.grey,

                                        hintText: "Örn:Annem",
                                        hintStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                          fontStyle: FontStyle.italic,
                                          fontFamily: "verdana_regular",
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      onChanged: (value) {

                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 5,),
                                  Flexible(
                                    flex: 3,
                                    child: TextFormField(
                                      controller: _phone1Controller,
                                      autofocus: false,
                                      maxLength: 10,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        focusColor: Colors.white,
                                        //add prefix icon
                                        prefixIcon: const Icon(
                                          Icons.call,
                                          color: Colors.grey,
                                        ),

                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),

                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                          const BorderSide(color: Colors.amber, width: 1.0),
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        fillColor: Colors.grey,

                                        hintText: "5xxxxxxxxx",
                                        hintStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                          fontStyle: FontStyle.italic,
                                          fontFamily: "verdana_regular",
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),

                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: _panicButtonSwitch,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  Flexible(
                                    flex:2,
                                    child: TextFormField(
                                      controller: _name2Controller,
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        focusColor: Colors.white,
                                        //add prefix icon
                                        prefixIcon: const Icon(
                                          Icons.person,
                                          color: Colors.grey,
                                        ),

                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),

                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                          const BorderSide(color: Colors.amber, width: 1.0),
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        fillColor: Colors.grey,

                                        hintText: "Örn:Babam",
                                        hintStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                          fontStyle: FontStyle.italic,
                                          fontFamily: "verdana_regular",
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),

                                    ),
                                  ),
                                  const SizedBox(width: 5,),
                                  Flexible(
                                    flex: 3,
                                    child: TextFormField(
                                      maxLength: 10,
                                      controller: _phone2Controller,
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        focusColor: Colors.white,
                                        //add prefix icon
                                        prefixIcon: const Icon(
                                          Icons.call,
                                          color: Colors.grey,
                                        ),

                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),

                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                          const BorderSide(color: Colors.amber, width: 1.0),
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        fillColor: Colors.grey,

                                        hintText: "5xxxxxxxxx",
                                        hintStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                          fontStyle: FontStyle.italic,
                                          fontFamily: "verdana_regular",
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),

                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: _panicButtonSwitch,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  Flexible(
                                    flex:2,
                                    child: TextFormField(
                                      controller: _name3Controller,
                                      autofocus: false,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        focusColor: Colors.white,
                                        //add prefix icon
                                        prefixIcon: const Icon(
                                          Icons.person,
                                          color: Colors.grey,
                                        ),

                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),

                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                          const BorderSide(color: Colors.amber, width: 1.0),
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        fillColor: Colors.grey,

                                        hintText: "Örn:Eşim",
                                        hintStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                          fontStyle: FontStyle.italic,
                                          fontFamily: "verdana_regular",
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      onChanged: (value) {

                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 5,),
                                  Flexible(
                                    flex: 3,
                                    child: TextFormField(
                                      maxLength: 10,
                                      controller: _phone3Controller,
                                      keyboardType: TextInputType.phone,
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        focusColor: Colors.white,
                                        //add prefix icon
                                        prefixIcon: const Icon(
                                          Icons.call,
                                          color: Colors.grey,
                                        ),

                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),

                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                          const BorderSide(color: Colors.amber, width: 1.0),
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        fillColor: Colors.grey,

                                        hintText: "5xxxxxxxxx",
                                        hintStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                          fontStyle: FontStyle.italic,
                                          fontFamily: "verdana_regular",
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      onChanged: (value) {

                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Visibility(
                            visible: _panicButtonSwitch,
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
                                  formValidation();

                                },
                                child:const Text( "Kaydet",
                                  style: TextStyle(color: Colors.white),),
                              ),
                            ),
                          ),
                         // LineChartSample5(dataModel: earthQuakeViewModel)
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: getSharedSwichPanic,
                  child:Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    elevation: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          child:const Center(
                            child: Text("Panik Özelliği Aktif", style: TextStyle(fontSize: 14),),
                          ),
                        ),
                        const SizedBox(height: 5,),
                        const Text("Sms atılacak Kişiler", style: TextStyle(fontSize: 12),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '${name1!.toTitleCaseTr()}, ',
                              style: const TextStyle(
                                fontSize: 14.0,
                                color:  Colors.blue,
                              ),
                            ),
                            Text(
                              '${name2!.toTitleCaseTr()}, ',
                              style: const TextStyle(
                                fontSize: 14.0,
                                color:  Colors.blue,
                              ),
                            ),
                            Text(
                              name3!.toTitleCaseTr(),
                              style: const TextStyle(
                                fontSize: 14.0,
                                color:  Colors.blue,
                              ),
                            ),

                          ],
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
                              sharedPreferences!.remove('name1');
                              sharedPreferences!.remove('name2');
                              sharedPreferences!.remove('name3');
                              sharedPreferences!.remove('tel1');
                              sharedPreferences!.remove('tel2');
                              sharedPreferences!.remove('tel3');
                              sharedPreferences!.remove('isActive');
                              setState(() {
                                getSharedSwichPanic = false;
                                _panicButtonSwitch = false;
                              });
                              MotionToast.delete(
                                title:  const Text("Bilgi"),
                                description:  const Text("Panik özelliği iptal edildi."),
                              ).show(context);

                            },
                            child:const Text( "İptal Et",
                              style: TextStyle(color: Colors.white),),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                const Divider(thickness: 0.5, color: Colors.amber,),
                Visibility(
                  visible: !_viewFiltered,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    elevation: 0,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 1),
                            Container(
                              height: 50,
                              child:const Center(
                                child: Text("Dinlemeyi Aktif Et", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
                              ),
                            ),
                            Switch.adaptive(
                                value:  _filterSwitch,
                                onChanged: (newValue) {
                                  setState(() {
                                    _filterSwitch = newValue;
                                  });
                                })
                          ],
                        ),
                        const Text("Bu özellik, seçeceğiniz şehirde yaşanan deprem olaylarını listeler ve bildirimlerini anlık olarak gönderir.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 10),
                        ),
                        const SizedBox(height: 10,),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: _filterSwitch,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    elevation: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 5),
                        Container(
                          height: 50,
                          child:const Center(
                            child: Text("Şehir: ", style: TextStyle(fontSize: 14),),
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
                Visibility(
                  visible: _filterSwitch,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    elevation: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 5),
                        Container(
                          height: 50,
                          child:const Center(
                            child: Text("Şiddet: ", style: TextStyle(fontSize: 14),),
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
                Visibility(
                  visible: _viewFiltered,
                  child:Card(
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
                                  sharedPreferences!.remove('city');
                                  sharedPreferences!.remove('swich');
                                  sharedPreferences!.remove('viewFilter');
                                  sharedPreferences!.remove('mag');
                                  setState(() {
                                    _viewFiltered = false;
                                    _filterSwitch = false;
                                  });
                                  MotionToast.info(
                                    title:  const Text("Bilgi"),
                                    description:  const Text("Filtre kaldırıldı."),
                                  ).show(context);

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
                /*  Visibility(
                  visible: !_viewFiltered,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Bildirim Gönder: "),
                      Switch(value: _enabled, onChanged: _onClickEnable),
                    ],
                  ),
                ),*/

                Visibility(
                  visible: _filterSwitch,
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
                        //Workmanager().cancelAll();
                        if(_filterSwitch == true){
                          _saveSettings(city[_selectedCity].toString(),mag[_selectedMag],true, true).whenComplete(() {
                            MotionToast.success(
                              onClose: (){
                                Navigator.pop(context, true);
                              },
                              dismissable: false,
                              animationDuration: const Duration(milliseconds: 900),
                              title:  const Text("Başarılı!"),
                              description:  const Text("Ayarınız başarılya kaydedildi."),
                            ).show(context);
                          });

                        }else{
                          MotionToast.warning(
                            title:  const Text("Dikkat!"),
                            description:  const Text("Lütfen filtrelemeyi etkinleştirin."),
                          ).show(context);
                        }
                      },
                      child:const Text( "Kaydet",
                        style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ),

                const SizedBox(height: 50,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
