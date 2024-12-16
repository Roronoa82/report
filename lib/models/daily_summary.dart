import 'package:isar/isar.dart';

part 'daily_summary.g.dart'; // สร้าง g.dart ผ่านคำสั่ง isar_generator

@collection
class DailySummary {
  Id id = Isar.autoIncrement; // Primary Key (Auto Increment)

  @Index(unique: true) // Index สำหรับวันที่ (ห้ามซ้ำ)
  late DateTime date;

  late String data; // ข้อมูลในรูปแบบ JSON หรือ String
}
