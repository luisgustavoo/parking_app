import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parking_app/core/exceptions/failure.dart';
import 'package:parking_app/models/user_model.dart';
import 'package:parking_app/modules/register/bloc/register_bloc.dart';
import 'package:parking_app/modules/register/service/register_service.dart';

import '../../../core/log/mock_log.dart';
import '../mocks/mock_register_service.dart';

void main() {
  late RegisterBloc registerBloc;
  late RegisterService mockRegisterService;

  const userModel = UserModel(
    id: 1,
    name: 'Sr João',
    cpf: '12345678912',
    password: '123456',
  );

  setUp(() {
    mockRegisterService = MockRegisterService();
    registerBloc = RegisterBloc(
      registerService: mockRegisterService,
      log: MockLog(),
    );

    registerFallbackValue(userModel);
  });

  group('RegisterBloc test', () {
    blocTest<RegisterBloc, RegisterState>(
      'Empty state',
      build: () => registerBloc,
      expect: () => <RegisterState>[],
    );

    blocTest<RegisterBloc, RegisterState>(
      'Register user Success',
      build: () => registerBloc,
      setUp: () {
        when(
          () => mockRegisterService.register(any()),
        ).thenAnswer((_) async => _);
      },
      act: (bloc) => bloc.add(
        RegisterUserEvent(
          cpf: userModel.cpf,
          name: userModel.name,
          password: userModel.name,
        ),
      ),
      expect: () => <RegisterState>[
        RegisterLoading(),
        RegisterSuccess(),
      ],
    );

    blocTest<RegisterBloc, RegisterState>(
      'Register user Failure',
      build: () => registerBloc,
      setUp: () {
        when(
          () => mockRegisterService.register(any()),
        ).thenThrow(Failure());
      },
      act: (bloc) => bloc.add(
        RegisterUserEvent(
          cpf: userModel.cpf,
          name: userModel.name,
          password: userModel.name,
        ),
      ),
      expect: () => <RegisterState>[
        RegisterLoading(),
        RegisterFailure(),
      ],
    );
  });
}
