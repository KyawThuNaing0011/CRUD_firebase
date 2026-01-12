import 'package:crud/server/database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UpdateEmployee extends StatefulWidget {
  final String id;
  final String name;
  final String age;
  final String location;

  const UpdateEmployee({
    Key? key,
    required this.id,
    required this.name,
    required this.age,
    required this.location,
  }) : super(key: key);

  @override
  State<UpdateEmployee> createState() => _UpdateEmployeeState();
}

class _UpdateEmployeeState extends State<UpdateEmployee> {
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController locationController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    ageController = TextEditingController(text: widget.age);
    locationController = TextEditingController(text: widget.location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Update",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Text(
              "Employee",
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        Map<String, dynamic> employeeInfoMap = {
                          "Name": nameController.text,
                          "Age": ageController.text,
                          "Location": locationController.text,
                        };

                        await DatabaseMethods()
                            .updateEmployeeDetails(employeeInfoMap, widget.id);

                        Fluttertoast.showToast(msg: "Employee Updated Successfully");
                        Navigator.pop(context);
                      } catch (e) {
                        Fluttertoast.showToast(msg: "Error: $e");
                      }
                    },
                    child: Text(
                      "UPDATE",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    child: Text(
                      "CANCEL",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({required String label, required TextEditingController controller}) {
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