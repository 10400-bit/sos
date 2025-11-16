import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String phone;

  @HiveField(3)
  String bloodGroup;

  @HiveField(4)
  String emergencyContact1;

  @HiveField(5)
  String? emergencyContact2;

  @HiveField(6)
  String vehicleNumber;

  @HiveField(7)
  String? serverUserId;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.bloodGroup,
    required this.emergencyContact1,
    this.emergencyContact2,
    required this.vehicleNumber,
    this.serverUserId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'blood_group': bloodGroup,
      'emergency_contact_1': emergencyContact1,
      'emergency_contact_2': emergencyContact2,
      'vehicle_number': vehicleNumber,
      'server_user_id': serverUserId,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      bloodGroup: json['blood_group'] ?? '',
      emergencyContact1: json['emergency_contact_1'] ?? '',
      emergencyContact2: json['emergency_contact_2'],
      vehicleNumber: json['vehicle_number'] ?? '',
      serverUserId: json['server_user_id'],
    );
  }
}

