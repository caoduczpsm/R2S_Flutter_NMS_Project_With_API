import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final emailController = TextEditingController();
  final ageController = TextEditingController();
  final noteCubit = NoteCubit(NoteRepository());
  static const textNormalStyle = TextStyle(fontSize: 20);
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    noteCubit.getAllProfiles();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    ageController.dispose();
  }

  void _showModalBottomSheet() {
    showModalBottomSheet<int>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          height: 400,
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              gradient: LinearGradient(
                  colors: [Colors.lightBlue, Colors.white, Colors.white],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, 6)
                )
              ]
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                height: 5,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[300], // màu nền
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ],
          ),
        );
      },
    );
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
                      itemCount: note.length,
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
                        key: Key(note[index][6]),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.endToStart) {
                            _showModalBottomSheet();
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
            _showModalBottomSheet();
          },
          child: const Icon(Icons.add)),
    );
  }
}
