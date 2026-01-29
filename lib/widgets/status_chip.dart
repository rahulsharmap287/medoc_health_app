import 'package:flutter/material.dart';
import '../models/claim_model.dart';

class StatusChip extends StatelessWidget {
  final ClaimStatus status;

  const StatusChip({super.key, required this.status});

  Color getColor() {
    switch (status) {
      case ClaimStatus.draft:
        return Colors.grey;
      case ClaimStatus.submitted:
        return Colors.blue;
      case ClaimStatus.approved:
        return Colors.green;
      case ClaimStatus.rejected:
        return Colors.red;
      case ClaimStatus.partiallySettled:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        status.name,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: getColor(),
    );
  }
}
