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
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class DespesasView extends StatefulWidget {
  Viagem viagemSelected;
  Usuario usuarioLogado;
  ViagemController viagemController;
  String cnpj;
  DespesasView(
      this.usuarioLogado,
      this.viagemSelected,
      this.viagemController,
      this.cnpj,
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
  void initState() {
    despesasController.orderBy(widget.viagemSelected,type: 'id',desc: false);
    super.initState();
  }
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
                      despesasController.formKey,
                      tec1:despesasController.tecCodigo,
                      labelText1: "Código",
                      t1: 1,
                      tec2:despesasController.tecFornecedor,
                      labelText2: "Fornecedor",
                      t2: 50,
                      tec3:despesasController.tecLocalidade,
                      labelText3: "Localidade",
                      t3: 50,
                      tec4: despesasController.tecDocumento,
                      t4: 6,
                      labelText4: "Nota",
                      textFormField5: TextFormField(
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                        controller: despesasController.tecValor,
                        decoration: InputDecoration(border: OutlineInputBorder(),labelText: "Valor"),
                        keyboardType: TextInputType.numberWithOptions(),
                        validator: (value) {
                          if (value == null || value.isEmpty || value.length > 12) {
                            if(value == null || value.isEmpty ){
                              return 'O campo não pode ser vazio';
                            }else{
                              return 'O tamanho máximo para esse campo é de 12 caracter(es)';
                            }
                          }
                          return null;
                        },
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
                        keyboardType: TextInputType.none,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            if(value == null || value.isEmpty ){
                              return 'O campo não pode ser vazio';
                            }
                          }
                          return null;
                        },
                      ),
                      botao2: ElevatedButton.icon(
                          onPressed: () async{
                            if (alertDialogWidget.formKey.currentState!.validate()){
                              circularProgressWidget.showCircularProgress(context);
                              await despesasController.insertDespesas(
                                  widget.viagemSelected,
                                  widget.cnpj,
                                  valor: alertDialogWidget.valor);
                              await widget.viagemController.getAll(widget.cnpj);
                              setState(() {});
                              circularProgressWidget.hideCircularProgress(context);
                              Navigator.of(context).pop();
                            }
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
                onPressed: () async {
                  despesasController.orderBy(widget.viagemSelected,type: 'date',desc: false);
                  await despesasController.getEmpresa(widget.cnpj);
                  pdfWidget.gerarRelatorio(despesasController.empresa!,viagem: widget.viagemSelected);
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
                                          Text("${widget.viagemSelected.despesas[index].fornecedor} - ",style: TextStyle(color: Colors.grey)),
                                          Text("${widget.viagemSelected.despesas[index].local}",style: TextStyle(color: Colors.grey))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("${DataFormatoUtil.getDate(widget.viagemSelected.despesas[index].data, 'dd/MM/yyyy')}",style: TextStyle(color: Colors.grey))
                                        ],
                                      )
                                    ],
                                  )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right:8.0),
                                child: Text(UtilBrasilFields.obterReal(widget.viagemSelected.despesas[index].valor!),
                                  style: TextStyle(color: Colors.green),),
                              )
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
                              despesasController.formKey,
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
                                    showDialog(context: context, builder: (context) {
                                      return AlertDialog(
                                        title: Text("Confirmação"),
                                        content: Text("Deseja apagar essa despesa?"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("Não")
                                          ),
                                          TextButton(
                                              onPressed: () async{
                                                circularProgressWidget.showCircularProgress(context);
                                                await despesasController.deleteDespesas(
                                                    widget.viagemSelected,
                                                    index,
                                                    widget.cnpj
                                                );
                                                await widget.viagemController.getAll(widget.cnpj);
                                                circularProgressWidget.hideCircularProgress(context);
                                                setState(() {});
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("Sim")
                                          ),
                                        ],
                                      );
                                    });
                                    // circularProgressWidget.showCircularProgress(context);
                                    // await despesasController.deleteDespesas(
                                    //     widget.viagemSelected,
                                    //     index,
                                    //     widget.cnpj
                                    // );
                                    // setState(() {});
                                    // await widget.viagemController.getAll(widget.cnpj);
                                    // circularProgressWidget.hideCircularProgress(context);
                                    // setState(() {});
                                    // Navigator.of(context).pop();
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
                                        widget.cnpj,
                                        valor: alertDialogWidget.valor);
                                    await widget.viagemController.getAll(widget.cnpj);
                                    circularProgressWidget.hideCircularProgress(context);                                     // Navigator.of(context).pop();
                                    setState(() {});
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: SpeedDial(
          icon: Icons.sort,
          activeIcon: Icons.close,
          spacing: 3,
          // openCloseDial: isDialOpen,
          childPadding: const EdgeInsets.all(5),
          spaceBetweenChildren: 4,
          children: [
            SpeedDialChild(
              child: Icon(Icons.calendar_today),
              label: "Ordenar por Id crescente",
              onTap: (){
                despesasController.orderBy(widget.viagemSelected,type: 'id',desc: false);
                setState(() {
                });
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.calendar_today),
              label: "Ordenar por Id decrescente",
              onTap: (){
                despesasController.orderBy(widget.viagemSelected,type: 'id',desc: true);
                setState(() {
                });
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.calendar_today),
              label: "Ordenar por data crescente",
              //label: 'First',
              onTap: (){
                despesasController.orderBy(widget.viagemSelected,type: 'date',desc: false);
                setState(() {
                });
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.calendar_today),
              label: "Ordenar por data decrescente",
              onTap: (){
                despesasController.orderBy(widget.viagemSelected,type: 'date',desc: true);
                setState(() {
                });
              },
            )
          ],
        ),

    );
  }

}
