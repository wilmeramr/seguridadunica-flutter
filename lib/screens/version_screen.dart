import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:Unica/providers/login_form_provider.dart';
import 'package:Unica/services/services.dart';
import 'package:Unica/ui/input_decorations.dart';
import 'package:Unica/widgets/widgets.dart';
import 'package:provider/provider.dart';

class VersionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
            child: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 250,
          ),
          CardContainer(
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Actualización',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(
                  height: 30,
                ),
                ChangeNotifierProvider(
                  create: (_) => LoginFormProvider(),
                  child: const _LoginForm(),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          /* TextButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, 'register'),
            style: ButtonStyle(
                overlayColor:
                    MaterialStateProperty.all(Colors.blue.withOpacity(0.1)),
                shape: MaterialStateProperty.all(StadiumBorder())),
            child: Text(
              'Crear una nueva cuenta',
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
          ), */
          const SizedBox(
            height: 50,
          )
        ],
      ),
    )));
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
        child:
            Text('Debes actualizar esta aplicación desde la tienda oficial'));
  }
}
