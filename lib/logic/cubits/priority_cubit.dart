
// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_api/data/note_data.dart';
import 'package:note_management_system_api/logic/repositories/priority_repository.dart';
import 'package:note_management_system_api/logic/states/priority_state.dart';

class PriorityCubit extends Cubit<PriorityState>{
  final PriorityRepository _repository;

  PriorityCubit(this._repository) : super(InitialPriorityState());

  Future<NoteData?> getAllData(String email) async {
    emit(LoadingPriorityState());
    try {
      var result = await _repository.getAllData(email);
      emit(SuccessLoadAllPriorityState(result));
      return result;
    } catch (e) {
      emit(FailurePriorityState(e.toString()));
      return null;
    }
  }
}