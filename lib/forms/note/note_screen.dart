import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_api/data/note_data.dart';
import 'package:note_management_system_api/logic/cubits/category_cubit.dart';
import 'package:note_management_system_api/logic/cubits/priority_cubit.dart';
import 'package:note_management_system_api/logic/cubits/status_cubit.dart';
import 'package:note_management_system_api/logic/repositories/category_repository.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:note_management_system_api/logic/repositories/priority_repository.dart';
import 'package:note_management_system_api/logic/repositories/status_repository.dart';
import '../../logic/cubits/note_cubit.dart';
import '../../logic/repositories/note_repository.dart';
import '../../logic/states/note_state.dart';

class NoteScreen extends StatelessWidget {
  const NoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _NoteScreen(),
    );
  }
}

class _NoteScreen extends StatefulWidget {
  const _NoteScreen();

  @override
  State<_NoteScreen> createState() => __NoteScreenState();
}

class __NoteScreenState extends State<_NoteScreen> {
  final nameController = TextEditingController();

  final noteCubit = NoteCubit(NoteRepository());
  final categoryCubit = CategoryCubit(CategoryRepository());
  final statusCubit = StatusCubit(StatusRepository());
  final priorityCubit = PriorityCubit(PriorityRepository());

  static const textNormalStyle = TextStyle(fontSize: 20);
  int selectedIndex = -1;

  NoteData? categories, status, priorities;
  List<dynamic>? categoryListData, statusListData, priorityListData;
  dynamic categoryDropdownValue;
  dynamic statusDropdownValue;
  dynamic priorityDropdownValue;

