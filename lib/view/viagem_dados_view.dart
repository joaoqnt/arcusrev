import 'package:arcusrev/controller/viagem_controller.dart';
import 'package:arcusrev/controller/viagem_dados_controller.dart';
import 'package:arcusrev/model/usuario.dart';
import 'package:arcusrev/model/viagem.dart';
import 'package:arcusrev/widgets/elevatedbutton_widget.dart';
import 'package:arcusrev/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: Text("Dados Viagem"),
        actions: [
          IconButton(
              onPressed: () async{
                showDialog(context: context, builder: (context) {
                  return AlertDialog(
                    title: Text("Confirmação"),
                    content: Text(widget.tipo == 'I' ? "Deseja cadastrar essa viagem?" : "Deseja atualizar essa viagem?"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Não")
                      ),
                      TextButton(
                          onPressed: () async{
                            if(widget.tipo == 'I' && viagemCadastroController.formKey.currentState!.validate()){
                              await viagemCadastroController.insert( widget.cnpj!, context, widget.viagemController!, widget.usuarioLogado!);
                              Navigator.of(context).pop();
                            }
                            if(widget.tipo != 'I'){
                              await viagemCadastroController.update(widget.viagemSelected!, widget.cnpj!, context, widget.viagemController!);
                              Navigator.of(context).pop();
                            }
                            Navigator.of(context).pop();
                          },
                          child: Text("Sim")
                      ),
                    ],
                  );
                });
              },
              icon: Icon(Icons.save)
          ),
          widget.tipo == "I" ? Container() :
          Padding(
            padding: const EdgeInsets.only(right:8.0),
            child: IconButton(
                onPressed: () async{
                  showDialog(context: context, builder: (context) {
                    return AlertDialog(
                      title: Text("Confirmação"),
                      content: Text("Deseja apagar essa viagem?"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Não")
                        ),
                        TextButton(
                            onPressed: () async{
                              await viagemCadastroController.delete(widget.viagemSelected!, widget.cnpj!, context, widget.usuarioLogado!);
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: Text("Sim")
                        ),
                      ],
                    );
                  });
                },
                icon: Icon(Icons.delete)
            ),
          )
        ]
      ),
      body: SingleChildScrollView(
        child: Form(
          key: viagemCadastroController.formKey,
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: textFormFieldWidget.criaTff(viagemCadastroController.tecId, "Código da Viagem",ativo: false,isNeeded: false),
                    ),
                  ),

                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right:8.0),
                        child: textFormFieldWidget.criaTff(viagemCadastroController.tecAcompanhantes, "Acompanhantes", isNeeded: false),
                      )
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, right: 8, left: 8),
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
                          items: widget.viagemController!.transportes.map((e) {
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
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8, left: 8),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
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
                        ),
                      ),
                    ),
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right:8.0),
                          child: TextFormField(
                            onTap: () async{
                              await viagemCadastroController.setDateChegada(context,tipo: widget.tipo,viagem: widget.viagemSelected,);
                            },
                            onChanged: (value) {
                              viagemCadastroController.tecDatachegada.text = DataFormatoUtil.getDate(viagemCadastroController.selectedDateSaida,"dd/MM/yyyy");
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
                          ),
                        )
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8, right: 8.0, left: 8),
                child: textFormFieldWidget.criaTff(viagemCadastroController.tecObservacao, "Observação",isNeeded: false),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // widget.tipo == 'I' ? Container() :
                  // ElevatedButton.icon(
                  //     onPressed: () async{
                  //       await viagemCadastroController.delete(widget.viagemSelected!, widget.cnpj!, context, widget.usuarioLogado!);
                  //       Navigator.of(context).pop();
                  //     },
                  //     icon: Icon(Icons.delete_outline),
                  //     label: Text('Excluir'),
                  //     style: ElevatedButton.styleFrom(
                  //       primary: Colors.redAccent,
                  //     )
                  // ),
                  // ElevatedButton.icon(
                  //     onPressed: () async{
                  //       if(widget.tipo == 'I' && viagemCadastroController.formKey.currentState!.validate()){
                  //         await viagemCadastroController.insert( widget.cnpj!, context, widget.viagemController!, widget.usuarioLogado!);
                  //         Navigator.of(context).pop();
                  //       }
                  //       if(widget.tipo != 'I'){
                  //         await viagemCadastroController.update(widget.viagemSelected!, widget.cnpj!, context, widget.viagemController!);
                  //         Navigator.of(context).pop();
                  //       }
                  //     },
                  //     icon: Icon(Icons.save_outlined),
                  //     label: Text('Salvar'),
                  //     style: ElevatedButton.styleFrom(
                  //       primary: Colors.lightGreen,
                  //     )
                  // ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  init(){
    viagemCadastroController.init(viagemSelected: widget.viagemSelected,maxId: widget.maxId);
    setState(() {
    });
  }
}
