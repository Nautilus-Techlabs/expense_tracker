import 'package:flutter/material.dart';
import 'package:expense_tracker/features/circle/models/circle_model.dart';

class CircleMember {
  final String initials;
  final Color color;
  const CircleMember({required this.initials, required this.color});
}

class CircleData {
  final String name;
  final CircleType type;
  final List<CircleMember> members;
  final double totalAmount;
  final double? pending; // for one-time circles
  final double? yourShare; // for ongoing circles
  final double? youOwe; // for ongoing circles where user owes
  final String lastActivity;
  final double settlementProgress; // 0.0 – 1.0 (for one-time circles)

  const CircleData({
    required this.name,
    required this.type,
    required this.members,
    required this.totalAmount,
    this.pending,
    this.yourShare,
    this.youOwe,
    required this.lastActivity,
    this.settlementProgress = 0,
  });
}
