import 'package:flutter/material.dart';

void main() {
  runApp(const TemperatureConverterApp());
}

class TemperatureConverterApp extends StatelessWidget {
  const TemperatureConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Converter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const TemperatureConverterPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

enum ConversionType { fToC, cToF }

class TemperatureConverterPage extends StatefulWidget {
  const TemperatureConverterPage({super.key});

  @override
  State<TemperatureConverterPage> createState() => _TemperatureConverterPageState();
}

class _TemperatureConverterPageState extends State<TemperatureConverterPage> {
  ConversionType _selectedConversion = ConversionType.fToC;
  final TextEditingController _inputController = TextEditingController();
  String? _result;
  final List<String> _history = [];
  final _formKey = GlobalKey<FormState>();

  void _convert() {
    if (!_formKey.currentState!.validate()) return;
    final input = double.tryParse(_inputController.text);
    if (input == null) return;
    double output;
    String conversion;
    if (_selectedConversion == ConversionType.fToC) {
      output = (input - 32) * 5 / 9;
      conversion = '${input.toStringAsFixed(2)} °F → ${output.toStringAsFixed(2)} °C';
    } else {
      output = (input * 9 / 5) + 32;
      conversion = '${input.toStringAsFixed(2)} °C → ${output.toStringAsFixed(2)} °F';
    }
    setState(() {
      _result = output.toStringAsFixed(2);
      _history.insert(0, conversion);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Converter'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ToggleButtons(
                    isSelected: [
                      _selectedConversion == ConversionType.fToC,
                      _selectedConversion == ConversionType.cToF
                    ],
                    onPressed: (index) {
                      setState(() {
                        _selectedConversion = ConversionType.values[index];
                        _result = null;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    selectedColor: Colors.white,
                    fillColor: Theme.of(context).colorScheme.primary,
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Fahrenheit → Celsius'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Celsius → Fahrenheit'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _inputController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: _selectedConversion == ConversionType.fToC
                          ? 'Enter temperature in °F'
                          : 'Enter temperature in °C',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      prefixIcon: const Icon(Icons.thermostat),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a value';
                      }
                      final n = double.tryParse(value);
                      if (n == null) {
                        return 'Enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _convert,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('CONVERT', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  if (_result != null) ...[
                    const SizedBox(height: 24),
                    Card(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'Converted Value:',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _selectedConversion == ConversionType.fToC
                                  ? '$_result °C'
                                  : '$_result °F',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  Text('History', style: Theme.of(context).textTheme.titleLarge),
                  const Divider(),
                  SizedBox(
                    height: isPortrait ? 120 : 80,
                    child: _history.isEmpty
                        ? const Center(child: Text('No conversions yet.'))
                        : ListView.builder(
                            itemCount: _history.length,
                            itemBuilder: (context, index) => ListTile(
                              leading: const Icon(Icons.history),
                              title: Text(_history[index]),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
