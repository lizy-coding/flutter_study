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
  static const double snapThreshold = 10.0;
  
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
    
    for (final snapLine in snapLines) {
      if (snapLine.type == SnapType.vertical) {
        if ((position.dx - snapLine.start.dx).abs() < snapThreshold) {
          newX = snapLine.start.dx;
        }
      } else if (snapLine.type == SnapType.horizontal) {
        if ((position.dy - snapLine.start.dy).abs() < snapThreshold) {
          newY = snapLine.start.dy;
        }
      }
    }
    
    return Offset(newX, newY);
  }
}