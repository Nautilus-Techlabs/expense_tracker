import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/ui_helpers.dart';
import '../viewmodels/category_notifier.dart';
import '../../../../core/theme/app_colors_extension.dart';
import '../widgets/category_list_item.dart';
import '../widgets/add_category_bottom_sheet.dart';

class CategoriesSettingsScreen extends ConsumerWidget {
  const CategoriesSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryState = ref.watch(categoryProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: context.colors.textPrimary,
            size: 20.sp,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Categories',
          style: context.appTexts.displayMedium.copyWith(
            color: context.colors.textPrimary,
            fontSize: 22.sp,
          ),
        ),
        centerTitle: false,
      ),
      body: categoryState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : categoryState.categories.isEmpty
              ? Center(
                  child: Text(
                    'No categories found.',
                    textAlign: TextAlign.center,
                    style: context.appTexts.bodyMedium.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                )
              : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  itemCount: categoryState.categories.length,
                  separatorBuilder: (context, index) => UIHelpers.verticalSpace(12),
                  itemBuilder: (context, index) {
                    final category = categoryState.categories[index];
                    return CategoryListItem(category: category);
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAddCategorySheet(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add Category',
          style: context.appTexts.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

