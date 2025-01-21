import 'package:flutter/material.dart';
import 'package:rideadmin/core/color.dart';
class StatusDialog extends StatelessWidget {
  final String message;


  const StatusDialog({
    super.key,
  
    required this.message,
  });

  static void show({
    required BuildContext context,
    required String message,

  }) {
    showDialog(
      context: context,
      builder: (context) {
        return StatusDialog(
        message: message,
       
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
         
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.neutralColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
