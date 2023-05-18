import 'package:arcusrev/utils/dataformato_util.dart';

class Despesa {
  int? id;
  String? nome;
  DateTime? data;
  int? nota;
  String? fornecedor;
  String? local;
  double? valor;

  Despesa(
      {this.id,
        this.nome,
        //this.data,
        this.nota,
        this.fornecedor,
        this.local,
        this.valor});

  Despesa.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    nome = json['NOME'];
    data = DateTime.parse(json['DATA']);
    nota = json['NOTA'];
    fornecedor = json['FORNECEDOR'];
    local = json['LOCAL'];
    valor = json['VALOR'];
  }

  Map<String, dynamic> toJson({int? viagem}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['VIAGEM'] = viagem;
    data['ID'] = this.id;
    data['NOME'] = this.nome;
    data['DATA'] = DataFormatoUtil.getDate(this.data, DataFormatoUtil.formatInsertFirebird);
    data['NOTA'] = this.nota;
    data['FORNECEDOR'] = this.fornecedor;
    data['LOCAL'] = this.local;
    data['VALOR'] = this.valor;
    return data;
  }
}
