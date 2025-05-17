class KidModel {
  final String id;
  final String name;
  final int age;
  final String email;
  final String? image;

  KidModel({required this.id, required this.name, required this.age, required this.email, this.image});

  factory KidModel.fromJson(Map<String, dynamic> json) => KidModel(
    id: json['id'],
    name: json['name'],
    age: json['age'],
    email: json['email'],
    image: json['image'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'age': age,
    'email': email,
    'image': image,
  };
} 