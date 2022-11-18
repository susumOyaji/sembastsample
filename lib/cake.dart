class Cake {
  final int id;
  final String name;
  final String yummyness;

  Cake({required this.id, required this.name, required this.yummyness});

  Map<String, dynamic> toMap() {
    return {'name': this.name, 'yummyness': this.yummyness};
  }

  factory Cake.fromMap(int id, Map<String, dynamic> map) {
    return Cake(
      id: id,
      name: map['name'],
      yummyness: map['yummyness'],
    );
  }

  Cake copyWith(
      {required int id, required String name, required String yummyness}) {
    return Cake(
      id: id ?? this.id,
      name: name ?? this.name,
      yummyness: yummyness ?? this.yummyness,
    );
  }
}
