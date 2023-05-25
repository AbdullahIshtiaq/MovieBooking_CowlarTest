import 'package:cowlar_entry_test_app/constants.dart';
import 'package:cowlar_entry_test_app/screens/movie_screen.dart';
import 'package:cowlar_entry_test_app/screens/seat_selection_screen.dart';
import 'package:flutter/material.dart';

class MovieTicketBookingScreen extends StatefulWidget {
  const MovieTicketBookingScreen(
      {super.key, required this.movieName, required this.releaseDate});

  final String movieName;
  final String releaseDate;

  @override
  State<MovieTicketBookingScreen> createState() =>
      _MovieTicketBookingScreenState();
}

class _MovieTicketBookingScreenState extends State<MovieTicketBookingScreen> {
  final List<String> dates = [
    '1 Jan',
    '2 Jan',
    '3 Jan',
    '4 Jan',
    '5 Jan',
    '6 Jan',
    '7 Jan',
  ];

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
                            widget.movieName,
                            style: const TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            widget.releaseDate,
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
          const SizedBox(height: 70.0),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Date',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 10.0),
            child: HorizontalDateList(items: dates),
          ),
          const SizedBox(height: 10.0),
          CinemaSeatsScreen(),
          const Spacer(),
          Center(
              child: Padding(
            padding: const EdgeInsets.all(30),
            child: SizedBox(
              width: double.infinity,
              child: RoundedButton(
                text: "Select Seats",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SeatSelectionScreen(
                        movieName: widget.movieName,
                        theaterName: 'January 1, 2023 | CineTech Hall 1',
                      ),
                    ),
                  );
                },
              ),
            ),
          ))
        ],
      ),
    );
  }
}

class HorizontalDateList extends StatefulWidget {
  const HorizontalDateList({super.key, required this.items});

  final List<String> items;

  @override
  State<HorizontalDateList> createState() => _HorizontalDateListState();
}

class _HorizontalDateListState extends State<HorizontalDateList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          widget.items.length,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 5),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: (index == 0)
                      ? blue
                      : const Color.fromARGB(255, 216, 216, 216),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    widget.items[index],
                    style: const TextStyle(color: Colors.white, fontSize: 12.0),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CinemaSeatsScreen extends StatelessWidget {
  CinemaSeatsScreen({super.key});

  final List theater = [
    'CineTech Hall 1',
    'CineTech Hall 2',
    'CineTech Hall 3',
    'CineTech Hall 4',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: theater.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 10.0),
            child: SizedBox(
              height: 300.0,
              width: 300.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        '13:00',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Text(
                        "${theater[index]}",
                        style:
                            const TextStyle(fontSize: 18.0, color: lightGray),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      height: 250.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: (index == 0)
                              ? blue
                              : const Color.fromARGB(255, 216, 216, 216),
                          width: 1.0,
                        ),
                      ),
                      child: Stack(
                        children: const [
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: CurvedLine(),
                          ),
                          Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: EdgeInsets.only(top: 30),
                                child: Text("Sreen"),
                              )),
                          Padding(
                            padding: EdgeInsets.only(top: 50),
                            child: SeatView(seatCount: 100),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Text(
                    'From 10.00\$ or 1000 bonus',
                    style: TextStyle(fontSize: 13.0),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class SeatView extends StatefulWidget {
  final int seatCount;

  const SeatView({super.key, required this.seatCount});

  @override
  _SeatViewState createState() => _SeatViewState();
}

class _SeatViewState extends State<SeatView> {
  final List<bool> _seatSelections = List.generate(100, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 10,
            childAspectRatio: 10,
            mainAxisSpacing: 10.0,
          ),
          itemCount: widget.seatCount,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _seatSelections[index] = !_seatSelections[index];
                });
              },
              child: Icon(
                Icons.event_seat,
                size: 12,
                color: _seatSelections[index] ? Colors.green : Colors.grey,
              ),
            );
          },
        ),
      ),
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
