import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  static const _widthOfTextFields = 320.0;
  final _allIsEntered = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            height: 35,
          ),
          Row(
            children: <Widget>[
              const SizedBox(
                width: 10,
              ),
              const Icon(
                Icons.arrow_back,
                size: 29,
              ),
              const SizedBox(
                width: 80,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  'assets/images/logo_icon.png',
                  width: 120,
                  height: 50,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const SizedBox(
            width: 320,
            child: Text(
              'Create your account',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'RalewayMedium',
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 50),
          const SizedBox(
            width: _widthOfTextFields,
            child: TextField(
              decoration: InputDecoration(labelText: 'Name'),
            ),
          ),
          const SizedBox(
            width: _widthOfTextFields,
            child: TextField(
              decoration:
                  InputDecoration(labelText: 'Phone number or email address'),
            ),
          ),
          const SizedBox(
            width: _widthOfTextFields,
            child: TextField(
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(labelText: 'Date of birth'),
            ),
          ),
          const SizedBox(height: 290),
          Row(
            children: <Widget>[
              const SizedBox(width: 280),
              ElevatedButton(
                child: const Text('Next'),
                onPressed: () {},
                style: (!_allIsEntered)
                    ? ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.grey.shade400),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.grey.shade600),
                        shape: MaterialStateProperty.all<StadiumBorder>(
                          const StadiumBorder(),
                        ),
                      )
                    : ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                        shape: MaterialStateProperty.all<StadiumBorder>(
                          const StadiumBorder(),
                        ),
                      ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
