import 'dart:developer';
import 'package:crud_bloc/pages/home/home_bloc/home_bloc.dart';
import 'package:crud_bloc/pages/home/home_bloc/home_state.dart';
import 'package:crud_bloc/widgets/main_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchBarCtrl = TextEditingController();
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
    return Scaffold(
      appBar:
          AppBar(title: const Text('LISTAGEM DOS PRODUTOS'), centerTitle: true),
      body: BlocBuilder<HomeBloc, HomeState>(
        bloc: BlocProvider.of<HomeBloc>(context),
        builder: (context, state) {
          if (state is HomeStateLoaded) {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: ListView(
                children: [
                  MainSearchBar(
                    controller: searchBarCtrl,
                    hintText: 'Pesquise aqui...',
                  ),
                  SizedBox(height: 8),
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200, // largura maxima
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 24,
                    ),
                    itemCount: state.list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _cardProduto(state.list[index]);
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
      ),
    );
  }
}
