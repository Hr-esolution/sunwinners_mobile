import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';
import '../data/models/user_model.dart';
import '../controllers/user_controller.dart';
import '../core/constants/app_routes.dart';

// Custom Button Components
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isLoading;
  final double? width;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 44,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.gold, AppColors.orange],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(AppBorderRadius.l),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.l),
          ),
          padding: EdgeInsets.zero,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[icon!, const SizedBox(width: 8)],
                  Text(
                    text,
                    style: AppTypography.body.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(width: 1.5, color: AppColors.gold),
        minimumSize: const Size(double.infinity, 44),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.l),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[icon!, const SizedBox(width: 8)],
          Text(
            text,
            style: AppTypography.body.copyWith(
              color: AppColors.gold,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class TertiaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const TertiaryButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.gold,
        textStyle: AppTypography.body.copyWith(fontWeight: FontWeight.bold),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(text),
    );
  }
}

class IconButtonWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;

  const IconButtonWidget({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.lightGray,
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Icon(icon, size: 20, color: iconColor ?? AppColors.gold),
        ),
      ),
    );
  }
}

// Custom Input Field
class CustomInputField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const CustomInputField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.body.copyWith(
            color: AppColors.darkGray,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.s),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          onChanged: onChanged,
          style: AppTypography.body.copyWith(color: AppColors.darkGray),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTypography.body.copyWith(color: AppColors.lightGray),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.m),
              borderSide: BorderSide(width: 1, color: AppColors.lightGray),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.m),
              borderSide: BorderSide(width: 1, color: AppColors.lightGray),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.m),
              borderSide: BorderSide(width: 2, color: AppColors.gold),
            ),
          ),
        ),
      ],
    );
  }
}

// Custom Checkbox
class CustomCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;

  const CustomCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
  });

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: widget.value ? AppColors.gold : Colors.transparent,
            borderRadius: BorderRadius.circular(AppBorderRadius.xs),
            border: Border.all(
              width: 1.5,
              color: widget.value ? AppColors.gold : AppColors.mediumGray,
            ),
          ),
          child: AnimatedContainer(
            duration: AppAnimations.standard,
            child: widget.value
                ? const Icon(Icons.check, size: 12, color: AppColors.white)
                : null,
          ),
        ),
        if (widget.label != null) ...[
          const SizedBox(width: AppSpacing.s),
          Text(widget.label!, style: AppTypography.body),
        ],
      ],
    );
  }
}

// Custom Radio Button
class CustomRadio<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T?>? onChanged;
  final String? label;

  const CustomRadio({
    super.key,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: 1.5,
              color: value == groupValue
                  ? AppColors.gold
                  : AppColors.mediumGray,
            ),
          ),
          child: AnimatedContainer(
            duration: AppAnimations.standard,
            child: value == groupValue
                ? Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.gold,
                    ),
                  )
                : null,
          ),
        ),
        if (label != null) ...[
          const SizedBox(width: AppSpacing.s),
          Text(label!, style: AppTypography.body),
        ],
      ],
    );
  }
}

// Custom Toggle Switch
class CustomToggle extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const CustomToggle({super.key, required this.value, this.onChanged});

  @override
  State<CustomToggle> createState() => _CustomToggleState();
}

class _CustomToggleState extends State<CustomToggle> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      child: GestureDetector(
        onTap: () => widget.onChanged?.call(!widget.value),
        child: Container(
          width: 44,
          height: 24,
          decoration: BoxDecoration(
            color: widget.value ? AppColors.green : AppColors.mediumGray,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 150),
            alignment: widget.value
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom Slider
class CustomSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;
  final String? label;

  const CustomSlider({
    super.key,
    required this.value,
    this.min = 0.0,
    this.max = 100.0,
    this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: AppTypography.body),
          const SizedBox(height: AppSpacing.s),
        ],
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 9),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
            activeTrackColor: AppColors.gold,
            inactiveTrackColor: AppColors.lightGray,
            thumbColor: AppColors.white,
            overlayColor: AppColors.gold.withValues(alpha: 0.2),
          ),
          child: Slider(value: value, min: min, max: max, onChanged: onChanged),
        ),
      ],
    );
  }
}

