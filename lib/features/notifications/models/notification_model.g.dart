// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      title: json['title'] as String,
      body: json['body'] as String,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      refId: (json['ref_id'] as num?)?.toInt(),
      refType: $enumDecodeNullable(
        _$NotificationRefTypeEnumMap,
        json['ref_type'],
      ),
      isRead: json['is_read'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'title': instance.title,
      'body': instance.body,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'ref_id': instance.refId,
      'ref_type': _$NotificationRefTypeEnumMap[instance.refType],
      'is_read': instance.isRead,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$NotificationTypeEnumMap = {
  NotificationType.circleInvite: 'circle_invite',
  NotificationType.memberRemoved: 'member_removed',
  NotificationType.transactionAdded: 'transaction_added',
  NotificationType.settlementDone: 'settlement_done',
  NotificationType.ownershipTransferred: 'ownership_transferred',
  NotificationType.circleSettled: 'circle_settled',
};

const _$NotificationRefTypeEnumMap = {
  NotificationRefType.circle: 'circle',
  NotificationRefType.transaction: 'transaction',
  NotificationRefType.split: 'split',
};
