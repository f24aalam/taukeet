import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taukeet/bloc/timer_bloc.dart';
import 'package:provider/provider.dart';
import 'package:taukeet/config.dart';
import 'package:taukeet/widgets/settings.dart';

class DateTimeText extends StatelessWidget {
  const DateTimeText({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    context.select((TimerBloc bloc) => bloc.state.duration);
    DateTime now = DateTime.now();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat('EEEE d MMMM').format(now).toUpperCase(),
          style: TextStyle(
            fontSize: App(context).appWidth(4),
            letterSpacing: 1,
            color: const Color(0xffF0E7D8),
            fontFamily: "Lateef",
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              DateFormat('hh:mm a').format(now),
              style: TextStyle(
                fontSize: App(context).appWidth(6),
                letterSpacing: 1,
                color: const Color(0xffF0E7D8),
                fontFamily: "Lateef",
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Settings(),
                  ),
                );
              },
              iconSize: App(context).appWidth(8),
              icon: const Icon(
                Icons.settings,
                color: Color(0xffF0E7D8),
              ),
            ),
          ],
        )
      ],
    );
  }
}
