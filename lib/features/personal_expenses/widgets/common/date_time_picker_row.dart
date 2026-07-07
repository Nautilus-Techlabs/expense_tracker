import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_theme.dart';

class DateTimePickerRow extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;
  final Function(DateTime) onTimeChanged;

  const DateTimePickerRow({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
    required this.onTimeChanged,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: Theme.of(context).colorScheme.primary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      onDateChanged(DateTime(
        picked.year,
        picked.month,
        picked.day,
        selectedDate.hour,
        selectedDate.minute,
      ));
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );
    if (picked != null) {
      onTimeChanged(DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        picked.hour,
        picked.minute,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: _PickerButton(
            label: DateFormat('dd MMM, yyyy').format(selectedDate),
            icon: Icons.calendar_today_rounded,
            onTap: () => _selectDate(context),
            colorScheme: colorScheme,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _PickerButton(
            label: DateFormat('hh:mm a').format(selectedDate),
            icon: Icons.access_time_rounded,
            onTap: () => _selectTime(context),
            colorScheme: colorScheme,
          ),
        ),
      ],
    );
  }
}

class _PickerButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  const _PickerButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppTheme.getSurfaceSecondaryColor(context),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppTheme.getBorderColor(context)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18.sp, color: colorScheme.primary),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
