import 'package:autocomplete_textfield/autocomplete_textfield.dart';
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

  // Widget autocompleteTFF(dynamic key, dynamic sugestoes){
  //   return AutoCompleteTextField<String>(
  //     key: key,
  //     suggestions: sugestoes,
  //     clearOnSubmit: false,
  //     textInputAction: TextInputAction.next,
  //     itemFilter: (item, query) {
  //       return item.toLowerCase().startsWith(query.toLowerCase());
  //     },
  //     itemSorter: (a, b) {
  //       return a.compareTo(b);
  //     },
  //     itemSubmitted: (item) {
  //       setState(() {
  //         valorSelecionado = item;
  //       });
  //     },
  //     itemBuilder: (context, item) {
  //       return ListTile(
  //         title: Text(item),
  //       );
  //     },
  //     decoration: InputDecoration(
  //       labelText: 'Digite um valor',
  //     ),
  //     controller: TextEditingController(text: valorSelecionado),
  //   ),
  // }
}