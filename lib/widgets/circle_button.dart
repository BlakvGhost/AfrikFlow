import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CircleButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final int index;

  const CircleButton({
    super.key,
    required this.icon,
    required this.label,
    required this.index,
  });

  @override
  CircleButtonState createState() => CircleButtonState();
}

class CircleButtonState extends State<CircleButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            switch (widget.index) {
              case 1:
                context.push('/send');
                break;
              case 2:
                context.push('/invoices');
                break;
              case 3:
                context.push('/transactions');
                break;
              case 4:
                context.push('/settings');
                break;
              case 5:
                context.push('/profile');
                break;
              case 6:
                context.push('/notifications');
                break;
              case 7:
                context.push('/assistance');
                break;
              case 8:
                context.push('/all-services');
                break;
              case 9:
                context.push('/about');
                break;
            }
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(22),
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 8,
            shadowColor: Colors.black.withOpacity(0.3),
          ),
          child: Icon(widget.icon, color: Colors.white),
        ),
        const SizedBox(height: 5),
        Text(
          widget.label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
