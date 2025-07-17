import 'package:flutter/material.dart';
import '../core/enums/view_state.dart';
import '../core/helper/view_state_manager.dart';



class CustomButton extends StatelessWidget {
  final ViewStateManager? viewStateManager;
  final Color borderColor;
  final double borderRadius;
  final double borderWidth;
  final Color btnColor;
  final Gradient? gradient;
  final bool isEnabled;
  final bool isExpanded;
  final Color lblColor;
  final VoidCallback? onTap;
  final String label;
  final TextStyle? style;
  final double? height;
  final double? width;
  final double paddingHorizontal;
  final double paddingVertical;
  final IconData? icon;
  final Widget? iconWidget;

  const CustomButton({
    super.key,
    this.viewStateManager,
    this.borderColor = Colors.transparent,
    this.borderRadius = 5.0,
    this.borderWidth = 1.0,
    this.btnColor = Colors.green,
    this.gradient,
    this.height = 50.0,
    this.width,
    this.icon,
    this.iconWidget,
    this.isEnabled = true,
    this.isExpanded = false,
    this.lblColor = Colors.white,
    this.label = '',
    this.onTap,
    this.style,
    this.paddingHorizontal = 10.0,
    this.paddingVertical = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    final currentState = viewStateManager?.state ?? ViewState.complete;

    if (currentState == ViewState.loading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.green),
      );
    }

    final borderRadiusValue = BorderRadius.circular(borderRadius);

    return Material(
      color: Colors.transparent,
      borderRadius: borderRadiusValue,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: borderRadiusValue,
        splashColor: Colors.white.withOpacity(0.2),
        highlightColor: Colors.white.withOpacity(0.1),
        child: Ink(
          height: height,
          width: width ?? double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: paddingHorizontal,
            vertical: paddingVertical,
          ),
          decoration: BoxDecoration(
            color: gradient == null
                ? (isEnabled ? btnColor : Colors.grey.shade300)
                : null,
            gradient: isEnabled ? gradient : null,
            borderRadius: borderRadiusValue,
            border: Border.all(
              color: isEnabled ? borderColor : Colors.grey,
              width: borderWidth,
            ),
          ),
          child: Center(child: _buildContent()),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final textPart = _buildTextPart();

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 18.0),
          const SizedBox(width: 6),
          if (isExpanded) Expanded(child: textPart) else textPart,
        ],
      );
    } else if (iconWidget != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget!,
          const SizedBox(width: 6),
          if (isExpanded) Expanded(child: textPart) else textPart,
        ],
      );
    } else {
      return isExpanded ? Expanded(child: textPart) : textPart;
    }
  }

  Widget _buildTextPart() {
    return Text(
      label,
      textAlign: TextAlign.center,
      style: style ??
          TextStyle(
            color: lblColor,
            fontSize: 20.0,
          ),
    );
  }
}
