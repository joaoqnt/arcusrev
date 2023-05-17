import 'package:arcusrev/model/transporte.dart';
import 'package:arcusrev/model/usuario.dart';
import 'package:arcusrev/model/viagem.dart';
import 'package:arcusrev/repository/usuario_repository.dart';
import 'package:arcusrev/repository/viagem_repository.dart';
import 'package:flutter/material.dart';

class ViagemController{
  List<Viagem> viagens = [];
  List<Transporte> transportes = [];
  ViagemRepository viagemRepository = ViagemRepository();
  Transporte? transporteSelecionado;
  Viagem? viagemSelected;
  double valorTotal = 0;


  Future<bool> getAll() async{
    viagens = await viagemRepository.getAll();
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
}