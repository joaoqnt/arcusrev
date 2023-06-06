import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';

class BrasilFields{
  String adicionarSeparador(String texto) {
    var valorFinal = "";
    var pointCount = 0;
    for (var i = texto.length - 1; i > -1; i--) {
      if (pointCount == 3) {
        valorFinal = ".$valorFinal";
        pointCount = 0;
      }
      pointCount = pointCount + 1;
      valorFinal = texto[i] + valorFinal;
    }

    return valorFinal;
  }

  String obterReal(double value, {bool moeda = true, int decimal = 2}) {
    bool isNegative = false;

    if (value.isNegative) {
      isNegative = true;
      value = value * (-1);
    }

    String fixed = value.toStringAsFixed(decimal);
    List<String> separatedValues = fixed.split(".");
    separatedValues[0] = adicionarSeparador(separatedValues[0]);
    String formatted = separatedValues.join(",");

    if (isNegative) {
      formatted = "-$formatted";
    }

    if (moeda) {
      return r"R$ " + formatted;
    } else {
      return formatted;
    }
  }

  static String obterCnpj(String cnpj) {
    return CNPJValidator.format(cnpj);
  }

  static String removeCaracteres(String valor) {
    assert(valor.isNotEmpty);
    return valor.replaceAll(RegExp('[^0-9a-zA-Z]+'), '');
  }
}