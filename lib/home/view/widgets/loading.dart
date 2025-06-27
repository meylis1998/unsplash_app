part of '../home_view.dart';

class _LoadingWidget extends StatefulWidget {
  const _LoadingWidget({Key? key}) : super(key: key);

  @override
  _LoadingWidgetState createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<_LoadingWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _shimmerController,
        builder: (context, child) {
          final shimmerPosition = _shimmerController.value * 2 - 1;
          return ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment(-1 - shimmerPosition, 0),
                end: Alignment(1 + shimmerPosition, 0),
                colors: [Colors.blue.shade300, AppTheme.black, Colors.blue.shade300],
                stops: const [0.1, 0.5, 0.9],
              ).createShader(bounds);
            },
            blendMode: BlendMode.srcATop,
            child: child,
          );
        },
        child: Text(
          'Loading photos…',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppTheme.grey, // base color for the mask
          ),
        ),
      ),
    );
  }
}
