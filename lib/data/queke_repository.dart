
import '../locator.dart';
import 'earth_queke_api_client.dart';

class QuekeRepository{

  EartQukeApiClient erattQuekeApiClient = locator<EartQukeApiClient>();

  Future<List> getQueksRepository() async{
    return await erattQuekeApiClient.getQueke();
  }

  Future<List> getQueksRepositoryFiltered(String selectedCity, double mag) async{
    return await erattQuekeApiClient.getQuekeFiltered(selectedCity, mag);
  }


}