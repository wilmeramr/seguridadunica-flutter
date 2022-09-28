import 'dart:async';

import 'package:Unica/models/doc_model.dart';
import 'package:Unica/models/expensa_models.dart';
import 'package:Unica/models/noticias_models.dart';
import 'package:Unica/screens/screens.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/controllers.dart';
import '../../models/user.dart';
import '../../services/services.dart';
import '../../widgets/widgets.dart';

class ExpensaInicioScreen extends StatelessWidget {
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
            final expenCtrl = Get.find<ExpensaController>();

            var result = await expenCtrl.getTopExpScroll();
            if (!result.contains('Ok')) {
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
          final expCtrl = Get.find<ExpensaController>();

          var result = await expCtrl.getTopExp();
          if (!result.contains('Ok')) {
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

              if (snapshot.data!.rol.contains('Admm')) return _BotonNewList();
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
          'SUBIR UN REGLAMENTO',
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
  final expCtrl = Get.put(ExpensaController());
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
    final expCtrl = Get.find<ExpensaController>();

    return RefreshIndicator(
      edgeOffset: 130,
      onRefresh: () async {
        final authService = Provider.of<AuthService>(context, listen: false);

        var conx = await authService.internetConnectivity();
        if (conx) {
          var result = await expCtrl.getTopExp();
          if (!result.contains('Ok')) {
            NotificationsService.showSnackbar(
                'Oh!', result, ContentType.failure);
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
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
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
              expCtrl.data.isEmpty && _start > 0
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
                      ...expCtrl.data.map((e) => _ListItem(expn: e)).toList(),
                      expCtrl.isLoading.value
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
              tag: const Text('Expensas'),
              child: BotonGordoNoti(
                iconL: FontAwesomeIcons.paypal,
                iconR: FontAwesomeIcons.chevronLeft,
                texto: 'Expensas',
                color1: const Color.fromARGB(255, 45, 207, 164),
                color2: const Color.fromARGB(255, 39, 142, 108),
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
  final Expen expn;

  const _ListItem({required this.expn});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GestureDetector(
          onTap: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ViewPDFScreen(
                        url: expn.expenUrl!, title: expn.expenName)));
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                _NotificacionTopBar(expn),
                const Divider(),
                _NotificacionTitulo(
                  expn,
                ),
                const SizedBox(
                  height: 10,
                ),
                // _NotificacionStatus(doc),
              ],
            ),
          )),
    ]);
  }
}

class _NotificacionStatus extends StatelessWidget {
  final Doc doc;

  const _NotificacionStatus(this.doc);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RawMaterialButton(
          constraints: BoxConstraints(minWidth: 200),
          onPressed: () {},
          //  fillColor: this.noti.notiEnvio == 1 ? Colors.green : Colors.red,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [Text('Ver')],
          ),
        )
      ],
    );
  }
}

class _NotificacionTitulo extends StatelessWidget {
  final Expen expn;

  const _NotificacionTitulo(this.expn);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 20),
      child: Row(
        children: [
          const Icon(FontAwesomeIcons.solidFilePdf),
          SizedBox(
            width: 10,
          ),
          Flexible(
            child: Text(
              expn.expenName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificacionTopBar extends StatelessWidget {
  final Expen expn;

  const _NotificacionTopBar(this.expn);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.only(bottom: 5, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              'Fecha de registro: ${expn.updatedAt.day.toString().padLeft(2, '0')}/${expn.updatedAt.month.toString().padLeft(2, '0')}/${expn.updatedAt.year.toString().padLeft(4, '0')}')
        ],
      ),
    );
  }
}

void _launchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    NotificationsService.showSnackbar(
        'Oh! ',
        'Intentolo mas tarde o sComUnicarse con Administración',
        ContentType.failure);
  }
  ;
}
