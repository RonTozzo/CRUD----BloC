import 'dart:developer';
import 'package:flutter/material.dart';

class ListaProdutosPage extends StatefulWidget {
  final List listaProdutos;

  const ListaProdutosPage(this.listaProdutos, {Key? key}) : super(key: key);

  @override
  _ListaProdutosPageState createState() => _ListaProdutosPageState();
}

class _ListaProdutosPageState extends State<ListaProdutosPage> {

  Widget _cardProduto(Map produto) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/edicao_produto',
                arguments: produto);
          },
          leading: Image.network(
            produto['image'] ?? '',
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return Image.asset(
                'assets/images/error_load_image.png',
              );
            },
          ),
          title: Text(
            produto['name'].toString(),
            style: const TextStyle(fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text: '${produto['regular_price']}',
                        style: (produto['discount_percentage']
                                .toString()
                                .isNotEmpty)
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
              Text(
                produto['installments'] ?? '',
              ),
            ],
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios_outlined,
            size: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ListView(
        children: [
          const SizedBox(height: 8),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
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
