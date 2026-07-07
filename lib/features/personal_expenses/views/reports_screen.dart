import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_constants.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Reports',
                      style: AppTexts.displayMedium.copyWith(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.primary,
                        fontSize: 32.sp,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : AppColors.borderLight,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.chevron_left_rounded,
                            size: 20.sp,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Jun 2024',
                            style: AppTexts.bodyMedium.copyWith(
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 20.sp,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Top Stats ──
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _StatItem(
                      title: 'INCOME',
                      amount: '₹45,000',
                      color: AppColors.income,
                      isDark: isDark,
                    ),
                    _StatItem(
                      title: 'EXPENSE',
                      amount: '₹32,000',
                      color: AppColors.expense,
                      isDark: isDark,
                    ),
                    _StatItem(
                      title: 'NET',
                      amount: '+₹13,000',
                      color: AppColors.income,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),

              // ── Monthly Trend Card ──
              _MonthlyTrendCard(isDark: isDark),
              SizedBox(height: 16.h),

              // ── Spending Breakdown Card ──
              _SpendingBreakdownCard(isDark: isDark),
              SizedBox(height: 16.h),

              // ── By Account Card ──
              _ByAccountCard(isDark: isDark),
              SizedBox(height: 120.h), // Bottom padding for nav bar
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;
  final bool isDark;

  const _StatItem({
    required this.title,
    required this.amount,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: AppTexts.bodySmall.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          amount,
          style: AppTexts.displayMedium.copyWith(
            color: color,
            fontSize: 22.sp,
          ),
        ),
      ],
    );
  }
}

class _MonthlyTrendCard extends StatelessWidget {
  final bool isDark;
  const _MonthlyTrendCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MONTHLY TREND',
            style: AppTexts.bodySmall.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 32.h),
          SizedBox(
            height: 150.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _BarGroup(label: 'Jan', incomePercent: 0.5, expensePercent: 0.35, isDark: isDark),
                _BarGroup(label: 'Feb', incomePercent: 0.6, expensePercent: 0.45, isDark: isDark),
                _BarGroup(label: 'Mar', incomePercent: 0.55, expensePercent: 0.5, isDark: isDark),
                _BarGroup(label: 'Apr', incomePercent: 0.8, expensePercent: 0.4, isDark: isDark),
                _BarGroup(label: 'May', incomePercent: 0.75, expensePercent: 0.55, isDark: isDark),
                _BarGroup(label: 'Jun', incomePercent: 0.9, expensePercent: 0.7, isDark: isDark, isCurrentMonth: true),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendItem(color: AppColors.income, label: 'Income', isDark: isDark),
              SizedBox(width: 24.w),
              _LegendItem(color: AppColors.expense, label: 'Expense', isDark: isDark),
            ],
          ),
        ],
      ),
    );
  }
}

class _BarGroup extends StatelessWidget {
  final String label;
  final double incomePercent;
  final double expensePercent;
  final bool isDark;
  final bool isCurrentMonth;

  const _BarGroup({
    required this.label,
    required this.incomePercent,
    required this.expensePercent,
    required this.isDark,
    this.isCurrentMonth = false,
  });

