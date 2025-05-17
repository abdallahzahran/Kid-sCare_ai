class ProfileModel {
  final String name;
  final String email;
  final String phone;
  final String? image;

  ProfileModel({required this.name, required this.email, required this.phone, this.image});

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    name: json['name'],
    email: json['email'],
    phone: json['phone'],
    image: json['image'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
    'image': image,
  };
} 