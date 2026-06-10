import 'package:base_starter/src/common/utils/extensions/bloc_extension.dart';
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

  static UserState _error(Object _, String message, Object? cause, int? _) =>
      ErrorUserState(message: message, cause: cause);

  Future<void> _onFetch(FetchUserEvent event, Emitter<UserState> emit) =>
      guard(emit: emit, errorState: _error, reportBug: onError, () async {
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
      });

  Future<void> _onClear(ClearUserEvent event, Emitter<UserState> emit) =>
      guard(emit: emit, errorState: _error, reportBug: onError, () async {
        await userRepository.clearCache();
        emit(const InitialUserState());
      });
}
