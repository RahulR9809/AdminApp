import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:rideadmin/core/color.dart';
import 'package:rideadmin/widgets/drawer.dart';
import 'package:rideadmin/widgets/widgets.dart';
 final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
class AdminHomePage extends StatelessWidget {
  final int latestTripsCount = 120;
  final String mostActiveDriver = "John Doe";
  final int totalTripsCompleted = 350;

  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
       appBar: CustomAppBar(
        title: 'Home Page',titleStyle: const TextStyle(color: AppColors.white),
        onLeadingPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        backgroundColor: AppColors.primaryColor,
        icon: const Icon(Icons.menu,color: AppColors.white,), // You can replace with any icon
      ),
       drawer: const CustomDrawer(), 
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Dashboard Overview",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMetricCard(
                    title: 'Latest Trips',
                    value: latestTripsCount.toString(),
                    icon: Icons.directions_car,
                    color: Colors.blue,
                  ),
                  _buildMetricCard(
                    title: 'Most Active Driver',
                    value: mostActiveDriver,
                    icon: Icons.person,
                    color: Colors.green,
                  ),
                  _buildMetricCard(
                    title: 'Total Trips',
                    value: totalTripsCompleted.toString(),
                    icon: Icons.check_circle,
                    color: Colors.purple,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              const Text(
                "Trips Overview",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: LineChart(
  LineChartData(
    gridData: const FlGridData(show: true),
    titlesData: FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            return Text(
              value.toInt().toString(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            );
          },
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTitlesWidget: (value, meta) {
            return Text(
              'Day ${value.toInt()}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            );
          },
        ),
      ),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    ),
    borderData: FlBorderData(
      show: true,
      border: Border.all(color: Colors.black26),
    ),
    lineBarsData: [
      LineChartBarData(
        spots: [
          const FlSpot(1, 20),
          const FlSpot(2, 30),
          const FlSpot(3, 40),
          const FlSpot(4, 25),
          const FlSpot(5, 50),
        ],
        isCurved: true,
        color: Colors.blue,
        barWidth: 4,
        belowBarData: BarAreaData(
          show: true,
          color: Colors.blue.withOpacity(0.3),
        ),
      ),
    ],
  ),
)

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
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
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
