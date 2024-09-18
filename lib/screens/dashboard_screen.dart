import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Handle logout logic here
              Navigator.pushReplacementNamed(context, '/login'); // Example of navigating to login screen
            },
          ),
        ],
      ),
      body: Center( // Center the GridView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2, // Number of columns
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            shrinkWrap: true, // Ensure it wraps content
            children: [
              _buildDashboardItem(
                context,
                Icons.shopping_cart,
                'Buying',
                Colors.blue,
                () {
                  Navigator.pushNamed(context, '/buying');
                },
              ),
              _buildDashboardItem(
                context,
                Icons.sell,
                'Selling',
                Colors.green,
                () {
                  Navigator.pushNamed(context, '/selling');
                },
              ),
              _buildDashboardItem(
                context,
                Icons.account_balance_wallet,
                'Transaction',
                Colors.orange,
                () {
                  Navigator.pushNamed(context, '/transaction');
                },
              ),
              _buildDashboardItem(
                context,
                Icons.monetization_on,
                'Loan',
                Colors.purple,
                () {
                  Navigator.pushNamed(context, '/loan');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardItem(
      BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200), // Animation duration
        curve: Curves.easeInOut, // Smooth transition
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: label, // Hero animation tag
                child: Icon(
                  icon,
                  size: 50,
                  color: color,
                ),
              ),
              SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
