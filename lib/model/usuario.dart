class Usuario {
  int? id;
  String? nome;
  String? administrador;

  Usuario({
    this.id,
    this.nome
  });

  Usuario.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    nome = json['NOME'];
    // senha = json['senha'];
    administrador = json['ADMINISTRADOR'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.id;
    data['NOME'] = this.nome;
    // data['senha'] = this.senha;
    data['ADMINISTRADOR'] = this.administrador;
    return data;
  }
}
