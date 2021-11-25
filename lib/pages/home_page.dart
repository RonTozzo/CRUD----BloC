import 'package:crud_bloc/pages/cadastro_produto._page.dart';
import 'package:crud_bloc/pages/lista_produtos_page.dart';
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('MENU DOS PRODUTOS'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'LISTAGEM',
              ),
              Tab(
                text: 'CADASTRO',
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
                  CadastroProdutoPage(),
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
