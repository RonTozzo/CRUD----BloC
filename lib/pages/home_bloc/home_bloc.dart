import 'dart:convert';
import 'package:crud_bloc/fun/armazenamento_fun.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(HomeState initialState) : super(HomeLoadingState());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    HomeState state = HomeLoadingState();
    switch (event.runtimeType) {
      case HomeFetchList:
        state = await _fetchList();
        break;
      case HomeFetchListWithError:
        state = await _fetchListWithError();
        break;
      case HomeFetchListWithEmptyList:
        state = await _fetchListWithEmptyList();
        break;
    }
    yield state;
  }

  Future<HomeState> _fetchList() async {
    List list = [];
    var aux = await buscarStorage('products');
    // log('Aux buscado' + aux.toString());
    if (aux == null) {
      final String response = await rootBundle.loadString('assets/db.json');
      // log('response arquivo' + response.toString());

      var data = await json.decode(response);
      // log('data decodado' + data.toString());

      list = data['products'];
      list.sort((a, b) {
        return a['name']
            .toString()
            .toLowerCase()
            .compareTo(b['name'].toString().toLowerCase());
      });
      await salvarStorage('products', list);
    } else {
      list = aux;
    }
    list.sort((a, b) {
      return a['name']
          .toString()
          .toLowerCase()
          .compareTo(b['name'].toString().toLowerCase());
    });
    return HomeStateLoaded(list: list);
  }
}

Future<HomeState> _fetchListWithEmptyList() async {
  return await Future.delayed(
      const Duration(
        seconds: 3,
      ),
      () => HomeStateEmptyList());
}

Future<HomeState> _fetchListWithError() async {
  return await Future.delayed(
      const Duration(
        seconds: 3,
      ),
      () => HomeErrorState(message: 'Não foi possível carregar os dados.'));
}
