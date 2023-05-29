import 'package:arcusrev/controller/viagem_controller.dart';
import 'package:arcusrev/controller/viagem_dados_controller.dart';
import 'package:arcusrev/model/usuario.dart';
import 'package:arcusrev/model/viagem.dart';
import 'package:arcusrev/widgets/elevatedbutton_widget.dart';
import 'package:arcusrev/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import '../model/transporte.dart';
import '../utils/dataformato_util.dart';
import '../widgets/circularprogress_widget.dart';

class ViagemDadosView extends StatefulWidget {
  Usuario? usuarioLogado;
  Viagem? viagemSelected;
  List<Transporte>? transportes;
  ViagemController? viagemController;
  String? tipo;
  int? maxId;
  String? cnpj;

  ViagemDadosView({
    Key? key,
    this.usuarioLogado,
    this.viagemSelected,
    this.transportes,
    this.tipo,
    this.viagemController,
    this.maxId,
    this.cnpj}) :super(key: key);

  @override
  State<ViagemDadosView> createState() => _ViagemDadosViewState();
}

class _ViagemDadosViewState extends State<ViagemDadosView> {
  ViagemDadosController viagemCadastroController = ViagemDadosController();
  TextFormFieldWidget textFormFieldWidget = TextFormFieldWidget();
  ElevatedButtonWidget elevatedButtonWidget = ElevatedButtonWidget();
  CircularProgressWidget circularProgressWidget = CircularProgressWidget();

  void initState() {
    init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dados Viagem")),
      body: SingleChildScrollView(
        child: Form(
          key: viagemCadastroController.formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: textFormFieldWidget.criaTff(viagemCadastroController.tecId, "Código da Viagem",ativo: false,tamanho:1),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: textFormFieldWidget.criaTff(viagemCadastroController.tecMotorista, "Funcionário",tamanho: 52),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, right: 8, left: 8),
                child: textFormFieldWidget.criaTff(viagemCadastroController.tecDestino, "Destino",tamanho: 30),
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
                          items: viagemCadastroController.transportes.map((e) {
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
                child: textFormFieldWidget.criaTff(viagemCadastroController.tecFinalidade, "Finalidade",tamanho: 30),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, right: 8, left: 8),
                child: TextFormField(
                  onTap: () async{
                    await viagemCadastroController.setDateSaida(context,tipo: widget.tipo,viagem: widget.viagemSelected,);
                  },
                  onChanged: (value) {
                    viagemCadastroController.tecDatasaida.text = DataFormatoUtil.getDate(viagemCadastroController.selectedDateSaida,"dd/MM/yyyy");
                  },
                  controller: viagemCadastroController.tecDatasaida,
                  decoration: InputDecoration(border: OutlineInputBorder(),labelText: "Data Saida"),
                  keyboardType: TextInputType.none,
                  validator: (value) {
                    if (value == null || value.isEmpty ) {
                      if(value == null || value.isEmpty ){
                        return 'O campo não pode ser vazio';
                      }
                      return null;
                    }
                  },
                )
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, right: 8, left: 8),
                child: TextFormField(
                  onTap: () async{
                    await viagemCadastroController.setDateChegada(context,tipo: widget.tipo,viagem: widget.viagemSelected);
                  },
                  onChanged: (value) {
                    viagemCadastroController.tecDatachegada.text = DataFormatoUtil.getDate(viagemCadastroController.selectedDateChegada,"dd/MM/yyyy");
                  },
                  controller: viagemCadastroController.tecDatachegada,
                  decoration: InputDecoration(border: OutlineInputBorder(),labelText: "Data Chegada"),
                  keyboardType: TextInputType.none,
                  validator: (value) {
                    if (value == null || value.isEmpty ) {
                      if(value == null || value.isEmpty ){
                        return 'O campo não pode ser vazio';
                      }
                      return null;
                    }
                  },
                )
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8),
                child: textFormFieldWidget.criaTff(viagemCadastroController.tecObservacao, "Observação",isNeeded: false),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  widget.tipo == 'I' ? Container() :
                  ElevatedButton.icon(
                      onPressed: () async{
                        circularProgressWidget.showCircularProgress(context);
                        await viagemCadastroController.deleteViagem(widget.viagemSelected!,widget.viagemController!,widget.cnpj!);
                        await widget.viagemController!.getAll(widget.cnpj!);
                        circularProgressWidget.hideCircularProgress(context);
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.delete_outline),
                      label: Text('Excluir'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent,
                      )
                  ),
                  ElevatedButton.icon(
                      onPressed: () async{
                        if(widget.tipo == 'I' && viagemCadastroController.formKey.currentState!.validate()){
                          await viagemCadastroController.insertViagem(widget.usuarioLogado!,widget.viagemController!,widget.cnpj!);
                          await widget.viagemController!.getAll(widget.cnpj!);
                          circularProgressWidget.hideCircularProgress(context);
                          Navigator.of(context).pop();
                        }
                        if(widget.tipo != 'I'){
                          circularProgressWidget.showCircularProgress(context);
                          print(widget.cnpj);
                          await viagemCadastroController.updateViagem(widget.viagemSelected!,widget.viagemController!,widget.cnpj!);
                          await widget.viagemController!.getAll(widget.cnpj!);
                          circularProgressWidget.hideCircularProgress(context);
                          Navigator.of(context).pop();
                        }
                      },
                      icon: Icon(Icons.save_outlined),
                      label: Text('Salvar'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightGreen,
                      )
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  init(){
    viagemCadastroController.getTransportes(widget.viagemController!);
    widget.viagemSelected == null ? null :
    viagemCadastroController.preencheCampos(widget.viagemSelected!);
    widget.viagemSelected != null ? null : viagemCadastroController.tecId.text = widget.maxId.toString();
  }
}
