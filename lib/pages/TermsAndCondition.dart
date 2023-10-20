import 'package:flutter/material.dart';

class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
            child: RichText(
          text: TextSpan(
            text: 'Terms and Conditions',
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            children: <TextSpan>[
              TextSpan(
                text:
                    '\n\n1.	In order to browse items or complete a transaction as a Requester or Adder within the App, \n you must first complete the registration form and set up an account as an Satiety User 5.	You shall keep your registration details for the App (Login Details) confidential and secure Without prejudice to any other rights and remedies available to Satiety, Satiety reserves the right to promptly disable your Login Details and suspend your access to the App in the event that Satiety has any reason to believe you have breached any of the provisions in these Terms',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),
              TextSpan(
                text:
                    '\n\nPAYMENT \n Satiety does not provide any payment function, system or payment processing \n Payment and the terms of any payment are organised and agreed between the Seller and the Buyer\nSatiety has created some guidance for payments for Buyers and Sellers in the Selling on Satiety FAQ However, Satiety is not responsible or liable for any payments, any non-payment, any refunds or any issues in connection with any payments\nUse of For Sale is currently free of charge and no fees or commission for Buyers or Sellers are payable ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
