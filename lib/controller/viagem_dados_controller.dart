import 'package:arcusrev/controller/viagem_controller.dart';
import 'package:arcusrev/model/transporte.dart';
import 'package:arcusrev/model/usuario.dart';
import 'package:arcusrev/model/viagem.dart';
import 'package:arcusrev/repository/viagem_repository.dart';
import 'package:arcusrev/utils/dataformato_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

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
  DateTime? selectedDate;

  Future updateViagem(Viagem viagem,ViagemController viagemController) async{
    alteraDados(viagem);
    await viagemRepository.updateViagem(viagem);
    // viagemController.viagens = await viagemRepository.getAll();
  }
  preencheCampos(Viagem viagem){
    tecId.text = viagem.id.toString();
    tecMotorista.text = viagem.motorista!;
    transporteSelected = viagem.transporte!;
    tecDestino.text = viagem.destino!;
    tecFinalidade.text = viagem.finalidade!;
    tecDatachegada.text = DataFormatoUtil.getDate(viagem.dataregresso, 'dd/MM/yyyy');
    tecDatasaida.text = DataFormatoUtil.getDate(viagem.datasaida, 'dd/MM/yyyy');
  }

  alteraDados(Viagem viagem){
    viagem.motorista = tecMotorista.text;
    viagem.transporte = transporteSelected;
    viagem.destino = tecDestino.text;
    viagem.finalidade = tecFinalidade.text;
  }

  Future insertViagem(Usuario responsavel, ViagemController viagemController) async{
    Viagem viagem = Viagem();
    viagem.id = int.parse(tecId.text);
    viagem.responsavel = responsavel;
    viagem.motorista = tecMotorista.text;
    viagem.finalidade = tecFinalidade.text;
    viagem.destino = tecDestino.text;
    viagem.transporte = transporteSelected;
    viagem.dataregresso = DateTime.now();
    viagem.datasaida = DateTime.now();
    print(viagem.datasaida);
    print(viagem.motorista);
    try{
      await viagemRepository.insertViagem(viagem);
      // viagemController.viagens = await viagemRepository.getAll();
    }catch(e){
      print("erro ao cadastrar viagem $e");
    }

  }



  Future deleteViagem(Viagem viagem,ViagemController viagemController) async{
    try{
      await viagemRepository.deleteViagem(viagem);
      // viagemController.viagens = await viagemRepository.getAll();
    }catch(e){
      print("erro ao deletar viagem $e");
    }
  }

  getTransportes(ViagemController viagemController){
    transportes.clear();
    transportes = viagemController.transportes;
  }

  Future setDateSaida(BuildContext context, {Viagem? viagem}) async{
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: viagem == null ? DateTime.now() : viagem.datasaida!,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      tecDatasaida.text = DataFormatoUtil.getDate(selectedDate,"dd/MM/yyyy");
      // print(tecDatasaida.text);
    }
  }

  Future setDateChegada(BuildContext context, {Viagem? viagem}) async{
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: viagem == null ? DateTime.now() : viagem.dataregresso!,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      tecDatachegada.text = DataFormatoUtil.getDate(selectedDate,"dd/MM/yyyy");
    }
  }
}