// Custom Badge
class CustomBadge extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Widget? child;

  const CustomBadge({
    super.key,
    required this.text,
    this.backgroundColor = AppColors.gold,
    this.textColor = AppColors.white,
    this.child,
  });

  factory CustomBadge.success({String text = '', Widget? child}) {
    return CustomBadge(
      text: text,
      backgroundColor: AppColors.green,
      child: child,
    );
  }

  factory CustomBadge.warning({String text = '', Widget? child}) {
    return CustomBadge(
      text: text,
      backgroundColor: AppColors.orange,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (child != null) child!,
        Positioned(
          top: -8,
          right: -8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(AppBorderRadius.xl),
            ),
            child: Text(
              text,
              style: AppTypography.caption.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Custom Card
class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? elevation;
  final ShapeBorder? shape;
  final VoidCallback? onTap;

  const CustomCard({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.color,
    this.elevation,
    this.shape,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin ?? const EdgeInsets.all(AppSpacing.m),
      color:
          color ??
          (Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkGray
              : AppColors.white),
      elevation: elevation ?? 2,
      shape:
          shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.xl),
            side: BorderSide(
              width: 0.5,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.mediumGray
                  : AppColors.lightGray,
            ),
          ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppSpacing.l),
          child: child,
        ),
      ),
    );
  }
}

// Custom Divider
class CustomDivider extends StatelessWidget {
  final double thickness;
  final Color? color;
  final EdgeInsetsGeometry? margin;

  const CustomDivider({
    super.key,
    this.thickness = 0.5,
    this.color,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: thickness,
      thickness: thickness,
      color: color ?? AppColors.lightGray,
      indent: margin?.horizontal ?? 0,
      endIndent: margin?.horizontal ?? 0,
    );
  }
}

// Custom Chip
class CustomChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool>? onChanged;
  final Color? selectedColor;
  final Color? unselectedColor;

  const CustomChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onChanged,
    this.selectedColor,
    this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label, style: AppTypography.caption),
      selected: isSelected,
      onSelected: onChanged,
      selectedColor: selectedColor ?? AppColors.gold,
      backgroundColor: unselectedColor ?? AppColors.white,
      shape: StadiumBorder(
        side: BorderSide(
          width: 1,
          color: isSelected ? AppColors.gold : AppColors.lightGray,
        ),
      ),
    );
  }
}

// Custom Progress Bar
class CustomProgressBar extends StatelessWidget {
  final double value;
  final double height;
  final Color? backgroundColor;
  final Color? valueColor;

  const CustomProgressBar({
    super.key,
    required this.value,
    this.height = 3,
    this.backgroundColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: value,
      minHeight: height,
      backgroundColor: backgroundColor ?? AppColors.lightGray,
      valueColor: AlwaysStoppedAnimation<Color>(valueColor ?? AppColors.gold),
    );
  }
}

// Custom Circular Progress
class CustomCircularProgress extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color? valueColor;
  final String? text;

  const CustomCircularProgress({
    super.key,
    this.size = 60,
    this.strokeWidth = 3,
    this.valueColor,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(
              valueColor ?? AppColors.gold,
            ),
          ),
        ),
        if (text != null)
          Text(
            text!,
            style: AppTypography.h3.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }
}

// Custom Stepper
class CustomStepper extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> steps;

  const CustomStepper({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        totalSteps,
        (index) => Expanded(
          child: Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: index <= currentStep
                      ? AppColors.gold
                      : Colors.transparent,
                  border: Border.all(
                    width: index == currentStep ? 2 : 1.5,
                    color: index <= currentStep
                        ? AppColors.gold
                        : AppColors.lightGray,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: AppTypography.caption.copyWith(
                      color: index <= currentStep
                          ? AppColors.white
                          : AppColors.lightGray,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s),
              if (index < totalSteps - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    color: index < currentStep
                        ? AppColors.gold
                        : AppColors.lightGray,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Spinner
class CustomSpinner extends StatelessWidget {
  final double size;
  final Color? color;

  const CustomSpinner({super.key, this.size = 40, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(color ?? AppColors.gold),
      ),
    );
  }
}

// Custom Avatar
class CustomAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final double radius;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;

  const CustomAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.radius = 24,
    this.backgroundColor,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? AppColors.lightGray,
        backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
        child: imageUrl == null
            ? Text(
                initials ?? '?',
                style: AppTypography.body.copyWith(
                  color: textColor ?? AppColors.darkGray,
                  fontSize: radius * 0.6,
                ),
              )
            : null,
      ),
    );
  }
}

