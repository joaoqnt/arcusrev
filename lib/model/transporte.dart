class Transporte {
  int? id;
  String? nome;

  Transporte({this.id, this.nome});

  Transporte.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    nome = json['NOME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.id;
    data['NOME'] = this.nome;
    return data;
  }
}
