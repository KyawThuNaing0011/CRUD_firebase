import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseMethods {
  Future<void> addEmployeeDetails(
    Map<String, dynamic> employeeInfoMap,
    String id,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection("Employee")
          .doc(id)
          .set(employeeInfoMap);
    } catch (e) {
      debugPrint("Error adding employee: $e");
    }
  }

  Future<void> updateEmployeeDetails(
    Map<String, dynamic> employeeInfoMap,
    String id,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection("Employee")
          .doc(id)
          .update(employeeInfoMap);
    } catch (e) {
      debugPrint("Error updating employee: $e");
    }
  }

  Future<void> deleteEmployee(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection("Employee")
          .doc(id)
          .delete();
    } catch (e) {
      debugPrint("Error deleting employee: $e");
    }
  }
}
