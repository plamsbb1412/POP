import 'dart:convert';

class ProductModel {
  final String id;
  final String idStore;
  final String nameProduct;
  final String price;
  final String priceSpecial;
  final String image;
  ProductModel({
    required this.id,
    required this.idStore,
    required this.nameProduct,
    required this.price,
    required this.priceSpecial,
    required this.image,
  });

  ProductModel copyWith({
    String? id,
    String? idStore,
    String? nameProduct,
    String? price,
    String? priceSpecial,
    String? image,
  }) {
    return ProductModel(
      id: id ?? this.id,
      idStore: idStore ?? this.idStore,
      nameProduct: nameProduct ?? this.nameProduct,
      price: price ?? this.price,
      priceSpecial: priceSpecial ?? this.priceSpecial,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idStore': idStore,
      'nameProduct': nameProduct,
      'price': price,
      'priceSpecial': priceSpecial,
      'image': image,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',
      idStore: map['idStore'] ?? '',
      nameProduct: map['nameProduct'] ?? '',
      price: map['price'] ?? '',
      priceSpecial: map['priceSpecial'] ?? '',
      image: map['image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductModel(id: $id, idStore: $idStore, nameProduct: $nameProduct, price: $price, priceSpecial: $priceSpecial, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductModel &&
        other.id == id &&
        other.idStore == idStore &&
        other.nameProduct == nameProduct &&
        other.price == price &&
        other.priceSpecial == priceSpecial &&
        other.image == image;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        idStore.hashCode ^
        nameProduct.hashCode ^
        price.hashCode ^
        priceSpecial.hashCode ^
        image.hashCode;
  }
}
