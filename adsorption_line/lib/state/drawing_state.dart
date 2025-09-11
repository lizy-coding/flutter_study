import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/drawing_element.dart';

class DrawingState extends ChangeNotifier {
  final List<DrawingElement> _elements = [];
  DrawingElement? _selectedElement;
  bool _isDragging = false;
  Offset? _dragOffset;
  
  List<DrawingElement> get elements => List.unmodifiable(_elements);
  DrawingElement? get selectedElement => _selectedElement;
  bool get isDragging => _isDragging;
  
  void addElement(DrawingElement element) {
    _elements.add(element);
    notifyListeners();
  }
  
  void removeElement(String elementId) {
    _elements.removeWhere((element) => element.id == elementId);
    if (_selectedElement?.id == elementId) {
      _selectedElement = null;
    }
    notifyListeners();
  }
  
  void updateElement(DrawingElement updatedElement) {
    final index = _elements.indexWhere((element) => element.id == updatedElement.id);
    if (index != -1) {
      _elements[index] = updatedElement;
      if (_selectedElement?.id == updatedElement.id) {
        _selectedElement = updatedElement;
      }
      notifyListeners();
    }
  }
  
  void selectElement(String? elementId) {
    _selectedElement = elementId != null
        ? _elements.firstWhere((element) => element.id == elementId)
        : null;
    notifyListeners();
  }
  
  void clearSelection() {
    _selectedElement = null;
    notifyListeners();
  }
  
  void startDrag(Offset position) {
    _isDragging = true;
    _dragOffset = position;
    notifyListeners();
  }
  
  void updateDrag(Offset position) {
    if (_isDragging && _selectedElement != null && _dragOffset != null) {
      final delta = position - _dragOffset!;
      final newPosition = _selectedElement!.position + delta;
      
      final updatedElement = _selectedElement!.copyWith(position: newPosition);
      updateElement(updatedElement);
      
      _dragOffset = position;
    }
  }
  
  void endDrag() {
    _isDragging = false;
    _dragOffset = null;
    notifyListeners();
  }
  
  DrawingElement? findElementAt(Offset position) {
    for (int i = _elements.length - 1; i >= 0; i--) {
      if (_elements[i].containsPoint(position)) {
        return _elements[i];
      }
    }
    return null;
  }
  
  void clear() {
    _elements.clear();
    _selectedElement = null;
    _isDragging = false;
    _dragOffset = null;
    notifyListeners();
  }

  /// 删除选中的元素
  void deleteSelectedElement() {
    if (_selectedElement != null) {
      removeElement(_selectedElement!.id);
    }
  }

  /// 处理键盘事件
  bool handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      // Delete键或Backspace键删除选中元素
      if (event.logicalKey == LogicalKeyboardKey.delete ||
          event.logicalKey == LogicalKeyboardKey.backspace) {
        deleteSelectedElement();
        return true;
      }
      // Escape键取消选择
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        clearSelection();
        return true;
      }
    }
    return false;
  }
}