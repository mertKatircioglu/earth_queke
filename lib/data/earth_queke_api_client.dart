import 'dart:convert';
import 'package:http/http.dart' as http;


class EartQukeApiClient{

final http.Client httpClient = http.Client();

  Future getQueke() async {
    var url = Uri.parse("https://api.orhanaydogdu.com.tr/deprem/live.php?limit=200");
    final gelenCevap = await httpClient.get(url).catchError((onError){
      print(onError.toString());
    });
    final gelenCevapJson = (jsonDecode(gelenCevap.body));
    if(gelenCevap.statusCode == 200){
      List son = (gelenCevapJson["result"]) as List;
      return son;
    }else{
      throw Exception("Veri getirelemedi");
    }
  }

Future getQuekeFiltered(String sehir, double mag) async {
  var url = Uri.parse("https://api.orhanaydogdu.com.tr/deprem/live.php?limit=900");
  final gelenCevap = await httpClient.get(url).catchError((onError){
    print(onError.toString());
  });
  final gelenCevapJson = (jsonDecode(gelenCevap.body));
  if(gelenCevap.statusCode == 200){
    List son = ((gelenCevapJson["result"]) as List);

    List selectedCity =  son.where((i) => (i['title'] !=null ? i['title'].contains(sehir.toUpperCase()): false)).toList();
    List lastFiltered = selectedCity.where((element) => element['mag'] >= mag ?? 1.0).toList();
    return lastFiltered;
  }else{
    throw Exception("Veri getirelemedi");
  }
}


}