// Custom Rating Stars
class CustomRating extends StatelessWidget {
  final double rating;
  final int maxRating;
  final ValueChanged<double>? onRatingChanged;
  final bool interactive;

  const CustomRating({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.onRatingChanged,
    this.interactive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children:
          List.generate(maxRating, (index) {
              final starIndex = index + 1;
              return GestureDetector(
                onTap: interactive
                    ? () => onRatingChanged?.call(starIndex.toDouble())
                    : null,
                child: Icon(
                  Icons.star,
                  size: 16,
                  color: starIndex <= rating
                      ? AppColors.gold
                      : AppColors.lightGray,
                ),
              );
            }).expand((element) => [element, const SizedBox(width: 3)]).toList()
            ..removeLast(), // Remove the last SizedBox
    );
  }
}

// Custom List Item
class CustomListItem extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  const CustomListItem({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: ListTile(
        contentPadding:
            padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        onTap: onTap,
        minVerticalPadding: 0,
        dense: true,
      ),
    );
  }
}

// Custom Breadcrumb
class CustomBreadcrumb extends StatelessWidget {
  final List<BreadcrumbItem> items;

  const CustomBreadcrumb({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < items.length; i++)
          Expanded(
            child: Row(
              children: [
                Text(
                  items[i].title,
                  style: AppTypography.caption.copyWith(
                    color: i == items.length - 1
                        ? AppColors.darkGray
                        : AppColors.lightGray,
                    fontSize: 12,
                  ),
                ),
                if (i < items.length - 1) ...[
                  const SizedBox(width: 6),
                  Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: AppColors.lightGray,
                  ),
                  const SizedBox(width: 6),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

// Technician Approval Card
class TechnicianApprovalCard extends StatelessWidget {
  final List<UserModel> pendingTechnicians;
  final UserController userController;
  final VoidCallback? onRefresh;

  const TechnicianApprovalCard({
    super.key,
    required this.pendingTechnicians,
    required this.userController,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromRGBO(255, 255, 255, 0.08),
                Color.fromRGBO(255, 255, 255, 0.03),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFffd60a).withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 5,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFff6b6b), Color(0xFFff5252)],
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Techniciens à approuver',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFff6b6b).withValues(alpha: 0.2),
                          const Color(0xFFff5252).withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFff6b6b).withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      '${pendingTechnicians.length}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFff6b6b),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (pendingTechnicians.isEmpty)
                // Show empty state when no pending technicians
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromRGBO(255, 255, 255, 0.05),
                        Color.fromRGBO(255, 255, 255, 0.02),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF00d4ff).withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: const Color(0xFF00d4ff).withValues(alpha: 0.6),
                        size: 40,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Aucun technicien en attente',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tous les techniciens sont approuvés',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: pendingTechnicians.length > 3
                      ? 3
                      : pendingTechnicians.length, // Show max 3
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final technician = pendingTechnicians[index];
                    return _buildTechnicianItem(technician);
                  },
                ),
              if (pendingTechnicians.length > 3) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      // Navigate to full list of pending technicians
                      Get.toNamed(AppRoutes.technicianApproval);
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Color(0xFFffd60a),
                    ),
                    label: Text(
                      'Voir tous (${pendingTechnicians.length})',
                      style: const TextStyle(
                        color: Color(0xFFffd60a),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTechnicianItem(UserModel technician) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(255, 255, 255, 0.05),
            Color.fromRGBO(255, 255, 255, 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFff6b6b).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFff6b6b).withValues(alpha: 0.2),
              border: Border.all(color: const Color(0xFFff6b6b), width: 1.5),
            ),
            child: const Icon(
              Icons.engineering_rounded,
              color: Color(0xFFff6b6b),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  technician.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  technician.email,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFF00d4ff),
                  size: 20,
                ),
                tooltip: 'Approuver',
                onPressed: () {
                  userController.approveTechnician(technician.id);
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.cancel_outlined,
                  color: Color(0xFFff6b6b),
                  size: 20,
                ),
                tooltip: 'Rejeter',
                onPressed: () {
                  userController.rejectTechnician(technician.id);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BreadcrumbItem {
  final String title;
  final VoidCallback? onTap;

  BreadcrumbItem({required this.title, this.onTap});
}
