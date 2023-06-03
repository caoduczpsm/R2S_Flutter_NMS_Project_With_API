import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_api/data/note_data.dart';
import 'package:note_management_system_api/logic/cubits/category_cubit.dart';
import 'package:note_management_system_api/logic/cubits/priority_cubit.dart';
import 'package:note_management_system_api/logic/cubits/status_cubit.dart';
import 'package:note_management_system_api/logic/repositories/category_repository.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import 'package:note_management_system_api/logic/repositories/priority_repository.dart';
import 'package:note_management_system_api/logic/repositories/status_repository.dart';
import 'package:note_management_system_api/ultilities/Constant.dart';
import '../../logic/cubits/drawer_cubit.dart';
import '../../logic/cubits/note_cubit.dart';
import '../../logic/repositories/note_repository.dart';
import '../../logic/states/note_state.dart';
import 'custom_paint_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_spinkit/flutter_spinkit.dart';

class NoteScreen extends StatelessWidget {
  const NoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _NoteScreen(),
    );
  }
}

class _NoteScreen extends StatefulWidget {
  const _NoteScreen();

  @override
  State<_NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<_NoteScreen> {
  late String email;
  final nameController = TextEditingController();
  late SharedPreferences preference;

  final noteCubit = NoteCubit(NoteRepository());
  final categoryCubit = CategoryCubit(CategoryRepository());
  final statusCubit = StatusCubit(StatusRepository());
  final priorityCubit = PriorityCubit(PriorityRepository());
  final drawerCubit = DrawerCubit();

  static const textNormalStyle = TextStyle(fontSize: 20, color: Colors.black);
  static const textBigSizeStyle = TextStyle(
      fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent);
  static const double _borderRadius = 10;
  static const Color startColor = Color.fromARGB(255, 151, 222, 255);
  static const Color endColor = Color.fromARGB(255, 98, 205, 255);
  bool startAnimation = false;
  int selectedIndex = -1;

  NoteData? categories, status, priorities, notes;
  List<dynamic>? categoryListData, statusListData, priorityListData;
  dynamic categoryDropdownValue;
  dynamic statusDropdownValue;
  dynamic priorityDropdownValue;

  String _selectedDate = "";
  final DateTime _dateTime = DateTime.now();

  void showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> getData() async {
    preference = await drawerCubit.initSharePreference();

    email = preference.getString(Constant.KEY_EMAIL)!;
    noteCubit.getAllNotes(email);

    categories = await categoryCubit.getAllData(email);
    status = await statusCubit.getAllData(email);
    priorities = await priorityCubit.getAllData(email);

    categoryListData = categories?.data;
    statusListData = status?.data;
    priorityListData = priorities?.data;
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        startAnimation = true;
      });
    });
    getData();
  }

  void _showModalBottomSheet(List<dynamic>? note) {
    const Color iconColor = Colors.blueAccent;

    if (note == null) {
      categoryDropdownValue = categoryListData?[0][0];
      statusDropdownValue = statusListData?[0][0];
      priorityDropdownValue = priorityListData?[0][0];
      _selectedDate = noteCubit.formatDate(_dateTime);
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
        builder: (_) => StatefulBuilder(builder: (builderContext, setState) {
              return Container(
                padding: EdgeInsets.only(
                  top: 8,
                  left: 24,
                  right: 24,
                  bottom: MediaQuery.of(builderContext).viewInsets.bottom,
                ),
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.all(Radius.circular(_borderRadius)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 12,
                          offset: Offset(0, 6))
                    ],
                    gradient: LinearGradient(
                        colors: [endColor, Colors.white, Colors.white],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight)),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 5,
                        margin: const EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[300]),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black),
                        controller: nameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          label: Text(AppLocalizations.of(context).name),
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(
                            Icons.person,
                            color: iconColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        height: 65,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5)),
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                            onTap: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2023),
                                      lastDate: DateTime(2100))
                                  .then((value) {
                                setState(() {
                                  _selectedDate = noteCubit.formatDate(value!);
                                });
                              });
                            },
                            child: TextFormField(
                                enabled: false,
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(
                                    Icons.calendar_today,
                                    color: iconColor,
                                  ),
                                ),
                                controller:
                                    TextEditingController(text: _selectedDate),
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.black),
                                textAlign: TextAlign.left)),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: DropdownButtonFormField(
                          elevation: 16,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                Icons.category,
                                color: iconColor,
                              )),
                          value: categoryDropdownValue,
                          items: categoryListData
                              ?.map<DropdownMenuItem<dynamic>>((e) {
                            return DropdownMenuItem<dynamic>(
                              value: e[0],
                              child: Text(e[0],
                                  style: const TextStyle(fontSize: 20)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              categoryDropdownValue = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                          width: double.infinity,
                          child: DropdownButtonFormField(
                            elevation: 16,
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(
                                  Icons.priority_high,
                                  color: iconColor,
                                )),
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
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                          width: double.infinity,
                          child: DropdownButtonFormField(
                            elevation: 16,
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(
                                  Icons.signal_wifi_statusbar_null_outlined,
                                  color: iconColor,
                                )),
                            value: statusDropdownValue,
                            items: statusListData
                                ?.map<DropdownMenuItem<dynamic>>((e) {
                              return DropdownMenuItem<dynamic>(
                                value: e[0],
                                child: Text(e[0],
                                    style: const TextStyle(fontSize: 20)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                statusDropdownValue = value!;
                              });
                            },
                          )),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          if (nameController.text.isNotEmpty) {
                            if (noteCubit.isFromThisDay(_selectedDate)) {
                              if (note == null) {
                                NoteData? result = await noteCubit.createNote(
                                    email,
                                    nameController.text,
                                    priorityDropdownValue,
                                    categoryDropdownValue,
                                    statusDropdownValue,
                                    _selectedDate);
                                if (result != null) {
                                  if (result.status == Constant.KEY_STATUS_1) {
                                    if (!mounted) return;
                                    showMessage(AppLocalizations.of(context)
                                        .create_successful);
                                    noteCubit.getAllNotes(email);
                                  } else if (result.status ==
                                          Constant.KEY_STATUS__1 &&
                                      result.error == Constant.KEY_ERROR_2) {
                                    if (!mounted) return;
                                    showMessage(AppLocalizations.of(context)
                                        .create_error_name);
                                  }
                                }
                              } else {
                                NoteData? result;
                                if (note[0] == nameController.text) {
                                  result = await noteCubit.updateNote(
                                      email,
                                      nameController.text,
                                      "",
                                      priorityDropdownValue,
                                      categoryDropdownValue,
                                      statusDropdownValue,
                                      _selectedDate);
                                } else {
                                  result = await noteCubit.updateNote(
                                      email,
                                      note[0],
                                      nameController.text,
                                      priorityDropdownValue,
                                      categoryDropdownValue,
                                      statusDropdownValue,
                                      _selectedDate);
                                }
                                if (result != null) {
                                  if (result.status == Constant.KEY_STATUS_1) {
                                    if (!mounted) return;
                                    showMessage(AppLocalizations.of(context)
                                        .update_successful);
                                    noteCubit.getAllNotes(email);
                                  } else if (result.status ==
                                          Constant.KEY_STATUS__1 &&
                                      result.error == Constant.KEY_ERROR_2) {
                                    if (!mounted) return;
                                    showMessage(AppLocalizations.of(context)
                                        .create_error_name);
                                  }
                                }
                              }
                            } else {
                              if (!mounted) return;
                              showMessage(AppLocalizations.of(context)
                                  .note_error_plan_date);
                            }
                          } else {
                            if (!mounted) return;
                            showMessage(
                                AppLocalizations.of(context).create_empty_name);
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          fixedSize:
                              MaterialStateProperty.all(const Size(400, 55)),
                          side: MaterialStateProperty.all(const BorderSide(
                            color: iconColor,
                            width: 1.0,
                          )), // border cho button
                        ),
                        label: Text(
                          note == null
                              ? AppLocalizations.of(context).create
                              : AppLocalizations.of(context).update,
                          style: textBigSizeStyle,
                        ),
                        icon: Icon(
                          note == null ? Icons.add : Icons.update,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            }));
  }

  Future<bool> _showConfirmDeleteNoteDialog(List<dynamic> note) async {
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
                if (noteCubit.isNotLessThan6Months(note)) {
                  Navigator.of(builderContext).pop(true);
                  NoteData? result = await noteCubit.deleteNote(email, note[0]);
                  if (result != null) {
                    if (result.status == 1) {
                      if (!mounted) return;
                      showMessage(
                          AppLocalizations.of(context).delete_successful);
                    } else if (result.status == -1 && result.error == 2) {
                      if (!mounted) return;
                      showMessage(
                          AppLocalizations.of(context).delete_note_error);
                    }
                  }
                } else {
                  Navigator.of(builderContext).pop(false);
                  if (!mounted) return;
                  showMessage(
                      AppLocalizations.of(context).delete_note_error_6_months);
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

  Widget buildListCard(List<dynamic> note, int index) {
    //double screenWidth = MediaQuery.of(context).size.width;
    //double height = MediaQuery.of(context).size.height;

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
            margin: const EdgeInsets.only(top: 15),
            child: FittedBox(
              child: Stack(
                children: <Widget>[
                  Card(
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(_borderRadius))),
                    shadowColor: endColor,
                    elevation: 3,
                    child: Container(
                        width: 400,
                        height: 160,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(_borderRadius),
                            gradient: const LinearGradient(
                                colors: [startColor, endColor],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromARGB(255, 130, 148, 196),
                                  blurRadius: 12,
                                  offset: Offset(0, 6))
                            ]),
                        child: Center(
                          child: SizedBox(
                            width: 375,
                            child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      note[0],
                                      style: textBigSizeStyle,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 5),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.category),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(left: 5),
                                            child: Text(
                                              "${AppLocalizations.of(context).category}: ${note[1]},",
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
                                              "${AppLocalizations.of(context).priority}: ${note[2]}",
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
                                          const Icon(Icons
                                              .signal_wifi_statusbar_4_bar),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(left: 5),
                                            child: Text(
                                              "${AppLocalizations.of(context).status}: ${note[3]}",
                                              style: textNormalStyle,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        )),
                  ),
                  Positioned(
                    right: 5,
                    top: 0,
                    bottom: 0,
                    child: CustomPaint(
                      size: const Size(100, 80),
                      painter: CustomCardShapePainter(
                          _borderRadius, startColor, endColor),
                    ),
                  ),
                  Positioned(
                    top: 32,
                    right: 15,
                    bottom: 0,
                    child: Text(
                      "${note[4]}",
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    ),
                  ),
                  Positioned(
                      top: 80,
                      right: 10,
                      bottom: 0,
                      child: Image.asset(
                        'images/ic_note.png',
                        width: 55,
                        height: 55,
                      )),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: selectedIndex == index,
          child: Container(
            margin: const EdgeInsets.only(top: 10, bottom: 5, right: 5),
            child: Text(
              "${AppLocalizations.of(context).created_at}: ${note[6]}",
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
                child: SpinKitThreeInOut(
                  color: Colors.blueAccent,
                  size: 50.0,
                ),
              );
            } else if (state is SuccessLoadAllNoteState) {
              final note = state.notes?.data;
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
                                return await _showConfirmDeleteNoteDialog(
                                    note[index]);
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
          onPressed: () {
            if (categories == null || status == null || priorities == null) {
              showMessage(AppLocalizations.of(context).empty);
            } else {
              _showModalBottomSheet(null);
            }
          },
          backgroundColor: endColor,
          child: const Icon(Icons.add)),
    );
  }
}
