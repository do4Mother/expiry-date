import 'package:expiry/utils/state_helper.dart';
import 'package:expiry/views/home/bloc/list_product/list_product_bloc.dart';
import 'package:expiry/views/home/tabs/chat.dart';
import 'package:expiry/views/home/tabs/home.dart';
import 'package:expiry/views/home/tabs/market.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/bloc/authentication/authentication_bloc.dart';
import '../../models/profile.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  static const String routeName = '/';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, StateHelper<Profile>>(
      listener: (context, state) {
        state.listener(loaded: () {
          context.read<ListProductBloc>().add(GetListProduct());
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Expiry Date'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.cloud,
                color: Colors.green.shade700,
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: tabController.index,
          onTap: (value) {
            tabController.animateTo(value);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Market',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_rounded),
              label: 'Chat',
            ),
          ],
        ),
        body: TabBarView(
          controller: tabController,
          children: const [
            HomeTab(),
            MarketTab(),
            ChatTab(),
          ],
        ),
      ),
    );
  }
}
