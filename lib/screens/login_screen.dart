import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:Unikey/providers/login_form_provider.dart';
import 'package:Unikey/services/services.dart';
import 'package:Unikey/ui/input_decorations.dart';
import 'package:Unikey/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
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
                  'Bienvenido',
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
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '*****@c**.com',
                  labelText: 'Correo',
                  prefixIcon: Icons.email_outlined),
              onChanged: (value) => loginForm.email = value,
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

                RegExp regExp = new RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                    ? null
                    : "El valor es incorrecto";
              },
            ),
            const SizedBox(
              height: 30,
            ),
            Stack(
              children: [
                TextFormField(
                  autocorrect: false,
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecorations.authInputDecoration(
                      hintText: '*******',
                      labelText: 'Token',
                      prefixIcon: Icons.lock_outline),
                  onChanged: (value) => loginForm.password = value,
                  validator: (value) {
                    if (value != null && value.length >= 8) return null;

                    return 'La token debe ser de 8 caracteres';
                  },
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: loginForm.isLoadingToken
                          ? null
                          : () async {
                              final authService = Provider.of<AuthService>(
                                  context,
                                  listen: false);

                              var conx =
                                  await authService.internetConnectivity();
                              if (!conx) {
                                NotificationsService.showSnackbar(
                                    'Oh!',
                                    'Debe asegurarse que el dispositivo tengo conexión a internet.',
                                    ContentType.warning);

                                return;
                              }

                              String pattern =
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

                              RegExp regExp = new RegExp(pattern);

                              if (regExp.hasMatch(loginForm.email)) {
                                loginForm.isLoadingToken = true;
                                final response =
                                    await authService.token(loginForm.email);
                                /*   NotificationsService.showMyDialogAndroid(
                                    context,
                                    'Solicitud de Token',
                                    '${response}'); */
                                loginForm.isLoadingToken = false;

                                NotificationsService.showSnackbar(
                                    'Solicitud de Token',
                                    response["r"] as String,
                                    response["valido"]
                                        ? ContentType.success
                                        : ContentType.failure);
                              } else {
                                NotificationsService.showSnackbar(
                                    'Solicitud de Token',
                                    "Es un email incorrecto",
                                    ContentType.failure);
                                loginForm.isLoadingToken = false;
                              }
                              loginForm.isLoadingToken = false;
                            },
                      child: Text(
                        loginForm.isLoadingToken ? 'Espere..' : 'Solicitar',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.indigo),
                      )),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Colors.blue,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  child: Text(
                    loginForm.isLoading ? 'Espere..' : 'Ingresar',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                onPressed: loginForm.isLoading
                    ? null
                    : () async {
                        // throw new Exception('erro login');
                        final authService =
                            Provider.of<AuthService>(context, listen: false);

                        FocusScope.of(context).unfocus();

                        if (!loginForm.isValidForm()) return;

                        loginForm.isLoading = true;
                        final String? errorMessage = await authService.login(
                            loginForm.email, loginForm.password);

                        if (errorMessage == null) {
                          Navigator.pushReplacementNamed(context, 'dash2');
                        } else {
                          NotificationsService.showSnackbar(
                              'Oh!', errorMessage, ContentType.failure);
                          loginForm.isLoading = false;
                        }
                        loginForm.isLoading = false;
                      })
          ],
        ),
      ),
    );
  }
}
