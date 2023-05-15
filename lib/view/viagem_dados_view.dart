import 'package:arcusrev/controller/viagem_dados_controller.dart';
import 'package:arcusrev/model/usuario.dart';
import 'package:arcusrev/model/viagem.dart';
import 'package:arcusrev/widgets/elevatedbutton_widget.dart';
import 'package:arcusrev/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';

import '../model/transporte.dart';

class ViagemDadosView extends StatefulWidget {
  Usuario? usuarioLogado;
  Viagem? viagemSelected;
  List<Transporte>? transportes;
  String? tipo;

  ViagemDadosView({Key? key,this.usuarioLogado,this.viagemSelected,this.transportes,this.tipo}) : super(key: key);

  @override
  State<ViagemDadosView> createState() => _ViagemDadosViewState();
}

class _ViagemDadosViewState extends State<ViagemDadosView> {
  ViagemDadosController viagemCadastroController = ViagemDadosController();
  TextFormFieldWidget textFormFieldWidget = TextFormFieldWidget();
  ElevatedButtonWidget elevatedButtonWidget = ElevatedButtonWidget();
  void initState() {
    init();
    print(widget.viagemSelected);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dados Viagem")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: textFormFieldWidget.criaTff(viagemCadastroController.tecId, "Código da Viagem",ativo: false),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: textFormFieldWidget.criaTff(viagemCadastroController.tecMotorista, "Motorista"),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, right: 8, left: 8),
              child: textFormFieldWidget.criaTff(viagemCadastroController.tecDestino, "Destino"),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, right: 8, left: 8),
              child: Row(
                  children: [
                    Expanded(
                      child: DropdownButton(
                        isExpanded:true,
                        hint: Text("Transporte"),
                        value: viagemCadastroController.transporteSelected,
                        items: widget.transportes!.map((e) {
                          return DropdownMenuItem(
                              value: e,
                              child: Text('${e.nome}'));
                        }).toList(),
                        onChanged: (value) {
                          viagemCadastroController.transporteSelected = value;
                          setState(() {});
                        },
                      ),
                    ),
                  ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, right: 8, left: 8),
              child: textFormFieldWidget.criaTff(viagemCadastroController.tecFinalidade, "Finalidade"),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, right: 8, left: 8),
              child: textFormFieldWidget.criaTff(viagemCadastroController.tecDatasaida, "Saida"),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, right: 8, left: 8),
              child: textFormFieldWidget.criaTff(viagemCadastroController.tecDatachegada, "Chegada"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                    onPressed: () async{
                      viagemCadastroController.alteraDados(widget.viagemSelected!);
                      widget.tipo == 'I' ? viagemCadastroController.insertViagem() :
                      await viagemCadastroController.updateViagem(widget.viagemSelected!);
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.save_outlined),
                    label: Text('Salvar'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightGreen,
                    )
                )
              ],
            )
          ],
        ),
      ),
    );
  }
  init(){
    widget.viagemSelected == null ? null :
    viagemCadastroController.preencheCampos(widget.viagemSelected!);
  }
}
