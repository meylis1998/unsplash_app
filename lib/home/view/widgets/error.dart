part of '../home_view.dart';

class _ErrorWidget extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;

  const _ErrorWidget({this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message ?? 'Произошла ошибка'),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Повторить')),
        ],
      ),
    );
  }
}
