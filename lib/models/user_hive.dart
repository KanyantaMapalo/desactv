import 'package:hive/hive.dart';

part 'user_hive.g.dart';

@HiveType(typeId: 1)
class User_hive {

  User_hive({required this.userID,required this.firstname,required this.lastname,required this.email,required this.phone,required this.country});

  @HiveField(0)
  String firstname;

  @HiveField(1)
  String lastname;

  @HiveField(2)
  String country;

  @HiveField(3)
  String userID;

  @HiveField(4)
  String email;

  @HiveField(5)
  String phone;
}
