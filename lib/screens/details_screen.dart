import 'package:flutter/material.dart';
import '../config/db_heleper.dart';

class BuyingScreen extends StatefulWidget {
  @override
  _BuyingScreenState createState() => _BuyingScreenState();
}

class _BuyingScreenState extends State<BuyingScreen> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final DBHelper _dbHelper = DBHelper();

  void _buyProduct() async {
    String productName = _productNameController.text.trim();
    double price = double.tryParse(_priceController.text) ?? 0.0;
    int quantity = int.tryParse(_quantityController.text) ?? 0;

    if (productName.isEmpty || price <= 0 || quantity <= 0) {
      _showSnackBar('Please enter valid product details');
      return;
    }

    try {
      await _dbHelper.insertProduct({
        'name': productName,
        'price': price,
        'quantity': quantity,
      });

      await _dbHelper.insertBuyTransaction({
        'product_name': productName,
        'price': price,
        'quantity': quantity,
        'date': DateTime.now().toIso8601String(),
      });

      _showSnackBar('Product bought successfully!');
      _clearFields();
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
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
                    _buildTextField(_priceController, 'Price', TextInputType.number),
                    SizedBox(height: 16),
                    _buildTextField(_quantityController, 'Quantity', TextInputType.number),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _buyProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text('Buy', style: TextStyle(fontSize: 18, color: Colors.white)),
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

  Widget _buildTextField(TextEditingController controller, String label, [TextInputType? keyboardType]) {
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
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _customersController = TextEditingController();
  final DBHelper _dbHelper = DBHelper();

  void _sellProduct() async {
    String productName = _productNameController.text.trim();
    int customers = int.tryParse(_customersController.text) ?? 0;

    if (productName.isEmpty || customers <= 0) {
      _showSnackBar('Please enter valid details');
      return;
    }

    try {
      await _dbHelper.insertSellTransaction({
        'product_name': productName,
        'quantity': customers,
        'date': DateTime.now().toIso8601String(),
      });

      _showSnackBar('Product sold successfully!');
      _clearFields();
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
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
      _customersController.clear();
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
                    _buildTextField(_productNameController, 'Product Name'),
                    SizedBox(height: 16),
                    _buildTextField(_customersController, 'Number of Customers', TextInputType.number),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _sellProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text('Sell', style: TextStyle(fontSize: 18, color: Colors.white)),
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

  Widget _buildTextField(TextEditingController controller, String label, [TextInputType? keyboardType]) {
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

// Transaction Screen
class TransactionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              shrinkWrap: true,
              children: [
                _buildTransactionOption(context, 'Daily Transactions'),
                Divider(),
                _buildTransactionOption(context, 'Weekly Transactions'),
                Divider(),
                _buildTransactionOption(context, 'Monthly Transactions'),
                Divider(),
                _buildTransactionOption(context, 'Yearly Transactions'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionOption(BuildContext context, String title) {
    return ListTile(
      title: Text(title, style: TextStyle(fontSize: 18)),
      onTap: () {
        // TODO: Implement navigation to transaction details
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Navigate to $title')),
        );
      },
      trailing: Icon(Icons.arrow_forward_ios),
    );
  }
}

// Loan Screen
class LoanScreen extends StatefulWidget {
  @override
  _LoanScreenState createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen> {
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _customersNumberController = TextEditingController();
  final TextEditingController _dateToPayController = TextEditingController();
  final DBHelper _dbHelper = DBHelper();

  DateTime? selectedDate;

  void _submitLoan() async {
    String customerName = _customerNameController.text.trim();
    String productName = _productNameController.text.trim();
    int customersNumber = int.tryParse(_customersNumberController.text) ?? 0;
    String dateToPay = selectedDate?.toIso8601String() ?? '';

    if (customerName.isEmpty || productName.isEmpty || customersNumber <= 0 || dateToPay.isEmpty) {
      _showSnackBar('Please fill in all the details');
      return;
    }

    try {
      await _dbHelper.insertLoan({
        'customer_name': customerName,
        'product_name': productName,
        'customers_number': customersNumber,
        'date_to_pay': dateToPay,
      });

      _showSnackBar('Loan submitted successfully!');
      _clearFields();
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _clearFields() {
    setState(() {
      _customerNameController.clear();
      _productNameController.clear();
      _customersNumberController.clear();
      _dateToPayController.clear();
      selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loan'),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField(_customerNameController, 'Customer Name'),
                    SizedBox(height: 16),
                    _buildTextField(_productNameController, 'Product Name'),
                    SizedBox(height: 16),
                    _buildTextField(_customersNumberController, 'Number of Customers', TextInputType.number),
                    SizedBox(height: 16),
                    _buildDatePicker(),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submitLoan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text('Submit Loan', style: TextStyle(fontSize: 18, color: Colors.white)),
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

  Widget _buildTextField(TextEditingController controller, String label, [TextInputType? keyboardType]) {
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

  Widget _buildDatePicker() {
    return TextField(
      controller: _dateToPayController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Date to Pay',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onTap: () async {
        DateTime? date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
        );
        if (date != null) {
          setState(() {
            selectedDate = date;
            _dateToPayController.text = date.toLocal().toString().split(' ')[0];
          });
        }
      },
    );
  }
}
