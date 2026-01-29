import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/claim_provider.dart';
import '../widgets/status_chip.dart';
import 'create_claim_screen.dart';
import 'claim_detail_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final claims = context.watch<ClaimProvider>().claims;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Modern off-white background
      appBar: AppBar(
        title: const Text("Medoc Claims", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.black87),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryHeader(claims.length), // Naya summary section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text("Recent Claims",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          ),
          Expanded(
            child: claims.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: claims.length,
              itemBuilder: (context, index) {
                return _buildProfessionalClaimCard(context, claims[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF0052CC),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateClaimScreen())),
        label: const Text("New Claim", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white,),
      ),
    );
  }

  // Naya attractive header summary card
  Widget _buildSummaryHeader(int totalClaims) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0052CC), Color(0xFF0747A6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0052CC).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Welcome back,", style: TextStyle(color: Colors.white70, fontSize: 16)),
          const Text("Medoc Admin",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _summaryItem("Total Claims", totalClaims.toString()),
              _summaryItem("Active", "Processing"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildProfessionalClaimCard(BuildContext context, claim) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)), // Subtle border
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.person_search_rounded, color: Color(0xFF0052CC)),
        ),
        title: Text(claim.patientName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF1E293B))),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              const Icon(Icons.article_outlined, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(claim.policyNumber, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              const Spacer(),
              Text("₹${claim.pendingAmount}",
                  style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        ),
        trailing: StatusChip(status: claim.status),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ClaimDetailScreen(claim: claim))),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(color: Color(0xFFF1F5F9), shape: BoxShape.circle),
            child: const Icon(Icons.assignment_add, size: 60, color: Color(0xFFCBD5E1)),
          ),
          const SizedBox(height: 16),
          const Text("No active claims found",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
          const SizedBox(height: 8),
          const Text("Tap 'New Claim' to start processing.", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}