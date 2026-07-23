import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonEnum()
enum NotificationType {
  @JsonValue('circle_invite')
  circleInvite,
  @JsonValue('member_removed')
  memberRemoved,
  @JsonValue('transaction_added')
  transactionAdded,
  @JsonValue('settlement_done')
  settlementDone,
  @JsonValue('ownership_transferred')
  ownershipTransferred,
  @JsonValue('circle_settled')
  circleSettled,
}

@JsonEnum()
enum NotificationRefType {
  @JsonValue('circle')
  circle,
  @JsonValue('transaction')
  transaction,
  @JsonValue('split')
  split,
}

@JsonSerializable()
class NotificationModel {
  final int id;
  @JsonKey(name: 'user_id')
  final int userId;
  final String title;
  final String body;
  final NotificationType type;
  
  @JsonKey(name: 'ref_id')
  final int? refId;
  
  @JsonKey(name: 'ref_type')
  final NotificationRefType? refType;
  
  @JsonKey(name: 'is_read')
  final bool isRead;
  
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.refId,
    this.refType,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
