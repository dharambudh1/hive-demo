import 'package:hive/hive.dart';
part 'model.g.dart';

@HiveType(typeId: 0)
class Details extends HiveObject {
  @HiveField(0)
  String firstName;

  @HiveField(1)
  String lastName;

  @HiveField(2)
  String gender;

  @HiveField(3)
  int age;

  Details(
     this.firstName,
     this.lastName,
     this.gender,
     this.age,
  );
}
