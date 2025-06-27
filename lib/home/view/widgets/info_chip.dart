part of 'photo_detail_sheet.dart';

Widget _InfoChip({
  required IconData icon,
  required String label,
  Color? color,
  required BuildContext context,
}) {
  final chipColor = color ?? Colors.grey[600]!;
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(color: chipColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: chipColor),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 10, color: chipColor)),
      ],
    ),
  );
}
