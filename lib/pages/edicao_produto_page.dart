import 'dart:developer';
import 'package:crud_bloc/fun/armazenamento_fun.dart';
import 'package:crud_bloc/fun/dialogo_fun.dart';
import 'package:crud_bloc/widgets/main_input.dart';
import 'package:crud_bloc/widgets/main_select.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_bloc/home_event.dart';
import 'home_bloc/home_state.dart';
import 'home_page.dart';
import 'home_bloc/home_bloc.dart';

class EdicaoProduto extends StatefulWidget {
  @override
  _EdicaoProdutoState createState() => _EdicaoProdutoState();
}

class _EdicaoProdutoState extends State<EdicaoProduto> {
  final NumberFormat _br = NumberFormat('#,###,###,###,##0.00', 'pt_BR');

  Map produto = {};
  final GlobalKey<FormState> _formKey = GlobalKey();

  List disponivelParaVenda = [
    {
      'value': true,
      'txt': 'SIM',
    },
    {
      'value': false,
      'txt': 'NÃO',
    },
  ];
  List vezesEmCredito = [
    {
      'value': '1',
      'txt': '1x',
    },
    {
      'value': '2',
      'txt': '2x',
    },
    {
      'value': '3',
      'txt': '3x',
    },
    {
      'value': '4',
      'txt': '4x',
    },
    {
      'value': '5',
      'txt': '5x',
    },
    {
      'value': '6',
      'txt': '6x',
    },
    {
      'value': '7',
      'txt': '7x',
    },
  ];
  final nomeCtrl = TextEditingController();
  final regularPriceCtrl = TextEditingController();
  final actualPriceCtrl = TextEditingController();
  final discountPercentageCtrl = TextEditingController();
  final Map<String, dynamic> _formData = {
    'name': '',
    'on_sale': '',
    'regular_price': '',
    'actual_price': '',
    'discount_percentage': '',
    'installments': '',
  };
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 120), () async {
      produto = ModalRoute.of(context)!.settings.arguments as Map;
      nomeCtrl.text = produto['name'];
      regularPriceCtrl.text = produto['regular_price'];
      _formData['name'] = produto['name'];
      _formData['on_sale'] = produto['on_sale'];
      _formData['regular_price'] = produto['regular_price'];
      _formData['actual_price'] = produto['actual_price'];
      _formData['discount_percentage'] = produto['discount_percentage'];
      _formData['installments'] = produto['installments'];
      if (produto['regular_price'] != produto['actual_price']) {
        actualPriceCtrl.text = produto['actual_price'];
        discountPercentageCtrl.text = produto['discount_percentage'];
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final inputNome = MainInput(
      controller: nomeCtrl,
      label: 'Nome do produto',
      onChanged: (val) {
        if (val != null) {
          _formData['name'] = val;
        }
      },
      validator: (val) {
        if ((val ?? '').isEmpty) {
          return 'Defina um nome para o produto';
        }
      },
    );
    final inputPreco = MainInput(
      controller: regularPriceCtrl,
      label: 'Preço do produto',
      textMask: TextInputMask(
        mask: 'R!\$! !9+.999,99',
        reverse: true,
      ),
      onChanged: (val) {
        if (val != null) {
          _formData['regular_price'] = val;
        }
      },
      validator: (val) {
        if ((val ?? '').isEmpty) {
          return 'Defina um valor para o produto';
        }
      },
    );

    final inputPrecoPromocao = MainInput(
      controller: actualPriceCtrl,
      label: 'Preço de promoção do produto',
      hintText: 'Caso não tenha promoção, deixe em branco',
      textMask: TextInputMask(
        mask: 'R!\$! !9+.999,99',
        reverse: true,
      ),
      onChanged: (val) {
        if (val != null) {
          _formData['actual_price'] = val;
        }
      },
    );
    final inputPercentualDesconto = MainInput(
      controller: discountPercentageCtrl,
      label: 'Percentual de desconto',
      hintText: 'Caso não tenha desconto, deixe em branco',
      textMask: TextInputMask(
        mask: ' 9+999 !%!',
      ),
      onChanged: (val) {
        if (val != null) {
          val = val.toString().replaceAll(' ', '');
          _formData['discount_percentage'] = val;
        }
      },
    );
    final selectIsDisponivel = MainSelect(
      label: 'Disponivel para venda?',
      onChanged: (val) {
        if (val != null) {
          _formData['available'] = val;
        }
      },
      validator: (val) {
        if ((val ?? '').isEmpty) {
          return 'Defina a disponibilidade';
        }
      },
      items: disponivelParaVenda.map((dynamic val) {
        return MainSelectItem(
          text: val['txt'],
          value: val['value'],
        );
      }).toList(),
    );

    final selectVezesPagamanto = MainSelect(
      label: 'Em quantas vezes pode ser feito?',
      onChanged: (val) {
        if (val != null) {
          _formData['installments'] = val;
        }
      },
      validator: (val) {
        if ((val ?? '').isEmpty) {
          return 'Defina a possibilidade de crédito';
        }
      },
      items: vezesEmCredito.map((dynamic val) {
        return MainSelectItem(
          text: val['txt'],
          value: val['value'],
        );
      }).toList(),
    );

    final btnCadastrarCliente = ElevatedButton(
      child: const Text('SALVAR ALTERAÇÕES'),
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          List listaProdutos = await buscarStorage('products');
          if (_formData['actual_price'] == '' ||
              _formData['actual_price'] == null) {
            log('entrou');
            _formData['actual_price'] = _formData['regular_price'];
          }
          log(_formData['actual_price'].toString());
          var aux = _formData['actual_price'].toString().split(' ');
          log(aux.toString());
          String aux2 = aux[1].toString().replaceAll('.', '');
          aux2 = aux2.replaceAll(',', '.');
          double precoPrazo =
              double.parse(aux2) / int.parse(_formData['installments']);
          _formData['installments'] =
              '${_formData['installments']}x R\$ ${_br.format(precoPrazo)}';

          _formKey.currentState!.save();
          Map newProduct = {
            'name': _formData['name'],
            'on_sale': _formData['on_sale'],
            'regular_price': _formData['regular_price'],
            'actual_price': _formData['actual_price'],
            'discount_percentage': _formData['discount_percentage'],
            'installments': _formData['installments'],
          };
          for (var i = 0; i < listaProdutos.length; i++) {
            if (produto['style'] == listaProdutos[i]['style']) {
              listaProdutos[i]['name'] = newProduct['name'];
              listaProdutos[i]['on_sale'] = newProduct['on_sale'];
              listaProdutos[i]['regular_price'] = newProduct['regular_price'];
              listaProdutos[i]['actual_price'] = newProduct['actual_price'];
              listaProdutos[i]['discount_percentage'] =
                  newProduct['discount_percentage'];
              listaProdutos[i]['installments'] = newProduct['installments'];
              break;
            }
          }
          await salvarStorage('products', listaProdutos);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => BlocProvider<HomeBloc>(
                create: (BuildContext blocContext) =>
                    HomeBloc(HomeLoadingState())..add(HomeFetchList()),
                child: const HomePage(),
              ),
            ),
          );
        }
      },
    );

    final btnExcluirProduto = ElevatedButton(
      child: const Text('EXCLUIR PRODUTO'),
      style: ElevatedButton.styleFrom(
        primary: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      onPressed: () async {
        bool confirm = await mostrarAlertaConfirmacao(
            context, 'Você tem certeza que deseja excluir este produto?');
        if (confirm) {
          List listaProdutos = await buscarStorage('products');
          for (var i = 0; i < listaProdutos.length; i++) {
            if (produto['style'] == listaProdutos[i]['style']) {
              listaProdutos.removeAt(i);
              break;
            }
          }
          await salvarStorage('products', listaProdutos);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider<HomeBloc>(
                create: (BuildContext blocContext) =>
                    HomeBloc(HomeLoadingState())..add(HomeFetchList()),
                child: const HomePage(),
              ),
            ),
          );
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edição de produto'),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider<HomeBloc>(
                  create: (BuildContext blocContext) =>
                      HomeBloc(HomeLoadingState())..add(HomeFetchList()),
                  child: const HomePage(),
                ),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              inputNome,
              inputPreco,
              inputPrecoPromocao,
              inputPercentualDesconto,
              selectIsDisponivel,
              selectVezesPagamanto,
              btnCadastrarCliente,
              btnExcluirProduto,
            ],
          ),
        ),
      ),
    );
  }
}
