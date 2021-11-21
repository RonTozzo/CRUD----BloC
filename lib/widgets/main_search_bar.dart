import 'package:flutter/material.dart';

class MainSearchBar extends StatelessWidget {
  final String? _hintText;
  final TextEditingController? _controller;
  final Function(dynamic)? _onChanged;
  final FocusNode? _focusNode;

  const MainSearchBar({
    hintText = '',
    controller,
    onChanged,
    focusNode,
  })  : _controller = controller,
        _onChanged = onChanged,
        _focusNode = focusNode,
        _hintText = hintText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                  contentPadding: EdgeInsets.only(left: 32),
                  hintText: _hintText,
                ),
                controller: _controller,
                focusNode: _focusNode,
                onChanged: (val) {
                  if (_onChanged != null) {
                    _onChanged!(val);
                  }
                },
              ),
            ),
            Positioned(
              top: 14,
              left: 14,
              child: Icon(
                Icons.search,
                color: Colors.grey[600],
              ),
            ),
          ],
        )
      ],
    );
  }
}
