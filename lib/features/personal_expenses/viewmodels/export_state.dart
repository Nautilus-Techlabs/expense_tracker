class ExportState {
  final bool isLoading;
  final String? errorMessage;
  final bool exportCompleted;

  const ExportState({
    this.isLoading = false,
    this.errorMessage,
    this.exportCompleted = false,
  });

  ExportState copyWith({
    bool? isLoading,
    String? Function()? errorMessage,
    bool? exportCompleted,
  }) {
    return ExportState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      exportCompleted: exportCompleted ?? this.exportCompleted,
    );
  }
}
