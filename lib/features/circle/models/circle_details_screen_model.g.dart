// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_details_screen_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CircleDetailScreenModel _$CircleDetailScreenModelFromJson(
  Map<String, dynamic> json,
) => CircleDetailScreenModel(
  name: json['name'] as String,
  type: json['type'] as String,
  members: (json['members'] as List<dynamic>)
      .map((e) => Member.fromJson(e as Map<String, dynamic>))
      .toList(),
  circleId: (json['circle_id'] as num).toInt(),
  totalSpent: (json['total_spent'] as num).toInt(),
  pendingAmount: (json['pending_amount'] as num).toInt(),
  settledAmount: (json['settled_amount'] as num).toInt(),
  recentActivity: (json['recent_activity'] as List<dynamic>)
      .map((e) => RecentActivity.fromJson(e as Map<String, dynamic>))
      .toList(),
  settlementProgressPct: (json['settlement_progress_pct'] as num).toInt(),
);

Map<String, dynamic> _$CircleDetailScreenModelToJson(
  CircleDetailScreenModel instance,
) => <String, dynamic>{
  'name': instance.name,
  'type': instance.type,
  'members': instance.members,
  'circle_id': instance.circleId,
  'total_spent': instance.totalSpent,
  'pending_amount': instance.pendingAmount,
  'settled_amount': instance.settledAmount,
  'recent_activity': instance.recentActivity,
  'settlement_progress_pct': instance.settlementProgressPct,
};

Member _$MemberFromJson(Map<String, dynamic> json) => Member(
  role: json['role'] as String,
  status: json['status'] as String,
  isSelf: json['is_self'] as bool,
  userId: (json['user_id'] as num).toInt(),
  fullName: json['full_name'] as String,
  relationshipAmount: (json['relationship_amount'] as num).toInt(),
);

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
  'role': instance.role,
  'status': instance.status,
  'is_self': instance.isSelf,
  'user_id': instance.userId,
  'full_name': instance.fullName,
  'relationship_amount': instance.relationshipAmount,
};

RecentActivity _$RecentActivityFromJson(Map<String, dynamic> json) =>
    RecentActivity(
      note: json['note'],
      amount: (json['amount'] as num).toInt(),
      txnDate: DateTime.parse(json['txn_date'] as String),
      paidByName: json['paid_by_name'] as String,
      transactionId: (json['transaction_id'] as num).toInt(),
      paidByUserId: (json['paid_by_user_id'] as num).toInt(),
    );

Map<String, dynamic> _$RecentActivityToJson(RecentActivity instance) =>
    <String, dynamic>{
      'note': instance.note,
      'amount': instance.amount,
      'txn_date': instance.txnDate.toIso8601String(),
      'paid_by_name': instance.paidByName,
      'transaction_id': instance.transactionId,
      'paid_by_user_id': instance.paidByUserId,
    };
