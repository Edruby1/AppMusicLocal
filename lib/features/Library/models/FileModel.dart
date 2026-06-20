import 'package:hive/hive.dart';
part 'FileModel.g.dart';

@HiveType(typeId: 1)
class FileModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String path;

  FileModel({required this.id, required this.name, required this.path});
}
