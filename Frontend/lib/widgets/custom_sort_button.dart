import 'package:flutter/material.dart';

enum SortOrder {
  ascending,
  descending,
}

class SortIcon extends StatefulWidget {
  final SortOrder initialOrder;
  final Function(SortOrder) onSortChanged;

  SortIcon({required this.initialOrder, required this.onSortChanged});

  @override
  _SortIconState createState() => _SortIconState();
}

class _SortIconState extends State<SortIcon> {
  late SortOrder _currentOrder;

  @override
  void initState() {
    super.initState();
    _currentOrder = widget.initialOrder;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentOrder = _currentOrder == SortOrder.ascending
              ? SortOrder.descending
              : SortOrder.ascending;
          widget.onSortChanged(_currentOrder);
        });
      },
      child: Icon(
        _currentOrder == SortOrder.ascending
            ? Icons.arrow_upward
            : Icons.arrow_downward,
        color: Colors.black, // Измените цвет иконки по вашему вкусу
      ),
    );
  }
}
