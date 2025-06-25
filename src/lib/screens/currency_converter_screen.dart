import 'package:flutter/material.dart';
import '../utils/currency_api.dart';
import 'utils.dart';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final _amountController = TextEditingController();
  final _fromController = TextEditingController(text: 'USD');
  final _toController = TextEditingController(text: 'BRL');
  double? _convertedValue;
  bool _isLoading = false;
  String? _error;

  final List<String> _currencies = [
    'USD',
    'BRL',
    'EUR',
    'GBP',
    'ARS',
    'CAD',
    'AUD',
    'JPY',
    'CHF',
    'CNY',
    'BTC',
    'ETH',
  ];
  String _selectedFrom = 'USD';
  String _selectedTo = 'BRL';

  @override
  void initState() {
    super.initState();
    _fromController.text = _selectedFrom;
    _toController.text = _selectedTo;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  Future<void> _convert() async {
    if (_isLoading) return; // Evita múltiplas conversões simultâneas
    setState(() {
      _isLoading = true;
      _error = null;
      _convertedValue = null;
    });
    try {
      String input = _amountController.text.trim().replaceAll(',', '.');
      if (input.isEmpty) {
        setState(() => _error = 'Digite um valor.');
        return;
      }
      final amount = double.tryParse(input);
      if (amount == null || amount < 0) {
        setState(() => _error = 'Valor inválido.');
        return;
      }
      final from = _selectedFrom;
      final to = _selectedTo;
      double rate;
      try {
        rate = await getExchangeRate(from, to);
      } catch (e) {
        setState(
          () => _error = 'Erro ao obter taxa de câmbio. Tente novamente.',
        );
        return;
      }
      setState(() {
        _convertedValue = amount * rate;
      });
    } catch (e, s) {
      debugPrint('Erro inesperado na conversão: $e\n$s');
      setState(() => _error = 'Erro inesperado ao converter.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.buildHeader('Conversor de Moeda'),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Utils.buildInputField(
              'Valor',
              controller: _amountController,
              type: TextInputType.number,
              obscure: false,
              width: 300,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  child: DropdownButtonFormField<String>(
                    value: _selectedFrom,
                    items:
                        _currencies
                            .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedFrom = value!;
                        _fromController.text = value;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'De'),
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.arrow_forward, size: 28),
                const SizedBox(width: 16),
                SizedBox(
                  width: 120,
                  child: DropdownButtonFormField<String>(
                    value: _selectedTo,
                    items:
                        _currencies
                            .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTo = value!;
                        _toController.text = value;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Para'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Utils.buildButton(
              text: 'Converter',
              width: 200,
              onPressed: _isLoading ? () {} : () => _convert(),
            ),
            const SizedBox(height: 24),
            if (_isLoading) const CircularProgressIndicator(),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            if (_convertedValue != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'Resultado: ${_amountController.text} ${_fromController.text.toUpperCase()} = ${_convertedValue!.toStringAsFixed(2)} ${_toController.text.toUpperCase()}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
