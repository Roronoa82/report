// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      color: Colors.white,
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Text: Develop Resturant
          Text(
            "Develop Resturant",
            style: TextStyle(color: Colors.grey, fontSize: 18),
          ),
          // Dropdown for user name
          Container(
            // width: 200,
            decoration: BoxDecoration(
              color: Colors.white, // สีพื้นหลังของปุ่ม
              borderRadius: BorderRadius.circular(8), // มุมโค้งมน
              border: Border.all(color: Colors.grey, width: 1), // เส้นขอบของปุ่ม
            ),

            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                value: "Thanapat", // Default value
                onChanged: (String? newValue) {
                  // Handle dropdown change here
                },
                items: <String>['Thanapat', 'Logout'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
