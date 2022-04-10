import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taukeet/config.dart';
import 'package:taukeet/services/adhan_prayer_service.dart';

class PrayerCard extends StatelessWidget {
  final PrayerTime prayer;

  const PrayerCard({Key? key, required this.prayer}) : super(key: key);

  final cardTimeStyle = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Color(0xff191923),
  );

  final cardTimeLabelStyle = const TextStyle(
    fontSize: 20,
    color: Color(0xff191923),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: App(context).appHeight(.5),
        left: App(context).appWidth(4),
        right: App(context).appWidth(4),
      ),
      child: Card(
        color: const Color(0xffF0E7D8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      prayer.name.english,
                      style: TextStyle(
                        fontSize: App(context).appWidth(6),
                        color: const Color(0xff191923),
                        fontFamily: "Lateef",
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Center(
                      child: Text(
                        DateFormat("hh:mm a").format(prayer.startTime),
                        style: TextStyle(
                          fontSize: App(context).appWidth(8),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: const Color(0xff191923),
                          fontFamily: "Lateef",
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      prayer.name.arabic,
                      style: TextStyle(
                        fontSize: App(context).appWidth(6),
                        color: const Color(0xff191923),
                        fontFamily: "Lateef",
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
