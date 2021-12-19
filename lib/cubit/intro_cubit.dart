import 'dart:ffi';

import 'package:adhan/adhan.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taukeet/contracts/location_service.dart';
import 'package:taukeet/contracts/prayer_service.dart';

part 'intro_state.dart';

class IntroCubit extends Cubit<IntroState> {
  IntroCubit({
    required PrayerService prayerService,
    required LocationService locationService,
  })  : _prayerService = prayerService,
        _locationService = locationService,
        super(const IntroState());

  final PrayerService _prayerService;
  final LocationService _locationService;

  void initialize() {
    emit(
      state.copyWith(
        calculationMethods: _prayerService.calculationMethods,
      ),
    );
  }

  void locateUser() async {
    emit(state.copyWith(
      isAddressFetching: true,
    ));

    final result = await _locationService.currentPosition();
    final placemark = await _locationService.positionAddress(
      result.latitude,
      result.longitude,
    );

    String address = placemark.administrativeArea ?? "";
    address =
        placemark.country != null ? address + ", " + placemark.country! : "";
    address = address != ""
        ? address
        : result.latitude.toString() + ", " + result.longitude.toString();

    emit(state.copyWith(
      isAddressFetching: false,
      isAddressFetched: true,
      address: address,
      latitude: result.latitude,
      longitude: result.longitude,
    ));
  }

  void changeCalculationMethod(String method) => emit(
        state.copyWith(
          calculationMethod: method,
        ),
      );

  void changeMadhab(String madhab) => emit(
        state.copyWith(
          madhab: madhab,
        ),
      );
}
