import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/claim_model.dart';
import '../models/bill_model.dart';
import '../providers/claim_provider.dart';
import '../widgets/bill_tile.dart';
import '../widgets/status_chip.dart';

class ClaimDetailScreen extends StatelessWidget {
  final Claim claim;
  const ClaimDetailScreen({super.key, required this.claim});

  @override
  Widget build(BuildContext context) {
    return Consumer<ClaimProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Colors.grey[50], // Light background for better contrast
          appBar: AppBar(title: const Text("Claim Details")),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderCard(claim),
                const SizedBox(height: 24),
                const Text("Bills", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 12),
                _buildBillList(claim), // FIX: niche defined hai
                const Divider(height: 40),
                _buildInputSection(provider, claim),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddBillSheet(context),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  // FIX: Missing _buildBillList implementation
  Widget _buildBillList(Claim claim) {
    if (claim.bills.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: Text("No bills added yet.", style: TextStyle(color: Colors.grey))),
      );
    }
    return Column(
      children: claim.bills.map((b) => BillTile(bill: b)).toList(),
    );
  }

  Widget _buildHeaderCard(Claim claim) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0052CC), Color(0xFF0747A6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Bill", style: TextStyle(color: Colors.white70)),
              StatusChip(status: claim.status),
            ],
          ),
          const SizedBox(height: 8),
          Text("₹${claim.totalBill.toStringAsFixed(2)}",
              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoTile("Patient", claim.patientName),
              _infoTile("Pending", "₹${claim.pendingAmount.toStringAsFixed(2)}"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildInputSection(ClaimProvider provider, Claim claim) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Manage Payments & Status",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),

        // FIX: Ensure provider has updateAdvance or use updatePayments
        _modernTextField("Advance Paid", Icons.payment,
                (v) => provider.updateAdvance(claim, v)),

        const SizedBox(height: 12),

        // FIX: Ensure provider has updateSettlement
        _modernTextField("Settlement Amount", Icons.check_circle_outline,
                (v) => provider.updateSettlement(claim, v)),

        const SizedBox(height: 20),
        const Text("Update Status",
            style: TextStyle(fontSize: 14, color: Colors.grey)),

        DropdownButton<ClaimStatus>(
          isExpanded: true,
          value: claim.status,
          items: ClaimStatus.values.map((s) => DropdownMenuItem(
            value: s,
            child: Text(s.name.toUpperCase()),
          )).toList(),
          onChanged: (v) {
            if (v != null) {
              provider.updateStatus(claim, v);
            }
          },
        ),
      ],
    );
  }

  Widget _modernTextField(String label, IconData icon, Function(double) onChanged) {
    return TextField(
      onChanged: (v) => onChanged(double.tryParse(v) ?? 0),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF0052CC)),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  void _showAddBillSheet(BuildContext context) {
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Add New Bill", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Bill Title")),
            TextField(controller: amountCtrl, decoration: const InputDecoration(labelText: "Amount"), keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0052CC), foregroundColor: Colors.white),
                onPressed: () {
                  if (titleCtrl.text.isNotEmpty && amountCtrl.text.isNotEmpty) {
                    context.read<ClaimProvider>().addBill(
                      claim,
                      Bill(title: titleCtrl.text, amount: double.parse(amountCtrl.text)),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text("Save Bill"),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}