
// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerCubit extends Cubit<int> {
  DrawerCubit() : super(0);

  void selectIndex(int index) => emit(index);
}