import 'package:arcusrev/model/despesa.dart';
import 'package:arcusrev/model/transporte.dart';
import 'package:arcusrev/model/usuario.dart';
import 'package:arcusrev/utils/dataformato_util.dart';

class Viagem {
  int? id;
  List<Despesa> despesas = [];
  int? empresa;
  String? motorista;
  Transporte? transporte;
  String? destino;
  String? finalidade;
  String? acompanhantes;
  DateTime? datasaida;
  DateTime? dataregresso;
  Usuario? responsavel;
  String? observacao;

  Viagem(
      {this.id,
        this.empresa,
        this.motorista,
       // this.transporte,
        this.destino,
        this.finalidade,
        this.acompanhantes,
        this.datasaida,
        this.dataregresso,
       // this.responsavel,
        this.observacao});

  Viagem.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    empresa = json['EMPRESA'];
    motorista = json['MOTORISTA'];
    transporte = json['transporte'];
    destino = json['DESTINO'];
    finalidade = json['FINALIDADE'];
    acompanhantes = json['ACOMPANHANTES'];
    datasaida = DateTime.parse(json['DATASAIDA']);
    dataregresso = DateTime.parse(json['DATAREGRESSO']);
    //responsavel = json['responsavel'];
    observacao = json['OBSERVACAO'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.id;
    data['EMPRESA'] = this.empresa;
    data['MOTORISTA'] = this.motorista;
    data['TRANSPORTE'] = this.transporte!.id;
    // data['DESPESAS'] = this.despesas[0].toJson();
    data['DESTINO'] = this.destino;
    data['FINALIDADE'] = this.finalidade;
    data['ACOMPANHANTES'] = this.acompanhantes;
    data['DATASAIDA'] =  DataFormatoUtil.getDate(this.datasaida,DataFormatoUtil.formatInsertFirebird);
    data['DATAREGRESSO'] = DataFormatoUtil.getDate(this.dataregresso,DataFormatoUtil.formatInsertFirebird);
    data['RESPONSAVEL'] = this.responsavel!.id;
    data['OBSERVACAO'] = this.observacao;
    return data;
  }
}
