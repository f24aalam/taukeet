import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:taukeet/src/libraries/prayer_time_library.dart';
import 'package:taukeet/src/libraries/settings_library.dart';
import 'package:taukeet/src/libraries/size_library.dart';
import 'package:taukeet/src/modules/home/cubit/home_cubit.dart';
import 'package:taukeet/src/modules/settings/cubit/settings_cubit.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final PrayerTimeLibrary _prayerTimeLibrary =
      PrayerTimeLibrary(address: SettingsLibrary.getSettings().address);

  @override
  Widget build(BuildContext context) {
    final SizeLibrary sizeLibrary = SizeLibrary(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "12:02 AM",
                          style: TextStyle(
                            fontSize: sizeLibrary.appSize(14),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_pin,
                              size: sizeLibrary.appSize(12),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            BlocBuilder<SettingsCubit, SettingsState>(
                              builder: (context, state) => SizedBox(
                                width: sizeLibrary.appWidth(context, 60),
                                child: Text(
                                  state.address.address,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: sizeLibrary.appSize(12),
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    InkWell(
                      child: Icon(
                        Icons.settings,
                        size: sizeLibrary.appSize(24),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onTap: () => context.pushNamed('settings'),
                    ),
                  ],
                ),
                SizedBox(
                  height: sizeLibrary.appSize(150),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Fajr",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: sizeLibrary.appSize(34),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "05:30:45",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: sizeLibrary.appSize(12),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "فجر",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: sizeLibrary.appSize(16),
                                fontFamily: "Lateef",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            BlocProvider.of<HomeCubit>(context)
                                .changeToPrevDate();
                          },
                          child: Icon(
                            Icons.arrow_left_rounded,
                            size: sizeLibrary.appSize(40),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Expanded(
                          child: BlocBuilder<HomeCubit, HomeState>(
                            builder: (context, state) {
                              return InkWell(
                                onTap: () {
                                  BlocProvider.of<HomeCubit>(context)
                                      .changeToToday();
                                },
                                child: Text(
                                  DateFormat('EEE dd MMM, yyyy')
                                      .format(state.dateTime)
                                      .toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: sizeLibrary.appSize(12),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            BlocProvider.of<HomeCubit>(context)
                                .changeToNextDate();
                          },
                          child: Icon(
                            Icons.arrow_right_rounded,
                            size: sizeLibrary.appSize(40),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Card(
                      color: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(sizeLibrary.appSize(12)),
                        child: BlocBuilder<HomeCubit, HomeState>(
                          builder: (context, state) {
                            final List<PrayerTime> prayers =
                                _prayerTimeLibrary.prayers(state.dateTime);
                            return ListView.separated(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final PrayerTime prayer = prayers[index];

                                return Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        prayer.name.english,
                                        style: TextStyle(
                                          fontSize: sizeLibrary.appSize(12),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        DateFormat('hh:mm a')
                                            .format(prayer.startTime),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: sizeLibrary.appSize(16),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        prayer.name.arabic,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: sizeLibrary.appSize(16),
                                          fontFamily: "Lateef",
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 12,
                                );
                              },
                              itemCount: prayers.length,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
