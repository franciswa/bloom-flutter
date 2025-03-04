import 'package:flutter/material.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const ColorTestApp());
}

class ColorTestApp extends StatelessWidget {
  const ColorTestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color Test',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          primaryContainer: AppColors.primaryVariant,
          secondary: AppColors.secondary,
          secondaryContainer: AppColors.secondaryVariant,
          onPrimary: AppColors.onPrimary,
          onSecondary: AppColors.onSecondary,
        ),
      ),
      home: const ColorTestScreen(),
    );
  }
}

class ColorTestScreen extends StatelessWidget {
  const ColorTestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Test'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Primary Colors',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildColorBox('Primary', AppColors.primary),
            _buildColorBox('Primary Variant', AppColors.primaryVariant),
            _buildColorBox('Primary Light', AppColors.primaryLight),
            const SizedBox(height: 16),
            const Text(
              'Secondary Colors',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildColorBox('Secondary', AppColors.secondary),
            _buildColorBox('Secondary Variant', AppColors.secondaryVariant),
            _buildColorBox('Secondary Light', AppColors.secondaryLight),
            const SizedBox(height: 16),
            const Text(
              'Text on Primary Colors',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildTextOnColorBox(
                'Text on Primary', AppColors.primary, AppColors.onPrimary),
            const SizedBox(height: 16),
            const Text(
              'Text on Secondary Colors',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildTextOnColorBox('Text on Secondary', AppColors.secondary,
                AppColors.onSecondary),
            const SizedBox(height: 16),
            const Text(
              'UI Components with New Colors',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Elevated Button'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {},
              child: const Text('Outlined Button'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {},
              child: const Text('Text Button'),
            ),
            const SizedBox(height: 8),
            Switch(value: true, onChanged: (_) {}),
            const SizedBox(height: 8),
            Checkbox(value: true, onChanged: (_) {}),
            const SizedBox(height: 8),
            Slider(value: 0.5, onChanged: (_) {}),
          ],
        ),
      ),
    );
  }

  Widget _buildColorBox(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 50,
            color: color,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label),
                Text(
                  '0x${color.value.toRadixString(16).toUpperCase()}',
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextOnColorBox(String label, Color bgColor, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            width: 150,
            height: 50,
            color: bgColor,
            alignment: Alignment.center,
            child: Text(
              'Sample Text',
              style: TextStyle(color: textColor),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label),
                Text(
                  'Text: 0x${textColor.value.toRadixString(16).toUpperCase()}',
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
