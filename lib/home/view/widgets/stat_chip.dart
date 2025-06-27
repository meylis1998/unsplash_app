part of 'photo_detail_sheet.dart';

Widget _StatChip({
  required IconData icon,
  required String label,
  required Color color,
  required BuildContext context,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontSize: 12, fontWeight: FontWeight.w500, color: color),
        ),
      ],
    ),
  );
}
