
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideadmin/controller/dash/bloc/dash_bloc.dart';
import 'package:rideadmin/core/color.dart';
import 'package:rideadmin/views/home/latest_trips.dart';
import 'package:rideadmin/widgets/drawer.dart';
import 'package:rideadmin/widgets/widgets.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    context.read<DashBloc>().add(FetchMostActiveDriversEvent());
    context.read<DashBloc>().add(FetchTotalCompletedTripsEvent());
    context.read<DashBloc>().add(FetchTotalTripReportEvent());

    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % 5;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Home Page',
        titleStyle: const TextStyle(color: AppColors.white),
        onLeadingPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        backgroundColor: AppColors.primaryColor,
        icon: const Icon(Icons.menu, color: AppColors.white),
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Dashboard Overview",
                style: TextStyle(fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.02),
              const DashboardRow(),
              SizedBox(height: screenHeight * 0.03),
              Text(
                "Most Active Drivers",
                style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.02),
              const ActiveDriversSection(),
              SizedBox(height: screenHeight * 0.03),
              Text(
                "Trips Overview",
                style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.02),
              const TripsOverviewSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardRow extends StatelessWidget {
  const DashboardRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LatestTrips()));
          },
          child: _buildMetricCard(
            title: 'Latest Trips',
            value: '',
            icon: Icons.directions_car,
            color: Colors.blue,
          ),
        ),
        Expanded(
          child: _buildMetricCard(
            title: 'Total Trips',
            value: context.select((DashBloc bloc) {
              final state = bloc.state;
              if (state is DashLoaded) {
                return state.totalTripsCompleted?['data'].toString() ?? 'NA';
              }
              return 'Loading...';
            }),
            icon: Icons.check_circle,
            color: Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 40),
          const SizedBox(height: 10),
          Text(title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}




class ActiveDriversSection extends StatelessWidget {
  const ActiveDriversSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashBloc, DashState>(
      builder: (context, state) {
        if (state is DashLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DashLoaded) {
          final activeDrivers = state.mostActiveDrivers;

          if (activeDrivers != null && activeDrivers.isNotEmpty) {
            return Center(
              child: SizedBox(
                height: 200,
                child: activeDrivers.length == 1
                    ? _buildActiveDriverCard(activeDrivers[0])
                    : PageView.builder(
                        controller: PageController(viewportFraction: 0.8),
                        itemCount: activeDrivers.length,
                        itemBuilder: (context, index) {
                          return _buildActiveDriverCard(
                              activeDrivers[index]);
                        },
                      ),
              ),
            );
          }
          return const Center(child: Text('No Active Drivers'));
        } else if (state is DashError) {
          return Center(child: Text(state.error));
        } else {
          return const Center(child: Text('No Data'));
        }
      },
    );
  }

  Widget _buildActiveDriverCard(Map<String, dynamic> activeDriver) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Text(
            'Most Active Driver',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Name: ${activeDriver['name'] ?? 'N/A'}',
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            'Completed Trips: ${activeDriver['completedTrips'] ?? 'N/A'}',
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            'Email: ${activeDriver['email'] ?? 'N/A'}',
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            'License: ${activeDriver['licenseNumber'] ?? 'N/A'}',
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class TripsOverviewSection extends StatelessWidget {
  const TripsOverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF282F34),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 8,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
        child: BlocBuilder<DashBloc, DashState>(
          builder: (context, state) {
            if (state is DashLoading) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.white));
            } else if (state is DashLoaded) {
              final tripReport = state.totalTripReport?['tripStat'];
              if (tripReport != null && tripReport.isNotEmpty) {
                Map<String, double> weekData = {
                  'week1': 0.0,
                  'week2': 0.0,
                  'week3': 0.0,
                  'week4': 0.0,
                };

                for (var report in tripReport) {
                  final week = report.keys.first;
                  final value = report[week];
                  if (weekData.containsKey(week)) {
                    weekData[week] =
                        double.tryParse(value.toString()) ?? 0.0;
                  }
                }

                List<BarChartGroupData> barGroups = [];
                List<Color> barColors = [
                  const Color(0xFF646EFD),
                  Colors.green,
                  Colors.orange,
                  Colors.red,
                ];

                int colorIndex = 0;
                weekData.forEach((week, value) {
                  int weekNumber = int.parse(week.replaceAll('week', ''));
                  barGroups.add(
                    BarChartGroupData(
                      x: weekNumber,
                      barRods: [
                        BarChartRodData(
                          toY: value,
                          color: barColors[colorIndex % barColors.length],
                          width: 20,
                        ),
                      ],
                    ),
                  );
                  colorIndex++;
                });

                double maxY = weekData.values.isNotEmpty
                    ? weekData.values.reduce((a, b) => a > b ? a : b) * 1.2
                    : 5;

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: weekData.keys
                          .toList()
                          .asMap()
                          .entries
                          .map((entry) {
                        int index = entry.key;
                        String week = entry.value;
                        return Row(
                          children: [
                            Container(
                              width: 20,
                              height: 10,
                              color: barColors[index % barColors.length],
                            ),
                            const SizedBox(width: 4),
                            Text(week,
                                style:
                                    const TextStyle(color: Colors.white)),
                          ],
                        );
                      }).toList(),
                    ),
                    Expanded(
                      child: BarChart(
                        BarChartData(
                          gridData: const FlGridData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toStringAsFixed(0),
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 14),
                                  );
                                },
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 32,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toStringAsFixed(0),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 32,
                                getTitlesWidget: (value, meta) {
                                  switch (value.toInt()) {
                                    case 1:
                                      return const Text(
                                        'W1',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      );
                                    case 2:
                                      return const Text(
                                        'W2',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      );
                                    case 3:
                                      return const Text(
                                        'W3',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      );
                                    case 4:
                                      return const Text(
                                        'W4',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      );
                                    default:
                                      return const Text('');
                                  }
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: barGroups,
                          minY: 0,
                          maxY: maxY,
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const Center(
                  child: Text('No Data',
                      style: TextStyle(color: Colors.white)));
            } else if (state is DashError) {
              return Center(
                  child: Text(state.error,
                      style: const TextStyle(color: Colors.white)));
            } else {
              return const Center(
                  child: Text('No Data',
                      style: TextStyle(color: Colors.white)));
            }
          },
        ),
      ),
    );
  }
}
