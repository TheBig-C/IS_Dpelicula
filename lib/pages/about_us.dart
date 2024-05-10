import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:is_dpelicula/widgets/custom_app_bar.dart';
import 'package:is_dpelicula/widgets/desktop_footer.dart';
import 'dart:math' as math;

class AboutUsPage extends StatefulWidget {
  AboutUsPage({Key? key}) : super(key: key);

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  bool isFront = true; 

  void toggleCard() {
    setState(() {
      isFront = !isFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(isDesktop: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                      decoration: TextDecoration.none,
                    ),
                    children: const [
                      TextSpan(
                        text: 'No solo proyectamos películas\n',
                      ),
                      TextSpan(
                        text: 'CREAMOS EXPERIENCIAS memorables',
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 3.0,
                    enlargeCenterPage: true,
                    viewportFraction: 0.8,
                  ),
                  items: [
                    'assets/mision.jpeg',
                    'assets/vision.jpeg',
                    'assets/foto_sala.jpeg',
                  ].map((item) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width: 800,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage(item),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )).toList(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: 500,
                    width: 500,
                    child: Image.asset('assets/pareja_m.jpeg', fit: BoxFit.cover),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: toggleCard,
                    child: AnimatedContainer(
                      height: 500,
                      width: 500,
                      duration: Duration(seconds: 1),
                      transform: Matrix4.rotationY(isFront ? 0 : math.pi),
                      transformAlignment: Alignment.center,
                      child: isFront
                          ? Image.asset('assets/historia_m.jpeg', fit: BoxFit.cover)
                          : Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(math.pi),
                              child: Container(
                                color: const Color.fromARGB(255, 31, 20, 50),
                                alignment: Alignment.center,
                                child: Text(
                                  'Multicine es una empresa de entretenimiento cinematrográfico Boliviana, fundada en el año 2009, orgullosos de ser pioneros en la industria del cine y servicios de entretenimiento familiar a nivel nacional. Desdes nuestro inicio, hemos tenido un compromiso con la excelencia y la satisgacción de nuestros clientes, convirtiéndonos en punto de encuentro y destino preferido para el público a nivel nacional',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              const DesktopFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
