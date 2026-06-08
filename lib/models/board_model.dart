class BoardModel {
  final int id;
  final String name;
  final String code;

  const BoardModel({
    required this.id,
    required this.name,
    required this.code,
  });

  factory BoardModel.fromMap(Map<String, dynamic> map) {
    return BoardModel(
      id:   map['id']   as int,
      name: map['name'] as String,
      code: map['code'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
    'id':   id,
    'name': name,
    'code': code,
  };

  @override
  String toString() => 'BoardModel(id: $id, name: $name)';
}
