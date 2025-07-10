import 'package:flutter/material.dart';

class HourlyForcastItem extends StatelessWidget {
  final IconData icon;
  final String time;
  final String temp;
  const HourlyForcastItem({
    super.key,
    required this.icon,
    required this.time,
    required this.temp,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                time,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Icon(
                icon,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "$temp °C",
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
