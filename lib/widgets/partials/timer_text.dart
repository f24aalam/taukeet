import 'package:flutter/material.dart';
import 'package:taukeet/bloc/timer_bloc.dart';
import 'package:provider/provider.dart';
import 'package:taukeet/config.dart';

class TimerText extends StatelessWidget {
  const TimerText({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final hourStr = (duration / 3600).floor().toString().padLeft(2, "0");
    final minutesStr =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');
    return Text(
      '$hourStr:$minutesStr:$secondsStr',
      style: TextStyle(
        fontSize: App(context).appHeight(3),
        letterSpacing: 2,
        color: const Color(0xffF0E7D8),
        fontFamily: "Lateef",
      ),
    );
  }
}
