import 'package:flutter/material.dart';

class SingleDropdownFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Single Dropdown Filter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilter(
              title: "By Fuel Type",
              options: ["Petrol", "Diesel", "CNG", "LPG"],
            ),
            Divider(),
            _buildFilter(
              title: "By Number of Owner",
              options: ["First", "Second", "Third", "Fourth"],
            ),
            Divider(),
            _buildFilter(
              title: "By Budget",
              options: ["1L-5L", "5L-10L", "10L-15L", "30L+"],
            ),
            Divider(),
            _buildColorFilter(
              title: "By Colour",
              colors: [
                Colors.black,
                Colors.grey,
                Colors.red,
                Colors.blue,
                Colors.green,
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilter({
    required String title,
    required List<String> options,
  }) {
    return ExpansionTile(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      children: [
        Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: options.map((option) {
            return ChoiceChip(
              label: Text(option),
              selected: false,
              onSelected: (selected) {
                debugPrint('Selected: $option');
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildColorFilter({
    required String title,
    required List<Color> colors,
  }) {
    return ExpansionTile(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      children: [
        Wrap(
          spacing: 10.0,
          children: colors.map((color) {
            return GestureDetector(
              onTap: () {
                debugPrint('Selected color: $color');
              },
              child: CircleAvatar(
                backgroundColor: color,
                radius: 16.0,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SingleDropdownFilter(),
  ));
}
