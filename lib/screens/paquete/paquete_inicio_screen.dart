import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:Unica/models/masc_models.dart';
import 'package:Unica/services/services.dart';
import 'package:Unica/widgets/mascota_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../controllers/controllers.dart';
import '../../models/aut_models.dart';
import '../../widgets/boton_gordo.dart';
import '../../widgets/widgets.dart';

class PaqueteInicioScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final paqueteCtrl = Get.put(PaqueteController());

    return Scaffold(
        body: Stack(children: [
      Background(color2: Color(0xff6989F5), color1: Colors.white),
      _MainScroll(
        onNextPage: () async {
          final authService = Provider.of<AuthService>(context, listen: false);

          var conx = await authService.internetConnectivity();
          if (conx) {
            final paqueteCtrl = Get.find<PaqueteController>();

            var result = await paqueteCtrl.getTopPaqueteScroll();
            if (!result!.contains('Ok'))
              NotificationsService.showSnackbar(
                  'Oh! ', "${result}", ContentType.failure);
          } else
            NotificationsService.showSnackbar(
                'Oh!',
                "Debe asegurarse que el dipositivo tenga conexión  a internet",
                ContentType.failure);
        },
      ),
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
            final mascotaCtrl = Get.find<MascotaController>();
            mascotaCtrl.mascotaSelected = Mascota(
                    mascId: null,
                    mascUserId: 0,
                    mascName: '',
                    mascEspecieId: 1,
                    mascGeneroId: 2,
                    mascPeso: 0.00,
                    mascFechaNacimiento: DateTime.now(),
                    mascFechaVacunacion: DateTime.now())
                .obs;
            Navigator.pushNamed(context, 'mascotaEditar');
          } else
            NotificationsService.showSnackbar(
                'Oh!',
                "Debe asegurarse que el dipositivo tenga conexión  a internet",
                ContentType.failure);
        },
        child: const Text(
          'REGISTRAR UNA MASCOTA',
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

  const _MainScroll({Key? key, required this.onNextPage}) : super(key: key);
  @override
  State<_MainScroll> createState() => _MainScrollState();
}

class _MainScrollState extends State<_MainScroll> {
  final ScrollController scrollController = ScrollController();

  Timer? _timer;
  int _start = 5;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = new Timer.periodic(
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
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        widget.onNextPage();
      }
      ;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  onRefresh() {}

  @override
  Widget build(BuildContext context) {
    // final deliveryService = Provider.of<DeliveryService>(context);
    final paqueteCtrl = Get.find<PaqueteController>();

    return RefreshIndicator(
      edgeOffset: 130,
      onRefresh: () async {
        final authService = Provider.of<AuthService>(context, listen: false);

        var conx = await authService.internetConnectivity();
        if (conx) {
          var result = await paqueteCtrl.getTopPaquete();

          if (!result!.contains('Ok'))
            NotificationsService.showSnackbar(
                'Oh! ', "${result}", ContentType.failure);
        } else
          NotificationsService.showSnackbar(
              'Oh!',
              "Debe asegurarse que el dipositivo tenga conexión  a internet",
              ContentType.failure);
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
                      maxHeight: 233,
                      child: Container(
                          alignment: Alignment.centerLeft,
                          color: Colors.white,
                          child: _Titulo()))),
              paqueteCtrl.data.isEmpty && _start > 0
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
                      ...paqueteCtrl.data
                          .map((e) => PaqueteCard(paq: e, ctrl: paqueteCtrl))
                          .toList(),
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
              tag: const Text('Paqueteria / Mercado Libre'),
              child: BotonGordo(
                iconL: FontAwesomeIcons.box,
                iconR: FontAwesomeIcons.chevronLeft,
                texto: 'Paqueteria / Mercado Libre',
                color1: const Color.fromARGB(255, 2, 6, 244),
                color2: const Color.fromARGB(255, 246, 218, 12),
                onPress: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
