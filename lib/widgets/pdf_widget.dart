import 'package:arcusrev/model/empresa.dart';
import 'package:arcusrev/model/viagem.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../utils/dataformato_util.dart';

class PdfWidget {
  _headerOfPdf(Viagem viagem,dynamic image){
    return pw.Container(
        constraints: pw.BoxConstraints(maxWidth: 500),
        child: pw.Column(
          children: [
            pw.Row(
                children: [
                  pw.Padding(
                      padding: pw.EdgeInsets.only(right: 8),
                      child:
                      pw.Container(
                          width: 60,
                          child: pw.Image(image)
                      )
                  ),
                  pw.Expanded(
                      child:pw.Center(
                          child: pw.Text('Reembolso de Despesa de Viagem',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10)
                          )
                      )
                  ),
                  pw.Padding(
                      padding: pw.EdgeInsets.only(left: 8,right: 8),
                      child: pw.Text(
                          "NRo. ${viagem.id}",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10)
                      )
                  ),
                  pw.Text(
                      "${DataFormatoUtil.getDate(DateTime.now(), DataFormatoUtil.formatDDMMYYYYHHMM)}",
                      style: pw.TextStyle(fontSize: 10)
                  ),
                ]
            ),
            pw.Row(
                children:[
                  pw. Expanded(child: pw.Divider())
                ]
            ),
          ]
        )
    );
  }

  _mainOfPdf(Viagem viagem,{Empresa? empresa}){
    return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          pw.Padding(
              padding: pw.EdgeInsets.only(right: 16),
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Padding(
                        padding: pw.EdgeInsets.only(bottom: 4),
                        child: pw.Text("Empresa:",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))
                    ),
                    pw.Padding(
                        padding: pw.EdgeInsets.only(bottom: 4),
                        child: pw.Text("Nome:",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))
                    ),
                    pw.Padding(
                        padding: pw.EdgeInsets.only(bottom: 4),
                        child: pw.Text("Transporte:",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))

                    ),
                    pw.Padding(
                        padding: pw.EdgeInsets.only(bottom: 4),
                        child: pw.Text("Finalidade:",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))
                    ),
                    pw.Padding(
                        padding: pw.EdgeInsets.only(bottom: 4),
                        child: pw.Text("Destino:",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))
                    ),
                    pw.Padding(
                        padding: pw.EdgeInsets.only(bottom: 4),
                        child: pw.Text("Acompanhante:",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))
                    ),
                    pw.Padding(
                        padding: pw.EdgeInsets.only(bottom: 4),
                        child: pw.Text("Saida:",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))

                    ),
                    pw.Padding(
                        padding: pw.EdgeInsets.only(bottom: 4),
                        child: pw.Text("Chegada:",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))
                    ),
                    pw.Padding(
                        padding: pw.EdgeInsets.only(bottom: 4),
                        child: pw.Text("Observação:",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))
                    ),
                  ]
              )
          ),
          pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Padding(
                    padding: pw.EdgeInsets.only(bottom: 4),
                    child: pw.Text("${empresa!.nome}",style: pw.TextStyle(fontSize: 10))
                ),
                pw.Padding(
                    padding: pw.EdgeInsets.only(bottom: 4),
                    child: pw.Text("${viagem.motorista}",style: pw.TextStyle(fontSize: 10))
                ),
                pw.Padding(
                    padding: pw.EdgeInsets.only(bottom: 4),
                    child: pw.Text("${viagem.transporte!.nome}",style: pw.TextStyle(fontSize: 10))
                ),
                pw.Padding(
                    padding: pw.EdgeInsets.only(bottom: 4),
                    child: pw.Text("${viagem.finalidade}",style: pw.TextStyle(fontSize: 10))
                ),
                pw.Padding(
                    padding: pw.EdgeInsets.only(bottom: 4),
                    child: pw.Text("${viagem.destino}",style: pw.TextStyle(fontSize: 10))
                ),
                pw.Padding(
                    padding: pw.EdgeInsets.only(bottom: 4),
                    child: pw.Text("${viagem.acompanhantes}",style: pw.TextStyle(fontSize: 10))
                ),
                pw.Padding(
                    padding: pw.EdgeInsets.only(bottom: 4),
                    child: pw.Text("${DataFormatoUtil.getDate(
                        viagem.datasaida,
                        DataFormatoUtil.formatDDMMYYYY)}"
                        ,style: pw.TextStyle(fontSize: 10)
                    )
                ),
                pw.Padding(
                    padding: pw.EdgeInsets.only(bottom: 4),
                    child: pw.Text("${DataFormatoUtil.getDate(
                        viagem.dataregresso,
                        DataFormatoUtil.formatDDMMYYYY)}",
                        style: pw.TextStyle(fontSize: 10)
                    )
                ),
                pw.Padding(
                    padding: pw.EdgeInsets.only(bottom: 4),
                    child: pw.Text("${viagem.observacao}",
                        style: pw.TextStyle(fontSize: 10))
                ),
              ]
          ),
        ]
    );
  }

  tableOfPdf(Viagem viagem) {
    return pw.Container(
      child: pw.Column(
          children:[
            pw.Row(
                children:[
                  pw. Expanded(child: pw.Divider())
                ]
            ),
            pw.Row(
              children: [
                pw.Container(
                  width: 70,
                  decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 1))),
                  child: pw.Text('Despesas', style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10)),
                ),
                pw.Container(
                  width: 60,
                  decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 1))),
                  child: pw.Text('Data', style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10)),
                ),
                pw.Container(
                  width: 40,
                  decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 1))),
                  child: pw.Text('Nota', style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10)),
                ),
                pw.Container(
                  width: 140,
                  decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 1))),
                  child: pw.Text('Fornecedor', style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10)),
                ),
                pw.Expanded(
                    child: pw.Container(
                      decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 1))),
                      child: pw.Text('Localidade', style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10)),
                    )
                ),
                pw.Container(
                    width: 70,
                    decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 1))),
                    child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Text('Valor', style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))
                        ]
                    )
                  // pw.Text('Valor', style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10)),
                ),

              ],
            ),
            for(int index = 0; index < viagem.despesas.length; index++)
              pw.Row(
                  children: [
                    pw.Padding(
                        padding: pw.EdgeInsets.only(bottom: 8,top: index == 0 ? 8 : 0),
                        child: pw.Row(
                            children: [
                              pw.Container(
                                width: 70,
                                child: pw.Text('${viagem.despesas[index].nome}',
                                    style: pw.TextStyle(fontSize: 10)
                                ),
                              ),
                              pw.Container(
                                width: 60,
                                child: pw.Text('${DataFormatoUtil.getDate(viagem.despesas[index].data, 'dd/MM/yyyy')}',
                                    style: pw.TextStyle(fontSize: 10)
                                ),
                              ),
                              pw.Container(
                                width: 40,
                                child: pw.Text('${viagem.despesas[index].nota}',
                                    style: pw.TextStyle(fontSize: 10)
                                ),
                              ),
                              pw.Container(
                                  width: 140,
                                  child: pw.Text('${viagem.despesas[index].fornecedor}',
                                      style: pw.TextStyle(fontSize: 10))
                              ),
                              pw.Container(
                                  width: 100,
                                  child: pw.Expanded(child: pw.Text('${viagem.despesas[index].local}',
                                      style: pw.TextStyle(fontSize: 10)))
                              ),
                              pw.Container(
                                  width: 70,
                                  child: pw.Column(
                                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                                      children: [
                                        pw.Text(UtilBrasilFields.obterReal(viagem.despesas[index].valor!),
                                            style: pw.TextStyle(fontSize: 10)
                                        )
                                      ]
                                  )
                              )
                            ]
                        )
                    )
                  ]
              )
            ,
            pw.Row(
                children:[
                  pw. Expanded(child: pw.Divider())
                ]
            ),
            pw.Row(

                children: [
                  pw.Expanded(
                      child: pw.Text(
                          "Total Despesas:",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10)
                      )
                  ),
                  pw.Text(
                      UtilBrasilFields.obterReal(_getTotal(viagem)),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10)
                  )
                ]
            ),
            pw.Row(
                children:[
                  pw. Expanded(child: pw.Divider())
                ]
            )
          ]
      )
    );
  }

  endOfPdf(Viagem viagem){
    return pw.Container(
      child: pw.Column(
          children: _addRow(viagem)
      ),
    );
  }

  _assinatura(){
    return pw.Padding(
        padding: pw.EdgeInsets.only(top: 80),
        child:       pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                  children: [
                    pw.Container(
                        width: 150,
                        child: pw.Row(
                            children: [
                              pw.Expanded(child: pw.Divider())
                            ]
                        )
                    ),
                    pw.Text("Autorizado")
                  ]
              ),
              pw.Column(
                  children: [
                    pw.Container(
                        width: 150,
                        child: pw.Row(
                            children: [
                              pw.Expanded(child: pw.Divider())
                            ]
                        )
                    ),
                    pw.Text("Financeiro")
                  ]
              ),
              pw.Column(
                  children: [
                    pw.Container(
                        width: 150,
                        child: pw.Row(
                            children: [
                              pw.Expanded(child: pw.Divider())
                            ]
                        )
                    ),
                    pw.Text("Autorizante")
                  ]
              ),
            ]
        )
    );
  }

  Future<void> gerarRelatorio(Empresa empresa,{Viagem? viagem}) async {
    final pdf = pw.Document();
    final netImage = await networkImage(empresa.img);
    pdf.addPage(
      pw.MultiPage(
        maxPages: 100,
          pageFormat: PdfPageFormat.a4,
          header: (pw.Context context) {
            return _headerOfPdf(viagem!,netImage);
          },
          build: (pw.Context context) => <pw.Widget>[
            _mainOfPdf(viagem!,empresa: empresa),
            tableOfPdf(viagem),
            endOfPdf(viagem),
            _assinatura()
          ]
      )
    );
    await Printing.sharePdf(bytes: await pdf.save(), filename: '${viagem!.id}.pdf');
  }

  _getTotal(Viagem viagem){
    num total = 0;
    viagem.despesas.forEach((element) {
      total += element.valor!;
    });
    return total;
  }

  List<pw.Widget> _addRow(Viagem viagem){
    List<pw.Widget> list = [];
    List<String> _despesas = ['Hospedagem','Refeições','Combustivel','Outras','Sem comprovante'];
    _despesas.forEach((element) {
      list.add(
          pw.Row(
              children: [
                pw.Expanded(
                    child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [pw.Text("$element:",style: pw.TextStyle(fontSize: 10))]
                    )
                ),
                pw.Column(
                  children: [
                    pw.Text(
                        "${UtilBrasilFields.obterReal(_getValueByDespesa(viagem,element))}",
                        style: pw.TextStyle(fontSize: 10))
                  ]
                )
              ]
          )
      );
    });
    return list;
  }

  pw.Widget generateRows(int index, Viagem viagem){
    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: 8,top: index == 0 ? 8 : 0),
      child: pw.Row(
        children: [
          pw.Container(
            width: 70,
            child: pw.Text('${viagem.despesas[index].nome}',
                style: pw.TextStyle(fontSize: 10)
            ),
          ),
        ]
      )
    );
  }

  _getValueByDespesa(Viagem viagem, String element){
    double soma = 0;
    viagem.despesas.where((despesa) => despesa.nome == element).forEach((elemento) {
      soma += elemento.valor!;
    });
    return soma;
  }
}
