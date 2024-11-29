import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:rideadmin/widgets/drawer.dart';
import 'package:rideadmin/widgets/widgets.dart';
 final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
class AdminHomePage extends StatelessWidget {
  // Example data (replace with API integration)
  final int latestTripsCount = 120;
  final String mostActiveDriver = "John Doe";
  final int totalTripsCompleted = 350;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
       appBar: CustomAppBar(
        title: 'Home Page',
        onLeadingPressed: () {
          // Handle drawer open or any other action
          _scaffoldKey.currentState?.openDrawer();
        },
        backgroundColor: Colors.teal,
        icon: Icon(Icons.menu), // You can replace with any icon
      ),
       drawer: CustomDrawer(), 
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dashboard Header
              Text(
                "Dashboard Overview",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),

              // Metrics Row
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
              SizedBox(height: 24),

              // Chart Section
              Text(
                "Trips Overview",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
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
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: LineChart(
  LineChartData(
    gridData: FlGridData(show: true),
    titlesData: FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            return Text(
              value.toInt().toString(),
              style: TextStyle(
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
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            );
          },
        ),
      ),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    ),
    borderData: FlBorderData(
      show: true,
      border: Border.all(color: Colors.black26),
    ),
    lineBarsData: [
      LineChartBarData(
        spots: [
          FlSpot(1, 20),
          FlSpot(2, 30),
          FlSpot(3, 40),
          FlSpot(4, 25),
          FlSpot(5, 50),
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

  // Widget for Metric Cards
  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 40),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
