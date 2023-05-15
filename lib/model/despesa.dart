class Despesa {
  int? id;
  String? nome;
  String? data;
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
    //data = json['DATA'];
    nota = json['NOTA'];
    fornecedor = json['FORNECEDOR'];
    local = json['LOCAL'];
    valor = json['VALOR'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.id;
    data['NOME'] = this.nome;
    //data['DATA'] = this.data;
    data['NOTA'] = this.nota;
    data['FORNECEDOR'] = this.fornecedor;
    data['LOCAL'] = this.local;
    data['VALOR'] = this.valor;
    return data;
  }
}
