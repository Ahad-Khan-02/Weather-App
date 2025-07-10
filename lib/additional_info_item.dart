import 'package:flutter/material.dart';

class AdditionalInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final dynamic value;
  const AdditionalInfoItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Icon(
                icon,
              ),
              Text(
                label,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                value.toString(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
