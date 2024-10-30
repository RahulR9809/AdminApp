import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:rideadmin/controller/driver_service.dart';

part 'driver_event.dart';
part 'driver_state.dart';

class DriverBloc extends Bloc<DriverEvent, DriverState> {
  final DriverApiService driverApiService;

  DriverBloc({required this.driverApiService}) : super(DriverInitial()) {
    on<FetchDrivers>(_onFetchDrivers);
    on<FetchDriverDetails>(_fetchDriverDetails);
    on<AcceptDriver>(_onAccepDriver);
    on<BlockUnBlocDriver>(_onBlockUnBlocDriver);
  }

  FutureOr<void> _onFetchDrivers(FetchDrivers event, Emitter<DriverState> emit) async {
    emit(DriverLoading());
    try {
      final drivers = await DriverApiService.getAllDrivers();
      emit(DriverListLoaded(drivers));
                //  print("Driver details fetched: $drivers");

    } catch (e) {
      print("Error fetching drivers: $e");
      emit(DriverError('Failed to load drivers: $e'));
    }
  }

  FutureOr<void> _fetchDriverDetails(FetchDriverDetails event, Emitter<DriverState> emit) async {
    emit(DriverLoading());
    try {
      final response = await DriverApiService.getDriverDetails(event.driverId);
      final driverDetails = response['driverDetails'];
      final vehicleDetails = driverDetails['vehicleDetails'];
      emit(DriverDetailLoaded(driverDetails: driverDetails, vehicleDetails: vehicleDetails));
     
    } catch (e) {
      emit(DriverError('Failed to load driver details: $e'));
    }
  }

  FutureOr<void> _onAccepDriver(AcceptDriver event, Emitter<DriverState> emit) async {
    emit(DriverLoading());
    try {
      await driverApiService.acceptDriver(event.driverId,);
      // print("Driver accepted successfully: ${event.driverId}");
      emit(DriverActionSuccess('Driver accepted'));
    } catch (e) {
      print("Error accepting driver: $e");
      emit(DriverError("Failed to accept driver: $e"));
    }
  }

  FutureOr<void> _onBlockUnBlocDriver(BlockUnBlocDriver event, Emitter<DriverState> emit) async {
    print("Updating block status for driver ID: ${event.driverId}, isBlocked: ${event.isBlocked}");
        emit(DriverLoading());

    try {
      await driverApiService.blocunblocDriver(event.driverId, event.isBlocked);
      print("Driver block status updated successfully: ${event.isBlocked}");
      emit(DriverActionSuccess(event.isBlocked ? 'Driver Blocked' : 'Driver UnBlocked'));
    } catch (e) {
      print("Error updating driver block status: $e");
      emit(DriverError("Failed to update driver status: $e"));
    }
  }
}
