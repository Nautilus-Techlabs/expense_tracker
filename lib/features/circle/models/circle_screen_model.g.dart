// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_screen_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CircleScreenModel _$CircleScreenModelFromJson(Map<String, dynamic> json) =>
    CircleScreenModel(
      totals: Totals.fromJson(json['totals'] as Map<String, dynamic>),
      circles: (json['circles'] as List<dynamic>)
          .map((e) => Circle.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CircleScreenModelToJson(CircleScreenModel instance) =>
    <String, dynamic>{'totals': instance.totals, 'circles': instance.circles};

Circle _$CircleFromJson(Map<String, dynamic> json) => Circle(
  name: json['name'] as String,
  type: json['type'] as String,
  members: (json['members'] as List<dynamic>)
      .map((e) => Member.fromJson(e as Map<String, dynamic>))
      .toList(),
  youPaid: (json['you_paid'] as num).toInt(),
  circleId: (json['circle_id'] as num).toInt(),
  netAmount: (json['net_amount'] as num).toInt(),
  memberCount: (json['member_count'] as num).toInt(),
  settlementProgressPct: (json['settlement_progress_pct'] as num).toDouble(),
);

Map<String, dynamic> _$CircleToJson(Circle instance) => <String, dynamic>{
  'name': instance.name,
  'type': instance.type,
  'members': instance.members,
  'you_paid': instance.youPaid,
  'circle_id': instance.circleId,
  'net_amount': instance.netAmount,
  'member_count': instance.memberCount,
  'settlement_progress_pct': instance.settlementProgressPct,
};

Member _$MemberFromJson(Map<String, dynamic> json) => Member(
  userId: (json['user_id'] as num).toInt(),
  fullName: json['full_name'] as String,
);

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
  'user_id': instance.userId,
  'full_name': instance.fullName,
};

Totals _$TotalsFromJson(Map<String, dynamic> json) => Totals(
  totalYouOwe: (json['total_you_owe'] as num).toInt(),
  totalOwedToYou: (json['total_owed_to_you'] as num).toInt(),
);

Map<String, dynamic> _$TotalsToJson(Totals instance) => <String, dynamic>{
  'total_you_owe': instance.totalYouOwe,
  'total_owed_to_you': instance.totalOwedToYou,
};
