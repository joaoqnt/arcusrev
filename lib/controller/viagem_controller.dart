import 'package:arcusrev/model/transporte.dart';
import 'package:arcusrev/model/viagem.dart';
import 'package:arcusrev/repository/viagem_repository.dart';
import 'package:arcusrev/utils/dataformato_util.dart';
import 'package:flutter/material.dart';

class ViagemController{
  List<Viagem> viagensAll = [];
  List<Viagem> viagensIndex = [];
  List<Viagem> viagensFiltered = [];
  List<Transporte> transportes = [];
  ViagemRepository viagemRepository = ViagemRepository();
  Transporte? transporteSelected;
  Viagem? viagemSelected;
  double valorTotal = 0;
  List<String> tiposFiltro = ['Tudo','Data'];
  String? filtroSelected;
  TextEditingController tecBusca = TextEditingController();
  ScrollController scrollController = ScrollController();
  DateTime? selectedDate;
  List<int> listIndex = [];

  Future<bool> getAll(String cnpj, {int? index}) async{
    viagensIndex = await viagemRepository.getAll(cnpj, index: index);
    index == null? viagensAll = viagensIndex :
    viagensIndex.forEach((element) {
      viagensAll.add(element);
    });
    viagensFiltered = viagensAll;
    return true;
  }



  getTransportes(){
    transportes = viagemRepository.transportes;
  }

  int getMaxId(){
    int maxId = 0;
    viagensAll.forEach((element) {
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

  void filterOs({String? busca}){
    busca == null ? null : viagensFiltered = viagensAll.where((element) =>
        element.motorista.toString().toLowerCase().contains(busca.toString().toLowerCase())||
            element.id.toString().contains(busca.toString())||
            element.destino.toString().toLowerCase().contains(busca.toString().toLowerCase())
    ).toList();
  }

  Future filterDate(String cnpj) async{
    String data = DataFormatoUtil.getDate(selectedDate,'yyyy-MM-dd');
    viagensFiltered = await viagemRepository.filterDate(cnpj,data);
  }

  onChange(String value){
    filtroSelected = value;
    value != 'Data' ? viagensFiltered = viagensAll : null;
    tecBusca.clear();
  }

  Future setDate(BuildContext context, String cnpj) async{
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      tecBusca.text = DataFormatoUtil.getDate(selectedDate,"dd/MM/yyyy");
      await filterDate(cnpj);
    }
  }

  int checkIndex(int index){
    int numero = 0;
    if((index+1) % viagensIndex.length == 0){
      numero = -1;
      listIndex.where((element) => element == (index+1)).forEach((element) {
        numero = 666;
      });
      listIndex.add((index+1));
    }
    return numero;
  }
}