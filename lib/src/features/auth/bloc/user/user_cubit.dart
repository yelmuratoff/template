import 'package:base_starter/src/features/auth/resource/domain/models/user.dart';
import 'package:base_starter/src/features/auth/resource/domain/repositories/user/local_repository.dart';
import 'package:base_starter/src/features/auth/resource/domain/repositories/user/remote_repository.dart';
import 'package:bloc/bloc.dart';

class UserCubit extends Cubit<UserDTO?> {
  final IRemoteUserRepository remoteUserRepository;
  final ILocalUserRepository localUserRepository;

  UserCubit({
    required this.remoteUserRepository,
    required this.localUserRepository,
  }) : super(null);

  Future<void> get() async {
    try {
      final UserDTO? localUser = localUserRepository.get();
      emit(localUser);
      final UserDTO? remoteUser = await remoteUserRepository.get();
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
