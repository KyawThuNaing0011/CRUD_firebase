import 'package:crud/widgets/employee.dart';
import 'package:crud/widgets/update_employee.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    // Show a warning message on desktop platforms where Firebase isn't initialized
    if (!Platform.isAndroid && !Platform.isIOS) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Show dialog explaining Firebase limitation on desktop
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Feature not available"),
                  content: const Text(
                    "This feature requires Firebase which is only available on mobile platforms.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("OK"),
                    ),
                  ],
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Flutter",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const Text(
                "Firebase",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ),
        body: const Center(
          child: Text(
            'This app works best on mobile devices\nwhere Firebase is properly configured.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      );
    }

    // Mobile platforms with Firebase support
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Employee()),
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Flutter",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const Text(
              "Firebase",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Employee').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No employees added yet.\nClick + to add an employee.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final employees = snapshot.data!.docs;

          return ListView.builder(
            itemCount: employees.length,
            itemBuilder: (context, index) {
              final employee = employees[index];
              final employeeId = employee['Id'] ?? 'N/A';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Dismissible(
                  key: Key(employeeId.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) async {
                    // Delete employee when swiped
                    try {
                      await FirebaseFirestore.instance
                          .collection('Employee')
                          .doc(employee.id)
                          .delete();

                      Fluttertoast.showToast(
                        msg: "Employee deleted successfully",
                      );
                    } catch (e) {
                      Fluttertoast.showToast(
                        msg: "Error deleting employee: $e",
                      );
                    }
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: Colors.white, size: 40),
                  ),
                  child: ListTile(
                    title: Text(employee['Name'] ?? 'N/A'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Age: ${employee['Age'] ?? 'N/A'}'),
                        Text('Location: ${employee['Location'] ?? 'N/A'}'),
                        Text('ID: $employeeId'),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      icon: Icon(Icons.more_vert),
                      onSelected: (value) {
                        if (value == 'edit') {
                          // Navigate to update employee screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateEmployee(
                                id: employeeId,
                                name: employee['Name'] ?? '',
                                age: employee['Age'] ?? '',
                                location: employee['Location'] ?? '',
                              ),
                            ),
                          );
                        } else if (value == 'delete') {
                          // Show confirmation dialog before deletion
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Delete Employee"),
                                content: const Text(
                                  "Are you sure you want to delete this employee?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(
                                        context,
                                      ).pop(); // Close dialog
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      try {
                                        await FirebaseFirestore.instance
                                            .collection('Employee')
                                            .doc(employee.id)
                                            .delete();

                                        Fluttertoast.showToast(
                                          msg: "Employee deleted successfully",
                                        );
                                        Navigator.of(
                                          context,
                                        ).pop(); // Close dialog
                                      } catch (e) {
                                        Fluttertoast.showToast(
                                          msg: "Error deleting employee: $e",
                                        );
                                        Navigator.of(
                                          context,
                                        ).pop(); // Close dialog
                                      }
                                    },
                                    child: const Text("Delete"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: Colors.blue),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
