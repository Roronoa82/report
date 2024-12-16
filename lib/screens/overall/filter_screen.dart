import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  bool isFiltersVisible = false; // สถานะในการแสดงหรือซ่อนฟิลเตอร์

  String selectedEmployee = 'All Employees';
  String selectedOrderType = 'All Order Types';
  String selectedRevenueSource = 'All Sources';
  String selectedSection = 'All Sections';

  // ฟังก์ชันที่ใช้ในการเปิด/ปิดการแสดงฟิลเตอร์
  void toggleFilters() {
    setState(() {
      isFiltersVisible = !isFiltersVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("More Filters")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ปุ่ม More Filters
            GestureDetector(
              onTap: toggleFilters,
              child: Row(
                children: [
                  Icon(Icons.filter_list),
                  SizedBox(width: 8),
                  Text("More Filters"),
                ],
              ),
            ),
            SizedBox(height: 16),

            // เมื่อ isFiltersVisible เป็น true จะทำการแสดงฟิลเตอร์
            if (isFiltersVisible) ...[
              // Dropdown สำหรับ Employees
              DropdownButton<String>(
                value: selectedEmployee,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedEmployee = newValue!;
                  });
                },
                items: <String>['All Employees', 'Employee 1', 'Employee 2'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        Icon(Icons.person, size: 16),
                        SizedBox(width: 8),
                        Text(value),
                      ],
                    ),
                  );
                }).toList(),
              ),

              // Dropdown สำหรับ Order Types
              DropdownButton<String>(
                value: selectedOrderType,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedOrderType = newValue!;
                  });
                },
                items: <String>['All Order Types', 'Online', 'Offline'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        Icon(Icons.receipt, size: 16),
                        SizedBox(width: 8),
                        Text(value),
                      ],
                    ),
                  );
                }).toList(),
              ),

              // Dropdown สำหรับ Source of Revenue
              DropdownButton<String>(
                value: selectedRevenueSource,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedRevenueSource = newValue!;
                  });
                },
                items: <String>['All Sources', 'Source 1', 'Source 2'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        Icon(Icons.money, size: 16),
                        SizedBox(width: 8),
                        Text(value),
                      ],
                    ),
                  );
                }).toList(),
              ),

              // Dropdown สำหรับ Show/Hide Sections
              DropdownButton<String>(
                value: selectedSection,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSection = newValue!;
                  });
                },
                items: <String>['All Sections', 'Section 1', 'Section 2'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        Icon(Icons.visibility, size: 16),
                        SizedBox(width: 8),
                        Text(value),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
