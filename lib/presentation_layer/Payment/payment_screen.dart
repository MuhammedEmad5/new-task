import 'package:flutter/material.dart';

import '../../application_layer/App_colors.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key, required this.myCoins});
  final String myCoins;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text('Payment Options',style: Theme.of(context).textTheme.displayMedium,),
        actions: [
          myCoinsWidget(context, myCoins),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PaymentOptionCard(
              icon: Icons.credit_card,
              title: 'Credit Card',
              onTap: () {
                // Handle credit card payment
              },
            ),
            SizedBox(height: 20),
            PaymentOptionCard(
              icon: Icons.account_balance_wallet,
              title: 'PayPal',
              onTap: () {
                // Handle PayPal payment
              },
            ),
            SizedBox(height: 20),
            PaymentOptionCard(
              icon: Icons.phone_android,
              title: 'Vodafone Cash',
              onTap: () {
                // Handle Vodafone Cash payment
              },
            ),
          ],
        ),
      ),
    );
  }
  Widget myCoinsWidget(context,myCoins) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          myCoins,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: AppColors.thirdColor),
        ),
        const Icon(
          Icons.attach_money,
          color: Colors.orange,
        ),
      ],
    );
  }
}

class PaymentOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const PaymentOptionCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 40,color: Colors.teal,),
              const SizedBox(width: 20),
              Text(
                title,
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

