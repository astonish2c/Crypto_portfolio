import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Auth/widgets/utils.dart';
import '../../provider/allCoins_provider.dart';
import 'components/market_coins.dart';
import 'components/market_shimmer.dart';
import 'widgets/market_error.dart';

class MarketScreen extends StatelessWidget {
  static const routeName = 'Market_Page';

  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AllCoinsProvider provider = context.read<AllCoinsProvider>();

    final bool isFirstRun = context.select((AllCoinsProvider allCoinsProvider) => allCoinsProvider.getIsFirstRun);
    final bool isLoading = context.select((AllCoinsProvider allCoinsProvider) => allCoinsProvider.getIsLoadingMarket);

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: isFirstRun ? provider.getApiData() : Future.sync(() => provider.getCoins),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting && isFirstRun) {
              return MarketShimmer();
            }
            if (snapshot.hasError) {
              if (provider.getCoins.isEmpty) return MarketError(error: snapshot.error.toString());
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) => Utils.showSnackBar(snapshot.error.toString()));
              return MarketCoins();
            }
            return const MarketCoins();
          },
        ),
      ),
      floatingActionButton: isLoading
          ? const SizedBox()
          : provider.getCoins.isEmpty
              ? const SizedBox()
              : FloatingActionButton(
                  backgroundColor: theme.colorScheme.primary,
                  child: Icon(Icons.refresh, color: theme.colorScheme.onSecondary),
                  onPressed: () {
                    provider.setIsFirstRun(true);
                    provider.setIsLoadingMarket(true);
                  },
                ),
    );
  }
}
