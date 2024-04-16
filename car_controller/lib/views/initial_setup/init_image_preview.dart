import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InitImagePreview extends StatefulWidget {
  const InitImagePreview({super.key});

  @override
  State<InitImagePreview> createState() => _InitImagePreviewState();
}

class _InitImagePreviewState extends State<InitImagePreview> {
  @override
  Widget build(BuildContext context) {
    var img = ModalRoute.of(context)!.settings.arguments as Uint8List;

    return Scaffold(
      appBar: AppBar(
        
          title: const Text(
        'Init Image Preview',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 22.0,
        ),
      )),
      body: Center(
        child: Image.memory(img),
      ),
    );
  }
}
