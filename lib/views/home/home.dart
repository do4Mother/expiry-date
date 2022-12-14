import 'package:expiry/utils/state_helper.dart';
import 'package:expiry/views/home/bloc/list_product/list_product_bloc.dart';
import 'package:expiry/views/home/tabs/chat.dart';
import 'package:expiry/views/home/tabs/home.dart';
import 'package:expiry/views/home/tabs/market.dart';
import 'package:expiry/views/home/tabs/menu.dart';
import 'package:expiry/views/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
  final tooltipKey = GlobalKey<TooltipState>();

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    tooltipKey.currentState?.dispose();
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
            BlocBuilder<AuthenticationBloc, StateHelper<Profile>>(
              builder: (context, state) {
                return state.builder(
                  loaded: Tooltip(
                    key: tooltipKey,
                    message: 'Save in cloud is active',
                    triggerMode: TooltipTriggerMode.manual,
                    showDuration: const Duration(seconds: 3),
                    child: IconButton(
                      onPressed: () {
                        if (state.data != null && state.data!.isAnonymous) {
                          context.push(LoginView.routeName);
                        } else {
                          tooltipKey.currentState?.ensureTooltipVisible();
                        }
                      },
                      icon: Icon(
                        Icons.cloud,
                        color: state.data?.isAnonymous ?? false ? Colors.grey : Colors.green.shade700,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: tabController.index,
          type: BottomNavigationBarType.fixed,
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
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz_rounded),
              label: 'Menu',
            ),
          ],
        ),
        body: TabBarView(
          controller: tabController,
          children: const [
            HomeTab(),
            MarketTab(),
            ChatTab(),
            MenuTab(),
          ],
        ),
      ),
    );
  }
}
