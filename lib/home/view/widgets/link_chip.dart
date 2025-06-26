part of '../home_view.dart';

Widget _LinkChip({required IconData icon, required String label, required String url}) {
  return InkWell(
    onTap: () => _launchUrl(url),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.blue[100], borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.blue[700]),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.blue[700]),
          ),
        ],
      ),
    ),
  );
}

void _launchUrl(String url) async {
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  }
}
