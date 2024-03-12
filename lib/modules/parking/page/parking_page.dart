import 'package:flutter/material.dart';
import 'package:parking_app/core/ui/widgets/keep_alive_page.dart';
import 'package:parking_app/modules/parking_space/page/parking_space_page.dart';
import 'package:parking_app/modules/ticket/page/ticket_page.dart';
import 'package:parking_app/modules/vehicles/page/vehicles_page.dart';

class ParkingPage extends StatefulWidget {
  const ParkingPage({super.key});

  @override
  State<ParkingPage> createState() => _ParkingPageState();
}

class _ParkingPageState extends State<ParkingPage> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estacionamento'),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        children: const [
          KeepAlivePage(child: ParkingSpaceProvider()),
          KeepAlivePage(child: VehiclesPage()),
          KeepAlivePage(child: TicketPage()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        currentIndex: _currentIndex,
        onTap: (index) async {
          await _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeIn,
          );
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Vagas',
            icon: Icon(Icons.space_dashboard),
          ),
          BottomNavigationBarItem(
            label: 'Veículos',
            icon: Icon(Icons.directions_car),
          ),
          BottomNavigationBarItem(
            label: 'Ticket',
            icon: Icon(Icons.list_alt),
          ),
          BottomNavigationBarItem(
            label: 'Balanço',
            icon: Icon(Icons.attach_money),
          ),
        ],
      ),
    );
  }
}
