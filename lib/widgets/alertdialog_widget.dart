import 'package:arcusrev/widgets/elevatedbutton_widget.dart';
import 'package:arcusrev/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';

class AlertDialogWidget{
  TextFormFieldWidget textFormFieldWidget = TextFormFieldWidget();
  ElevatedButtonWidget elevatedButtonWidget = ElevatedButtonWidget();
  String? valor;
  adwDespesas(BuildContext context,String title,List<String> list,
      {Widget? botao1,Widget? botao2,TextEditingController? tec1,String? labelText1,
        TextEditingController? tec2,String? labelText2,
        TextEditingController? tec3,String? labelText3,
        TextEditingController? tec4,String? labelText4,
        TextFormField? textFormField5,
        TextFormField? textFormField6,
      })
  {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
          title: Text("${title}"),
          content: StatefulBuilder(builder: (BuildContext context, StateSetter setState){
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right:8.0),
                          child: SizedBox(
                            width: 80,
                            child: textFormFieldWidget.criaTff(tec1!, labelText1!,ativo: false,numeric: true),
                          ),
                        ),
                        Expanded(
                          child: DropdownButton(
                            isExpanded: true,
                            hint: Text("Transporte"),
                            value: valor,
                            items: list.map((e) {
                              return DropdownMenuItem(
                                  value: e,
                                  child: Text('${e}'));
                            }).toList(),
                            onChanged: (value) {
                              valor = value.toString();
                              print(valor);
                              setState(() {});
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(child: textFormFieldWidget.criaTff(tec2!, labelText2!))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(child: textFormFieldWidget.criaTff(tec3!, labelText3!))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: textFormFieldWidget.criaTff(tec4!, labelText4!,numeric: true),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:8.0,right: 8),
                          child: SizedBox(
                            width: 120,
                            child: textFormField5,
                          ),
                        ),
                        SizedBox(
                          width: 120,
                          child: textFormField6,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        botao1 ?? Container() ,
                        botao2!
                      ],
                    ),
                  )
                ],
              ),
            );
          })
      );
    });
  }
}