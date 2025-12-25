import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/widgets/state_flow_scaffold.dart';
import 'counter_bloc.dart';
import 'counter_event.dart';
import 'counter_state.dart';

class BlocRoute extends StatelessWidget {
  const BlocRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterBloc()..add(LoadInitial()),
      child: BlocBuilder<CounterBloc, CounterState>(
        builder: (context, state) {
          final bloc = context.read<CounterBloc>();
          return StateFlowScaffold(
            pageTitle: 'Bloc / flutter_bloc',
            subtitle: 'on<Event> -> emit(State) -> BlocBuilder 重建',
            value: state.value,
            flowSteps: const [
              'onPressed 事件',
              'add(Event)',
              'Bloc 逻辑处理',
              'emit(State)',
              '订阅者重建',
            ],
            onAdd: () => bloc.add(IncrementPressed()),
            onReset: () => bloc.add(ResetPressed()),
          );
        },
      ),
    );
  }
}

