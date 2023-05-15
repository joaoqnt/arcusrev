import 'package:intl/intl.dart';

class DataFormatoUtil{

  static String formatDDMMYYYY = 'dd/MM/yyyy';
  static String formatDDMM = 'dd/MM';
  static String formatHHMM = 'HH:mm';
  static String formatDDMMYYYYHHMM = 'dd/MM/yyyy HH:mm';
  static String formatInsertFirebird = 'yyyy-MM-dd HH:mm:00.0000';
  static String formatGetAgendamento = 'yyyy-MM-dd';

  static getDate(DateTime? dateTime, String format) {
    return DateFormat(format).format(dateTime!);
  }

  static getDateToInsertFirebird(DateTime dateTime,{bool? data}) {
    if(data != null && data){
      return DateFormat('yyyy-MM-dd').format(dateTime);
    }else {
      return DateFormat(formatInsertFirebird).format(dateTime);
    }
  }
}