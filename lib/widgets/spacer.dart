part of 'widgets.dart';

class HSpacer extends StatelessWidget {
  const HSpacer({super.key, this.space = 8});

  final double space;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: space,
    );
  }
}

class VSpacer extends StatelessWidget {
  const VSpacer({super.key, this.space = 8});

  final double space;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: space,
    );
  }
}
