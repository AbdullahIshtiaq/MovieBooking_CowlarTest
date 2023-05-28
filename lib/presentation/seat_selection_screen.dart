import 'package:cowlar_entry_test_app/constants.dart';
import 'package:cowlar_entry_test_app/main.dart';
import 'package:cowlar_entry_test_app/presentation/movie_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SeatSelectionScreen extends StatelessWidget {
  const SeatSelectionScreen(
      {super.key, required this.movieName, required this.theaterName});

  final String movieName;
  final String theaterName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGrey,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            color: bgWhite,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 25, 0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                  ),
                  Expanded(
                    flex: 20,
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            movieName,
                            style: const TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            theaterName,
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30.0),
          const CinemaSeatsScreen(),
          Expanded(
            child: Container(
                height: double.infinity,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20.0),
                      Row(
                        children: const [
                          SeatInfoWidget(
                            color: Colors.orange,
                            title: "Selected",
                          ),
                          SizedBox(width: 40.0),
                          SeatInfoWidget(
                            color: Colors.grey,
                            title: "Not Available",
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        children: const [
                          SeatInfoWidget(
                            color: navBarColor,
                            title: "VIP (\$150))",
                          ),
                          SizedBox(width: 30.0),
                          SeatInfoWidget(
                            color: blue,
                            title: "Regular (\$50))",
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Container(
                        height: 35.0,
                        width: 90,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 216, 216, 216),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: const [
                              Text(
                                "4/3 row",
                                style: TextStyle(
                                  fontSize: 10.0,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 10.0),
                              Icon(
                                CupertinoIcons.xmark,
                                size: 13.0,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 50.0,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 216, 216, 216),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Total Price",
                                    style: TextStyle(
                                      fontSize: 10.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "\$500",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: SizedBox(
                              height: 50.0,
                              width: double.infinity,
                              child: RoundedButton(
                                text: "Proceed to Pay",
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MyHomePage()),
                                      (route) => false);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

class CinemaSeatsScreen extends StatelessWidget {
  const CinemaSeatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400.0,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Stack(
          children: [
            const CurvedLine(),
            const Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Text("Sreen"),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: SeatView(seatCount: 100),
            ),
            Positioned(
              bottom: 30,
              right: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RoundedIconButton(icon: Icons.add, onPressed: () {}),
                  const SizedBox(
                    width: 10,
                  ),
                  RoundedIconButton(icon: Icons.remove, onPressed: () {}),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  height: 5,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: lightGray,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SeatView extends StatelessWidget {
  final int seatCount;

  SeatView({super.key, required this.seatCount});

  final List<bool> _seatSelections = List.generate(100, (index) => false);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 10,
        childAspectRatio: 10,
        mainAxisSpacing: 20.0,
      ),
      itemCount: seatCount,
      itemBuilder: (BuildContext context, int index) {
        return Icon(
          Icons.event_seat,
          size: 13,
          color: _seatSelections[index] ? Colors.green : Colors.grey,
        );
      },
    );
  }
}

class CurvedLine extends StatelessWidget {
  const CurvedLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0 * 3.14,
      child: CustomPaint(
        painter: _CurvedLinePainter(),
        size: const Size(double.infinity, 100),
      ),
    );
  }
}

class _CurvedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = blue
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height / 2);
    path.quadraticBezierTo(size.width / 2, 0, size.width, size.height / 2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CurvedLinePainter oldDelegate) => false;
}

class RoundedIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const RoundedIconButton(
      {super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.0,
      height: 30.0,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: IconButton(
          icon: Icon(icon, size: 15.0),
          color: Colors.black,
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class SeatInfoWidget extends StatelessWidget {
  final String title;
  final Color color;

  const SeatInfoWidget({super.key, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.event_seat, color: color, size: 20.0),
        const SizedBox(width: 10.0),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12.0,
            color: lightGray,
          ),
        ),
      ],
    );
  }
}
