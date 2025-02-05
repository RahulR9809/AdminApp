// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
// import 'package:rideadmin/repositories/dash_service.dart';

// part 'dash_event.dart';
// part 'dash_state.dart';

// class DashBloc extends Bloc<DashEvent, DashState> {
//     final DashService dashService=DashService();

//   DashBloc() : super(DashInitial()) {
//     on<FetchLatestTripsEvent>(_onFetchLatestTrips);
//     on<FetchMostActiveDriversEvent>(_onFetchMostActiveDrivers);
//     on<FetchTotalCompletedTripsEvent>(_onFetchTotalCompletedTrips);
//   }


//    Future<void> _onFetchLatestTrips(
//     FetchLatestTripsEvent event,
//     Emitter<DashState> emit,
//   ) async {
//     emit(DashLoading());
//     try {
//       final latestTrips = await dashService.fetchLatestTrips();
//       emit(DashLoaded(latestTrips));
//     } catch (e) {
//       emit(DashError('Error fetching latest trips: $e'));
//     }
//   }

//   // Method for fetching most active drivers
//   Future<void> _onFetchMostActiveDrivers(
//     FetchMostActiveDriversEvent event,
//     Emitter<DashState> emit,
//   ) async {
//     emit(DashLoading());
//     try {
//       final activeDrivers = await dashService.fetchMostActiveDrivers();
//       emit(DashLoaded(activeDrivers));
//     } catch (e) {
//       emit(DashError('Error fetching active drivers: $e'));
//     }
//   }

//   // Method for fetching total completed trips
//   Future<void> _onFetchTotalCompletedTrips(
//     FetchTotalCompletedTripsEvent event,
//     Emitter<DashState> emit,
//   ) async {
//     emit(DashLoading());
//     try {
//       final totalTrips = await dashService.fetchTotalCompletedTrips();
//       emit(DashLoaded(totalTrips));
//     } catch (e) {
//       emit(DashError('Error fetching total completed trips: $e'));
//     }
//   }
// }



import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rideadmin/repositories/dash_service.dart';

part 'dash_event.dart';
part 'dash_state.dart';

class DashBloc extends Bloc<DashEvent, DashState> {
  final DashService dashService = DashService();

  DashBloc() : super(DashInitial()) {
    // on<FetchLatestTripsEvent>(_onFetchLatestTrips);
    on<FetchMostActiveDriversEvent>(_onFetchMostActiveDrivers);
    on<FetchTotalCompletedTripsEvent>(_onFetchTotalCompletedTrips);
        on<FetchTotalTripReportEvent>(_onFetchTotalReports);
      on<FetchLatestTripsEvent>(_onFetchLatestTrips);

  }

  Future<void> _onFetchLatestTrips(
    FetchLatestTripsEvent event,
    Emitter<DashState> emit,
  ) async {
    emit(DashLoading());
    try {
      final latestTrips = await dashService.fetchLatestTrips();
      emit(LatestTripLoaded(latestTrips: latestTrips)); // Adjusted to return all necessary data
    } catch (e) {
      emit(DashError('Error fetching latest trips: $e'));
    }
  }

  // Future<void> _onFetchMostActiveDrivers(
  //   FetchMostActiveDriversEvent event,
  //   Emitter<DashState> emit,
  // ) async {
  //   emit(DashLoading());
  //   try {
  //     final activeDrivers = await dashService.fetchMostActiveDrivers();
  //     emit(DashLoaded(null, activeDrivers['data'], null)); // Adjusted to return active drivers
  //   } catch (e) {
  //     emit(DashError('Error fetching active drivers: $e'));
  //   }
  // }

  // Future<void> _onFetchTotalCompletedTrips(
  //   FetchTotalCompletedTripsEvent event,
  //   Emitter<DashState> emit,
  // ) async {
  //   emit(DashLoading());
  //   try {
  //     final totalTrips = await dashService.fetchTotalCompletedTrips();
  //     emit(DashLoaded(null, null, totalTrips )); // Adjusted to return total trips
  //   } catch (e) {
  //     emit(DashError('Error fetching total completed trips: $e'));
  //   }
  // }


  Future<void> _onFetchMostActiveDrivers(
  FetchMostActiveDriversEvent event,
  Emitter<DashState> emit,
) async {
  try {
    final activeDrivers = await dashService.fetchMostActiveDrivers();

    if (state is DashLoaded) {
      emit((state as DashLoaded).copyWith(mostActiveDrivers: activeDrivers['data']));
    } else {
      emit(DashLoaded(mostActiveDrivers: activeDrivers['data']));
    }
  } catch (e) {
    emit(DashError('Error fetching active drivers: $e'));
  }
}

Future<void> _onFetchTotalCompletedTrips(
  FetchTotalCompletedTripsEvent event,
  Emitter<DashState> emit,
) async {
  try {
    final totalTrips = await dashService.fetchTotalCompletedTrips();

    if (state is DashLoaded) {
      emit((state as DashLoaded).copyWith(totalTripsCompleted: totalTrips));
    } else {
      emit(DashLoaded(totalTripsCompleted: totalTrips));
    }
  } catch (e) {
    emit(DashError('Error fetching total completed trips: $e'));
  }
}



Future<void> _onFetchTotalReports(
  FetchTotalTripReportEvent event,
  Emitter<DashState> emit,
) async {
  try {
    final Report = await dashService.fetchTripReport();

    if (state is DashLoaded) {
      emit((state as DashLoaded).copyWith(totalTripReport: Report));
    } else {
      emit(DashLoaded(totalTripsCompleted: Report));
    }
  } catch (e) {
    emit(DashError('Error fetching total completed trips: $e'));
  }
}


}
