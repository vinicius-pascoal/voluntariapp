import 'package:flutter/material.dart';

class LoginLayout extends StatelessWidget {
  final Widget child;
  final bool showBackButtom;

  const LoginLayout({
    super.key,
    required this.child,
    this.showBackButtom = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showBackButtom
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          : null,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 24),
                    Image.asset('assets/images/logo.png'),
                    const SizedBox(height: 32),
                    child,
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
