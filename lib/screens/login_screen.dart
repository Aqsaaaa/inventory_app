import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inventory/gen/colors.gen.dart';
import 'package:inventory/widget/dialog_widget.dart';
import '../../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nrpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthRepository _authRepository = AuthRepository();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      var result = await _authRepository.login(
        int.parse(_nrpController.text),
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        showSnackBarr(
          context,
          result['message'],
          buttonColor: ColorName.textGreen,
          backgroundColor: ColorName.bgGreen,
          textColor: ColorName.background,
        );
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        showSnackBarr(
          context,
          result['message'],
          buttonColor: ColorName.textRed,
          backgroundColor: ColorName.bgRed,
          textColor: ColorName.background,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D47A1), // Dark blue
              Color(0xFF90CAF9), // Light blue
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Circle logo
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFF0D47A1), width: 3),
                      color: Colors.white,
                    ),
                    child: ClipOval(
                      child: SvgPicture.asset(
                        'assets/images/logo.svg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 48),

                  // Login form
                  Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xFF0D47A1), width: 2),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'WELCOME',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D47A1),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 24),

                          // NRP field
                          TextFormField(
                            controller: _nrpController,
                            decoration: InputDecoration(
                              labelText: 'NRP',
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF0D47A1),
                                  width: 2,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your NRP';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),

                          // Password field
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF0D47A1),
                                  width: 2,
                                ),
                              ),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 24),
                          _isLoading
                              ? Center(child: CircularProgressIndicator())
                              : ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF64B5F6),
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
