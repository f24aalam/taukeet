import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taukeet/config.dart';
import 'package:taukeet/contracts/prayer_service.dart';
import 'package:taukeet/contracts/storage_service.dart';
import 'package:taukeet/cubit/prayer_cubit.dart';
import 'package:taukeet/service_locator.dart';
import 'package:taukeet/widgets/partials/prayer_card.dart';
import 'package:taukeet/widgets/partials/date_time_text.dart';
import 'package:taukeet/widgets/partials/timer_text.dart';

class Home extends StatelessWidget {
  final prayerService = getIt<PrayerService>();
  final storageService = getIt<StorageService>();

  Home({Key? key}) : super(key: key) {
    prayerService.refreshTimes(storageService);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff191923),
      body: Stack(
        children: [
          Positioned(
            top: App(context).appHeight(4),
            left: 0,
            right: 0,
            height: App(context).appHeight(40),
            child: Center(
              child: BlocBuilder<PrayerCubit, PrayerState>(
                builder: (context, state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.currentPrayer?.name.english.toUpperCase() ??
                            "none",
                        style: TextStyle(
                          fontSize: App(context).appHeight(5),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 6,
                          color: const Color(0xffF0E7D8),
                          fontFamily: "Lateef",
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TimerText(),
                          const SizedBox(width: 5),
                          Text(
                            state.currentPrayer?.name.arabic ?? "none",
                            style: TextStyle(
                              fontSize: App(context).appHeight(3),
                              color: const Color(0xffF0E7D8),
                              fontFamily: "Lateef",
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: App(context).appHeight(38)),
                child: BlocBuilder<PrayerCubit, PrayerState>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: state.prayerTimes
                          .map(
                            (prayer) => PrayerCard(
                              prayer: prayer,
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            top: App(context).appHeight(5),
            left: 0,
            right: 0,
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: App(context).appHeight(5)),
              child: const DateTimeText(),
            ),
          ),
        ],
      ),
    );
  }
}
