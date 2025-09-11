import 'dart:async';
import 'package:flutter/material.dart';
import '../models/drawing_element.dart';

class SnapLine {
  final Offset start;
  final Offset end;
  final SnapType type;

  const SnapLine({
    required this.start,
    required this.end,
    required this.type,
  });
}

enum SnapType {
  horizontal,
  vertical,
  center,
}

class AdsorptionManager {
  static const double snapThreshold = 25.0;

  /// 延迟隐藏时间（毫秒）
  static const int hideDelayMs = 300;

  /// 当前是否处于吸附状态
  static bool _isSnapped = false;

  /// 延迟隐藏计时器
  static Timer? _hideTimer;

  /// 最后一次吸附的线条
  static List<SnapLine> _lastSnapLines = [];

  /// 位置历史记录，用于平滑移动
  static Offset? _lastPosition;
  static int _stableFrameCount = 0;
  static const int _requiredStableFrames = 3;

  /// 磁吸效果阻尼函数
  /// 当距离接近阈值时，产生非线性阻力效果，添加死区避免晃动
  static double magnetEffect(double distance, double threshold) {
    if (distance.abs() < threshold) {
      final ratio = distance.abs() / threshold;

      // 添加死区，避免在极近距离时的晃动
      if (distance.abs() < 1.0) {
        return 0; // 完全停止移动
      }

      // 使用更平滑的阻尼曲线，减少突变
      // 使用三次函数提供更平滑的过渡
      final smoothRatio = 1 - (1 - ratio) * (1 - ratio) * (1 - ratio);
      final dampingFactor = 0.05 + 0.15 * smoothRatio;

      return distance * dampingFactor;
    }
    return distance;
  }

  /// 获取可见的吸附线（带延迟隐藏机制）
  static List<SnapLine> getVisibleSnapLines(
    List<DrawingElement> elements,
    DrawingElement? currentElement,
  ) {
    if (currentElement == null) return [];

    final allSnapLines = calculateSnapLines(elements, currentElement);
    final visibleLines = <SnapLine>[];
    final currentSnapPoints = currentElement.getSnapPoints();
    bool hasActiveSnap = false;

    for (final snapLine in allSnapLines) {
      bool shouldShow = false;

      for (final point in currentSnapPoints) {
        if (snapLine.type == SnapType.vertical) {
          if ((point.dx - snapLine.start.dx).abs() < snapThreshold) {
            shouldShow = true;
            hasActiveSnap = true;
            break;
          }
        } else if (snapLine.type == SnapType.horizontal) {
          if ((point.dy - snapLine.start.dy).abs() < snapThreshold) {
            shouldShow = true;
            hasActiveSnap = true;
            break;
          }
        }
      }

      if (shouldShow) {
        visibleLines.add(snapLine);
      }
    }

    // 更新吸附状态和延迟隐藏逻辑
    if (hasActiveSnap) {
      // 有活跃的吸附，取消隐藏计时器
      _hideTimer?.cancel();
      _isSnapped = true;
      _lastSnapLines = visibleLines;
      return visibleLines;
    } else {
      // 没有活跃吸附
      if (_isSnapped) {
        // 刚离开吸附状态，启动延迟隐藏
        _isSnapped = false;
        _hideTimer?.cancel();
        _hideTimer = Timer(Duration(milliseconds: hideDelayMs), () {
          _lastSnapLines.clear();
        });
        // 在延迟期间继续显示上次的吸附线
        return _lastSnapLines;
      } else {
        // 非吸附状态且不在延迟期间
        return _lastSnapLines.isEmpty ? [] : _lastSnapLines;
      }
    }
  }

  static List<SnapLine> calculateSnapLines(
    List<DrawingElement> elements,
    DrawingElement? currentElement,
  ) {
    if (currentElement == null) return [];

    final snapLines = <SnapLine>[];
    final currentSnapPoints = currentElement.getSnapPoints();

    for (final element in elements) {
      if (element.id == currentElement.id) continue;

      final elementSnapPoints = element.getSnapPoints();

      for (final currentPoint in currentSnapPoints) {
        for (final elementPoint in elementSnapPoints) {
          if ((currentPoint.dx - elementPoint.dx).abs() < snapThreshold) {
            snapLines.add(SnapLine(
              start: Offset(elementPoint.dx, 0),
              end: Offset(elementPoint.dx, double.infinity),
              type: SnapType.vertical,
            ));
          }

          if ((currentPoint.dy - elementPoint.dy).abs() < snapThreshold) {
            snapLines.add(SnapLine(
              start: Offset(0, elementPoint.dy),
              end: Offset(double.infinity, elementPoint.dy),
              type: SnapType.horizontal,
            ));
          }
        }
      }
    }

    return snapLines;
  }

