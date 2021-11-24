import 'package:flutter/material.dart';

class MainSelectItem {
  String text;
  dynamic value;

  MainSelectItem({required this.text, this.value});
}

class MainSelect extends StatelessWidget {
  final String _label;
  final List<MainSelectItem> items;
  final dynamic _value;
  final Function(dynamic)? _onSaved;
  final Function(dynamic)? _onChanged;
  final Function(dynamic)? _validator;

  const MainSelect({
    required label,
    required this.items,
    onChanged,
    onSave,
    validator,
    value,
  })  : _label = label,
        _onChanged = onChanged,
        _onSaved = onSave,
        _validator = validator,
        _value = value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              _label,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
              textWidthBasis: TextWidthBasis.longestLine,
            ),
          ),
          SizedBox(height: 2),
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Color.fromRGBO(233, 237, 246, 1)),
                height: 52,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 1, 12, 1),
                child: DropdownButtonFormField(
                  value: _value,
                  decoration: InputDecoration(border: InputBorder.none),
                  isExpanded: true,
                  // itemHeight: 40,
                  items: items.map((e) {
                    return DropdownMenuItem<String>(
                      value: e.value.toString(),
                      child: Text(
                        e.text.toString(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onSaved: (val) {
                    if (_onSaved != null) {
                      _onSaved!(val);
                    }
                  },
                  validator: (val) {
                    if (_validator != null) {
                      return _validator!(val);
                    }
                  },
                  onChanged: (val) {
                    print('onChanged');
                    if (_onChanged != null) {
                      _onChanged!(val);
                    }
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
