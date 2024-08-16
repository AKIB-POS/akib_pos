part of 'member_cubit.dart';

abstract class MemberState extends Equatable {
  const MemberState();

  @override
  List<Object> get props => [];
}

class MemberInitial extends MemberState {}

class MemberLoading extends MemberState {}

class MemberLoaded extends MemberState {
  final List<MemberModel> members;

  const MemberLoaded(this.members);

  @override
  List<Object> get props => [members];
}

class MemberError extends MemberState {
  final String message;

  const MemberError(this.message);

  @override
  List<Object> get props => [message];
}

class MemberPosting extends MemberState {}

class MemberPostedSuccess extends MemberState {}

