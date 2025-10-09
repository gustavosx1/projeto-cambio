import 'package:flutter/material.dart';


class ExchangeRatesBox extends StatelessWidget {
  final bool _isLoading = false;
  final Map<String, dynamic> exchangeRates;
  final String fromCurrency;

  const ExchangeRatesBox({
    Key? key,
    required this.exchangeRates,
    required this.fromCurrency

}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    final rates = exchangeRates['rates'] ?? {};
    if (rates.isEmpty) {
      return Center(child: Text('Nenhuma taxa disponível'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Taxas atuais (base: $fromCurrency)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: rates.length,
            itemBuilder: (context, index) {
              final currency = rates.keys.elementAt(index);
              final rate = rates[currency];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(currency),
                  backgroundColor: Colors.blue[100],
                  foregroundColor: Colors.blue[700],
                ),
                title: Text(currency),
                trailing: Text(rate.toStringAsFixed(4)),
                tileColor: index.isEven ? Colors.grey[50] : null,
              );
            },
          ),
        ),
      ],
    );
  }
}