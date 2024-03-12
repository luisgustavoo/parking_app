import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/models/daily_closing_model.dart';
import 'package:parking_app/models/ticket_model.dart';
import 'package:parking_app/modules/daily_closing/repository/daily_closing_repository.dart';

part 'daily_closing_event.dart';
part 'daily_closing_state.dart';

class DailyClosingBloc extends Bloc<DailyClosingEvent, DailyClosingState> {
  DailyClosingBloc({
    required DailyClosingRepository dailyClosingRepository,
    required Log log,
  })  : _dailyClosingRepository = dailyClosingRepository,
        _log = log,
        super(DailyClosingInitial()) {
    on<DailyClosingRegisterEvent>(_register);
    on<DailyClosingFindAllEvent>(_findAll);
  }

  final DailyClosingRepository _dailyClosingRepository;
  final Log _log;
  List<DailyClosingModel>? dailyClosingList;

  Future<void> _register(
    DailyClosingRegisterEvent event,
    Emitter<DailyClosingState> emit,
  ) async {
    try {
      emit(DailyClosingLoading());
      var sum = 0.0;

      dailyClosingList = await _dailyClosingRepository.findAll();

      if (dailyClosingList?.isNotEmpty ?? false) {
        final exist = dailyClosingList!.any(
          (element) => element.date == event.filteredDate,
        );

        if (exist) {
          emit(DailyClosingFailure());
          add(DailyClosingFindAllEvent());
          return;
        }
      }

      for (final ticket in event.ticketList) {
        sum += ticket.amountPaid ?? 0.0;
      }
      final dailyClosing = DailyClosingModel(
        amount: sum,
        date: DateTime.now(),
      );
      await _dailyClosingRepository.register(dailyClosing);
      emit(const DailyClosingSuccess());
    } on Exception catch (e, s) {
      emit(DailyClosingFailure());
      _log.error('Erro ao realizar fechamento diário', e, s);
    }
  }

  Future<void> _findAll(
    DailyClosingFindAllEvent event,
    Emitter<DailyClosingState> emit,
  ) async {
    try {
      emit(DailyClosingLoading());
      dailyClosingList = await _dailyClosingRepository.findAll();
      emit(DailyClosingSuccess(dailyClosingList: dailyClosingList));
    } on Exception catch (e, s) {
      emit(DailyClosingFailure());
      _log.error('Erro ao listar fechamento diário', e, s);
    }
  }
}
