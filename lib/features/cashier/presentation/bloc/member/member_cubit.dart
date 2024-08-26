import 'package:akib_pos/features/cashier/data/models/member_model.dart';
import 'package:akib_pos/features/cashier/data/repositories/kasir_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'member_state.dart';

class MemberCubit extends Cubit<MemberState> {
  final KasirRepository repository;

  MemberCubit({required this.repository}) : super(MemberInitial());

  Future<void> getAllMembers() async {
    emit(MemberLoading());
    final result = await repository.getAllMembers();
    result.fold(
      (failure) => emit(MemberError("Failed to load members")),
      (members) => emit(MemberLoaded(members)),
    );
  }

  Future<void> updateMember(MemberModel member) async {
    if (state is MemberLoaded) {
      final currentState = state as MemberLoaded;
      emit(MemberLoading());
      
      final result = await repository.updateMember(member);
      
      result.fold(
        (failure) {
          emit(MemberUpdateError('Failed to update member'));
          emit(MemberLoaded(currentState.members)); // Re-emit the current members list
        },
        (updatedMember) {
          // Update the member in the current list
          final updatedMembers = currentState.members.map((m) {
            return m.id == updatedMember.id ? updatedMember : m;
          }).toList();

          emit(MemberUpdatedSuccess(updatedMember));
          emit(MemberLoaded(updatedMembers)); // Emit the updated list
        },
      );
    } else {
      emit(MemberError("Cannot update member, members not loaded"));
    }
  }

  Future<void> searchMemberByName(String name) async {
    emit(MemberLoading());
    final result = await repository.searchMemberByName(name);
    result.fold(
      (failure) => emit(MemberError("Failed to load members")),
      (members) => emit(MemberLoaded(members)),
    );
  }

  Future<void> postMember(String name, String phoneNumber, {String? email}) async {
    emit(MemberPosting());
    final result = await repository.postMember(name, phoneNumber, email: email);
    result.fold(
      (failure) => emit(AddMemberError("Failed to post member")),
      (_) {
        emit(MemberPostedSuccess());
        getAllMembers(); // Reload members after a successful post
      },
    );
  }
}