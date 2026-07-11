import '../models/reports_model.dart';

class ReportState {
  final bool isLoading;
  final ReportModel? report;
  final String? errorMessage;

  ReportState({
    this.isLoading = false,
    this.report,
    this.errorMessage,
  });

  ReportState copyWith({
    bool? isLoading,
    ReportModel? Function()? report,
    String? Function()? errorMessage,
  }) {
    return ReportState(
      isLoading: isLoading ?? this.isLoading,
      report: report != null ? report() : this.report,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
