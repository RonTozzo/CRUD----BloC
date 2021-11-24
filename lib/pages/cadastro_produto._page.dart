import 'dart:developer';

import 'package:crud_bloc/util/armazenamento_util.dart';
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

class CadastroProdutoPage extends StatefulWidget {
  CadastroProdutoPage({Key? key}) : super(key: key);

  @override
  _CadastroProdutoPageState createState() => _CadastroProdutoPageState();
}

class _CadastroProdutoPageState extends State<CadastroProdutoPage> {
  final NumberFormat _br = NumberFormat('#,###,###,###,##0.00', 'pt_BR');
  final GlobalKey<FormState> _formKey = GlobalKey();
  final Map<String, dynamic> _formData = {
    'name': '',
    'on_sale': '',
    'regular_price': '',
    'actual_price': '',
    'discount_percentage': '',
    'installments': '',
  };
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
      'txt': '5x',
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            MainInput(
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
            ),
            MainInput(
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
            ),
            MainInput(
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
            ),
            MainInput(
              label: 'Percentual de desconto',
              hintText: 'Caso não tenha desconto, deixe em branco',
              onChanged: (val) {
                if (val != null) {
                  _formData['discount_percentage'] = val;
                }
              },
            ),
            MainSelect(
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
            ),
            MainSelect(
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
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    List listaProdutos =
                        await ArmazenamentoUtil.buscar('products');
                    if (_formData['actual_price'] == '' ||
                        _formData['actual_price'] == null) {
                      _formData['actual_price'] = _formData['regular_price'];
                    }
                    var aux = _formData['actual_price'].toString().split(' ');
                    double preco = double.parse(aux[1]);
                    double precoPrazo =
                        preco / int.parse(_formData['installments']);
                    _formData['installments'] =
                        '${_formData['installments']}x R\$ ${_br.format(precoPrazo)}';
                    log(_formData['installments']);
                    _formKey.currentState!.save();

                    Map newProduct = {
                      'name': _formData['name'],
                      'on_sale': _formData['on_sale'],
                      'regular_price': _formData['regular_price'],
                      'actual_price': _formData['actual_price'],
                      'discount_percentage': _formData['discount_percentage'],
                    };
                    // log(listaProdutos.length.toString());
                    listaProdutos.add(newProduct);
                    // log(listaProdutos.length.toString());
                    // log(listaProdutos.toString());
                    await ArmazenamentoUtil.salvar('products', listaProdutos);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider<HomeBloc>(
                          create: (BuildContext blocContext) =>
                              HomeBloc(HomeLoadingState())
                                ..add(HomeFetchList()),
                          child: const HomePage(),
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Cadastrar Produto'))
          ],
        ),
      ),
    );
  }
}
