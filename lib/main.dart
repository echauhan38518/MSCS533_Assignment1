import 'package:flutter/material.dart';

void main() {
  runApp(const UnitConverterApp());
}

class UnitConverterApp extends StatelessWidget {
  const UnitConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unit Converter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ConverterScreen(),
    );
  }
}

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final TextEditingController _controller = TextEditingController(text: "1");

  String _fromUnit = 'Miles';
  String _toUnit = 'Kilometers';
  String _resultText = '';

  // Units grouped by category
  final Map<String, List<String>> _units = {
    'Distance': ['Miles', 'Kilometers'],
    'Weight': ['Kilograms', 'Pounds'],
  };

  // Abbreviations for units
  final Map<String, String> _unitAbbr = {
    'Miles': 'mi',
    'Kilometers': 'km',
    'Kilograms': 'kg',
    'Pounds': 'lbs',
  };

  /// Determine the category of the selected unit
  String _getCategory(String unit) {
    for (var category in _units.keys) {
      if (_units[category]!.contains(unit)) return category;
    }
    return 'Distance';
  }

  /// Perform conversion and update result text
  void _convert() {
    final double input = double.tryParse(_controller.text) ?? 1;
    String category = _getCategory(_fromUnit);
    double converted = input;

    if (category == 'Distance') {
      if (_fromUnit == 'Miles' && _toUnit == 'Kilometers') {
        converted = input * 1.60934;
      } else if (_fromUnit == 'Kilometers' && _toUnit == 'Miles') {
        converted = input / 1.60934;
      }
    } else if (category == 'Weight') {
      if (_fromUnit == 'Kilograms' && _toUnit == 'Pounds') {
        converted = input * 2.20462;
      } else if (_fromUnit == 'Pounds' && _toUnit == 'Kilograms') {
        converted = input / 2.20462;
      }
    }

    setState(() {
      // Show in the form: "1 kg = 2.20 lbs"
      _resultText =
          '${input.toStringAsFixed(2)} ${_unitAbbr[_fromUnit]} = ${converted.toStringAsFixed(2)} ${_unitAbbr[_toUnit]}';
    });
  }

  @override
  Widget build(BuildContext context) {
    // Automatically detect category from "From" unit
    String category = _getCategory(_fromUnit);
    List<String> currentUnits = _units[category]!;

    // Ensure _toUnit is valid for current category
    if (!currentUnits.contains(_toUnit)) _toUnit = currentUnits[1];

    return Scaffold(
      appBar: AppBar(title: const Text('Measures Converter')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Input value
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter value',
               // border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // From unit dropdown
            DropdownButtonFormField<String>(
              initialValue: _fromUnit,
              decoration: const InputDecoration(labelText: 'From'),
              items: _units.values
                  .expand((list) => list)
                  .map((unit) => DropdownMenuItem(
                        value: unit,
                        child: Text(unit),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _fromUnit = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // To unit dropdown (filtered based on From selection)
            DropdownButtonFormField<String>(
              initialValue: _toUnit,
              decoration: const InputDecoration(labelText: 'To'),
              items: currentUnits
                  .map((unit) => DropdownMenuItem(
                        value: unit,
                        child: Text(unit),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _toUnit = value);
              },
            ),
            const SizedBox(height: 20),

            // Convert button
            ElevatedButton(
              onPressed: _convert,
              child: const Text('Convert'),
            ),
            const SizedBox(height: 20),

            // Result display
            Text(
              _resultText,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
