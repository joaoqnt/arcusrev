import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldWidget{
  Widget criaTff(
      TextEditingController tec,String label,
      {bool? ativo, bool? numeric,bool? price,
        Future? funcao, int? tamanho, bool? password,
        IconButton? icone, bool? visible, bool? isNeeded}){
    return TextFormField(
      decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          suffixIcon: icone,
      ),
      validator: (value) {
        if(isNeeded == true || isNeeded == null){
          if (value == null || value.isEmpty || value.length > tamanho!) {
            if(value == null || value.isEmpty ){
              return 'O campo não pode ser vazio';
            }else{
              return 'O tamanho máximo para esse campo é de $tamanho caracter(es)';
            }
          }
          return null;
        }
      },
      controller: tec,
      enabled: ativo != null ? false : true,
      keyboardType: numeric == true ? TextInputType.datetime : null,
      inputFormatters: numeric == true ?[FilteringTextInputFormatter.digitsOnly]: null,
      obscureText: visible ?? false,
      onTap: () async{
        await funcao;
      },
    );
  }

  Widget tffBusca(TextEditingController tec,String label){
    return TextFormField(
      controller: tec,
      decoration: InputDecoration(
          labelText: label,
          icon: Icon(Icons.search),
          fillColor: Colors.grey,
      ),
    );
  }

}