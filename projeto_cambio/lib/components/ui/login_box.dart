import 'package:flutter/material.dart';

class LoginBox extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginBox({
    Key? key,
    required this.emailController,
    required this.passwordController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //field Email
        TextFormField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: "Email",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
          ),
        ),
        SizedBox(height: 20),

        //Field Senha
        TextFormField(
          controller: passwordController,
          obscureText: true,
          decoration:
              InputDecoration(labelText: "Senha", border: OutlineInputBorder()),
        )
      ],
    );
  }
}
