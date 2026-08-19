import '../../features/circle/models/circle_details_screen_model.dart';

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

class AddCircleExpenseArgs {
  final int circleId;
  final List<Member> members;

  const AddCircleExpenseArgs({
    required this.circleId,
    required this.members,
  });
}
