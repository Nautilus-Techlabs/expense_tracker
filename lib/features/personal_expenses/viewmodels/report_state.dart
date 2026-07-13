import '../models/reports_model.dart';

class ReportState {
  final bool isLoading;
  final ReportModel? report;
  final SpendingBreakdown? breakdown;
  final String? errorMessage;

  ReportState({
    this.isLoading = false,
    this.report,
    this.breakdown,
    this.errorMessage,
  });

  ReportState copyWith({
    bool? isLoading,
    ReportModel? Function()? report,
    SpendingBreakdown? Function()? breakdown,
    String? Function()? errorMessage,
  }) {
    return ReportState(
      isLoading: isLoading ?? this.isLoading,
      report: report != null ? report() : this.report,
      breakdown: breakdown != null ? breakdown() : this.breakdown,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
