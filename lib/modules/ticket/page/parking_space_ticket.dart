import 'package:flutter/material.dart';

class ParkingSpaceTicket extends StatefulWidget {
  const ParkingSpaceTicket({super.key});

  @override
  State<ParkingSpaceTicket> createState() => _ParkingSpaceTicketState();
}

class _ParkingSpaceTicketState extends State<ParkingSpaceTicket> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 200),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [Text('Resgiter')],
      ),
    );
  }
}
