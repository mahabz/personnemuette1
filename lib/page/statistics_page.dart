import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class StatisticsPage extends StatelessWidget {
  final Map<String, double> mutePercentages = {
    'Germany': 30.0,
    'USA': 25.0,
    'France': 18.0,
    'Japan': 15.0,
    'Tunisia': 12.0,
  };

  final Map<String, int> muteCount = {
    'Germany': 900000,
    'USA': 1200000,
    'France': 800000,
    'Japan': 600000,
    'Tunisia': 400000,
  };

  final Map<String, int> totalPopulation = {
    'Germany': 83000000,
    'USA': 331000000,
    'France': 67000000,
    'Japan': 125000000,
    'Tunisia': 12000000,
  };

  StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Tri par pourcentage décroissant
    final sortedCountries = mutePercentages.keys.toList()
      ..sort((a, b) => mutePercentages[b]!.compareTo(mutePercentages[a]!));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300], // couleur gris clair
        title: const Text("Mute Statistics"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.grey[100],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200], // fond gris clair
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12),
              child: const Text(
                "Mute Percentage by Country",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              "Below is a summary of mute individuals by country:",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 16),

            PieChart(
              dataMap: mutePercentages,
              animationDuration: const Duration(milliseconds: 800),
              chartType: ChartType.disc,
              chartRadius: MediaQuery.of(context).size.width / 2.2,
              colorList: [
                Colors.blueAccent,
                Colors.redAccent,
                Colors.green,
                Colors.orange,
                Colors.purple,
              ],
              chartValuesOptions: const ChartValuesOptions(
                showChartValuesInPercentage: true,
                showChartValues: true,
              ),
              legendOptions: const LegendOptions(
                showLegendsInRow: false,
                legendPosition: LegendPosition.right,
                showLegends: true,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: sortedCountries.length,
                itemBuilder: (context, index) {
                  final country = sortedCountries[index];
                  final percentage = mutePercentages[country] ?? 0.0;
                  final count = muteCount[country] ?? 0;
                  final population = totalPopulation[country] ?? 0;

                  return Card(
                    color: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green[100],
                        child: Text("#${index + 1}"),
                      ),
                      title: Text(
                        "$country - ${count.toString().replaceAllMapped(RegExp(r"(\d)(?=(\d{3})+(?!\d))"), (match) => "${match[1]},")} people",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Population: ${population.toString().replaceAllMapped(RegExp(r"(\d)(?=(\d{3})+(?!\d))"), (match) => "${match[1]},")}"),
                      trailing: Text(
                        '${percentage.toStringAsFixed(2)}%',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),
            Text(
              "Total Countries: ${mutePercentages.length}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
