import 'package:flutter/material.dart';
import 'package:rideadmin/views/login/login_screen.dart';
import 'package:rideadmin/core/color.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  final VoidCallback onLeadingPressed;
  final Color backgroundColor;
  final Icon icon;
  final TextStyle? titleStyle;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.onLeadingPressed,
    this.backgroundColor = Colors.blueAccent,
    required this.icon,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: onLeadingPressed,
        icon: icon,
      ),
      title: Text(
        title,
        style: titleStyle ?? const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      backgroundColor: backgroundColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}



  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }



class DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const DetailRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value, 
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: AppColors.teal),
          const SizedBox(width: 12),
          Text('$title:', style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(color: AppColors.blackColor))),
        ],
      ),
    );
  }
}
 


class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 20.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.teal,
        ),
      ),
    );
  }
}
 


class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  
  const ProfileAvatar({super.key, this.imageUrl,});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 52,
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      backgroundColor: AppColors.teal,
      child: imageUrl == null
          ? const Icon(Icons.person, size: 52, color: AppColors.lightTeal)
          : null,
    );
  }
}



class ImageSection extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final Function(BuildContext, String?) onImageTap;

  const ImageSection({
    super.key,
    required this.title,
    this.imageUrl,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.teal)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => onImageTap(context, imageUrl),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.lightTeal,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColors.teal, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl == null || imageUrl!.isEmpty
                  ? const Icon(Icons.image_not_supported, color: AppColors.neutralColor, size: 100)
                  : Image.network(
                      imageUrl!,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.image_not_supported,
                        color: AppColors.neutralColor,
                        size: 100,
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}


class ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback? onPressed;

  const ActionButton({
    super.key,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: onPressed == null ? AppColors.lightTeal : color,
        foregroundColor: AppColors.lightPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 16)),
    );
  }
}




class ConfirmationDialog extends StatelessWidget {
  final String action;
  final VoidCallback onConfirm;
final String content;
  const ConfirmationDialog({
    super.key,
    required this.action,
    required this.onConfirm,
    required this.content
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text('Confirm $action', style: const TextStyle(fontWeight: FontWeight.w600,)),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: AppColors.teal)),
        ),
    
         TextButton(
  onPressed: () {
            onConfirm();
            Navigator.pop(context);
          },        child: Text(action, style: const TextStyle(color: AppColors.teal)),
        ),
      ],
    );
  }
}
