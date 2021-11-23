import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VxInput extends StatelessWidget {
  final String? _label;
  final String? _hintText;
  final TextEditingController? _controller;
  final _textMask;
  final TextInputType _textInputType;
  final Function(dynamic)? _onChanged;
  final Function(dynamic)? _onSaved;
  final String? Function(String?)? _validator;
  final Function? _onTap;
  final FocusNode? _focusNode;
  final bool _readOnly;
  final TextAlign _textAlign;
  final String? _initVal;

  const VxInput({
    label = '',
    hintText,
    controller,
    textMask,
    textInputType = TextInputType.text,
    onChanged,
    onSaved,
    validator,
    onTap,
    focusNode,
    readOnly = false,
    textAlign = TextAlign.start,
    initVal,
  })  : _label = label,
        _controller = controller,
        _textMask = textMask,
        _textInputType = textInputType,
        _onChanged = onChanged,
        _onSaved = onSaved,
        _validator = validator,
        _onTap = onTap,
        _focusNode = focusNode,
        _readOnly = readOnly,
        _hintText = hintText,
        _textAlign = textAlign,
        _initVal = initVal;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(
            _label!,
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
              child: TextFormField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: _hintText,
                    hintStyle:
                        TextStyle(color: Colors.grey[600]!.withOpacity(0.7))),
                initialValue: _initVal,
                textAlign: _textAlign,
                controller: _controller,
                keyboardType: _textInputType,
                inputFormatters: (_textMask != null) ? [_textMask] : [],
                readOnly: _readOnly,
                focusNode: _focusNode,
                onTap: () {
                  if (_onTap != null) {
                    _onTap!();
                  }
                },
                onChanged: (val) {
                  if (_onChanged != null) {
                    _onChanged!(val);
                  }
                },
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
              ),
            ),
          ],
        )
      ],
    );
  }
}
