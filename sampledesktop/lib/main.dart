//CODE  displays pie chart with %
import 'dart:convert';
import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color pastelOrangeColor = Color.fromRGBO(253, 223, 196, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: Text('DATA ABOUT DEFECTS'),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0, bottom: 16.0),
        color: pastelOrangeColor,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Blue Box',
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(height: 20),
                      PieChartWidget(),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: AnotherBoxTable(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PieChartWidget extends StatefulWidget {
  @override
  _PieChartWidgetState createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  String selectedDefect = '';

  final jsonData = '''
    {
      "products": [
        {"id": 1, "name": "A1", "defects": ["Loose screws"]},
        {"id": 2, "name": "B1", "defects": ["Scratched surface"]},
        {"id": 3, "name": "C1", "defects": ["Loose screws"]},
        {"id": 4, "name": "D1", "defects": ["Overheating issue", "Loose screws"]},
        {"id": 5, "name": "E1", "defects": ["Overheating issue", "Loose screws"]},
        {"id": 6, "name": "F1", "defects": ["Loose screws"]},
        {"id": 7, "name": "G1", "defects": ["Scratched surface"]},
        {"id": 8, "name": "H1", "defects": ["Malfunctioning sensor"]},
        {"id": 9, "name": "I1", "defects": ["Loose screws"]},
        {"id": 10, "name": "J1", "defects": ["Overheating issue"]},
        {"id": 11, "name": "K1", "defects": ["Scratched surface"]},
        {"id": 12, "name": "L1", "defects": ["Scratched surface", "Malfunctioning sensor"]}
      ]
    }
  ''';

  @override
  Widget build(BuildContext context) {
    final data = json.decode(jsonData);
    final List<Map<String, dynamic>> products = List<Map<String, dynamic>>.from(data['products']);

    Map<String, Color> defectColors = {};
    List<String> allDefects = [];

    for (var product in products) {
      allDefects.addAll((product['defects'] as List<dynamic>).cast<String>());
    }

    Set<Color?> usedColors = {};

    int totalDefectsCount = allDefects.length;

    Map<String, double> defectsCountMap = {};

    for (var defect in allDefects) {
      if (!defectsCountMap.containsKey(defect)) {
        defectsCountMap[defect] = 1.0;
      } else {
        defectsCountMap[defect] = defectsCountMap[defect]! + 1.0;
      }
    }

    List<PieChartSectionData> pieChartSections = defectsCountMap.keys.map((defect) {
      Color? color;
      if (!defectColors.containsKey(defect)) {
        do {
          color = Colors.primaries[Math.Random().nextInt(Colors.primaries.length)];
        } while (usedColors.contains(color));

        usedColors.add(color);
        defectColors[defect] = color;
      } else {
        color = defectColors[defect];
      }

      return PieChartSectionData(
        color: color!,
        value: defectsCountMap[defect]!,
        title: '${(defectsCountMap[defect]! / totalDefectsCount * 100).toStringAsFixed(2)}%',
        titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
        radius: 50,
        showTitle: true,
        titlePositionPercentageOffset: 0.5,
        // titlePositionPercentageOffsetOrigin: 1,
        // titlePositionPercentageOffsetUnit: 1,
        // onTap: () {
        //   setState(() {
        //     selectedDefect = defect;
        //   });
        //   _showDefectDetails(context, defect, defectsCountMap[defect]!);
        // },
      );
    }).toList();

    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Container(
              height: 300,
              width: 500,
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.0),
              ),
              child: PieChart(
                PieChartData(
                  sectionsSpace: 4,
                  centerSpaceRadius: 70,
                  sections: pieChartSections,
                  borderData: FlBorderData(show: false),
                  //sectionsSpace: 0,
                  // centerSpaceRadius: 40,
                  // startDegreeOffset: 180,
                ),
              ),
            ),
            SizedBox(width: 120),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: defectColors.entries.map((entry) => Container(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      color: entry.value,
                    ),
                    SizedBox(width: 40),
                    Text(
                      '${entry.key}: ${defectsCountMap[entry.key]}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              )).toList(),
            ),
            SizedBox(height: 20),
            if (selectedDefect.isNotEmpty)
              Text(
                'Selected Defect: $selectedDefect',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }

  void _showDefectDetails(BuildContext context, String defect, double count) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Defect Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Defect: $defect'),
              Text('Count: $count'),
              // Add more details as needed
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class AnotherBoxTable extends StatelessWidget {
  final jsonData = '''
    {
      "products": [
        {"id": 1, "name": "A1", "defects": ["Loose screws"]},
        {"id": 2, "name": "B1", "defects": ["Scratched surface"]},
        {"id": 3, "name": "C1", "defects": ["Loose screws"]},
        {"id": 4, "name": "D1", "defects": ["Overheating issue", "Loose screws"]},
        {"id": 5, "name": "E1", "defects": ["Overheating issue", "Loose screws"]},
        {"id": 6, "name": "F1", "defects": ["Loose screws"]},
        {"id": 7, "name": "G1", "defects": ["Scratched surface"]},
        {"id": 8, "name": "H1", "defects": ["Malfunctioning sensor"]},
        {"id": 9, "name": "I1", "defects": ["Loose screws"]},
        {"id": 10, "name": "J1", "defects": ["Overheating issue"]},
        {"id": 11, "name": "K1", "defects": ["Scratched surface"]},
        {"id": 12, "name": "L1", "defects": ["Scratched surface", "Malfunctioning sensor"]}
      ]
    }
  ''';

  @override
  Widget build(BuildContext context) {
    final data = json.decode(jsonData);
    final List<Map<String, dynamic>> products = List<Map<String, dynamic>>.from(data['products']);

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Defects')),
        ],
        rows: products.map((product) {
          return DataRow(
            cells: [
              DataCell(Text(product['id'].toString())),
              DataCell(Text(product['name'])),
              DataCell(Text(product['defects'].join(", "))),
            ],
          );
        }).toList(),
      ),
    );
  }
}







