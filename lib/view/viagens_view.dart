import 'package:arcusrev/controller/viagem_controller.dart';
import 'package:arcusrev/model/usuario.dart';
import 'package:arcusrev/utils/dataformato_util.dart';
import 'package:arcusrev/view/despesas_view.dart';
import 'package:arcusrev/view/viagem_dados_view.dart';
import 'package:arcusrev/widgets/alertdialog_widget.dart';
import 'package:arcusrev/widgets/elevatedbutton_widget.dart';
import 'package:flutter/material.dart';

class ViagensView extends StatefulWidget {
  Usuario usuarioLogado;
  ViagensView(this.usuarioLogado,{Key? key}) : super(key: key);

  @override
  State<ViagensView> createState() => _ViagensViewState();
}

class _ViagensViewState extends State<ViagensView> {
  ViagemController viagemController = ViagemController();
  AlertDialogWidget alertDialogWidget = AlertDialogWidget();
  ElevatedButtonWidget elevatedButtonWidget = ElevatedButtonWidget();
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Viagens"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (BuildContext) => ViagemDadosView(transportes: viagemController.transportes,tipo: 'I',)
                  ));
                },
                icon: Icon(Icons.add))
          ]
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: viagemController.viagens.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: InkWell(
                        onTap: (){
                          viagemController.viagemSelected = viagemController.viagens[index];
                          print(viagemController.viagemSelected!.toJson());
                          Navigator.push(
                              context, MaterialPageRoute(builder: (BuildContext) => DespesasView(widget.usuarioLogado,viagemController.viagemSelected!)
                          )).then((value) => null);
                        },
                        child: Container(
                          child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text("${viagemController.viagens[index].id} - "),
                                              Text('${viagemController.viagens[index].destino}'),
                                            ],
                                          ),
                                          Text(
                                            '${viagemController.viagens[index].motorista}',
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                          Text(
                                            "Saida : ${DataFormatoUtil.getDate(viagemController.viagens[index].datasaida, 'dd/MM/yyyy')}",
                                            style: TextStyle(color: Colors.grey)),
                                          Text(
                                              "Chegada : ${DataFormatoUtil.getDate(viagemController.viagens[index].dataregresso, 'dd/MM/yyyy')}",
                                              style: TextStyle(color: Colors.grey)),
                                    ],
                                  )),
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                        onPressed: (){
                                          viagemController.viagemSelected = viagemController.viagens[index];
                                          Navigator.push(
                                              context, MaterialPageRoute(builder: (BuildContext) => ViagemDadosView(
                                              usuarioLogado: widget.usuarioLogado,
                                              viagemSelected: viagemController.viagemSelected,
                                              transportes: viagemController.transportes)
                                          )).then((value) => setState((){}));
                                        },
                                        icon: Icon(Icons.edit_outlined))
                                  ],
                                )
                              ]
                          ),
                        )
                      ),
                    );
                  }
              )
          )
        ],
      ),
    );
  }
  Future init() async{
    await viagemController.getAll();
    viagemController.getTransportes();
    setState(() {

    });
  }
}

