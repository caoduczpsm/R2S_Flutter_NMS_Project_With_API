import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/note_data.dart';
import '../../logic/cubits/category_cubit.dart';
import '../../logic/cubits/drawer_cubit.dart';
import '../../logic/repositories/category_repository.dart';
import '../../logic/states/category_state.dart';
import '../../ultilities/Constant.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _CategoryScreen());
  }
}

// ignore: must_be_immutable
class _CategoryScreen extends StatefulWidget {
  const _CategoryScreen();

  @override
  // ignore: no_logic_in_create_state
  State<_CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<_CategoryScreen> {
  late String email;
  final nameController = TextEditingController();
  late SharedPreferences preference;

  final categoryCubit = CategoryCubit(CategoryRepository());
  final drawerCubit = DrawerCubit();
  NoteData? categories;

  static const Color endColor = Color.fromARGB(255, 98, 205, 255);
  int selectedIndex = -1;

  String createAt = "";
  final DateTime _dateTime = DateTime.now();

  void showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> getData() async {
    if (categoryCubit.state is SuccessLoadAllCategoryState) {
      categories = categoryCubit.state.data;
    } else {
      categories = await categoryCubit.getAllData(email);
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void _showModalBottomSheet(List<dynamic>? category) {
    if (category == null) {
      nameController.text = "";
      createAt = categoryCubit.formatDateTime(_dateTime);
    } else {
      nameController.text = category[0];
      createAt = category[2];
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
                          hintText: AppLocalizations.of(context).name,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          if (category == null) {
                            NoteData? result =
                                await categoryCubit.createCategory(
                              email,
                              nameController.text,
                            );
                            if (result != null) {
                              if (result.status == Constant.KEY_STATUS_1) {
                                if (!mounted) return;
                                showMessage(AppLocalizations.of(context)
                                    .create_successful);
                                categoryCubit.getAllData(email);
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
                            if (category[0] == nameController.text) {
                              result = await categoryCubit.updateCategory(
                                email,
                                nameController.text,
                                "",
                              );
                            } else {
                              result = await categoryCubit.updateCategory(
                                email,
                                category[0],
                                nameController.text,
                              );
                            }
                            if (result != null) {
                              if (result.status == Constant.KEY_STATUS_1) {
                                if (!mounted) return;
                                showMessage(AppLocalizations.of(context)
                                    .update_successful);
                                categoryCubit.getAllData(email);
                              } else if (result.status ==
                                      Constant.KEY_STATUS__1 &&
                                  result.error == Constant.KEY_ERROR_2) {
                                if (!mounted) return;
                                showMessage(AppLocalizations.of(context)
                                    .create_error_name);
                              }
                            }
                          }
                        },
                        child: Text(category == null
                            ? AppLocalizations.of(context).create
                            : AppLocalizations.of(context).update)),
                  ],
                ),
              );
            }));
  }

  Future<bool> _showConfirmDeleteDialog(List<dynamic> category) async {
    bool result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).delete_confirm),
          content: Text(AppLocalizations.of(context).delete_title),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(AppLocalizations.of(context).no),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(true);
                NoteData? result =
                    await categoryCubit.deleteCategory(email, category[0]);
                if (result != null) {
                  if (result.status == 1) {
                    categoryCubit.getAllData(email);
                    if (!mounted) return;
                    showMessage(AppLocalizations.of(context).delete_successful);
                  } else if (result.status == -1 && result.error == 2) {
                    if (!mounted) return;
                    showMessage(
                        AppLocalizations.of(context).delete_error_in_use);
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

  Widget buildListCard(List<dynamic> category, index) {
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
              title:
                  Text("${AppLocalizations.of(context).name}: ${category[0]}"),
              subtitle: Text(
                  '${AppLocalizations.of(context).created_at}: ${category[2]}'),
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

            categoryCubit.getAllData(email);
            getData();

            return Scaffold(
              body: BlocProvider.value(
                value: categoryCubit,
                child: BlocBuilder<CategoryCubit, CategoryState>(
                  builder: (context, state) {
                    if (state is InitialCategoryState ||
                        state is LoadingCategoryState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is SuccessLoadAllCategoryState) {
                      final category = state.data?.data;
                      return Padding(
                          padding: const EdgeInsets.only(left: 4, right: 4),
                          child: ListView.builder(
                              itemCount: category?.length,
                              itemBuilder: (context, index) => Dismissible(
                                    background: Container(
                                      color: Colors.red,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin:
                                                const EdgeInsets.only(left: 20),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 20),
                                            child: const Icon(
                                              Icons.edit,
                                              size: 24,
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    key: Key(category![index][0]),
                                    confirmDismiss: (direction) async {
                                      if (direction ==
                                          DismissDirection.endToStart) {
                                        _showModalBottomSheet(category[index]);
                                        return false;
                                      } else {
                                        return await _showConfirmDeleteDialog(
                                            category[index]);
                                      }
                                    },
                                    child:
                                        buildListCard(category[index], index),
                                  )));
                    } else if (state is FailureCategoryState) {
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
