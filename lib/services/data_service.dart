// lib/services/data_service.dart
class DataService {
  static List<dynamic> extractNestedValues(Map<String, dynamic> data, List<String> keys) {
    var current = data;
    for (var key in keys) {
      current = current[key];
    }
    return current as List<dynamic>;
  }
}