  static Offset snapPosition(
    Offset position,
    List<DrawingElement> elements,
    DrawingElement currentElement,
  ) {
    final snapLines = calculateSnapLines(elements, currentElement);
    double newX = position.dx;
    double newY = position.dy;

    // 查找最近的吸附线
    double minXDistance = double.infinity;
    double minYDistance = double.infinity;
    double snapX = position.dx;
    double snapY = position.dy;

    for (final snapLine in snapLines) {
      if (snapLine.type == SnapType.vertical) {
        final distance = position.dx - snapLine.start.dx;
        if (distance.abs() < snapThreshold &&
            distance.abs() < minXDistance.abs()) {
          minXDistance = distance;
          snapX = snapLine.start.dx;
        }
      } else if (snapLine.type == SnapType.horizontal) {
        final distance = position.dy - snapLine.start.dy;
        if (distance.abs() < snapThreshold &&
            distance.abs() < minYDistance.abs()) {
          minYDistance = distance;
          snapY = snapLine.start.dy;
        }
      }
    }

    // 应用磁吸效果
    if (minXDistance != double.infinity) {
      final magnetX = magnetEffect(minXDistance, snapThreshold);
      newX = position.dx - magnetX;

      // 当非常接近时直接吸附
      if (minXDistance.abs() < 2.0) {
        newX = snapX;
      }
    }

    if (minYDistance != double.infinity) {
      final magnetY = magnetEffect(minYDistance, snapThreshold);
      newY = position.dy - magnetY;

      // 当非常接近时直接吸附
      if (minYDistance.abs() < 2.0) {
        newY = snapY;
      }
    }

    return Offset(newX, newY);
  }

  /// 应用磁吸效果的拖拽方法
  /// 这是主要的磁吸逻辑，会产生阻力感和自动吸附
  static Offset applyMagneticEffect(
    Offset currentPosition,
    List<DrawingElement> elements,
    DrawingElement currentElement,
  ) {
    final snapLines = calculateSnapLines(elements, currentElement);

    // 获取当前元素的吸附点
    final currentSnapPoints = currentElement.getSnapPoints();

    double finalX = currentPosition.dx;
    double finalY = currentPosition.dy;

    // 查找最近的吸附线并应用磁吸效果
    double minXDistance = double.infinity;
    double minYDistance = double.infinity;

    for (final snapLine in snapLines) {
      for (final snapPoint in currentSnapPoints) {
        if (snapLine.type == SnapType.vertical) {
          final distance = snapPoint.dx - snapLine.start.dx;
          if (distance.abs() < snapThreshold &&
              distance.abs() < minXDistance.abs()) {
            minXDistance = distance;
          }
        } else if (snapLine.type == SnapType.horizontal) {
          final distance = snapPoint.dy - snapLine.start.dy;
          if (distance.abs() < snapThreshold &&
              distance.abs() < minYDistance.abs()) {
            minYDistance = distance;
          }
        }
      }
    }

    // 应用磁吸阻尼效果
    if (minXDistance != double.infinity) {
      // 计算阻尼后的位移
      final dampedDistance = magnetEffect(minXDistance, snapThreshold);
      final newX = currentPosition.dx - (minXDistance - dampedDistance);

      // 当非常接近时直接吸附，避免晃动
      if (minXDistance.abs() < 2.0) {
        finalX = currentPosition.dx - minXDistance;
      } else {
        // 使用插值平滑过渡，减少突变
        const t = 0.3; // 平滑系数
        finalX = finalX * (1 - t) + newX * t;
      }
    }

    if (minYDistance != double.infinity) {
      // 计算阻尼后的位移
      final dampedDistance = magnetEffect(minYDistance, snapThreshold);
      final newY = currentPosition.dy - (minYDistance - dampedDistance);

      // 当非常接近时直接吸附，避免晃动
      if (minYDistance.abs() < 2.0) {
        finalY = currentPosition.dy - minYDistance;
      } else {
        // 使用插值平滑过渡，减少突变
        const t = 0.3; // 平滑系数
        finalY = finalY * (1 - t) + newY * t;
      }
    }

    // 稳定性检查，避免微小晃动
    final result = Offset(finalX, finalY);

    if (_lastPosition != null) {
      final deltaX = (result.dx - _lastPosition!.dx).abs();
      final deltaY = (result.dy - _lastPosition!.dy).abs();

      // 如果移动距离很小，认为是稳定的
      if (deltaX < 0.5 && deltaY < 0.5) {
        _stableFrameCount++;

        // 连续稳定帧数足够时，停止微调
        if (_stableFrameCount >= _requiredStableFrames) {
          _lastPosition = result;
          return _lastPosition!;
        }
      } else {
        _stableFrameCount = 0;
      }
    }

    _lastPosition = result;
    return result;
  }

  /// 清理延迟隐藏计时器（在页面销毁时调用）
    static void dispose() {
      _hideTimer?.cancel();
      _hideTimer = null;
      _lastSnapLines.clear();
      _isSnapped = false;
      _lastPosition = null;
      _stableFrameCount = 0;
    }
}
