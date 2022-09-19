import 'dart:async';

import 'package:Unica/models/noticias_models.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../controllers/controllers.dart';
import '../../models/user.dart';
import '../../services/services.dart';
import '../../widgets/widgets.dart';

class NoticiaInicioScreen extends StatelessWidget {
  // final notificacionCtrl = Get.find<NotificacionController>();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
        body: Stack(children: [
      const Background(color2: Color(0xff6989F5), color1: Colors.white),
      _MainScroll(
        onNextPage: () async {
          final authService = Provider.of<AuthService>(context, listen: false);

          var conx = await authService.internetConnectivity();
          if (conx) {
            final notificacionCtrl = Get.find<NoticiaController>();

            var result = await notificacionCtrl.getTopNoticScroll();
            if (!result!.contains('Ok')) {
              NotificationsService.showSnackbar(
                  'Oh! ', result, ContentType.failure);
            }
          } else {
            NotificationsService.showSnackbar(
                'Oh!',
                "Debe asegurarse que el dipositivo tenga conexión  a internet",
                ContentType.failure);
          }
        },
        onInitNoti: () async {
          final notificacionCtrl = Get.find<NoticiaController>();

          var result = await notificacionCtrl.getTopNotic();
          if (!result!.contains('Ok')) {
            NotificationsService.showSnackbar(
                'Oh! ', result, ContentType.failure);
          }
        },
      ),
      Positioned(
          bottom: -10,
          right: 0,
          child: FutureBuilder(
            future: authService.readUser(),
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }

              if (snapshot.data!.rol.contains('Adm')) return _BotonNewList();
              return Container();
            },
          ))
    ]));
  }
}

class _BotonNewList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ButtonTheme(
      minWidth: size.width * 0.9,
      height: 100,
      child: MaterialButton(
        color: Colors.blue,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(50))),
        onPressed: () async {
          final authService = Provider.of<AuthService>(context, listen: false);

          var conx = await authService.internetConnectivity();
          if (conx) {
            Navigator.pushNamed(context, 'enviarNoticia');
          } else {
            NotificationsService.showSnackbar(
                'Oh!',
                "Debe asegurarse que el dipositivo tenga conexión a internet",
                ContentType.failure);
          }
        },
        child: const Text(
          'CREAR UNA NOTICIA',
          style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 3),
        ),
      ),
    );
  }
}

class _MainScroll extends StatefulWidget {
  final Function onNextPage;
  final Function onInitNoti;

  const _MainScroll(
      {Key? key, required this.onNextPage, required this.onInitNoti})
      : super(key: key);
  @override
  State<_MainScroll> createState() => _MainScrollState();
}

class _MainScrollState extends State<_MainScroll> {
  final ScrollController scrollController = ScrollController();
  final notificacionCtrl = Get.put(NoticiaController());
  Timer? _timer;
  int _start = 5;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    widget.onInitNoti();
    scrollController.addListener(() {
      /*  print(scrollController.position.pixels);
      print(scrollController.position.maxScrollExtent);
      print('lanzar${scrollController.position.maxScrollExtent - 4600}'); */
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // print(scrollController.position.pixels);
        //print(scrollController.position.maxScrollExtent);

        widget.onNextPage();
      }
      ;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    // notificacionCtrl.data.clear();
    super.dispose();
  }

  List<_ListItem> items2 = [];

  onRefresh() {}

