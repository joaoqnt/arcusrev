import 'package:arcusrev/model/transporte.dart';
import 'package:arcusrev/model/viagem.dart';
import 'package:arcusrev/repository/viagem_repository.dart';
import 'package:flutter/material.dart';

class ViagemController{
  List<Viagem> viagens = [];
  List<Viagem> viagensOriginal = [];
  List<Transporte> transportes = [];
  ViagemRepository viagemRepository = ViagemRepository();
  Transporte? transporteSelecionado;
  Viagem? viagemSelected;
  double valorTotal = 0;
  TextEditingController tecBusca = TextEditingController();
  ScrollController scrollController = ScrollController();


  Future<bool> getAll(String cnpj, {int? index}) async{
    viagensOriginal = await viagemRepository.getAll(cnpj, index: index);
    viagensOriginal.forEach((element) {
      viagens.add(element);
    });
    // viagens = viagensOriginal;
    return true;
  }

  getTransportes(){
    transportes = viagemRepository.transportes;
  }

  int getMaxId(){
    int maxId = 0;
    viagens.forEach((element) {
      if(element.id! > maxId){
        maxId = element.id!;
      }
    });
    return maxId + 1;
  }

  double getTotal(Viagem viagem){
    double soma = 0;

    viagem.despesas.forEach((element) {
      soma += element.valor!;
    });

    return soma;
  }

  void filterOs(String? busca){
    viagens = viagensOriginal.where((element) =>
    element.id.toString().contains(busca.toString()) ||
        element.motorista!.toLowerCase().contains(busca!.toLowerCase())).toList();
  }
}