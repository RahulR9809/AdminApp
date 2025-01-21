part of 'driver_bloc.dart';

@immutable
sealed class DriverState {}

final class DriverInitial extends DriverState {}

class DriverLoading extends DriverState {}

class DriverListLoaded extends DriverState {
  final List<dynamic> drivers;
  DriverListLoaded(this.drivers);
}

class DriverDetailLoaded extends DriverState {
  final Map<String, dynamic> driverDetails;
  final Map<String, dynamic> vehicleDetails;

  DriverDetailLoaded(
      {required this.driverDetails, required this.vehicleDetails});
}

class DriverError extends DriverState {
  final String message;

  DriverError(this.message);
}

class DriverActionSuccess extends DriverState {
  final String message;

  DriverActionSuccess(this.message);
}

class DriverButtonState extends DriverState {
  final bool isAccepted;
  final bool isBlocked;
  DriverButtonState({required this.isAccepted, required this.isBlocked});
}
