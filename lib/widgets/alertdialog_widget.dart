import 'package:arcusrev/widgets/elevatedbutton_widget.dart';
import 'package:arcusrev/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';

class AlertDialogWidget{
  TextFormFieldWidget textFormFieldWidget = TextFormFieldWidget();
  ElevatedButtonWidget elevatedButtonWidget = ElevatedButtonWidget();

  adwCadastro(BuildContext context,String title,List list,Object? selected,
      {Widget? botao1,Widget? botao2,TextEditingController? tec1,String? labelText1,
        TextEditingController? tec2,String? labelText2,
        TextEditingController? tec3,String? labelText3,
        TextEditingController? tec4,String? labelText4,
        TextEditingController? tec5,String? labelText5,
      }){
    showDialog(context: context, builder: (context) {
      return AlertDialog(
          title: Text("${title}"),
          content: StatefulBuilder(builder: (BuildContext context, StateSetter setState){
            return SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                      children: [
                        Expanded(
                          child: DropdownButton(
                            isExpanded:true,
                            hint: Text("Transporte"),
                            value: selected,
                            items: list.map((e) {
                              return DropdownMenuItem(
                                  value: e,
                                  child: Text('${e.nome}'));
                            }).toList(),
                            onChanged: (value) {
                              selected = value;
                              setState(() {

                              });
                            },
                          ),
                        ),
                      ]
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: textFormFieldWidget.criaTff(tec1!, labelText1!),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: textFormFieldWidget.criaTff(tec2!, labelText2!),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: textFormFieldWidget.criaTff(tec3!, labelText3!),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: textFormFieldWidget.criaTff(tec4!, labelText4!),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      botao1!,
                      botao2!
                    ],
                  )
                  // DateTime
                ],
              ),
            );
          })
      );
    },
    );
  }
}