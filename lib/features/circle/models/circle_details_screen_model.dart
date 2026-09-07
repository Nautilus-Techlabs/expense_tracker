import 'package:json_annotation/json_annotation.dart';

part 'circle_details_screen_model.g.dart';

@JsonSerializable()
class CircleDetailScreenModel {
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "type")
  String type;
  @JsonKey(name: "members")
  List<Member> members;
  @JsonKey(name: "circle_id")
  int circleId;
  @JsonKey(name: "total_spent")
  int totalSpent;
  @JsonKey(name: "pending_amount")
  int pendingAmount;
  @JsonKey(name: "settled_amount")
  int settledAmount;
  @JsonKey(name: "recent_activity")
  List<RecentActivity> recentActivity;
  @JsonKey(name: "settlement_progress_pct")
  int settlementProgressPct;

  CircleDetailScreenModel({
    required this.name,
    required this.type,
    required this.members,
    required this.circleId,
    required this.totalSpent,
    required this.pendingAmount,
    required this.settledAmount,
    required this.recentActivity,
    required this.settlementProgressPct,
  });

  factory CircleDetailScreenModel.fromJson(Map<String, dynamic> json) =>
      _$CircleDetailScreenModelFromJson(json);

  Map<String, dynamic> toJson() => _$CircleDetailScreenModelToJson(this);
}

@JsonSerializable()
class Member {
  @JsonKey(name: "role")
  String role;
  @JsonKey(name: "status")
  String status;
  @JsonKey(name: "is_self")
  bool isSelf;
  @JsonKey(name: "user_id")
  int userId;
  @JsonKey(name: "full_name")
  String fullName;
  @JsonKey(name: "relationship_amount")
  int relationshipAmount;

  Member({
    required this.role,
    required this.status,
    required this.isSelf,
    required this.userId,
    required this.fullName,
    required this.relationshipAmount,
  });

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);

  Map<String, dynamic> toJson() => _$MemberToJson(this);
}

@JsonSerializable()
class RecentActivity {
  @JsonKey(name: "note")
  dynamic note;
  @JsonKey(name: "amount")
  int amount;
  @JsonKey(name: "txn_date")
  DateTime txnDate;
  @JsonKey(name: "paid_by_name")
  String paidByName;
  @JsonKey(name: "transaction_id")
  int transactionId;
  @JsonKey(name: "paid_by_user_id")
  int paidByUserId;

  RecentActivity({
    required this.note,
    required this.amount,
    required this.txnDate,
    required this.paidByName,
    required this.transactionId,
    required this.paidByUserId,
  });

  factory RecentActivity.fromJson(Map<String, dynamic> json) =>
      _$RecentActivityFromJson(json);

  Map<String, dynamic> toJson() => _$RecentActivityToJson(this);
}
