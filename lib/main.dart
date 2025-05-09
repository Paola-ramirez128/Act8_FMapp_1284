import 'package:flutter/material.dart';
import 'package:animator/animator.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ));

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true); // Repite la animación ida y vuelta

    _slideAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.0), // Comienza fuera de pantalla a la derecha
      end: Offset.zero, // Posición normal
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Fondo con imagen y gradiente
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.9),
                    Colors.black.withOpacity(0.3),
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    // Lista horizontal de artesanías con efecto slide de retorno
                    Container(
                      height: 250,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          SlideTransition(
                            position: _slideAnimation,
                            child:
                                makeItem(image: 'assets/images/artesania.jpg'),
                          ),
                          SlideTransition(
                            position: _slideAnimation,
                            child:
                                makeItem(image: 'assets/images/artesania2.jpg'),
                          ),
                          SlideTransition(
                            position: _slideAnimation,
                            child:
                                makeItem(image: 'assets/images/artesania3.png'),
                          ),
                        ]
                            .map((widget) => Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: widget,
                                ))
                            .toList(),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),

          // Puntos animados
          makeAnimatedPoint(top: 140.0, left: 40.0, color: Colors.blue),
          makeAnimatedPoint(top: 190.0, left: 190.0, color: Colors.blue),
          makeAnimatedPoint(top: 219.0, left: 60.0, color: Colors.blue),
        ],
      ),
    );
  }

  // Punto animado
  Widget makeAnimatedPoint(
      {required double top, required double left, required Color color}) {
    return Positioned(
      top: top,
      left: left,
      child: Animator<double>(
        duration: Duration(seconds: 2),
        cycles: 0,
        curve: Curves.easeInOut,
        tween: Tween<double>(begin: 10.0, end: 20.0),
        builder: (context, animatorState, child) => Container(
          width: animatorState.value,
          height: animatorState.value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.6),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: animatorState.value / 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Tarjeta de artesanía
  Widget makeItem({required String image}) {
    return AspectRatio(
      aspectRatio: 1.7 / 2,
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage(image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey[200],
                    ),
                    child: Text(
                      '2.1 mi',
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Text(
                'Artesanías',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.star_border,
                  color: Colors.yellow[700],
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
