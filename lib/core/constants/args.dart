class CircleDetailsArgs {
  final int circleId;
  final String circleName;

  const CircleDetailsArgs({
    required this.circleId,
    required this.circleName,
  });
}

class CircleSettingsArgs {
  final int circleId;
  final String circleName;
  final int? ownerId;

  const CircleSettingsArgs({
    required this.circleId,
    required this.circleName,
    this.ownerId,
  });
}
