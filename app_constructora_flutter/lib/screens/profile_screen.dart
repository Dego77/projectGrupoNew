import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_constructora/theme/app_theme.dart';
import 'package:app_constructora/screens/login_screen.dart';
import 'package:app_constructora/providers/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, backgroundColor: AppTheme.primaryColor, child: Icon(Icons.person, size: 50, color: Colors.white)),
            const SizedBox(height: 16),
            Text(userProvider.userName, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(userProvider.userEmail, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 48),

            _buildProfileOption(context, icon: Icons.lock_outline, title: 'Cambiar Contraseña', onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Navegando a cambio de clave...')))),
            _buildProfileOption(context, icon: Icons.notifications_outlined, title: 'Notificaciones', onTap: () {}),
            _buildProfileOption(context, icon: Icons.help_outline, title: 'Soporte y Ayuda', onTap: () {}),
            
            const SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), side: const BorderSide(color: Colors.red)),
                onPressed: () {
                  context.read<UserProvider>().logout();
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
