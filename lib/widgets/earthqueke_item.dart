import 'package:earth_queke/model/data_model.dart';
import 'package:earth_queke/widgets/item_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../global/globals.dart';

class EarthQuekeItem extends StatelessWidget {
  DataModel? earthQuakeViewModel;
  String? city;
   EarthQuekeItem({Key? key,required this.earthQuakeViewModel, this.city}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ItemDetailWidget(earthQuakeViewModel: earthQuakeViewModel,)));
        },
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Merkes Üssü: ",
                      style: TextStyle(
                        fontSize: 12,
                        color: kPrymaryColor,
                      ),
                    ),
                    Expanded(
                      child: Text(earthQuakeViewModel!.title.toString(),
                        style:const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: kPrymaryColor, size: 20,)
                  ],
                ),
                const SizedBox(height: 5,),
                Row(
                  children: [
                    const Text("Tarih-Saat: ",
                      style: TextStyle(
                        fontSize: 12,
                        color: kPrymaryColor,
                      ),
                    ),
                    const SizedBox(width: 2,),
                    Text(DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.parse(earthQuakeViewModel!.date!.replaceAll(".", "-"))),
                      style:const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5,),
                Row(
                  children: [
                    const Text("Şiddeti: ",
                      style: TextStyle(
                        fontSize: 14,
                        color: kPrymaryColor,
                      ),
                    ),
                    const SizedBox(width: 2,),
                    Text(earthQuakeViewModel!.mag.toString(),
                      style:const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
