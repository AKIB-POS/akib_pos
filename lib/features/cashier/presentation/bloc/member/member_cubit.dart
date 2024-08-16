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
      (failure) => emit(MemberError("Failed to post member")),
      (_) => emit(MemberPostedSuccess()),
    );
  }
}
