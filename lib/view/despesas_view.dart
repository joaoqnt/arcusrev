import 'package:arcusrev/controller/despesas_controller.dart';
import 'package:arcusrev/model/usuario.dart';
import 'package:arcusrev/model/viagem.dart';
import 'package:arcusrev/utils/dataformato_util.dart';
import 'package:arcusrev/widgets/alertdialog_widget.dart';
import 'package:arcusrev/widgets/elevatedbutton_widget.dart';
import 'package:arcusrev/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';

class DespesasView extends StatefulWidget {
  Viagem viagemSelected;
  Usuario usuarioLogado;
  DespesasView(this.usuarioLogado,this.viagemSelected,{Key? key}) : super(key: key);

  @override
  State<DespesasView> createState() => _DespesasViewState();
}

class _DespesasViewState extends State<DespesasView> {
  DespesasController despesasController = DespesasController();
  TextFormFieldWidget textFormFieldWidget = TextFormFieldWidget();
  ElevatedButtonWidget elevatedButtonWidget = ElevatedButtonWidget();
  AlertDialogWidget alertDialogWidget = AlertDialogWidget();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Despesas Viagem ${widget.viagemSelected.id}"),
          actions: [
            IconButton(
                onPressed: () {
                  despesasController.clearAll();
                  alertDialogWidget.adwDespesas(
                      context,
                      "Despesas",
                      despesasController.despesas,
                      despesasController.despesaSelected,
                      tec1:despesasController.tecCodigo,
                      labelText1: "Código",
                      tec2:despesasController.tecFornecedor,
                      labelText2: "Fornecedor",
                      tec3:despesasController.tecLocalidade,
                      labelText3: "Localidade",
                      tec4: despesasController.tecDocumento,
                      labelText4: "Nota",
                      tec5: despesasController.tecValor,
                      labelText5: "Valor",
                      textFormField6: TextFormField(
                        onTap: () async{
                          await despesasController.setDate(context);
                        },
                        onChanged: (value) {
                          despesasController.tecData.text = DataFormatoUtil.getDate(despesasController.selectedDate,"dd/MM/yyyy");
                        },
                        controller: despesasController.tecData,
                        decoration: InputDecoration(border: OutlineInputBorder(),labelText: "Data"),
                        keyboardType: TextInputType.none
                        ,
                      ),
                      botao1: elevatedButtonWidget.botaoExcluir(),
                      botao2: elevatedButtonWidget.botaoSalvar()
                  );
                },
                icon: Icon(Icons.add)
            )
          ]
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: widget.viagemSelected.despesas.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: InkWell(
                        child: Container(
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("${widget.viagemSelected.despesas[index].id} - "),
                                          Text("${widget.viagemSelected.despesas[index].nome}"),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("${widget.viagemSelected.despesas[index].fornecedor} - "),
                                          Text("${widget.viagemSelected.despesas[index].local}")
                                        ],
                                      )
                                    ],
                                  )),
                              ),
                              Text("R\$: ${widget.viagemSelected.despesas[index].valor}",
                                style: TextStyle(color: Colors.green),)
                            ],
                          ),
                        ),
                        onTap: () {
                          despesasController.onTap(widget.viagemSelected.despesas[index]);
                          alertDialogWidget.adwDespesas(
                              context,
                              "Despesas",
                              despesasController.despesas,
                              despesasController.despesaSelected,
                              tec1:despesasController.tecCodigo,
                              labelText1: "Código",
                              tec2:despesasController.tecFornecedor,
                              labelText2: "Fornecedor",
                              tec3:despesasController.tecLocalidade,
                              labelText3: "Localidade",
                              tec4: despesasController.tecDocumento,
                              labelText4: "Nota",
                              tec5: despesasController.tecValor,
                              labelText5: "Valor",
                              textFormField6: TextFormField(
                                onTap: () async{
                                  await despesasController.setDate(context,despesa: widget.viagemSelected.despesas[index]);
                                },
                                onChanged: (value) {
                                  despesasController.tecData.text = DataFormatoUtil.getDate(despesasController.selectedDate,"dd/MM/yyyy");
                                },
                                controller: despesasController.tecData,
                                decoration: InputDecoration(border: OutlineInputBorder(),labelText: "Data"),
                                keyboardType: TextInputType.none
                              ),
                              botao1: elevatedButtonWidget.botaoExcluir(),
                              botao2: elevatedButtonWidget.botaoSalvar()
                          );
                        },
                      ),
                    );
                  })
          ),
        ],
      ),
    );
  }
  
}
