import 'package:crud/server/database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';

class Employee extends StatefulWidget {
  const Employee({super.key});

  @override
  State<Employee> createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Employee",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

            Text(
              "Form",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTextField(label: "Name", controller: nameController),
            buildTextField(label: "Age", controller: ageController),
            buildTextField(label: "Location", controller: locationController),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    String id = randomAlphaNumeric(10);

                    Map<String, dynamic> employeeInfoMap = {
                      "Name": nameController.text,
                      "Age": ageController.text,
                      "Id": id,
                      "Location": locationController.text,
                    };

                    await DatabaseMethods().addEmployeeDetails(
                      employeeInfoMap,
                      id,
                    );

                    Fluttertoast.showToast(msg: "Employee Added Successfully");
                  } catch (e) {
                    Fluttertoast.showToast(msg: "Error: $e");
                  }
                },
                child: Text(
                  "ADD",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({required String label, controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.only(left: 15),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(border: InputBorder.none),
          ),
        ),
        SizedBox(height: 13),
      ],
    );
  }
}
