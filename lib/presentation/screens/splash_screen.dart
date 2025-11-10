import 'package:dadjoker/presentation/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// import '../../../auth_provider.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final token = ref.watch(accessTokenProvider);
    // print('tokennya update kah: $token');
    //
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (token != null) {
    //     context.go('/home');
    //   } else {
    //     context.go('/login');
    //   }
    // });

    return Scaffold(
      body: Container(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          color: babyOrange,
          child: Center(
            child: Text(
                "wanna impress someone's dad?",
                    style: TextStyle(
                      color: orange,
                      fontSize: 24,
                      fontWeight: FontWeight.w700
                    ),
            ),
          )),
    );
  }
}


