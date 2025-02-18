import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:rideadmin/repositories/driver_service.dart';
import 'package:rideadmin/widgets/status.dart';

part 'driver_event.dart';
part 'driver_state.dart';

class DriverBloc extends Bloc<DriverEvent, DriverState> {
  final DriverApiService driverApiService;

  List<Map<String, dynamic>> originalDrivers = [];

  DriverBloc({required this.driverApiService}) : super(DriverInitial()) {
    on<FetchDrivers>(_onFetchDrivers);
    on<FetchDriverDetails>(_fetchDriverDetails);
    on<AcceptDriver>(_onAcceptDriver);
    on<BlockUnBlocDriver>(_onBlockUnBlocDriver);
    on<SearchDriver>(_onSearchDriver);
    on<FilterDriver>(_onFilterDriver);
  }

  FutureOr<void> _onFetchDrivers(
      FetchDrivers event, Emitter<DriverState> emit) async {
    emit(DriverLoading());
    try {
      final drivers = await DriverApiService.getAllDrivers();
      originalDrivers = List<Map<String, dynamic>>.from(drivers);
      emit(DriverListLoaded(List.from(originalDrivers)));
    } catch (e) {
      emit(DriverError('Failed to load drivers: $e'));
    }
  }

  FutureOr<void> _fetchDriverDetails(
      FetchDriverDetails event, Emitter<DriverState> emit) async {
    emit(DriverLoading());
    try {
      final response = await DriverApiService.getDriverDetails(event.driverId);
      final driverDetails = response['driverDetails'];
      final vehicleDetails = driverDetails['vehicleDetails'];
      emit(DriverDetailLoaded(
          driverDetails: driverDetails, vehicleDetails: vehicleDetails));
    } catch (e) {
      emit(DriverError('Failed to load driver details: $e'));
    }
  }

  FutureOr<void> _onAcceptDriver(
      AcceptDriver event, Emitter<DriverState> emit) async {
    emit(DriverLoading());
    try {
      await driverApiService.acceptDriver(event.driverId);
      // ignore: unused_local_variable
      final response = await DriverApiService.getDriverDetails(event.driverId);
      emit(DriverButtonState(isAccepted: true, isBlocked: false));
      StatusDialog.show(
        context: event.context,
        message: 'Driver accepted successfully.',
      );
    } catch (e) {
      emit(DriverError("Failed to accept driver: $e"));
      StatusDialog.show(
        context: event.context,
        message: 'Failed to accept driver: $e',
      );
    }
  }

  FutureOr<void> _onBlockUnBlocDriver(
      BlockUnBlocDriver event, Emitter<DriverState> emit) async {
    emit(DriverLoading());
    try {
      await driverApiService.blocunblocDriver(event.driverId, event.isBlocked);
      // ignore: unused_local_variable
      final response = await DriverApiService.getDriverDetails(event.driverId);
      emit(DriverButtonState(isAccepted: true, isBlocked: event.isBlocked));
      StatusDialog.show(
        context: event.context,
        message: event.isBlocked
            ? 'Driver blocked successfully.'
            : 'Driver unblocked successfully.',
      );
    } catch (e) {
      emit(DriverError("Failed to update driver status: $e"));
      StatusDialog.show(
        context: event.context,
        message: 'Failed to update driver status: $e',
      );
    }
  }

  FutureOr<void> _onSearchDriver(
      SearchDriver event, Emitter<DriverState> emit) async {
    final currentState = state;
    if (currentState is DriverListLoaded) {
      if (event.query.isEmpty) {
        // Reset to the original drivers list
        final originalDrivers = await DriverApiService.getAllDrivers();
        emit(DriverListLoaded(originalDrivers));
      } else {
        // Filter drivers based on query
        var filteredDrivers = currentState.drivers
            .where((driver) =>
                driver['name']
                    .toLowerCase()
                    .contains(event.query.toLowerCase()) ||
                driver['email']
                    .toLowerCase()
                    .contains(event.query.toLowerCase()))
            .toList();
        emit(DriverListLoaded(filteredDrivers));
      }
    }
  }

  FutureOr<void> _onFilterDriver(
      FilterDriver event, Emitter<DriverState> emit) {
    var filteredDrivers = List<Map<String, dynamic>>.from(originalDrivers);

    if (event.status != 'All') {
      filteredDrivers = filteredDrivers
          .where((driver) =>
              driver['isAccepted'] == (event.status == 'Approved') &&
              driver['isBlocked'] != true)
          .toList();
    }

    if (event.query.isNotEmpty) {
      filteredDrivers = filteredDrivers
          .where((driver) =>
              driver['name']
                  ?.toLowerCase()
                  .contains(event.query.toLowerCase()) ??
              false ||
                  driver['email']
                      ?.toLowerCase()
                      .contains(event.query.toLowerCase()) ??
              false)
          .toList();
    }

    emit(DriverListLoaded(filteredDrivers));
  }
}
