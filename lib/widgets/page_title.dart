import 'package:flutter/material.dart';
import 'package:Unikey/models/user.dart';
import 'package:Unikey/services/services.dart';
import 'package:provider/provider.dart';

class PageTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.topLeft,
        child: FutureBuilder(
          future: _dataTitle(context),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            return snapshot.data;
          },
        ),
      ),
    );
  }

  Future<Column> _dataTitle(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    User sur = await authService.readUser();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sur.country,
          style: TextStyle(
              fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(
          height: 10,
        ),
        Text('${sur.name} ${sur.apellido}',
            style: TextStyle(fontSize: 16, color: Colors.white))
      ],
    );
  }
}
