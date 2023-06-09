import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_api/data/note_data.dart';
import 'package:note_management_system_api/logic/cubits/chart_cubit.dart';
import 'package:note_management_system_api/logic/repositories/chart_repository.dart';
import 'package:note_management_system_api/logic/states/chart_state.dart';
import 'package:note_management_system_api/ultilities/Constant.dart';
// ignore: depend_on_referenced_packages
import 'package:pie_chart/pie_chart.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomeScreen();
  }
}

// ignore: must_be_immutable
class _HomeScreen extends StatefulWidget {
  const _HomeScreen({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<_HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen> {
  ChartCubit chartCubit = ChartCubit(ChartRepository());

  List<Color> randomColors = [];

  Map<String, double> dataMap = {};

  late SharedPreferences preference;
  late NoteData data;
  late String email;

  Future<Map<String, double>> getData() async {
    preference = await SharedPreferences.getInstance();
    email = preference.getString(Constant.KEY_EMAIL)!;
    data = await chartCubit.getAllNotes(email);
    randomColors = chartCubit.randomListColor(data);
    return chartCubit.toMapData(email, data);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            dataMap = snapshot.data!;
            if (dataMap.isNotEmpty) {
              return Scaffold(
                body: BlocProvider.value(
                  value: chartCubit,
                  child: BlocBuilder<ChartCubit, ChartState>(
                      builder: (cubitContext, state) {
                    if (state is LoadingChartState) {
                      return const Center(
                        child: SpinKitThreeInOut(
                          color: Colors.blueAccent,
                          size: 50.0,
                        ),
                      );
                    } else {
                      return Scaffold(
                          body: PieChart(
                        dataMap: dataMap,
                        animationDuration: const Duration(milliseconds: 800),
                        chartLegendSpacing: 26,
                        chartRadius: MediaQuery.of(context).size.width / 2,
                        colorList: randomColors,
                        initialAngleInDegree: 0,
                        chartType: ChartType.ring,
                        ringStrokeWidth: 32,
                        //centerText: "Note Management System",
                        legendOptions: const LegendOptions(
                          showLegendsInRow: false,
                          legendPosition: LegendPosition.right,
                          showLegends: true,
                          legendTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        chartValuesOptions: const ChartValuesOptions(
                          showChartValueBackground: true,
                          showChartValues: true,
                          showChartValuesInPercentage: true,
                          showChartValuesOutside: false,
                          decimalPlaces: 1,
                        ),
                      ));
                    }
                  }),
                ),
              );
            } else {
              return Center(
                child: Text(
                  AppLocalizations.of(context).empty_note,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.blueAccent),
                ),
              );
            }
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