  @override
  Widget build(BuildContext context) {
    final noticiaCtrl = Get.find<NoticiaController>();

    return RefreshIndicator(
      edgeOffset: 130,
      onRefresh: () async {
        final authService = Provider.of<AuthService>(context, listen: false);

        var conx = await authService.internetConnectivity();
        if (conx) {
          var result = await noticiaCtrl.getTopNotic();
          if (!result!.contains('Ok')) {
            NotificationsService.showSnackbar(
                'Oh!', "$result", ContentType.failure);
          }
        } else {
          NotificationsService.showSnackbar(
              'Oh!',
              "Debe asegurarse que el dipositivo tenga conexión a internet",
              ContentType.failure);
        }
      },
      child: Obx(() => CustomScrollView(
            controller: scrollController,
            physics: BouncingScrollPhysics(
                parent: const AlwaysScrollableScrollPhysics()),
            slivers: [
              SliverPersistentHeader(
                  floating: true,
                  delegate: _SliverCustomHeaderDelegate(
                      minHeight: 170,
                      maxHeight: 225,
                      child: Container(
                          alignment: Alignment.centerLeft,
                          color: Colors.white,
                          child: _Titulo()))),
              noticiaCtrl.data.isEmpty && _start > 0
                  ? SliverList(
                      delegate: SliverChildListDelegate([
                      const LinearProgressIndicator(
                        color: Colors.green,
                      ),
                      const Center(child: Text('Espere por favor')),
                      const SizedBox(
                        height: 10,
                      )
                    ]))
                  : SliverList(
                      delegate: SliverChildListDelegate([
                      ...noticiaCtrl.data
                          .map((e) => _ListItem(noti: e))
                          .toList(),
                      noticiaCtrl.isLoading.value
                          ? const CircularProgressIndicator(
                              color: Colors.red,
                            )
                          : const Text(""),
                      const SizedBox(
                        height: 100,
                      )
                    ]))
            ],
          )),
    );
  }
}

class _SliverCustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverCustomHeaderDelegate(
      {required this.minHeight, required this.maxHeight, required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent =>
      (this.minHeight > this.maxHeight) ? this.minHeight : this.maxHeight;

  @override
  // TODO: implement minExtent
  double get minExtent =>
      (this.maxHeight > this.minHeight) ? this.maxHeight : this.minHeight;

  @override
  bool shouldRebuild(covariant _SliverCustomHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class _Titulo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 0),
        SafeArea(
          child: Container(
            color: Colors.white,
            //  margin: EdgeInsets.only(top: 200),
            child: Hero(
              tag: const Text('Noticias'),
              child: BotonGordoNoti(
                iconL: FontAwesomeIcons.bell,
                iconR: FontAwesomeIcons.chevronLeft,
                texto: 'Noticias',
                color1: const Color.fromARGB(255, 31, 226, 44),
                color2: const Color.fromARGB(255, 169, 228, 68),
                onPress: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ListItem extends StatelessWidget {
  final Noticia noti;

  const _ListItem({required this.noti});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GestureDetector(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                _NotificacionStatus(noti),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                _NotificacionTitulo(
                  noti,
                ),
                const SizedBox(
                  height: 10,
                ),
                _NotificacionBody(
                  noti,
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          )),
    ]);
  }
}

class _NotificacionStatus extends StatelessWidget {
  final Noticia noti;

  const _NotificacionStatus(this.noti);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RawMaterialButton(
          onPressed: () {},
          //  fillColor: this.noti.notiEnvio == 1 ? Colors.green : Colors.red,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              Text(
                  'Fecha de envío: ${noti.updatedAt.day.toString().padLeft(2, '0')}/${noti.updatedAt.month.toString().padLeft(2, '0')}/${noti.updatedAt.year.toString().padLeft(4, '0')}')
            ],
          ),
        )
      ],
    );
  }
}

class _NotificacionBody extends StatelessWidget {
  final Noticia noti;

  const _NotificacionBody(this.noti);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ExpandedText(
        maxLines: 100,
        minLines: 3,
        text: noti.noticBody,
      ),
    );
  }
}

class _NotificacionTitulo extends StatelessWidget {
  final Noticia noti;

  const _NotificacionTitulo(this.noti);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        noti.noticTitulo,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _NotificacionTopBar extends StatelessWidget {
  final Noticia noti;

  const _NotificacionTopBar(this.noti);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.only(bottom: 0),
      child: Row(
        children: [Text(noti.noticTitulo)],
      ),
    );
  }
}
