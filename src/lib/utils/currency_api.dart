import 'dart:convert';
import 'package:http/http.dart' as http;

Future<double> getExchangeRate(String currency, String baseCurrency) async {
  // Check if the currency is valid
  if (currency.isEmpty || baseCurrency.isEmpty) {
    throw ArgumentError('Moeda ou moeda base não podem ser vazias.');
  }

  // Uppercase the currency codes to ensure consistency
  currency = currency.toUpperCase();
  baseCurrency = baseCurrency.toUpperCase();

  final url = 'https://economia.awesomeapi.com.br/json/last/$currency-$baseCurrency';
  
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data.isNotEmpty) {
      return data['$currency$baseCurrency']['bid'];
    } else {
      throw Exception('Dados não encontrados para a moeda solicitada.');
    }
  } else {
    throw Exception('Falha ao carregar dados: ${response.statusCode}');
  }
}