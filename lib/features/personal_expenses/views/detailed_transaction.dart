import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../domain/entities/transaction.dart';
import '../viewmodels/detailed_transaction_viewmodel.dart';

class DetailedTransactionScreen extends ConsumerStatefulWidget {
  final Transaction transaction;
  final String? heroTag;

  const DetailedTransactionScreen({
    super.key,
    required this.transaction,
    this.heroTag,
  });

  @override
  ConsumerState<DetailedTransactionScreen> createState() =>
      _DetailedTransactionScreenState();
}

class _DetailedTransactionScreenState
    extends ConsumerState<DetailedTransactionScreen> {
  @override
  void initState() {
    super.initState();
    // Seed the viewmodel as soon as the widget is inserted into the tree
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(detailedTransactionViewModelProvider.notifier)
          .init(widget.transaction);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(detailedTransactionViewModelProvider);
    final vm = ref.read(detailedTransactionViewModelProvider.notifier);

    final isManual = widget.transaction.source == TransactionSource.manual;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Listen for errors and show snackbars
    ref.listen<DetailedTransactionState>(detailedTransactionViewModelProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.expense,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
          onPressed: () => context.pop(),
        ),
        title: Text(
          state.isEditing ? 'Edit Transaction' : 'Transaction Details',
          style: AppTexts.heading.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        actions: [
          if (!state.isEditing && !widget.transaction.isSample) ...[
            if (isManual)
              IconButton(
                icon: Icon(Icons.delete_outline_rounded, size: 22.sp, color: AppColors.expense),
                onPressed: () => _handleDelete(context, vm),
              ),
            IconButton(
              icon: Icon(Icons.edit_rounded, size: 22.sp, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
              onPressed: vm.toggleEditing,
            ),
          ] else if (state.isEditing)
            TextButton(
              onPressed: () async {
                final success = await vm.saveTransaction();
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Changes saved successfully!'), backgroundColor: AppColors.income),
                  );
                }
              },
              child: Text(
                'Save',
                style: AppTexts.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          SizedBox(width: 8.w),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            if (widget.heroTag != null)
              Hero(tag: widget.heroTag!, child: _buildAmountCard(context, state, vm, isDark))
            else
              _buildAmountCard(context, state, vm, isDark),
            
            SizedBox(height: 24.h),

            if (state.isEditing) ...[
              _buildEditForm(context, state, vm, isDark),
            ] else ...[
              _buildDetails(context, state, isManual, isDark),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildAmountCard(BuildContext context, DetailedTransactionState state, DetailedTransactionViewModel vm, bool isDark) {
    final isDebit = widget.transaction.type == TransactionType.debit;
    final semanticColor = isDebit ? AppColors.expense : AppColors.income;
    final semanticBg = isDebit ? AppColors.expenseBg : AppColors.incomeBg;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: semanticBg,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: semanticColor.withAlpha(isDark ? 150 : 80), width: 1.5),
      ),
      child: Column(
        children: [
          if (state.isEditing)
            CustomTextField(
              label: 'Merchant',
              controller: TextEditingController(text: state.merchant)..selection = TextSelection.collapsed(offset: state.merchant.length),
              onChanged: (val) => vm.updateField(merchant: val),
            )
          else
            Text(
              state.merchant.isNotEmpty ? state.merchant : 'Unknown Merchant',
              style: AppTexts.displaySmall.copyWith(color: semanticColor, fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
          
          SizedBox(height: 16.h),
          
          if (state.isEditing)
            CustomTextField(
              label: 'Amount',
              keyboardType: TextInputType.number,
              controller: TextEditingController(text: state.amount)..selection = TextSelection.collapsed(offset: state.amount.length),
              onChanged: (val) => vm.updateField(amount: val),
            )
          else
            Text(
              '₹ ${state.amount}',
              style: AppTexts.displayLarge.copyWith(color: semanticColor, fontWeight: FontWeight.w900),
            ),
        ],
      ),
    );
  }

  Widget _buildEditForm(BuildContext context, DetailedTransactionState state, DetailedTransactionViewModel vm, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: 'Account Number',
          hint: 'e.g. X1234',
          controller: TextEditingController(text: state.account)..selection = TextSelection.collapsed(offset: state.account.length),
          onChanged: (val) => vm.updateField(account: val),
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          label: 'Bank Name',
          hint: 'e.g. HDFC Bank',
          controller: TextEditingController(text: state.bankName)..selection = TextSelection.collapsed(offset: state.bankName.length),
          onChanged: (val) => vm.updateField(bankName: val),
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          label: 'Description',
          hint: 'Add a brief note...',
          maxLines: 3,
          controller: TextEditingController(text: state.description)..selection = TextSelection.collapsed(offset: state.description.length),
          onChanged: (val) => vm.updateField(description: val),
        ),
        SizedBox(height: 24.h),
        PrimaryButton(
          text: 'Save Changes',
          isLoading: state.isSaving,
          onPressed: () => vm.saveTransaction(),
        ),
      ],
    );
  }

  Widget _buildDetails(BuildContext context, DetailedTransactionState state, bool isManual, bool isDark) {
    return Column(
      children: [
        _buildInfoRow(context, 'Bank Name', state.bankName, Icons.store_rounded),
        SizedBox(height: 12.h),
        _buildInfoRow(context, 'Account Number', state.account.isEmpty ? 'N/A' : state.account, Icons.tag_rounded),
        SizedBox(height: 12.h),
        _buildInfoRow(context, 'Payment Method', state.method.name.toUpperCase(), Icons.credit_card_rounded),
        SizedBox(height: 12.h),
        _buildInfoRow(context, 'Date', DateFormat('dd MMM yyyy, hh:mm a').format(widget.transaction.date), Icons.calendar_today_rounded),
        SizedBox(height: 12.h),
        if (state.description.isNotEmpty)
          _buildInfoRow(context, 'Description', state.description, Icons.notes_rounded),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.cardDark : AppColors.cardLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24.sp),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: AppTexts.bodyMedium.copyWith(
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: AppTexts.bodyLarge.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _handleDelete(BuildContext context, DetailedTransactionViewModel vm) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Transaction', style: AppTexts.heading),
        content: Text('Are you sure you want to delete this manual transaction?', style: AppTexts.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: AppTexts.bodyMedium),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: Text('Delete', style: AppTexts.bodyMedium.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await vm.deleteTransaction();
      if (success && context.mounted) {
        context.pop();
      }
    }
  }
}
