import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../global/globals.dart';
import '../view_models/queke_view_model.dart';

class HomePageTopBar extends StatelessWidget {
  String? city;
  double? mag;
   HomePageTopBar({Key? key, this.city, this.mag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              child:const Center(
                child: Text("Seçilen Filtre:  ",
                  style: TextStyle(fontSize: 14,
                      color: kPrymaryColor
                  ),),
              ),
            ),
            Row(
              children: <Widget>[
                Text(
                  city ?? "",
                  style: const TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                const SizedBox(width: 8,),
                const Text(
                  "Şiddeti: ",
                  style: TextStyle(
                      fontSize: 14.0,
                      color: kPrymaryColor
                  ),
                ),
                Text(
                  "$mag mag",
                  style: const TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                const SizedBox(width: 8,),
                const Text("D. Sayısı: ", style:TextStyle(
                    fontSize: 14.0,
                    color: kPrymaryColor
                ),),

           /*     Consumer(builder: (context, EarthQuakeViewModel viewModel, widget){
                  return Text(viewModel.getDataCount().toString());
                })*/

              ],
            ),
          ],
        ),
      ),
    );
  }
}
