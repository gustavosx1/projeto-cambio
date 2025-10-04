import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  static const String _apiKey = 'bbe4890ad421b775a31ec6b2'; // Obtenha em: https://exchangerate-api.com
  static const String _baseUrl = 'https://api.exchangerate-api.com/v4/latest/';

  static Future<Map<String, dynamic>> getExchangeRates(String baseCurrency) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl$baseCurrency'));
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Falha ao carregar taxas de câmbio');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Método simulado para quando não há API key
  static Map<String, dynamic> getMockRates() {
    return {
      'rates': {
        'USD': 1.0,
        'BRL': 5.50,
        'EUR': 0.85,
        'GBP': 0.73,
        'JPY': 110.0,
        'CAD': 1.25,
      }
    };
  }
}