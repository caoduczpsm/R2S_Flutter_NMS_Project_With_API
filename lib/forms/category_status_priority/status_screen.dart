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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_spinkit/flutter_spinkit.dart';

// ignore: must_be_immutable
class StatusScreen extends StatelessWidget {

  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: _StatusScreen());
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
        builder: (_) => StatefulBuilder(builder: (builderContext, setState) {
          return Container(
            padding: EdgeInsets.only(
              top: 20,
              left: 16,
              right: 16,
              bottom: MediaQuery.of(builderContext).viewInsets.bottom + 20,
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
                      hintText: AppLocalizations.of(context).name,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.of(builderContext).pop();
                      if (status == null) {
                        NoteData? result = await statusCubit.createStatus(
                          email,
                          nameController.text,);
                        if (result != null) {
                          if (result.status == Constant.KEY_STATUS_1) {
                            statusCubit.getAllData(email);
                            if(!mounted) return;
                            showMessage(AppLocalizations.of(context).create_successful);
                          } else if (result.status == Constant.KEY_STATUS__1 &&
                              result.error == Constant.KEY_ERROR_2) {
                            if(!mounted) return;
                            showMessage(AppLocalizations.of(context).create_error_name);
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
                            statusCubit.getAllData(email);
                            if(!mounted) return;
                            showMessage(AppLocalizations.of(context).update_successful);
                          } else if (result.status == Constant.KEY_STATUS__1 &&
                              result.error == Constant.KEY_ERROR_2) {
                            if(!mounted) return;
                            showMessage(AppLocalizations.of(context).create_error_name);
                          }
                        }
                      }
                    },
                    child: Text(status == null ? AppLocalizations.of(context).create : AppLocalizations.of(context).update)
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
      builder: (builderContext) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).delete_confirm),
          content: Text(AppLocalizations.of(context).delete_title),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(builderContext).pop(false);
              },
              child: Text(AppLocalizations.of(context).no),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(builderContext).pop(true);
                NoteData? result = await statusCubit.deleteStatus(email, status[0]);
                if(result != null) {
                  if(result.status == 1) {
                    statusCubit.getAllData(email);
                    if(!mounted) return;
                    showMessage(AppLocalizations.of(context).delete_successful);
                  } else if(result.status == -1 && result.error == 2){
                    if(!mounted) return;
                    showMessage(AppLocalizations.of(context).delete_error_in_use);
                  }
                }
              },
              child: Text(AppLocalizations.of(context).yes),
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
              title: Text("${AppLocalizations.of(context).name}: ${status[0]}"),
              subtitle: Text('${AppLocalizations.of(context).created_at}: ${status[2]}'),
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
                      return const Center(
                        child: SpinKitThreeInOut(
                          color: Colors.blueAccent,
                          size: 50.0,
                        ),
                      );
                    } else if (state is SuccessLoadAllStatusState) {
                      final status = state.data?.data;
                      if (status!.isNotEmpty) {
                        return Padding(
                            padding: const EdgeInsets.only(left: 4, right: 4),
                            child: ListView.builder(
                                itemCount: status.length,
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
                                  key: Key(status[index][0]),
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
                      } else {
                        return Center(
                          child: Text(
                            AppLocalizations.of(context).empty_status,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.blueAccent),
                          ),
                        );
                      }
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
            return const Center(
              child: SpinKitThreeInOut(
                color: Colors.blueAccent,
                size: 50.0,
              ),
            );
          }
        });

  }
}
