import 'package:flutter/material.dart';

class ElevatedButtonWidget{
  Widget botaoSalvar({Future? function}) {
    ElevatedButton buttonSave = ElevatedButton.icon(
        onPressed : () async {
          await function;
        },
        label: Text('Salvar'),
        icon: Icon(Icons.save_outlined),
        style: ElevatedButton.styleFrom(
            primary: Colors.lightGreen,
        )
    );
    return buttonSave;
  }

  Widget botaoExcluir({Future<dynamic>? function}) {
    ElevatedButton buttonDelete = ElevatedButton.icon(
        onPressed : (){
          function;
        },
        label: Text('Excluir'),
        icon: Icon(Icons.delete_outline),
        style: ElevatedButton.styleFrom(
          primary: Colors.redAccent,
        )
    );
    return buttonDelete;
  }
}