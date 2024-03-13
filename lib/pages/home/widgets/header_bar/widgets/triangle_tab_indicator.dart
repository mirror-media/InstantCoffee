import 'package:flutter/material.dart';

class TriangleTabIndicator extends Decoration {
  final double radius;
  final Color color;
  final double indicatorHeight;

  const TriangleTabIndicator({
    this.radius = 8,
    this.indicatorHeight = 4,
    this.color = Colors.blue,
  });

  @override
  CustomPainter createBoxPainter([VoidCallback? onChanged]) {
    return CustomPainter(
      this,
      onChanged,
      radius,
      color,
      indicatorHeight,
    );
  }
}

class CustomPainter extends BoxPainter {
  final TriangleTabIndicator decoration;
  final double radius;
  final Color color;
  final double indicatorHeight;

  CustomPainter(
    this.decoration,
    VoidCallback? onChanged,
    this.radius,
    this.color,
    this.indicatorHeight,
  ) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);

    double xAxisPos = offset.dx + configuration.size!.width / 2 - 10;
    double yAxisPos =
        offset.dy + configuration.size!.height - indicatorHeight / 2 - 8;
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill; // 設置繪製樣式為填充
    Path path = Path(); // 創建路徑
    path.moveTo(16 / 2 + xAxisPos, 0 + yAxisPos); // 移動到頂點
    path.lineTo(16 + xAxisPos, 10 + yAxisPos); // 繪製到右下角
    path.lineTo(0 + xAxisPos, 10 + yAxisPos); // 繪製到左下角
    path.close(); // 關閉路徑，形成封閉的三角形

    canvas.drawPath(path, paint);
  }
}
