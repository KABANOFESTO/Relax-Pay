import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Management'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BuyingScreen()),
                );
              },
              child: Text('Buy Product'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SellingScreen()),
                );
              },
              child: Text('Sell Product'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StocksListScreen()),
                );
              },
              child: Text('View Stocks'),
            ),
          ],
        ),
      ),
    );
  }
}

// Buying Screen
class BuyingScreen extends StatefulWidget {
  @override
  _BuyingScreenState createState() => _BuyingScreenState();
}

class _BuyingScreenState extends State<BuyingScreen> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  void _buyProduct() async {
    String productName = _productNameController.text.trim();
    double price = double.tryParse(_priceController.text) ?? 0.0;
    int quantity = int.tryParse(_quantityController.text) ?? 0;

    if (productName.isEmpty || price <= 0 || quantity <= 0) {
      _showSnackBar('Please enter valid product details');
      return;
    }

    try {
      await _postStockData({
        'product': productName,
        'price': price,
        'quantity': quantity,
      });

      _showSnackBar('Product bought successfully!');
      _clearFields();
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
    }
  }

  Future<void> _postStockData(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(
          'https://relax-pay-endpoints.onrender.com/customer/stock'), // Buying endpoint
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to save purchase data');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _clearFields() {
    setState(() {
      _productNameController.clear();
      _priceController.clear();
      _quantityController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buying'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextField(_productNameController, 'Product Name'),
                    SizedBox(height: 16),
                    _buildTextField(
                        _priceController, 'Price', TextInputType.number),
                    SizedBox(height: 16),
                    _buildTextField(
                        _quantityController, 'Quantity', TextInputType.number),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _buyProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text('Buy',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      [TextInputType? keyboardType]) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

// Selling Screen
class SellingScreen extends StatefulWidget {
  @override
  _SellingScreenState createState() => _SellingScreenState();
}

class _SellingScreenState extends State<SellingScreen> {
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _numberToReceiveController =
      TextEditingController();
  final TextEditingController _numberToPayController = TextEditingController();

  void _sellProduct() async {
    String product = _productController.text.trim();
    int quantity = int.tryParse(_quantityController.text) ?? 0;
    int numberToReceive = int.tryParse(_numberToReceiveController.text) ?? 0;
    int numberToPay = int.tryParse(_numberToPayController.text) ?? 0;

    if (product.isEmpty ||
        quantity <= 0 ||
        numberToReceive <= 0 ||
        numberToPay <= 0) {
      _showSnackBar('Please enter valid details');
      return;
    }

    try {
      await _postSaleData({
        'product': product,
        'quantity': quantity,
        'number_to_receive': numberToReceive,
        'number_to_pay': numberToPay,
      });

      _showSnackBar('Product sold successfully!');
      _clearFields();
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
    }
  }

  Future<void> _postSaleData(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(
          'https://relax-pay-endpoints.onrender.com/stock'), // Selling endpoint
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to save sale data');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _clearFields() {
    setState(() {
      _productController.clear();
      _quantityController.clear();
      _numberToReceiveController.clear();
      _numberToPayController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selling'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextField(_productController, 'Product'),
                    SizedBox(height: 16),
                    _buildTextField(
                        _quantityController, 'Quantity', TextInputType.number),
                    SizedBox(height: 16),
                    _buildTextField(_numberToReceiveController,
                        'Number to Receive', TextInputType.number),
                    SizedBox(height: 16),
                    _buildTextField(_numberToPayController, 'Number to Pay',
                        TextInputType.number),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _sellProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text('Sell',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      [TextInputType? keyboardType]) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

// Stocks List Screen
class StocksListScreen extends StatefulWidget {
  @override
  _StocksListScreenState createState() => _StocksListScreenState();
}

class _StocksListScreenState extends State<StocksListScreen> {
  List<dynamic> stocks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStocks();
  }

  Future<void> _fetchStocks() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://relax-pay-endpoints.onrender.com/stocks/stocks'),
      );

      if (response.statusCode == 200) {
        setState(() {
          stocks = json.decode(response.body)['stocks'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load stocks');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorSnackBar('Failed to load stocks. Please try again.');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stocks List'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchStocks,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : stocks.isEmpty
              ? Center(child: Text('No stocks available'))
              : RefreshIndicator(
                  onRefresh: _fetchStocks,
                  child: ListView.builder(
                    itemCount: stocks.length,
                    itemBuilder: (context, index) {
                      final stock = stocks[index];
                      return Card(
                        elevation: 4,
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ExpansionTile(
                          title: Text(
                            stock['product'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Quantity: ${stock['quantity']}'),
                          trailing: Text(
                            '\$${stock['price'].toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Total Value: \$${(stock['price'] * stock['quantity']).toStringAsFixed(2)}'),
                                  SizedBox(height: 8),
                                  Text(
                                      'Last Updated: ${DateTime.now().toString()}'), // Replace with actual last updated time if available
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
