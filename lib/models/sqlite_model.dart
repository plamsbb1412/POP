import 'dart:convert';

class SQLiteModel {
  final int? id;
  final String idStore;
  final String idProduct;
  final String name;
  final String price;
  final String proceSpecial;
  final String amount;
  final String sum;
  SQLiteModel({
    this.id,
    required this.idStore,
    required this.idProduct,
    required this.name,
    required this.price,
    required this.proceSpecial,
    required this.amount,
    required this.sum,
  });

  SQLiteModel copyWith({
    int? id,
    String? idStore,
    String? idProduct,
    String? name,
    String? price,
    String? proceSpecial,
    String? amount,
    String? sum,
  }) {
    return SQLiteModel(
      id: id ?? this.id,
      idStore: idStore ?? this.idStore,
      idProduct: idProduct ?? this.idProduct,
      name: name ?? this.name,
      price: price ?? this.price,
      proceSpecial: proceSpecial ?? this.proceSpecial,
      amount: amount ?? this.amount,
      sum: sum ?? this.sum,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idStore': idStore,
      'idProduct': idProduct,
      'name': name,
      'price': price,
      'proceSpecial': proceSpecial,
      'amount': amount,
      'sum': sum,
    };
  }

  factory SQLiteModel.fromMap(Map<String, dynamic> map) {
    return SQLiteModel(
      id: map['id']?.toInt() ?? 0,
      idStore: map['idStore'] ?? '',
      idProduct: map['idProduct'] ?? '',
      name: map['name'] ?? '',
      price: map['price'] ?? '',
      proceSpecial: map['proceSpecial'] ?? '',
      amount: map['amount'] ?? '',
      sum: map['sum'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SQLiteModel.fromJson(String source) =>
      SQLiteModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SQLiteModel(id: $id, idStore: $idStore, idProduct: $idProduct, name: $name, price: $price, proceSpecial: $proceSpecial, amount: $amount, sum: $sum)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SQLiteModel &&
        other.id == id &&
        other.idStore == idStore &&
        other.idProduct == idProduct &&
        other.name == name &&
        other.price == price &&
        other.proceSpecial == proceSpecial &&
        other.amount == amount &&
        other.sum == sum;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        idStore.hashCode ^
        idProduct.hashCode ^
        name.hashCode ^
        price.hashCode ^
        proceSpecial.hashCode ^
        amount.hashCode ^
        sum.hashCode;
  }
}
