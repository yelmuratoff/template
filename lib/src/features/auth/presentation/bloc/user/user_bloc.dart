import 'package:base_starter/src/common/utils/extensions/bloc_extension.dart';
import 'package:base_starter/src/core/exceptions/app_exception.dart';
import 'package:base_starter/src/core/rest_client/exceptions/rest_client_exception.dart';
import 'package:base_starter/src/features/auth/data/models/user.dart';
import 'package:base_starter/src/features/auth/domain/repositories/user/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({required this.userRepository}) : super(const InitialUserState()) {
    on<FetchUserEvent>(_onFetch, transformer: restartable());
    on<ClearUserEvent>(_onClear, transformer: sequential());
  }

  final IUserRepository userRepository;

  Future<void> _onFetch(FetchUserEvent event, Emitter<UserState> emit) async {
    try {
      final cachedUser = userRepository.getCachedUser();
      emit(
        cachedUser != null
            ? LoadedUserState(user: cachedUser)
            : const LoadingUserState(),
      );

      final freshUser = await userRepository.getFreshUser();
      if (freshUser != null && freshUser != cachedUser) {
        emit(LoadedUserState(user: freshUser));
      }
    } on AppException catch (e, st) {
      _emitError(e, st, emit);
    } on RestClientException catch (e, st) {
      _emitError(e, st, emit);
    } on Object catch (e, st) {
      _emitError(e, st, emit);
      onError(e, st);
    }
  }

  Future<void> _onClear(ClearUserEvent event, Emitter<UserState> emit) async {
    try {
      await userRepository.clearCache();
      emit(const InitialUserState());
    } on AppException catch (e, st) {
      _emitError(e, st, emit);
    } on RestClientException catch (e, st) {
      _emitError(e, st, emit);
    } on Object catch (e, st) {
      _emitError(e, st, emit);
      onError(e, st);
    }
  }

  void _emitError(Object e, StackTrace st, Emitter<UserState> emit) {
    handleException(
      exception: e,
      stackTrace: st,
      onError: (message, cause, _) =>
          emit(ErrorUserState(message: message, cause: cause)),
    );
  }
}
