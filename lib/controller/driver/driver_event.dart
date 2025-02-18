part of 'driver_bloc.dart';

@immutable
sealed class DriverEvent {}

class FetchDrivers extends DriverEvent {}

class FetchDriverDetails extends DriverEvent {
  final String driverId;

  FetchDriverDetails(
    this.driverId,
  );
}

class AcceptDriver extends DriverEvent {
  final String driverId;
  final BuildContext context;

  AcceptDriver(this.context, {required this.driverId});
}

class BlockUnBlocDriver extends DriverEvent {
  final String driverId;
  final bool isBlocked;
  final BuildContext context;

  BlockUnBlocDriver(this.context,
      {required this.driverId, required this.isBlocked});
}

class SearchDriver extends DriverEvent {
  final String query;
  SearchDriver(this.query);
}

class FilterDriver extends DriverEvent {
  final String status;
  final String query;
  FilterDriver(this.status, this.query);
}
