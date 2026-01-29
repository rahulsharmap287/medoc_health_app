import 'package:flutter/material.dart';
import '../models/bill_model.dart';

class BillTile extends StatelessWidget {
  final Bill bill;

  const BillTile({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.receipt_long),
        title: Text(bill.title),
        trailing: Text(
          "₹${bill.amount.toStringAsFixed(2)}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
