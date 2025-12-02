import 'package:flutter_test/flutter_test.dart';
import 'package:status_manage/features/bloc/counter_bloc.dart';
import 'package:status_manage/features/bloc/counter_event.dart';
import 'package:status_manage/features/bloc/counter_state.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
  group('CounterBloc', () {
    test('initial state', () {
      final bloc = CounterBloc();
      expect(bloc.state.value, 0);
      expect(bloc.state.status, CounterStatus.initial);
      bloc.close();
    });

    blocTest<CounterBloc, CounterState>(
      'emits success after LoadInitial',
      build: () => CounterBloc(),
      act: (bloc) => bloc.add(LoadInitial()),
      wait: const Duration(milliseconds: 250),
      expect: () => [
        isA<CounterState>().having((s) => s.status, 'status', CounterStatus.loading),
        isA<CounterState>().having((s) => s.status, 'status', CounterStatus.success),
      ],
    );

    blocTest<CounterBloc, CounterState>(
      'increment increases value',
      build: () => CounterBloc(),
      act: (bloc) => bloc.add(IncrementPressed()),
      expect: () => [
        isA<CounterState>().having((s) => s.value, 'value', 1),
      ],
    );

    blocTest<CounterBloc, CounterState>(
      'reset sets value to 0',
      build: () => CounterBloc(),
      act: (bloc) => bloc
        ..add(IncrementPressed())
        ..add(ResetPressed()),
      expect: () => [
        isA<CounterState>().having((s) => s.value, 'value', 1),
        isA<CounterState>().having((s) => s.value, 'value', 0),
      ],
    );
  });
}

