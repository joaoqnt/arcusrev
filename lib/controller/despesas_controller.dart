import 'package:arcusrev/model/viagem.dart';
import 'package:arcusrev/repository/despesa_repository.dart';
import 'package:arcusrev/utils/dataformato_util.dart';
import 'package:flutter/material.dart';

import '../model/despesa.dart';

class DespesasController{
  DespesaRepository despesaRepository = DespesaRepository();
  TextEditingController tecFornecedor = TextEditingController();
  TextEditingController tecCodigo = TextEditingController();
  TextEditingController tecLocalidade = TextEditingController();
  TextEditingController tecValor = TextEditingController();
  TextEditingController tecData = TextEditingController();
  TextEditingController tecDocumento = TextEditingController();
  List<String> despesas = ['Combustivel','Hospedagem','Outras','Refeições','Sem comprovante'];
  String? despesaSelected;
  DateTime? selectedDate;

  alteraDados(Despesa despesa,{String? valor}){
    despesaSelected = valor;
    selectedDate == null ? null : despesa.data = selectedDate;
    despesa.valor = double.tryParse(tecValor.text);
    despesa.nome = despesaSelected;
    despesa.nota = int.tryParse(tecDocumento.text);
    despesa.local = tecLocalidade.text;
    despesa.fornecedor = tecFornecedor.text;
  }

  insertDespesas(int viagem,{List<Despesa>? listdespesas, String? valor}){
    despesaSelected = valor;
    Despesa despesa = Despesa();
    despesa.data = selectedDate;
    despesa.nome = despesaSelected;
    despesa.nota = int.tryParse(tecDocumento.text);
    despesa.local = tecLocalidade.text;
    despesa.valor = double.tryParse(tecValor.text);
    despesa.fornecedor = tecFornecedor.text;
    despesaRepository.insertDespesa(despesa,viagem: viagem);
  }

  updateDespesas(Despesa despesa, int viagem,{String? valor}){
    alteraDados(despesa,valor: valor);
    print(despesa.toJson(viagem: viagem));
    try{
      despesaRepository.updateDespesa(despesa, viagem);
    }catch(e){
      print(despesa.toJson());
      print("erro ao atualizar despesa $e");
    }
  }

  deleteDespesas(Despesa despesa, int viagem){
    try{
      despesaRepository.deleteDespesa(despesa, viagem);
    }catch(e){
      print("erro ao deletar despesa $e");
    };
  }

  onTap(Despesa despesa,{String? valor}){
    despesaSelected = despesa.nome;
    valor = despesaSelected;
    print(valor);
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

  int maxId(List<Despesa> listdespesas){
    int maxid = 0;
    listdespesas.forEach((element) {
      if(element.id! > maxid){
        maxid = element.id!;
      }
    });
    return maxid + 1;
  }
}