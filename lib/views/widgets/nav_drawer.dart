import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.deepPurple),
            child: Text(
              'FuelSense',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/screen01');
            },
          ),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Login'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.motorcycle),
            title: const Text('Bikes'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/bikes');
            },
          ),
          ListTile(
            leading: const Icon(Icons.arrow_circle_down),
            title: const Text('My Bikes'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/my_bikes');
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outlined),
            title: const Text('Add Bikes'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/add_bike');
            },
          ),
        ],
      ),
    );
  }
}
