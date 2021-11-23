import 'package:crud_bloc/pages/home_bloc/home_event.dart';
import 'package:crud_bloc/util/armazenamento_util.dart';
import 'package:crud_bloc/widgets/main_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_bloc/home_bloc.dart';
import 'home_bloc/home_state.dart';

class ListaProdutosPage extends StatefulWidget {
  const ListaProdutosPage({Key? key}) : super(key: key);

  @override
  _ListaProdutosPageState createState() => _ListaProdutosPageState();
}

class _ListaProdutosPageState extends State<ListaProdutosPage> {
  List listaProdutos = [];
  List defaultList = [];
  final searchBarCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Future.delayed(const Duration(milliseconds: 120), () async {
    //   listaProdutos = await ArmazenamentoUtil.buscar('products');
    //   setState(() {
    //     listaFiltrada = listaProdutos;
    //   });
    // });
  }

  void _filtrarInput(String val, List listaProduto) {
    // var list = [];
    // if (val.isEmpty) {
    //   list = listaProdutos;
    // } else {
    //   list = listaProdutos
    //       .where((produto) => produto['name']
    //           .toString()
    //           .toLowerCase()
    //           .contains(val.toLowerCase()))
    //       .toList();
    // }
    // setState(() {
    //   listaProduto = list;
    // });
  }

  Widget _cardProduto(Map produto) {
    return Column(
      children: [
        SizedBox(
          height: 150,
          child: Image.network(produto['image'], errorBuilder:
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
              produto['installments'],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final tab1 = BlocBuilder<HomeBloc, HomeState>(
      bloc: BlocProvider.of<HomeBloc>(context),
      builder: (context, state) {
        if (state is HomeStateLoaded) {
          defaultList = state.list;
          return Padding(
            padding: const EdgeInsets.all(12),
            child: ListView(
              children: [
                MainSearchBar(
                    controller: searchBarCtrl,
                    hintText: 'Pesquise aqui...',
                    onChanged: (val) => _filtrarInput(val, listaProdutos)),
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
                  itemCount: listaProdutos.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _cardProduto(listaProdutos[index]);
                  },
                ),
              ],
            ),
          );
        }
        if (state is HomeErrorState) {
          return Center(
            child: Text(state.message),
          );
        }
        if (state is HomeStateEmptyList) {
          return const Center(
            child: Text('Não há dados disponíveis.'),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('MENU DOS PRODUTOS'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'LISTAGEM DOS PRODUTOS',
              ),
              Tab(
                text: 'CADASTRO DE PRODUTO',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            tab1,
            BlocBuilder<HomeBloc, HomeState>(
              bloc: BlocProvider.of<HomeBloc>(context),
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: [],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
