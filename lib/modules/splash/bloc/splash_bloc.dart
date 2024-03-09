import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:parking_app/core/helpers/constants.dart';
import 'package:parking_app/core/rest_client/local_storages/shared_preferences_local_storage_impl.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc({required SharedPreferencesLocalStorageImpl storage})
      : _storage = storage,
        super(const SplashState.initial()) {
    on<SplashVerifyLocalUserEvent>(_verifyLocalUser);
  }

  final SharedPreferencesLocalStorageImpl _storage;

  Future<void> _verifyLocalUser(
    SplashEvent event,
    Emitter<SplashState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          status: SplashStatus.loading,
        ),
      );
      final user = await _storage.read<bool>(Constants.localUserKey);

      if (user != null) {
        emit(
          state.copyWith(
            status: SplashStatus.loading,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: SplashStatus.failure,
          ),
        );
      }
    } on Exception catch (_) {
      emit(
        state.copyWith(
          status: SplashStatus.failure,
        ),
      );
    }
  }
}
