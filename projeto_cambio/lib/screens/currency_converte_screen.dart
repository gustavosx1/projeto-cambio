import 'package:flutter/material.dart';
import '../services/current_services.dart';

class CurrencyConverterScreen extends StatefulWidget {
  final Function() onLogout;

  const CurrencyConverterScreen({Key? key, required this.onLogout}) : super(key: key);

  @override
  _CurrencyConverterScreenState createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final TextEditingController _amountController = TextEditingController();
  final List<String> currencies = ['USD', 'BRL', 'EUR', 'GBP', 'JPY', 'CAD'];
  
  String _fromCurrency = 'USD';
  String _toCurrency = 'BRL';
  double _convertedAmount = 0.0;
  bool _isLoading = false;
  Map<String, dynamic> _exchangeRates = {};

  @override
  void initState() {
    super.initState();
    _loadExchangeRates();
  }

  Future<void> _loadExchangeRates() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final rates = await CurrencyService.getExchangeRates(_fromCurrency);
      setState(() {
        _exchangeRates = rates;
      });
    } catch (e) {
      // Usar dados mock em caso de erro
      setState(() {
        _exchangeRates = CurrencyService.getMockRates();
      });
      print('Usando dados mock: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _convertCurrency() {
    if (_amountController.text.isEmpty) return;

    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final rates = _exchangeRates['rates'] ?? {};

    if (rates.containsKey(_toCurrency)) {
      final rate = rates[_toCurrency];
      setState(() {
        _convertedAmount = amount * rate;
      });
    }
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
    });
    _loadExchangeRates();
    _convertCurrency();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversor de Moedas'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: widget.onLogout,
            tooltip: 'Sair',
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Card de entrada de valor
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        labelText: 'Valor a converter',
                        prefixIcon: Icon(Icons.attach_money),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) => _convertCurrency(),
                    ),
                    SizedBox(height: 20),
                    
                    // Seleção de moedas
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _fromCurrency,
                            items: currencies.map((String currency) {
                              return DropdownMenuItem<String>(
                                value: currency,
                                child: Text(currency),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _fromCurrency = newValue;
                                });
                                _loadExchangeRates();
                                _convertCurrency();
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'De',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          icon: Icon(Icons.swap_horiz),
                          onPressed: _swapCurrencies,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.blue[50],
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _toCurrency,
                            items: currencies.map((String currency) {
                              return DropdownMenuItem<String>(
                                value: currency,
                                child: Text(currency),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _toCurrency = newValue;
                                });
                                _convertCurrency();
                              }
                            },
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
            ),
            SizedBox(height: 20),

            // Card de resultado
            Card(
              elevation: 4,
              color: Colors.blue[50],
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'Resultado da Conversão',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                    SizedBox(height: 10),
                    _isLoading
                        ? CircularProgressIndicator()
                        : Text(
                            '${_amountController.text.isEmpty ? '0' : _amountController.text} $_fromCurrency =',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                    SizedBox(height: 5),
                    _isLoading
                        ? SizedBox()
                        : Text(
                            '${_convertedAmount.toStringAsFixed(2)} $_toCurrency',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Botão de conversão
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _convertCurrency,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  'Converter',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            // Taxas de câmbio atuais
            Expanded(
              child: _buildExchangeRatesList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExchangeRatesList() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    final rates = _exchangeRates['rates'] ?? {};
    if (rates.isEmpty) {
      return Center(child: Text('Nenhuma taxa disponível'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Taxas atuais (base: $_fromCurrency)',
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

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}