  String _selectedDate = "";
  final DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    noteCubit.getAllNotes("kyle@r2s.com.vn");
    getData();
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  void showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> getData() async {
    categories = await categoryCubit.getAllData("kyle@r2s.com.vn");
    categoryListData = categories?.data;
    status = await statusCubit.getAllData("kyle@r2s.com.vn");
    statusListData = status?.data;
    priorities = await priorityCubit.getAllData("kyle@r2s.com.vn");
    priorityListData = priorities?.data;
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void _showModalBottomSheet(List<dynamic>? note) {
    if (note == null) {
      categoryDropdownValue = categoryListData?[0][0];
      statusDropdownValue = statusListData?[0][0];
      priorityDropdownValue = priorityListData?[0][0];
      _selectedDate = _formatDate(_dateTime);
      nameController.text = "";
    } else {
      nameController.text = note[0];
      categoryDropdownValue = note[1];
      priorityDropdownValue = note[2];
      statusDropdownValue = note[3];
      _selectedDate = note[4];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => StatefulBuilder(builder: (context, setState) {
              return Container(
                padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
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
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Icon(
                            Icons.category,
                            color: Colors.orange,
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 5),
                              child: DropdownButton(
                                icon: const Icon(Icons.arrow_drop_down,
                                    color: Colors.orange),
                                elevation: 16,
                                style: const TextStyle(color: Colors.black),
                                underline: Container(
                                  height: 2,
                                  color: Colors.orange,
                                ),
                                value: categoryDropdownValue,
                                items: categoryListData
                                    ?.map<DropdownMenuItem<dynamic>>((e) {
                                  return DropdownMenuItem<dynamic>(
                                    value: e[0],
                                    child: Text(
                                      e[0],
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    categoryDropdownValue = value!;
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Icon(
                            Icons.priority_high,
                            color: Colors.green,
                          ),
                          Expanded(
                              child: Container(
                            margin: const EdgeInsets.only(left: 5),
                            child: DropdownButton(
                              icon: const Icon(Icons.arrow_drop_down,
                                  color: Colors.green),
                              elevation: 16,
                              style: const TextStyle(color: Colors.black),
                              underline: Container(
                                height: 2,
                                color: Colors.green,
                              ),
                              value: priorityDropdownValue,
                              items: priorityListData
                                  ?.map<DropdownMenuItem<dynamic>>((e) {
                                return DropdownMenuItem<dynamic>(
                                  value: e[0],
                                  child: Text(e[0],
                                      style: const TextStyle(fontSize: 20)),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  priorityDropdownValue = value!;
                                });
                              },
                            ),
                          ))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Icon(Icons.signal_wifi_statusbar_4_bar,
                                  color: Colors.red),
                              Expanded(
                                child: Container(
                                    margin: const EdgeInsets.only(left: 5),
                                    child: DropdownButton(
                                      icon: const Icon(Icons.arrow_drop_down,
                                          color: Colors.red),
                                      elevation: 16,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      underline: Container(
                                          height: 2, color: Colors.red),
                                      value: statusDropdownValue,
                                      items: statusListData
                                          ?.map<DropdownMenuItem<dynamic>>((e) {
                                        return DropdownMenuItem<dynamic>(
                                            value: e[0],
                                            child: Text(e[0],
                                                style: const TextStyle(
                                                    fontSize: 20)));
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          statusDropdownValue = value!;
                                        });
                                      },
                                    )),
                              ),
                            ])),
                    const SizedBox(height: 10),
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
                    Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black26),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: GestureDetector(
                            onTap: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2023),
                                      lastDate: DateTime(2100))
                                  .then((value) {
                                setState(() {
                                  _selectedDate = _formatDate(value!);
                                });
                              });
                            },
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: Text(_selectedDate,
                                          style: const TextStyle(fontSize: 20),
                                          textAlign: TextAlign.left)),
                                ]))),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          if (note == null) {
                            NoteData? result = await noteCubit.createNote(
                                "kyle@r2s.com.vn",
                                nameController.text,
                                priorityDropdownValue,
                                categoryDropdownValue,
                                statusDropdownValue,
                                _selectedDate);
                            if (result != null) {
                              if (result.status == 1) {
                                showMessage("Successfully");
                                noteCubit.getAllNotes("kyle@r2s.com.vn");
                              } else if (result.status == -1 &&
                                  result.error == 2) {
                                showMessage("Duplicate name");
                              }
                            }
                          } else {
                            showMessage("Update");
                          }
                        },
                        child: Text(note == null ? "Create New" : "Update")),
                  ],
                ),
              );
            }));
  }

  Future<bool> _showConfirmDeleteNoteDialog() async {
    bool result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this note?"),
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
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
    return result;
  }

  Widget buildListCard(List<dynamic> note, index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              selectedIndex == index
                  ? selectedIndex = -1
                  : selectedIndex = index;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: Card(
              elevation: 3,
              shadowColor: Colors.grey,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: FittedBox(
                child: Container(
                    width: 400,
                    height: 160,
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    child: Center(
                      child: SizedBox(
                        width: 375,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    note[0],
                                    style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent),
                                  ),
                                  Text(
                                    "${note[4]}",
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.category),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(
                                            "Category: ${note[1]},",
                                            style: textNormalStyle,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.low_priority),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(
                                            "Priority: ${note[2]}",
                                            style: textNormalStyle,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    child: Row(
                                      children: [
                                        const Icon(
                                            Icons.signal_wifi_statusbar_4_bar),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(
                                            "Status: ${note[3]}",
                                            style: textNormalStyle,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
              ),
            ),
          ),
        ),
        Visibility(
          visible: selectedIndex == index,
          child: Container(
            margin: const EdgeInsets.only(top: 5, bottom: 5, right: 5),
            child: Text(
              "Created at: ${note[6]}",
              style: textNormalStyle,
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
        value: noteCubit,
        child: BlocBuilder<NoteCubit, NoteState>(
          builder: (context, state) {
            if (state is InitialNoteState || state is LoadingNoteState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is SuccessLoadAllNoteState) {
              final note = state.notes.data;
              return Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: ListView.builder(
                      itemCount: note?.length,
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
                            key: Key(note![index][6]),
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.endToStart) {
                                _showModalBottomSheet(note[index]);
                                return false;
                              } else {
                                return await _showConfirmDeleteNoteDialog();
                              }
                            },
                            child: buildListCard(note[index], index),
                          )));
            } else if (state is FailureNoteState) {
              return Center(
                child: Text(state.errorMessage),
              );
            }
            return Text(state.toString());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (categories == null || status == null || priorities == null) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("Empty")));
            } else {
              _showModalBottomSheet(null);
            }
          },
          child: const Icon(Icons.add)),
    );
  }
}
