import 'package:flutter/material.dart';

class CurrencyBox extends StatelessWidget {
  final TextEditingController amountController;
  final List<String> currencies;
  final String fromCurrency;
  final String toCurrency;
  final Function(String?) onFromCurrencyChanged;
  final Function(String?) onToCurrencyChanged;
  final Function() onSwap;
  final Function(String) onAmountChanged;

  const CurrencyBox({
    Key? key,
    required this.amountController,
    required this.currencies,
    required this.fromCurrency,
    required this.toCurrency,
    required this.onFromCurrencyChanged,
    required this.onToCurrencyChanged,
    required this.onSwap,
    required this.onAmountChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'Valor a converter',
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: onAmountChanged,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: fromCurrency,
                    items: currencies.map((String currency) {
                      return DropdownMenuItem<String>(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                    onChanged: onFromCurrencyChanged,
                    decoration: InputDecoration(
                      labelText: 'De',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.swap_horiz),
                  onPressed: onSwap,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: toCurrency,
                    items: currencies.map((String currency) {
                      return DropdownMenuItem<String>(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                    onChanged: onToCurrencyChanged,
                    decoration: InputDecoration(
                      labelText: 'Para',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}