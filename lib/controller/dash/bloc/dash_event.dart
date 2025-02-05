part of 'dash_bloc.dart';

@immutable
sealed class DashEvent {}



class FetchLatestTripsEvent extends DashEvent {}

class FetchMostActiveDriversEvent extends DashEvent {}

class FetchTotalCompletedTripsEvent extends DashEvent {}
class FetchTotalTripReportEvent extends DashEvent{}