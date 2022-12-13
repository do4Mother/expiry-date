import 'package:expiry/app/router.dart';
import 'package:expiry/repositories/product_repository.dart';
import 'package:expiry/repositories/profile_repository.dart';
import 'package:expiry/repositories/storage_repository.dart';
import 'package:expiry/themes/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/authentication/authentication_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProfileRepository>(
          create: (context) => ProfileRepository(),
        ),
        RepositoryProvider<ProductRepository>(
          create: (context) => ProductRepository(),
        ),
        RepositoryProvider<StorageRepository>(
          create: (context) => StorageRepository(),
        ),
      ],
      child: BlocProvider<AuthenticationBloc>(
        lazy: false,
        create: (context) => AuthenticationBloc(
          profileRepository: RepositoryProvider.of<ProfileRepository>(context),
        )..add(AuthInitialize()),
        child: MaterialApp.router(
          routerConfig: appRouter,
          theme: ligthTheme,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
