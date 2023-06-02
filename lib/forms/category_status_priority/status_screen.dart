import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

import 'package:note_management_system_api/logic/states/status_state.dart';
import '../../data/note_data.dart';
import '../../logic/cubits/drawer_cubit.dart';
import '../../logic/cubits/status_cubit.dart';
import '../../logic/repositories/status_repository.dart';
import '../../ultilities/Constant.dart';

// ignore: must_be_immutable
class StatusScreen extends StatelessWidget {

  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _StatusScreen());
  }
}

// ignore: must_be_immutable
class _StatusScreen extends StatefulWidget {

  const _StatusScreen();

  @override
  // ignore: no_logic_in_create_state
  State<_StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<_StatusScreen> {
  late String email;
  final nameController = TextEditingController();
  late SharedPreferences preference;

  final statusCubit = StatusCubit(StatusRepository());
  final drawerCubit = DrawerCubit();
  NoteData? status;

  static const Color endColor = Color.fromARGB(255, 98, 205, 255);
  int selectedIndex = -1;

  String createAt = "";
  final DateTime _dateTime = DateTime.now();

  NoteData? name;

  void showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> getData() async {
    if(statusCubit.state is SuccessLoadAllStatusState){
      status = statusCubit.state.data;
    } else {
      status = await statusCubit.getAllData(email);
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void _showModalBottomSheet(List<dynamic>? status) {
    if (status == null) {
      nameController.text = "";
      createAt = statusCubit.formatDateTime(_dateTime);
    } else {
      nameController.text = status[0];
      createAt = status[2];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => StatefulBuilder(builder: (context, setState) {
          return Container(
            padding: EdgeInsets.only(
              top: 20,
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, 6))
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextFormField(
                  style: const TextStyle(fontSize: 20),
                  controller: nameController,
                  decoration: InputDecoration(
                      hintText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      if (status == null) {
                        NoteData? result = await statusCubit.createStatus(
                          email,
                          nameController.text,);
                        if (result != null) {
                          if (result.status == Constant.KEY_STATUS_1) {
                            showMessage("Create Successfully");
                            statusCubit.getAllData(email);
                          } else if (result.status == Constant.KEY_STATUS__1 &&
                              result.error == Constant.KEY_ERROR_2) {
                            showMessage("Duplicate name");
                          }
                        }
                      } else {
                        NoteData? result;
                        if (status[0] == nameController.text) {
                          result = await statusCubit.updateStatus(
                            email,
                            nameController.text,
                            "",);
                        } else {
                          result = await statusCubit.updateStatus(
                            email,
                            status[0],
                            nameController.text,);
                        }
                        if (result != null) {
                          if (result.status == Constant.KEY_STATUS_1) {
                            showMessage("Update Successfully");
                            statusCubit.getAllData(email);
                          } else if (result.status == Constant.KEY_STATUS__1 &&
                              result.error == Constant.KEY_ERROR_2) {
                            showMessage("Duplicate name");
                          }
                        }
                      }
                    },
                    child: Text(status == null ? "Create New" : "Update")
                ),
              ],
            ),
          );
        }));
  }

  Future<bool> _showConfirmDeleteDialog(List<dynamic> status) async {
    bool result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this status?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(true);
                NoteData? result = await statusCubit.deleteStatus(email, status[0]);
                if(result != null) {
                  if(result.status == 1) {
                    statusCubit.getAllData(email);
                    showMessage("Delete Successfully");
                  } else if(result.status == -1 && result.error == 2){
                    showMessage("In use, cannot be deleted");
                  }
                }
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
    return result;
  }

  Widget buildListCard(List<dynamic> status, index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 5),
          child: Card(
            elevation: 3,
            shadowColor: Colors.grey,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: ListTile(
              title: Text("Name: ${status[0]}"),
              subtitle: Text('Created At: ${status[2]}'),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: drawerCubit.initSharePreference(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            preference = snapshot.data!;
            email = preference.getString(Constant.KEY_EMAIL)!;

            statusCubit.getAllData(email);
            getData();

            return Scaffold(
              body: BlocProvider.value(
                value: statusCubit,
                child: BlocBuilder<StatusCubit, StatusState>(
                  builder: (context, state) {
                    if (state is InitialStatusState || state is LoadingStatusState){
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is SuccessLoadAllStatusState) {
                      final status = state.data?.data;
                      return Padding(
                          padding: const EdgeInsets.only(left: 4, right: 4),
                          child: ListView.builder(
                              itemCount: status?.length,
                              itemBuilder: (context, index) => Dismissible(
                                background: Container(
                                  color: Colors.red,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 20),
                                        child: const Icon(
                                          Icons.delete,
                                          size: 24,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                secondaryBackground: Container(
                                  color: Colors.green,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(right: 20),
                                        child: const Icon(
                                          Icons.edit,
                                          size: 24,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                key: Key(status![index][0]),
                                confirmDismiss: (direction) async {
                                  if (direction == DismissDirection.endToStart) {
                                    _showModalBottomSheet(status[index]);
                                    return false;
                                  } else {
                                    return await _showConfirmDeleteDialog(
                                        status[index]);
                                  }
                                },
                                child: buildListCard(status[index], index),
                              )));
                    } else if (state is FailureStatusState) {
                      return Center(child: Text(state.errorMessage));
                    }
                    return Text(state.toString());
                  },
                ),
              ),
              floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    _showModalBottomSheet(null);
                  },
                  backgroundColor: endColor,
                  child: const Icon(Icons.add)),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });

  }
}
