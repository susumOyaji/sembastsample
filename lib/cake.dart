class Cake {
  final int id;
  final String name;
  final int yummyness;

  Cake({required this.id, required this.name, required this.yummyness});

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'yummyness': this.yummyness
    };
  }

  factory Cake.fromMap(int id, Map<String, dynamic> map) {
    return Cake(
      id: id,
      name: map['name'],
      yummyness: map['yummyness'],
    );
  }

  Cake copyWith({required int id, required String name, required int yummyness}){
    return Cake(
      id: id ?? this.id,
      name: name ?? this.name,
      yummyness: yummyness ?? this.yummyness,
    );
  }
}
