import 'package:expiry/app/bloc/authentication/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuTab extends StatelessWidget {
  const MenuTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: const Text('Logout'),
          onTap: () {
            context.read<AuthenticationBloc>().add(Logout());
          },
        ),
      ],
    );
  }
}
