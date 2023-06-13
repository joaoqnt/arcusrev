import 'package:arcusrev/controller/viagem_controller.dart';
import 'package:arcusrev/model/usuario.dart';
import 'package:arcusrev/utils/dataformato_util.dart';
import 'package:arcusrev/view/despesas_view.dart';
import 'package:arcusrev/view/viagem_dados_view.dart';
import 'package:arcusrev/widgets/alertdialog_widget.dart';
import 'package:arcusrev/widgets/elevatedbutton_widget.dart';
import 'package:arcusrev/widgets/textformfield_widget.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import '../widgets/circularprogress_widget.dart';

class ViagensView extends StatefulWidget {
  Usuario usuarioLogado;
  String cnpj;
  ViagensView(this.usuarioLogado,this.cnpj,{Key? key}) : super(key: key);

  @override
  State<ViagensView> createState() => _ViagensViewState();
}

class _ViagensViewState extends State<ViagensView> {
  ViagemController viagemController = ViagemController();
  AlertDialogWidget alertDialogWidget = AlertDialogWidget();
  ElevatedButtonWidget elevatedButtonWidget = ElevatedButtonWidget();
  CircularProgressWidget circularProgressWidget = CircularProgressWidget();
  TextFormFieldWidget textFormFieldWidget = TextFormFieldWidget();
  DataFormatoUtil dataFormatoUtil = DataFormatoUtil();
  
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
            widget.usuarioLogado.administrador == 'N' ? Container() :
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) =>
                      ViagemDadosView(
                        transportes: viagemController.transportes,
                        tipo: 'I',
                        usuarioLogado: widget.usuarioLogado,
                        viagemController: viagemController,
                        maxId: viagemController.getMaxId(),
                        cnpj: widget.cnpj,)
                  )).then((value) => init());
                },
                icon: Icon(Icons.add))
          ]
      ),
      body:Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: SizedBox(
                        width: 75,
                        height: 60,
                        child: DropdownButton(
                            hint:Text('Filtros'),
                            isExpanded: true,
                            underline: const SizedBox(),
                            alignment: Alignment.center,
                            value:viagemController.filtroSelected,
                            items: viagemController.tiposFiltro.map((e) {
                              return DropdownMenuItem(
                                  value: e,
                                  child: Text('${e}')
                              );
                            }).toList(),
                            onChanged: (value){
                              viagemController.onChange(value!);
                              setState(() {
                              });
                            },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: viagemController.tecBusca,
                          decoration:  InputDecoration(
                            labelText: "Pesquisa",
                            fillColor: Colors.grey,
                            hintText: viagemController.filtroSelected == "Data" ?
                            "Pesquise pela data saida/chegada" : "Funcionario/viagem/destino"
                          ),
                          onChanged: (value) {
                            setState(() {
                              viagemController.filterOs(busca: value);
                            });
                          },
                          onTap: () async{
                            viagemController.filtroSelected == 'Data' ? await viagemController.setDate(context,widget.cnpj) : null;
                            viagemController.filtroSelected == 'Data' ? setState((){}) : null;
                          }
                        )
                      ),
                    ),
                  ]
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  controller: viagemController.scrollController,
                  itemCount: viagemController.viagensFiltered.length,
                  itemBuilder: (context, index) {
                    viagemController.checkIndex(index) == -1 ? init(index: (index + 1)) : null;
                    return Card(
                      child: InkWell(
                        onTap: (){
                          viagemController.viagemSelected = viagemController.viagensFiltered[index];
                          Navigator.push(
                              context, MaterialPageRoute(builder: (BuildContext) => DespesasView(
                              widget.usuarioLogado,
                              viagemController.viagemSelected!,
                              widget.cnpj)
                          )).then((value) => init());
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
                                              Text("${viagemController.viagensFiltered[index].id} - "),
                                              Text('${viagemController.viagensFiltered[index].destino}'),
                                            ],
                                          ),
                                          Text(
                                            '${viagemController.viagensFiltered[index].motorista}',
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                          Text(
                                            "Saida : ${DataFormatoUtil.getDate(viagemController.viagensFiltered[index].datasaida, 'dd/MM/yyyy')}",
                                            style: TextStyle(color: Colors.grey)),
                                          Text(
                                              "Chegada : ${DataFormatoUtil.getDate(viagemController.viagensFiltered[index].dataregresso, 'dd/MM/yyyy')}",
                                              style: TextStyle(color: Colors.grey)),
                                    ],
                                  )),
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Text(
                                          "${UtilBrasilFields.obterReal(viagemController.getTotal(viagemController.viagensFiltered[index]))}",
                                          style:TextStyle(fontSize: 10) ),
                                    ),
                                    IconButton(
                                        onPressed: (){
                                          viagemController.viagemSelected = viagemController.viagensFiltered[index];
                                          Navigator.push(
                                              context, MaterialPageRoute(builder: (BuildContext) => ViagemDadosView(
                                              cnpj: widget.cnpj,
                                              usuarioLogado: widget.usuarioLogado,
                                              viagemSelected: viagemController.viagemSelected,
                                              transportes: viagemController.transportes,
                                              viagemController: viagemController)
                                          )).then((value) => init());
                                        },
                                        icon: Icon(Icons.edit_outlined)
                                    )
                                  ],
                                )
                              ]
                          ),
                        )
                      ),
                    );
                  }
              )
          ),
        ],
      ),
    );
  }
  Future init({int? index}) async{
    await viagemController.getAll(widget.cnpj,index: index);
    index == null ? viagemController.getTransportes() : null;
    setState(() {});
  }
}

