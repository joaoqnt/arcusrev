import 'package:flutter/material.dart';

class CircularProgressWidget{
  showCircularProgress(BuildContext context){
    showDialog (
        context: context,
        builder: (context) {
           return Center(child: CircularProgressIndicator());
        });
  }
  hideCircularProgress(BuildContext context){
    Navigator.of(context).pop();
  }
}