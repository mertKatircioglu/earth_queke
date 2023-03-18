
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomLoadingDialog extends StatelessWidget {

  BuildContext? context;
  final String? message;
  CustomLoadingDialog({this.context,this.message});


  Widget _dialog(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              alignment: Alignment.center,
              padding:const EdgeInsets.only(top: 10),
              child:const CupertinoActivityIndicator()
          ),
          const SizedBox(height: 10,),
          Text(message!,textAlign: TextAlign.center, style: TextStyle(color: Colors.black54),)

        ],
      ),
    );
  }

  void _scaleDialog() {
    showGeneralDialog(
      context: context!,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: _dialog(ctx),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _dialog(context);
  }
}
