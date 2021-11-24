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

  @override
  Widget build(BuildContext context) {
    final inputNome = MainInput(
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
      label: 'Percentual de desconto',
      hintText: 'Caso não tenha desconto, deixe em branco',
      textMask: TextInputMask(
        mask: ' 9+999 !%!',
      ),
      onChanged: (val) {
        if (val != null) {
          val = val.toString().replaceAll(' ', '');
          log(val);
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
      child: const Text('Cadastrar Produto'),
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          List listaProdutos = await ArmazenamentoUtil.buscar('products');
          if (_formData['actual_price'] == '' ||
              _formData['actual_price'] == null) {
            _formData['actual_price'] = _formData['regular_price'];
          }

          var aux = _formData['actual_price'].toString().split(' ');
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

          listaProdutos.add(newProduct);
          await ArmazenamentoUtil.salvar('products', listaProdutos);

          Navigator.of(context).push(
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
    return Padding(
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
          ],
        ),
      ),
    );
  }
}
