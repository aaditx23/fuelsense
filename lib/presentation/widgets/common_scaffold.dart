import 'package:flutter/material.dart';
import 'package:fuelsense/presentation/widgets/nav_drawer.dart';

class CommonScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final bool showDrawer;
  final List<Widget>? actions;
  final FloatingActionButton? fab;

  const CommonScaffold({
    Key? key,
    required this.body,
    this.title,
    this.showDrawer = true,
    this.actions,
    this.fab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: title != null ? Text(title!) : null,
          actions: actions,
          centerTitle: true,
        ),
        drawer: showDrawer ? const NavDrawer() : null,
        body: body,
      
        floatingActionButton: fab,
      ),
    );
  }
}
