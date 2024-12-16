import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:isar/isar.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import '../models/daily_summary.dart';

class IsarService {
  late Isar isar;
  final Logger _logger = Logger();

  // ฟังก์ชันในการเปิดฐานข้อมูล
  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([DailySummarySchema], directory: dir.path);
  }

  // ฟังก์ชันในการโหลดข้อมูลจากไฟล์ JSON
  Future<void> loadAndSaveData() async {
    try {
      final jsonString = await rootBundle.loadString('assets/summary.json');
      final jsonResponse = jsonDecode(jsonString);

      // ตรวจสอบข้อมูลที่โหลดมา
      _logger.e(jsonResponse); // ดูว่าได้ข้อมูลจาก JSON หรือไม่

      // บันทึกข้อมูลจาก JSON ลงใน Isar
      await saveSummaryDataToIsar(jsonResponse);
    } catch (e) {
      _logger.e('Error loading and saving data: $e'); // แจ้งข้อผิดพลาดหากไม่สามารถโหลดหรือบันทึกข้อมูล
    }
  }

  Future<void> saveSummaryDataToIsar(List<dynamic> jsonData) async {
    try {
      await isar.writeTxn(() async {
        for (var item in jsonData) {
          final dailySummary = DailySummary()
            ..date = DateTime.parse(item['date']) // แปลงวันที่จาก String เป็น DateTime
            ..data = jsonEncode(item['data']); // เก็บข้อมูล JSON

          await isar.dailySummarys.put(dailySummary); // บันทึกข้อมูลลง Isar
        }
      });
    } catch (e) {
      print('Error saving data to Isar: $e'); // แจ้งข้อผิดพลาดเมื่อเกิดข้อผิดพลาดในการบันทึกข้อมูล
    }
  }

  // ฟังก์ชันในการดึงข้อมูลจาก Isar
  Future<List<DailySummary>> getSummaryByDate(DateTime date) async {
    final result = await isar.dailySummarys
        .filter()
        .dateEqualTo(date) // กรองข้อมูลที่ตรงกับวันที่
        .findAll();
    _logger.e(result); // ดูว่าได้ข้อมูลที่กรองแล้วหรือไม่
    return result;
  }

  Future<List<Map<String, dynamic>>> getSummaryAsMap(DateTime date) async {
    final result = await isar.dailySummarys
        .filter()
        .dateEqualTo(date) // กรองข้อมูลตามวันที่
        .findAll(); // ดึงข้อมูลทั้งหมดที่ตรงกับเงื่อนไข

    // แปลงข้อมูลจาก List<DailySummary> เป็น List<Map<String, dynamic>>
    final summaryList = result.map((dailySummary) {
      // แปลง data จาก String กลับเป็น Map<String, dynamic>
      final dataMap = jsonDecode(dailySummary.data) as Map<String, dynamic>;
      return {
        'date': dailySummary.date.toIso8601String(), // แปลงวันที่ให้เป็น String
        'data': dataMap, // ข้อมูลจาก DailySummary
      };
    }).toList();

    return summaryList;
  }
}
