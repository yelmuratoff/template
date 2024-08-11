import 'package:base_starter/src/features/auth/core/data/models/user.dart';
import 'package:base_starter/src/features/auth/core/domain/repositories/user/local_repository.dart';
import 'package:base_starter/src/features/auth/core/domain/repositories/user/remote_repository.dart';
import 'package:bloc/bloc.dart';

class UserCubit extends Cubit<UserDTO?> {
  UserCubit({
    required this.remoteUserRepository,
    required this.localUserRepository,
  }) : super(null);
  final IRemoteUserRepository remoteUserRepository;
  final ILocalUserRepository localUserRepository;

  Future<void> get() async {
    try {
      final localUser = localUserRepository.get();
      emit(localUser);
      final remoteUser = await remoteUserRepository.get();
      if (remoteUser != null && remoteUser != localUser) {
        localUserRepository.write(user: remoteUser);
        emit(remoteUser);
      }
    } catch (e) {
      rethrow;
    }
  }

  void write({required UserDTO user}) {
    try {
      localUserRepository.write(user: user);
      emit(user);
    } catch (e) {
      rethrow;
    }
  }

  void clear() {
    try {
      localUserRepository.clear();
      emit(null);
    } catch (e) {
      rethrow;
    }
  }
}
