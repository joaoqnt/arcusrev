import 'package:arcusrev/model/transporte.dart';
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
  Transporte? transporteSelected;

  Future updateViagem(Viagem viagem) async{
    await viagemRepository.updateViagem(viagem);
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

  Future insertViagem() async{
    Viagem viagem = Viagem();
    // viagem.motorista = tecMotorista.text;
    // viagem.transporte = transporteSelected;
    // viagem.destino = tecDestino.text;
    // viagem.finalidade = tecFinalidade.text;
    await viagemRepository.insertViagem(viagem);
  }
}