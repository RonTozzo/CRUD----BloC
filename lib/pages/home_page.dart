import 'package:crud_bloc/pages/cadastro_produto._page.dart';
import 'package:crud_bloc/pages/home_bloc/home_event.dart';
import 'package:crud_bloc/pages/lista_produtos_page.dart';
import 'package:crud_bloc/util/armazenamento_util.dart';
import 'package:crud_bloc/widgets/main_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_bloc/home_bloc.dart';
import 'home_bloc/home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List listaProdutos = [];
  List defaultList = [];
  final searchBarCtrl = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  // Future.delayed(const Duration(milliseconds: 120), () async {
  //   listaProdutos = await ArmazenamentoUtil.buscar('products');
  //   setState(() {
  //     listaFiltrada = listaProdutos;
  //   });
  // });
  // }

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

  @override
  Widget build(BuildContext context) {
    // final tab1 = (

    //   builder: (context, state) {
    //     if (state is HomeStateLoaded) {
    //       defaultList = state.list;
    //       return
    //     }
    //     if (state is HomeErrorState) {
    //       return Center(
    //         child: Text(state.message),
    //       );
    //     }
    //     if (state is HomeStateEmptyList) {
    //       return const Center(
    //         child: Text('Não há dados disponíveis.'),
    //       );
    //     }

    //     return const Center(child: CircularProgressIndicator());
    //   },
    // );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('MENU DOS PRODUTOS'),
          centerTitle: true,
          bottom: TabBar(
            tabs: const [
              Tab(
                text: 'LISTAGEM DOS PRODUTOS',
              ),
              Tab(
                text: 'CADASTRO DE PRODUTO',
              ),
            ],
          ),
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          bloc: BlocProvider.of<HomeBloc>(context),
          builder: (context, state) {
            if (state is HomeStateLoaded) {
              // if (tabController != null) {
              return TabBarView(
                children: [
                  ListaProdutosPage(state.list),
                  CadastroProdutoPage()
                ],
              );
              // }
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
        ),
      ),
    );
  }
}
