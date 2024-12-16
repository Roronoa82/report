import 'package:isar/isar.dart';

part 'filtered_data.g.dart';

@collection
class FilteredData {
  Id id = Isar.autoIncrement; // Primary Key (Auto Increment)

  late int referenceDateId; // Foreign Key อ้างถึง DailySummary.id

  @Index() // Index สำหรับคีย์การกรอง
  late String filterKey;

  @Index() // Index สำหรับค่าการกรอง
  late String filterValue;

  late String resultData; // ข้อมูลผลลัพธ์จากการกรอง
}
