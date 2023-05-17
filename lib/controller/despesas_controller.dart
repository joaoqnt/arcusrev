import 'package:arcusrev/model/viagem.dart';
import 'package:arcusrev/utils/dataformato_util.dart';
import 'package:flutter/material.dart';

import '../model/despesa.dart';

class DespesasController{
  TextEditingController tecFornecedor = TextEditingController();
  TextEditingController tecCodigo = TextEditingController();
  TextEditingController tecLocalidade = TextEditingController();
  TextEditingController tecValor = TextEditingController();
  TextEditingController tecData = TextEditingController();
  TextEditingController tecDocumento = TextEditingController();
  List<String> despesas = ['Combustivel','Hospedagem','Outras','Refeições','Sem comprovante'];
  String? despesaSelected;
  DateTime? selectedDate;

  onTap(Despesa despesa){
    despesaSelected = despesa.nome;
    tecCodigo.text = despesa.id.toString();
    tecDocumento.text = despesa.nota.toString();
    tecFornecedor.text = despesa.fornecedor!;
    tecLocalidade.text = despesa.local!;
    tecValor.text = despesa.valor.toString();
    tecData.text = DataFormatoUtil.getDate(despesa.data, 'dd/MM/yyyy');
  }

  clearAll(){
    despesaSelected = null;
    tecCodigo.text = '';
    tecDocumento.text = '';
    tecFornecedor.text = '';
    tecLocalidade.text = '';
    tecValor.text = '';
    tecData.text = '';
  }

  Future setDate(BuildContext context, {Despesa? despesa}) async{
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: despesa == null ? DateTime.now() : despesa.data!,
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime.now().year + 1),
      );

      if (picked != null && picked != selectedDate) {
        selectedDate = picked;
        tecData.text = DataFormatoUtil.getDate(selectedDate,"dd/MM/yyyy");

      }
  }
}