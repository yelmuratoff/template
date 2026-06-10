import 'package:base_starter/src/features/auth/data/models/user.dart';
import 'package:base_starter/src/features/auth/domain/repositories/user/user_repository.dart';
import 'package:bloc/bloc.dart';

class UserCubit extends Cubit<UserDTO?> {
  UserCubit({required this.userRepository}) : super(null);

  final IUserRepository userRepository;

  Future<void> get() async {
    final cachedUser = userRepository.getCachedUser();
    emit(cachedUser);
    final freshUser = await userRepository.getFreshUser();
    if (freshUser != null && freshUser != cachedUser) {
      emit(freshUser);
    }
  }

  Future<void> clear() async {
    await userRepository.clearCache();
    emit(null);
  }
}
