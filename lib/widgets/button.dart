part of 'widgets.dart';

class FilledButton extends StatelessWidget {
  const FilledButton({
    super.key,
    this.onPressed,
    this.icon,
    this.label,
  });

  final void Function()? onPressed;
  final IconData? icon;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              backgroundColor: Theme.of(context).colorScheme.primary,
              padding: icon != null
                  ? const EdgeInsets.only(left: 16, right: 24)
                  : null)
          .copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon),
            const HSpacer(
              space: Space.small,
            ),
          ],
          if (label != null) Text(label!),
        ],
      ),
    );
  }
}
