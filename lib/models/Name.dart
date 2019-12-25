import 'package:hive/hive.dart';

part 'Name.g.dart';

@HiveType()
class Name {
  @HiveField(0)
  String shortName;
  
  @HiveField(1)
  String fullName;
  Name({this.fullName, this.shortName});
}