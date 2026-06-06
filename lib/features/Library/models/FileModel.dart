import 'package:hive/hive.dart';
part 'FileModel.g.dart';

@HiveType(typeId: 1)
class FileModel {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String path;

  FileModel(this.name, this.path);
}
