import 'package:flutter/material.dart';
import '../utils/currency_api.dart';
import 'utils.dart';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final _amountController = TextEditingController();
  final _fromController = TextEditingController(text: 'USD');
  final _toController = TextEditingController(text: 'BRL');
  double? _convertedValue;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _amountController.dispose();
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  Future<void> _convert() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _convertedValue = null;
    });
    try {
      final amount = double.tryParse(_amountController.text.trim());
      if (amount == null) {
        setState(() => _error = 'Valor inválido.');
        return;
      }
      final from = _fromController.text.trim().toUpperCase();
      final to = _toController.text.trim().toUpperCase();
      final rate = await getExchangeRate(from, to);
      setState(() {
        _convertedValue = amount * rate;
      });
    } catch (e) {
      setState(() => _error = 'Erro: ${e.toString()}');
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
                  child: Utils.buildInputField(
                    'De',
                    controller: _fromController,
                    type: TextInputType.text,
                    obscure: false,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.arrow_forward, size: 28),
                const SizedBox(width: 16),
                SizedBox(
                  width: 120,
                  child: Utils.buildInputField(
                    'Para',
                    controller: _toController,
                    type: TextInputType.text,
                    obscure: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Utils.buildButton(
              text: 'Converter',
              width: 200,
              onPressed: _convert,
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
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
