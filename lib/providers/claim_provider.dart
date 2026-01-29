import 'package:flutter/material.dart';
import '../models/claim_model.dart';
import '../models/bill_model.dart';

class ClaimProvider with ChangeNotifier {
  final List<Claim> _claims = [];
  List<Claim> get claims => _claims;

  void addClaim(Claim claim) {
    _claims.add(claim);
    notifyListeners();
  }

  void addBill(Claim claim, Bill bill) {
    claim.bills.add(bill);
    notifyListeners();
  }

  void updatePayments(Claim claim, {double? adv, double? setl}) {
    if (adv != null) claim.advance = adv;
    if (setl != null) claim.settlement = setl;
    notifyListeners();
  }

  void updateStatus(Claim claim, ClaimStatus newStatus) {
    claim.status = newStatus;
    notifyListeners();
  }

  void updateAdvance(Claim claim, double value) {
    claim.advance = value;
    notifyListeners();
  }

  void updateSettlement(Claim claim, double value) {
    claim.settlement = value;
    notifyListeners();
  }

}

