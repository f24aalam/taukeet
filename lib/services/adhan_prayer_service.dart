import 'package:adhan/adhan.dart';
import 'package:taukeet/contracts/prayer_service.dart';
import 'package:taukeet/contracts/storage_service.dart';

class PrayerTime {
  final String prayer;
  final DateTime startTime;
  final DateTime endTime;
  final bool isCurrentPrayer;

  PrayerTime({
    required this.prayer,
    required this.startTime,
    required this.endTime,
    this.isCurrentPrayer = false,
  });
}

class AdhanPrayerService extends PrayerService {
  late Coordinates coordinates;
  late CalculationParameters params;
  late Madhab madhab;
  late PrayerTimes prayerTimes;

  @override
  void refreshTimes(StorageService storageService) {
    CalculationMethod method = CalculationMethod.values.byName(
        storageService.getString("calculationMethod") ?? 'muslim_world_league');

    coordinates = Coordinates(storageService.getDouble('lattitude') ?? 24.5247,
        storageService.getDouble('longitude') ?? 39.5692);
    madhab = storageService.getString("madhab") == "hanfi"
        ? Madhab.hanafi
        : Madhab.shafi;

    params = method.getParameters();
    params.madhab = madhab;

    prayerTimes = _getPrayerTimes(DateTime.now());
  }

  /// Return current prayer and ending time
  @override
  PrayerTime getCurrentPrayer() {
    Prayer prayer = prayerTimes.currentPrayer();
    Prayer nextPrayer = prayerTimes.nextPrayer() == Prayer.none
        ? Prayer.fajr
        : prayerTimes.nextPrayer();

    DateTime endTime;
    DateTime startTime;

    if (prayer == Prayer.isha && prayerTimes.nextPrayer() == Prayer.none) {
      // it's end of the day and we don't have next prayer,
      // so we need to get fajar end time for tomorrow

      var today = DateTime.now();
      var tomorrow = today.add(const Duration(days: 1));
      var tomorrowPareyerTimes = _getPrayerTimes(tomorrow);

      startTime = prayerTimes.timeForPrayer(prayer)!;
      endTime = tomorrowPareyerTimes.timeForPrayer(Prayer.fajr)!;
    } else if (prayer == Prayer.none &&
        prayerTimes.nextPrayer() == Prayer.fajr) {
      // it's start of the day and we don't have current prayer,
      // so we need to get isha start time for yesterday.

      prayer = Prayer.isha;

      var today = DateTime.now();
      var yesterday = today.subtract(const Duration(days: 1));
      var yesterdayPareyerTimes = _getPrayerTimes(yesterday);

      startTime = yesterdayPareyerTimes.timeForPrayer(Prayer.isha)!;
      endTime = prayerTimes.timeForPrayer(nextPrayer)!;
    } else {
      startTime = prayerTimes.timeForPrayer(prayer)!;
      endTime = prayerTimes.timeForPrayer(nextPrayer)!;
    }

    return PrayerTime(
      prayer: _getPrayerName(prayer),
      startTime: startTime,
      endTime: endTime,
    );
  }

  /// Return the list of PrayerTime Object
  @override
  List<PrayerTime> getPrayerTimes() {
    List<PrayerTime> times = [];

    for (var prayer in Prayer.values) {
      switch (prayer) {
        case Prayer.none:
          break;
        case Prayer.fajr:
          times.add(PrayerTime(
            prayer: 'fajr',
            startTime: prayerTimes.fajr,
            endTime: prayerTimes.sunrise,
            isCurrentPrayer: prayerTimes.currentPrayer() == Prayer.fajr,
          ));
          break;
        case Prayer.sunrise:
          times.add(PrayerTime(
            prayer: 'sunrise',
            startTime: prayerTimes.sunrise,
            endTime: prayerTimes.dhuhr,
            isCurrentPrayer: prayerTimes.currentPrayer() == Prayer.sunrise,
          ));
          break;
        case Prayer.dhuhr:
          times.add(PrayerTime(
            prayer: 'dhuhr',
            startTime: prayerTimes.dhuhr,
            endTime: prayerTimes.asr,
            isCurrentPrayer: prayerTimes.currentPrayer() == Prayer.dhuhr,
          ));
          break;
        case Prayer.asr:
          times.add(PrayerTime(
            prayer: 'asr',
            startTime: prayerTimes.asr,
            endTime: prayerTimes.maghrib,
            isCurrentPrayer: prayerTimes.currentPrayer() == Prayer.asr,
          ));
          break;
        case Prayer.maghrib:
          times.add(PrayerTime(
            prayer: 'maghrib',
            startTime: prayerTimes.maghrib,
            endTime: prayerTimes.isha,
            isCurrentPrayer: prayerTimes.currentPrayer() == Prayer.maghrib,
          ));
          break;
        case Prayer.isha:
          times.add(PrayerTime(
            prayer: 'isha',
            startTime: prayerTimes.isha,
            endTime: prayerTimes.fajr,
            isCurrentPrayer: prayerTimes.currentPrayer() == Prayer.maghrib,
          ));
          break;
      }
    }

    return times;
  }

  @override
  List<CalculationMethod> get calculationMethods => CalculationMethod.values;

  /// return the strring name of prayer
  String _getPrayerName(Prayer prayer) {
    switch (prayer) {
      case Prayer.none:
        return "none";
      case Prayer.fajr:
        return "fajr";
      case Prayer.sunrise:
        return "sunrise";
      case Prayer.dhuhr:
        return "dhuhr";
      case Prayer.asr:
        return "asr";
      case Prayer.maghrib:
        return "maghrib";
      case Prayer.isha:
        return "isha";
    }
  }

  PrayerTimes _getPrayerTimes(DateTime dateTime) {
    return PrayerTimes(
      coordinates,
      DateComponents.from(dateTime),
      params,
    );
  }
}
