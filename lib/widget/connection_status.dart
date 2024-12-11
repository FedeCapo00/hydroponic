import 'package:flutter/material.dart';

class ConnectionStatus extends StatefulWidget {
  const ConnectionStatus({
    super.key,
    this.size = 60.0,
  });

  final double size;

  @override
  State<ConnectionStatus> createState() => _ConnectionStatus();
}

class _ConnectionStatus extends State<ConnectionStatus> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size * 1.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Last data received on: ",
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
