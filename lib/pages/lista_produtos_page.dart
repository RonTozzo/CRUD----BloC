import 'dart:developer';

import 'package:crud_bloc/widgets/main_search_bar.dart';
import 'package:flutter/material.dart';

class ListaProdutosPage extends StatefulWidget {
  final List listaProdutos;

  const ListaProdutosPage(this.listaProdutos, {Key? key}) : super(key: key);

  @override
  _ListaProdutosPageState createState() => _ListaProdutosPageState();
}

class _ListaProdutosPageState extends State<ListaProdutosPage> {
  Widget _cardProduto(Map produto) {
    log(produto.toString());
    return Column(
      children: [
        SizedBox(
          height: 150,
          child: Image.network(produto['image'] ?? '', errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Image.asset(
              'assets/images/error_load_image.png',
            );
          }),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: Text(
                produto['name'].toString(),
                style: const TextStyle(fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: '${produto['regular_price']}',
                      style:
                          (produto['discount_percentage'].toString().isNotEmpty)
                              ? const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey)
                              : const TextStyle(fontWeight: FontWeight.bold)),
                  if ((produto['discount_percentage'].toString().isNotEmpty))
                    TextSpan(
                        text: ' - ${produto['actual_price']}',
                        style: const TextStyle(color: Colors.red))
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              produto['installments'] ?? '',
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ListView(
        children: [
          // MainSearchBar(
          //   // controller: searchBarCtrl,
          //   hintText: 'Pesquise aqui...',
          //   // onChanged: (val) => _filtrarInput(val, listaProdutos),
          // ),
          const SizedBox(height: 8),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200, // largura maxima
              childAspectRatio: 0.7,
              crossAxisSpacing: 12,
              mainAxisSpacing: 24,
            ),
            itemCount: widget.listaProdutos.length,
            itemBuilder: (BuildContext context, int index) {
              return _cardProduto(widget.listaProdutos[index]);
            },
          ),
        ],
      ),
    );
  }
}