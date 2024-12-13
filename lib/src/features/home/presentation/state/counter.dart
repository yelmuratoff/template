import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider =
    StateNotifierProvider<CounterState, int>((_) => CounterState());

class CounterState extends StateNotifier<int> {
  CounterState() : super(0);

  void increment() {
    state++;
  }

  void decrement() {
    state--;
  }
}
