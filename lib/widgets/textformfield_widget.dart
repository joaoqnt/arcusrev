import 'package:flutter/material.dart';

class TextFormFieldWidget{
  Widget criaTff(TextEditingController tec,String label, {bool? ativo, bool? date,Future? funcao}){
    return TextFormField(
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      controller: tec,
      enabled: ativo != null ? false : true,
      keyboardType: date == true ? TextInputType.datetime : null,
      onTap: () async{
        await funcao;
      },
    );
  }
}