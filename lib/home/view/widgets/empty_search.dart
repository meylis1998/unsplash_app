part of '../home_view.dart';

class _EmptySearchWidget extends StatelessWidget {
  final String query;
  const _EmptySearchWidget({required this.query});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(CupertinoIcons.search, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Ничего не найдено',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'По запросу "$query" ничего не найдено.\nПопробуйте другие ключевые слова.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
