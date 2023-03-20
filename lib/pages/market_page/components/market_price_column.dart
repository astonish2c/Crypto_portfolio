import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/coin_model.dart';
import '../../../provider/theme_provider.dart';
import '../../../utils/constants.dart';

class MarketPriceColumn extends StatelessWidget {
  const MarketPriceColumn({
    Key? key,
    required this.cm,
  }) : super(key: key);

  final CoinModel cm;

  @override
  Widget build(BuildContext context) {
    bool isNegative = double.parse(cm.priceDiff).isNegative;

    String readyCurrentPrice = '\$${convertStrToNum(cm.currentPrice)}';
    String readyPriceDiff = '${isNegative ? '' : '+'}${convertPerToNum(cm.priceDiff)}%';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            readyCurrentPrice,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        SizedBox(height: defaultPadding / 4),
        Consumer<ThemeProvider>(
          builder: (context, value, child) => FittedBox(
            fit: BoxFit.scaleDown,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isNegative ? Colors.red[300] : Colors.green[300],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                readyPriceDiff,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }
}