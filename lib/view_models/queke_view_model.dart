import 'dart:async';

import 'package:earth_queke/data/queke_repository.dart';
import 'package:flutter/material.dart';

import '../locator.dart';

enum CustomUserState{
  initialEartherState,
  weatherLoadingState,
  weatherLoadedState,
  weatherErrorState
}

class EarthQuakeViewModel with ChangeNotifier{
CustomUserState? _customUserState;
  QuekeRepository _repository= locator<QuekeRepository>();
  List? _getirilenDataModel;
  List? _getirilenDataModel2;
  List? _annualDatas;

  EarthQuakeViewModel(){
    _getirilenDataModel = [];
    _getirilenDataModel2 = [];
    _annualDatas = [];
    _customUserState = CustomUserState.initialEartherState;
  }


  List get getirilenDataModel => _getirilenDataModel!;
  List get getirilenDataModel2 => _getirilenDataModel2!;
  List get annualDatas => _annualDatas!;

CustomUserState get customUserState => _customUserState!;


set customUserState(CustomUserState value) {
    _customUserState = value;
    notifyListeners();
  }

  Future<List> getQuekeFromUi() async {
    try{
      _customUserState = CustomUserState.weatherLoadingState;
      _getirilenDataModel = await _repository.getQueksRepository();
      _customUserState = CustomUserState.weatherLoadedState;
    }catch (e){
      _customUserState = CustomUserState.weatherErrorState;
    }
    return _getirilenDataModel!;
  }

  Future<List> getQuekesFilteredFromUi(String selectedCity, double mag) async {
    try{
      _customUserState = CustomUserState.weatherLoadingState;
      _getirilenDataModel2 = await _repository.getQueksRepositoryFiltered(selectedCity, mag);
      _customUserState = CustomUserState.weatherLoadedState;
    }catch (e){
      _customUserState = CustomUserState.weatherErrorState;
    }
    return _getirilenDataModel2!;
  }

Future<List> getAnnualDataFromUi(String selectedCity) async {
  try{
    _customUserState = CustomUserState.weatherLoadingState;
    _annualDatas = await _repository.getAnnualDatas(selectedCity);
    _customUserState = CustomUserState.weatherLoadedState;
  }catch (e){
    _customUserState = CustomUserState.weatherErrorState;
  }
  return _annualDatas!;
}


  Future<void> refresh()async {
    getQuekeFromUi();
    return Future.delayed(const Duration(seconds: 1),(){
    });
  }




  // String havaDurumuStatuGetirme(){
  //   return _getirilenDataModel!.status.toString();
  // }
}