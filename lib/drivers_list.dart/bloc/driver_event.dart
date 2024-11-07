part of 'driver_bloc.dart';

@immutable
sealed class DriverEvent {}

class FetchDrivers extends DriverEvent{}


class FetchDriverDetails extends DriverEvent{
  final String driverId;

  FetchDriverDetails(this.driverId,);
}


class AcceptDriver extends DriverEvent{
  final String driverId;
  
  AcceptDriver( {required this.driverId});
}

class BlockUnBlocDriver extends DriverEvent{
  final String driverId;
  final bool isBlocked;

  BlockUnBlocDriver({required this.driverId, required this.isBlocked});
}