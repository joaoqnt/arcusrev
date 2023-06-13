import 'package:arcusrev/controller/viagem_controller.dart';
import 'package:arcusrev/model/transporte.dart';
import 'package:arcusrev/model/usuario.dart';
import 'package:arcusrev/model/viagem.dart';
import 'package:arcusrev/repository/viagem_repository.dart';
import 'package:arcusrev/utils/dataformato_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

import '../widgets/circularprogress_widget.dart';

class ViagemDadosController{
  ViagemRepository viagemRepository = ViagemRepository();
  TextEditingController tecId = TextEditingController();
  TextEditingController tecMotorista = TextEditingController();
  TextEditingController tecDestino = TextEditingController();
  TextEditingController tecFinalidade = TextEditingController();
  TextEditingController tecAcompanhantes = TextEditingController();
  TextEditingController tecDatasaida = MaskedTextController(mask: '00/00/0000');
  TextEditingController tecDatachegada = MaskedTextController(mask: '00/00/0000');
  TextEditingController tecObservacao = TextEditingController();
  List<Transporte> transportes = [];
  Transporte? transporteSelected;
  DateTime? selectedDateSaida;
  DateTime? selectedDateChegada;
  CircularProgressWidget circularProgressWidget = CircularProgressWidget();
  final formKey = GlobalKey<FormState>();

  Future _updateViagem(Viagem viagem,String cnpj) async{
    alteraDados(viagem);
    await viagemRepository.updateViagem(viagem,cnpj);
  }
  init({Viagem? viagemSelected,int? maxId}){
    viagemSelected == null ? null : preencheCampos(viagemSelected);
    viagemSelected != null ? null : tecId.text = maxId.toString();
  }
  preencheCampos(Viagem viagem){
    tecId.text = viagem.id.toString();
    tecMotorista.text = viagem.motorista!;
    transporteSelected = viagem.transporte!;
    tecDestino.text = viagem.destino!;
    tecFinalidade.text = viagem.finalidade!;
    tecDatachegada.text = DataFormatoUtil.getDate(viagem.dataregresso, 'dd/MM/yyyy');
    tecDatasaida.text = DataFormatoUtil.getDate(viagem.datasaida, 'dd/MM/yyyy');
    tecObservacao.text = viagem.observacao!;
    tecAcompanhantes.text = viagem.acompanhantes!;
  }

  alteraDados(Viagem viagem){
    viagem.motorista = tecMotorista.text;
    viagem.transporte = transporteSelected;
    viagem.destino = tecDestino.text;
    viagem.finalidade = tecFinalidade.text;
    viagem.acompanhantes = tecAcompanhantes.text;
    viagem.observacao = tecObservacao.text;
    selectedDateChegada != null ? viagem.dataregresso = selectedDateChegada : selectedDateChegada = viagem.dataregresso;
    selectedDateSaida != null ? viagem.datasaida = selectedDateSaida : selectedDateSaida = viagem.datasaida;
  }

  Future update(Viagem viagem, String cnpj, dynamic context, ViagemController viagemController) async{
    circularProgressWidget.showCircularProgress(context);
    await _updateViagem(viagem,cnpj);
    circularProgressWidget.hideCircularProgress(context);
  }

  Future insert(String cnpj, dynamic context, ViagemController viagemController, Usuario usuario) async{
    circularProgressWidget.showCircularProgress(context);
    await _insertViagem(usuario,cnpj);
    circularProgressWidget.hideCircularProgress(context);
  }

  Future _insertViagem(Usuario responsavel, String cnpj) async{
    Viagem viagem = Viagem();
    viagem.id = int.parse(tecId.text);
    viagem.responsavel = responsavel.id;
    viagem.motorista = tecMotorista.text;
    viagem.finalidade = tecFinalidade.text;
    viagem.destino = tecDestino.text;
    viagem.acompanhantes = tecAcompanhantes.text;
    viagem.transporte = transporteSelected;
    viagem.dataregresso = selectedDateChegada;
    viagem.datasaida = selectedDateSaida;
    viagem.observacao = tecObservacao.text;
    try{
      await viagemRepository.insertViagem(viagem,cnpj);
    }catch(e){
      print("erro ao cadastrar viagem $e");
    }
  }

  Future delete(Viagem viagem, String cnpj, dynamic context, Usuario usuario) async{
    circularProgressWidget.showCircularProgress(context);
    viagem.responsavel = usuario.id;
    await _deleteViagem(viagem,cnpj);
    circularProgressWidget.hideCircularProgress(context);
  }

  Future _deleteViagem(Viagem viagem, String cnpj) async{
    try{
      await viagemRepository.deleteViagem(viagem,cnpj);
    }catch(e){
      print("erro ao deletar viagem $e");
    }
  }

  Future setDateSaida(BuildContext context, {String? tipo, Viagem? viagem}) async{
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tipo == 'I' ? DateTime.now() : viagem!.datasaida!,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (picked != null && picked != selectedDateSaida) {
      selectedDateSaida = picked;
      tecDatasaida.text = DataFormatoUtil.getDate(selectedDateSaida,"dd/MM/yyyy");
    }
  }

  Future setDateChegada(BuildContext context, {String? tipo, Viagem? viagem}) async{
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tipo == 'I' ? DateTime.now()  : viagem!.dataregresso!,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (picked != null && picked != selectedDateChegada) {
      selectedDateChegada = picked;
      tecDatachegada.text = DataFormatoUtil.getDate(selectedDateChegada,"dd/MM/yyyy");
    }
  }
}