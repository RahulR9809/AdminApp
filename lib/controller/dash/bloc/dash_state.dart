part of 'dash_bloc.dart';

@immutable
sealed class DashState {}

class DashInitial extends DashState {}

class DashLoading extends DashState {}

class LatestTripLoaded extends DashState{
    final Map<String, dynamic> latestTrips;

  LatestTripLoaded({required this.latestTrips});

}


class DashLoaded extends DashState {
  final List<dynamic>? mostActiveDrivers;
  final Map<String, dynamic>? totalTripsCompleted;
    final    Map<String, dynamic>? totalTripReport;

  DashLoaded({this.mostActiveDrivers, this.totalTripsCompleted,this.totalTripReport});

  DashLoaded copyWith({
    List<dynamic>? mostActiveDrivers,
    Map<String, dynamic>? totalTripsCompleted,
        Map<String, dynamic>? totalTripReport,

  }) {
    return DashLoaded(
      mostActiveDrivers: mostActiveDrivers ?? this.mostActiveDrivers,
      totalTripsCompleted: totalTripsCompleted ?? this.totalTripsCompleted,
      totalTripReport:totalTripReport??this.totalTripReport
    );
  }
}

class DashError extends DashState {
  final String error;
  DashError(this.error);
}

