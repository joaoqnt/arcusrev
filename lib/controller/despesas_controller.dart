import 'package:arcusrev/model/empresa.dart';
import 'package:arcusrev/model/viagem.dart';
import 'package:arcusrev/repository/despesa_repository.dart';
import 'package:arcusrev/repository/empresa_repository.dart';
import 'package:arcusrev/utils/dataformato_util.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import '../model/despesa.dart';
import '../widgets/circularprogress_widget.dart';

class DespesasController{
  DespesaRepository despesaRepository = DespesaRepository();
  TextEditingController tecFornecedor = TextEditingController();
  TextEditingController tecCodigo = TextEditingController();
  TextEditingController tecLocalidade = TextEditingController();
  TextEditingController tecValor = TextEditingController();
  TextEditingController tecData = TextEditingController();
  TextEditingController tecDocumento = TextEditingController();
  List<String> despesas = ['Combustivel','Hospedagem','Outras','Refeições','Sem comprovante'];
  EmpresaRepositoy empresaRepositoy = EmpresaRepositoy();
  CircularProgressWidget circularProgressWidget = CircularProgressWidget();
  Empresa? empresa;
  String? despesaSelected;
  DateTime? selectedDate;
  bool isOrdered = false;
  final formKey = GlobalKey<FormState>();

  alteraDados(Despesa despesa,{String? valor}){
    despesaSelected = valor;
    selectedDate == null ? null : despesa.data = selectedDate;
    despesa.valor = double.tryParse(replaceValor());
    despesa.nome = despesaSelected;
    despesa.nota = tecDocumento.text;
    despesa.local = tecLocalidade.text;
    despesa.fornecedor = tecFornecedor.text;
  }

  String replaceValor(){
    String texto = UtilBrasilFields.removerSimboloMoeda(tecValor.text);
    String valorFormatado = texto.replaceAll(".", "").replaceAll(",", ".");
    return texto.length < 7 ?
    texto.replaceAll(',', '.') :
    valorFormatado;
  }

  Future insertDespesas(Viagem viagem,String cnpj,{String? valor, dynamic context}) async{
    despesaSelected = valor;
    Despesa despesa = Despesa();
    despesa.id = maxId(viagem.despesas);
    despesa.data = selectedDate;
    despesa.nome = despesaSelected;
    despesa.nota = tecDocumento.text;
    despesa.local = tecLocalidade.text;
    despesa.valor = double.tryParse(replaceValor());
    despesa.fornecedor = tecFornecedor.text;
    try{
      circularProgressWidget.showCircularProgress(context);
      await despesaRepository.insertDespesa(despesa,viagem,cnpj);
      await despesaRepository.getDespesa(viagem, cnpj);
      circularProgressWidget.hideCircularProgress(context);
    }catch(e){
      print("erro ao inserir despesa $e");
    }

  }



  Future updateDespesas(Despesa despesa, Viagem viagem,String cnpj,{String? valor, dynamic context}) async{
    alteraDados(despesa,valor: valor);
    try {
      circularProgressWidget.showCircularProgress(context);
      await despesaRepository.updateDespesa(despesa, viagem,cnpj);
      await despesaRepository.getDespesa(viagem, cnpj);
      circularProgressWidget.hideCircularProgress(context);
    }catch(e){
      print("erro ao atualizar despesa $e");
    }
  }

  Future deleteDespesas(Viagem viagem, int index, String cnpj,{dynamic context}) async{
    try{
      circularProgressWidget.showCircularProgress(context);
      await despesaRepository.deleteDespesa(viagem, index,cnpj);
      await despesaRepository.getDespesa(viagem, cnpj);
      circularProgressWidget.hideCircularProgress(context);
    }catch(e){
      print("erro ao deletar despesa $e");
    };
  }

  onTap(Despesa despesa,{String? valor}){
    despesaSelected = despesa.nome;
    valor = despesaSelected;
    tecCodigo.text = despesa.id.toString();
    tecDocumento.text = despesa.nota.toString();
    tecFornecedor.text = despesa.fornecedor!;
    tecLocalidade.text = despesa.local!;
    tecValor.text = UtilBrasilFields.obterReal(despesa.valor!);
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

  Future getEmpresa(String cnpj) async{
    empresa = await empresaRepositoy.getAll(cnpj);
  }

  void orderBy(Viagem viagem,{String? type, bool? desc}){
    if(!isOrdered){
      if(type == 'id'){
        if(desc == false){
          viagem.despesas.sort((Despesa b, Despesa a)=> b.id!.compareTo(a.id!));
        }else{
          viagem.despesas.sort((Despesa b, Despesa a)=> a.id!.compareTo(b.id!));
        }
      }else{
        if(desc == false){
          viagem.despesas.sort((Despesa b, Despesa a)=> b.data!.compareTo(a.data!));
        }else{
          viagem.despesas.sort((Despesa b, Despesa a)=> a.data!.compareTo(b.data!));
        }
      }
    }
    else{
    }
  }

}