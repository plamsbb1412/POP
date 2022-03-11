import 'dart:convert';

class WalletModel {
  final String id;
  final String idUser;
  final String datePay;
  final String money;
  final String pathSlip;
  final String status;
  WalletModel({
    required this.id,
    required this.idUser,
    required this.datePay,
    required this.money,
    required this.pathSlip,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idUser': idUser,
      'datePay': datePay,
      'money': money,
      'pathSlip': pathSlip,
      'status': status,
    };
  }

  factory WalletModel.fromMap(Map<String, dynamic> map) {
    return WalletModel(
      id: map['id'] ?? '',
      idUser: map['idUser'] ?? '',
      datePay: map['datePay'] ?? '',
      money: map['money'] ?? '',
      pathSlip: map['pathSlip'] ?? '',
      status: map['status'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory WalletModel.fromJson(String source) =>
      WalletModel.fromMap(json.decode(source));
}
