import 'bill_model.dart';

enum ClaimStatus { draft, submitted, approved, rejected, partiallySettled }

class Claim {
  String patientName;
  String policyNumber;
  List<Bill> bills;
  double advance;
  double settlement;
  ClaimStatus status;

  Claim({
    required this.patientName,
    required this.policyNumber,
    required this.bills,
    this.advance = 0,
    this.settlement = 0,
    this.status = ClaimStatus.draft,
  });

  double get totalBill => bills.fold<double>(0, (sum, bill) => sum + bill.amount);

  double get pendingAmount => totalBill - advance - settlement;
}