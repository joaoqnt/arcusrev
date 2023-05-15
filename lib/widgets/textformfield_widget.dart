import 'package:flutter/material.dart';

class TextFormFieldWidget{
  Widget criaTff(TextEditingController tec,String label, {bool? ativo}){
    return TextFormField(
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      controller: tec,
      enabled: ativo != null ? false : true,
    );
  }
}