  @override
  Widget build(BuildContext context) {
    final incomeColor = isCurrentMonth ? AppColors.income : AppColors.income.withAlpha(isDark ? 100 : 80);
    final expenseColor = isCurrentMonth ? AppColors.expense : AppColors.expense.withAlpha(isDark ? 100 : 80);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 8.w,
              height: 120.h * incomePercent,
              color: incomeColor,
            ),
            SizedBox(width: 4.w),
            Container(
              width: 8.w,
              height: 120.h * expensePercent,
              color: expenseColor,
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Text(
          label,
          style: AppTexts.bodySmall.copyWith(
            color: isCurrentMonth
                ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)
                : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
            fontWeight: isCurrentMonth ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool isDark;

  const _LegendItem({required this.color, required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: AppTexts.bodySmall.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}

class _SpendingBreakdownCard extends StatelessWidget {
  final bool isDark;
  const _SpendingBreakdownCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    // Colors matching the design
    final rentColor = AppColors.expense;
    final foodColor = AppColors.income;
    final transportColor = const Color(0xFF2A5934); // Dark Green
    final healthColor = const Color(0xFFA3C2A4); // Light Green
    final othersColor = const Color(0xFF8D8D8D); // Grey

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SPENDING BREAKDOWN',
            style: AppTexts.bodySmall.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 32.h),

          // Donut Chart
          Center(
            child: SizedBox(
              width: 160.w,
              height: 160.w,
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size(160.w, 160.w),
                    painter: _DonutChartPainter(
                      segments: [
                        _Segment(value: 37, color: rentColor),
                        _Segment(value: 25, color: foodColor),
                        _Segment(value: 9, color: transportColor),
                        _Segment(value: 6, color: healthColor),
                        _Segment(value: 23, color: othersColor),
                      ],
                      strokeWidth: 16.w,
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '₹32k / ₹40k',
                          style: AppTexts.displayMedium.copyWith(
                            color: isDark ? AppColors.textPrimaryDark : AppColors.primary,
                            fontSize: 18.sp,
                          ),
                        ),
                        Text(
                          'spent',
                          style: AppTexts.bodySmall.copyWith(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 32.h),

          // List Items
          _BreakdownItem(color: rentColor, label: 'Rent', amount: '₹12,000', percentage: '37%', isDark: isDark),
          SizedBox(height: 16.h),
          _BreakdownItem(color: foodColor, label: 'Food', amount: '₹8,000', percentage: '25%', isDark: isDark),
          SizedBox(height: 16.h),
          _BreakdownItem(color: transportColor, label: 'Transport', amount: '₹3,000', percentage: '9%', isDark: isDark),
          SizedBox(height: 16.h),
          _BreakdownItem(color: healthColor, label: 'Health', amount: '₹2,000', percentage: '6%', isDark: isDark),
          SizedBox(height: 16.h),
          _BreakdownItem(color: othersColor, label: 'Others', amount: '₹7,000', percentage: '23%', isDark: isDark),

          SizedBox(height: 24.h),
          Center(
            child: InkWell(
              onTap: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View all categories',
                    style: AppTexts.bodySmall.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 16.sp,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BreakdownItem extends StatelessWidget {
  final Color color;
  final String label;
  final String amount;
  final String percentage;
  final bool isDark;

  const _BreakdownItem({
    required this.color,
    required this.label,
    required this.amount,
    required this.percentage,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 12.w),
        Text(
          label,
          style: AppTexts.bodyMedium.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          '$amount ($percentage)',
          style: AppTexts.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}

class _ByAccountCard extends StatelessWidget {
  final bool isDark;
  const _ByAccountCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'BY ACCOUNT',
            style: AppTexts.bodySmall.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 24.h),
          
          // Header Row
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Account Name',
                  style: AppTexts.bodySmall.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Inflow',
                  style: AppTexts.bodySmall.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Outflow',
                  style: AppTexts.bodySmall.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Net',
                  style: AppTexts.bodySmall.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          
          // List Items
          _AccountRow(
            icon: Icons.account_balance_rounded,
            name: 'HDFC\nSavings',
            inflow: '₹35,000',
            outflow: '₹24,500',
            net: '₹10,500',
            isDark: isDark,
          ),
          SizedBox(height: 20.h),
          _AccountRow(
            icon: Icons.account_balance_wallet_rounded,
            name: 'SBI\nAccount',
            inflow: '₹10,000',
            outflow: '₹5,000',
            net: '₹5,000',
            isDark: isDark,
          ),
          SizedBox(height: 20.h),
          _AccountRow(
            icon: Icons.payments_rounded,
            name: 'Cash',
            inflow: '₹0',
            outflow: '₹2,500',
            net: '-₹2,500',
            isDark: isDark,
            isNegativeNet: true,
          ),
        ],
      ),
    );
  }
}

class _AccountRow extends StatelessWidget {
  final IconData icon;
  final String name;
  final String inflow;
  final String outflow;
  final String net;
  final bool isDark;
  final bool isNegativeNet;

  const _AccountRow({
    required this.icon,
    required this.name,
    required this.inflow,
    required this.outflow,
    required this.net,
    required this.isDark,
    this.isNegativeNet = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F0),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  icon,
                  size: 16.sp,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  name,
                  style: AppTexts.bodySmall.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            inflow,
            style: AppTexts.bodySmall.copyWith(
              color: AppColors.income,
            ),
            textAlign: TextAlign.right,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            outflow,
            style: AppTexts.bodySmall.copyWith(
              color: AppColors.expense,
            ),
            textAlign: TextAlign.right,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            net,
            style: AppTexts.bodyMedium.copyWith(
              color: isNegativeNet ? AppColors.expense : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

// ── Donut Chart Custom Painter ──

class _Segment {
  final double value; // percentage
  final Color color;
  _Segment({required this.value, required this.color});
}

class _DonutChartPainter extends CustomPainter {
  final List<_Segment> segments;
  final double strokeWidth;

  _DonutChartPainter({required this.segments, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    double startAngle = -math.pi / 2; // Start from top

    for (var segment in segments) {
      final sweepAngle = (segment.value / 100) * 2 * math.pi;
      final paint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      // Add a tiny gap between segments
      startAngle += sweepAngle + 0.02; 
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
