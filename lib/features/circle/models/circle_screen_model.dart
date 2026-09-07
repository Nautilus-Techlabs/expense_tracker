import 'package:json_annotation/json_annotation.dart';

part 'circle_screen_model.g.dart';

@JsonSerializable()
class CircleScreenModel {
  @JsonKey(name: "totals")
  Totals totals;
  @JsonKey(name: "circles")
  List<Circle> circles;

  CircleScreenModel({required this.totals, required this.circles});

  factory CircleScreenModel.fromJson(Map<String, dynamic> json) =>
      _$CircleScreenModelFromJson(json);

  Map<String, dynamic> toJson() => _$CircleScreenModelToJson(this);
}

@JsonSerializable()
class Circle {
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "type")
  String type;
  @JsonKey(name: "members")
  List<Member> members;
  @JsonKey(name: "you_paid")
  int youPaid;
  @JsonKey(name: "circle_id")
  int circleId;
  @JsonKey(name: "net_amount")
  int netAmount;
  @JsonKey(name: "member_count")
  int memberCount;
  @JsonKey(name: "settlement_progress_pct")
  double settlementProgressPct;

  Circle({
    required this.name,
    required this.type,
    required this.members,
    required this.youPaid,
    required this.circleId,
    required this.netAmount,
    required this.memberCount,
    required this.settlementProgressPct,
  });

  factory Circle.fromJson(Map<String, dynamic> json) => _$CircleFromJson(json);

  Map<String, dynamic> toJson() => _$CircleToJson(this);
}

@JsonSerializable()
class Member {
  @JsonKey(name: "user_id")
  int userId;
  @JsonKey(name: "full_name")
  String fullName;

  Member({required this.userId, required this.fullName});

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);

  Map<String, dynamic> toJson() => _$MemberToJson(this);
}

@JsonSerializable()
class Totals {
  @JsonKey(name: "total_you_owe")
  int totalYouOwe;
  @JsonKey(name: "total_owed_to_you")
  int totalOwedToYou;

  Totals({required this.totalYouOwe, required this.totalOwedToYou});

  factory Totals.fromJson(Map<String, dynamic> json) => _$TotalsFromJson(json);

  Map<String, dynamic> toJson() => _$TotalsToJson(this);
}
