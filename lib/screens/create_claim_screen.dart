import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/claim_model.dart';
import '../providers/claim_provider.dart';

class CreateClaimScreen extends StatelessWidget {
  const CreateClaimScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final patientCtrl = TextEditingController();
    final policyCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("New Patient Claim"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Claim Information",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0052CC)),
            ),
            const SizedBox(height: 8),
            const Text(
              "Please enter the patient and policy details below to start the claim process.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // Patient Name Field
            _buildLabel("Patient Full Name"),
            _buildTextField(
              controller: patientCtrl,
              hint: "e.g. Rahul Sharma",
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 20),

            _buildLabel("Policy Number"),
            _buildTextField(
              controller: policyCtrl,
              hint: "e.g. POL-12345678",
              icon: Icons.assignment_ind_outlined,
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0052CC),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                ),
                onPressed: () {
                  if (patientCtrl.text.isNotEmpty && policyCtrl.text.isNotEmpty) {
                    context.read<ClaimProvider>().addClaim(
                      Claim(
                        patientName: patientCtrl.text,
                        policyNumber: policyCtrl.text,
                        bills: [],
                      ),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fill all fields")),
                    );
                  }
                },
                child: const Text(
                  "Create Claim",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for input labels
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }

  // Helper widget for modern text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF0052CC)),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF0052CC), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
      ),
    );
  }
}