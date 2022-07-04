import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/sockets/src/socket_notifier.dart';

import '../controllers/notificacion_controller.dart';
import '../models/users_models.dart';
import '../services/notifications_service.dart';

class UsuarioSearchDelegate extends SearchDelegate {
  @override
  // TODO: implement searchFieldLabel
  String? get searchFieldLabel => 'Buscar usuario';
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('buildResults');
  }

  Widget _emptyContainer() {
    return Container(
      child: Center(
        child: Icon(
          Icons.search,
          color: Colors.black38,
          size: 150,
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _emptyContainer();
    }
    void Onclose() {
      close(context, null);
    }

    final notificacionCtrl = Get.find<NotificacionController>();
    try {
      notificacionCtrl.getSguggestionsByQuery(query);
    } catch (e) {}

    return StreamBuilder(
      stream: notificacionCtrl.users.stream,
      builder: (context, AsyncSnapshot<List<Users>> snapshot) {
        if (!snapshot.hasData) return _emptyContainer();

        var user = snapshot.data!;
        return ListView.builder(
          itemCount: user.length,
          itemBuilder: (_, int index) =>
              _UserItem(user[index], () => Onclose()),
        );
      },
    );
  }
}

class _UserItem extends StatelessWidget {
  final Users users;
  final Function close;

  const _UserItem(this.users, this.close);

  @override
  Widget build(BuildContext context) {
    final notificacionCtrl = Get.find<NotificacionController>();

    return ListTile(
      minVerticalPadding: 20,
      title: Text(users.usrName + ' ' + users.usrApellido),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Lote: ' + users.lotName),
          Text('Email: ' + users.usEmail),
        ],
      ),
      onTap: () {
        notificacionCtrl.userIdSelected.value = users;
        close();
      },
    );
  }
}
