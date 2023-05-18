import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldWidget{
  Widget criaTff(TextEditingController tec,String label, {bool? ativo, bool? numeric,bool? price,Future? funcao}){
    return TextFormField(
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      controller: tec,
      enabled: ativo != null ? false : true,
      keyboardType: numeric == true ? TextInputType.datetime : null,
      inputFormatters: numeric == true ?[FilteringTextInputFormatter.digitsOnly]: null,
      onTap: () async{
        await funcao;
      },
    );
  }
}