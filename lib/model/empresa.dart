import 'package:pdf/widgets.dart';

class Empresa {
  int? id;
  String? nome;
  dynamic img;
  String? cnpj;

  Empresa({this.id, this.nome, this.img});

  Empresa.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    nome = json['NOME'];
    img = json['IMG'];
    cnpj = json['CNPJ'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.id;
    data['NOME'] = this.nome;
    data['IMG'] = this.img;
    data['CNPJ'] = this.cnpj;
    return data;
  }
}
