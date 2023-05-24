import 'package:arcusrev/controller/despesas_controller.dart';
import 'package:arcusrev/controller/viagem_controller.dart';
import 'package:arcusrev/model/usuario.dart';
import 'package:arcusrev/model/viagem.dart';
import 'package:arcusrev/utils/dataformato_util.dart';
import 'package:arcusrev/widgets/alertdialog_widget.dart';
import 'package:arcusrev/widgets/circularprogress_widget.dart';
import 'package:arcusrev/widgets/elevatedbutton_widget.dart';
import 'package:arcusrev/widgets/pdf_widget.dart';
import 'package:arcusrev/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DespesasView extends StatefulWidget {
  Viagem viagemSelected;
  Usuario usuarioLogado;
  ViagemController viagemController;
  DespesasView(
      this.usuarioLogado,
      this.viagemSelected,
      this.viagemController,
      {Key? key}) : super(key: key);

  @override
  State<DespesasView> createState() => _DespesasViewState();
}

class _DespesasViewState extends State<DespesasView> {
  DespesasController despesasController = DespesasController();
  TextFormFieldWidget textFormFieldWidget = TextFormFieldWidget();
  ElevatedButtonWidget elevatedButtonWidget = ElevatedButtonWidget();
  AlertDialogWidget alertDialogWidget = AlertDialogWidget();
  CircularProgressWidget circularProgressWidget = CircularProgressWidget();
  PdfWidget pdfWidget = PdfWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Despesas Viagem ${widget.viagemSelected.id}"),
          actions: [
            IconButton(
                onPressed: () {
                  despesasController.clearAll();
                  despesasController.tecCodigo.text = despesasController.maxId(widget.viagemSelected.despesas).toString();
                  alertDialogWidget.adwDespesas(
                      context,
                      "Despesas",
                      despesasController.despesas,
                      //selected: despesasController.despesaSelected,
                      tec1:despesasController.tecCodigo,
                      labelText1: "Código",
                      tec2:despesasController.tecFornecedor,
                      labelText2: "Fornecedor",
                      tec3:despesasController.tecLocalidade,
                      labelText3: "Localidade",
                      tec4: despesasController.tecDocumento,
                      labelText4: "Nota",
                      textFormField5: TextFormField(
                        onTap: () {

                        },
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                        controller: despesasController.tecValor,
                        decoration: InputDecoration(border: OutlineInputBorder(),labelText: "Valor"),
                        keyboardType: TextInputType.numberWithOptions(),
                      ),
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
                      //botao1: elevatedButtonWidget.botaoExcluir(),
                      botao2: ElevatedButton.icon(
                          onPressed: () async{
                            circularProgressWidget.showCircularProgress(context);
                            await despesasController.insertDespesas(
                                widget.viagemSelected.id!,
                                listdespesas: widget.viagemSelected.despesas,
                                valor: alertDialogWidget.valor);
                            await widget.viagemController.getAll();
                            circularProgressWidget.hideCircularProgress(context);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.save_outlined),
                          label: Text('Salvar'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.lightGreen,
                          )
                      )
                  );
                },
                icon: Icon(Icons.add)
            ),
            IconButton(
                onPressed: () {
                  pdfWidget.gerarRelatorio(viagem: widget.viagemSelected);
                },
                icon: Icon(Icons.picture_as_pdf))
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
                          alertDialogWidget.valor = despesasController.despesaSelected;
                          alertDialogWidget.adwDespesas(
                              context,
                              "Despesas",
                              despesasController.despesas,
                              tec1:despesasController.tecCodigo,
                              labelText1: "Código",
                              tec2:despesasController.tecFornecedor,
                              labelText2: "Fornecedor",
                              tec3:despesasController.tecLocalidade,
                              labelText3: "Localidade",
                              tec4: despesasController.tecDocumento,
                              labelText4: "Nota",
                              textFormField5: TextFormField(
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                                controller: despesasController.tecValor,
                                decoration: InputDecoration(border: OutlineInputBorder(),labelText: "Valor"),
                                keyboardType: TextInputType.numberWithOptions(),
                              ),
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
                              botao1: ElevatedButton.icon(
                                  onPressed: () async{
                                    circularProgressWidget.showCircularProgress(context);
                                    await despesasController.deleteDespesas(
                                        widget.viagemSelected.despesas[index],
                                        widget.viagemSelected.id!);
                                    await widget.viagemController.getAll();
                                    circularProgressWidget.hideCircularProgress(context);
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(Icons.save_outlined),
                                  label: Text('Excluir'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.redAccent,
                                  )
                              ),
                              botao2: ElevatedButton.icon(
                                  onPressed: () async{
                                    circularProgressWidget.showCircularProgress(context);
                                    await despesasController.updateDespesas(
                                        widget.viagemSelected.despesas[index],
                                        widget.viagemSelected.id!,
                                        valor: alertDialogWidget.valor);
                                    await widget.viagemController.getAll();
                                    circularProgressWidget.hideCircularProgress(context);
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(Icons.save_outlined),
                                  label: Text('Salvar'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.lightGreen,
                                  )
                              )
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
