import 'package:flutter/material.dart';

class ParkingPage extends StatefulWidget {
  const ParkingPage({super.key});

  @override
  State<ParkingPage> createState() => _ParkingPageState();
}

class _ParkingPageState extends State<ParkingPage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estacionamento'),
      ),
      body: PageView(
        children: [
          Container(
            color: Colors.red,
          ),
          Container(
            color: Colors.blue,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        currentIndex: _currentIndex,
        onTap: (index) async {
          setState(() {
            _currentIndex = index;
          });
          // widget.appController.tabIndex = index;
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
