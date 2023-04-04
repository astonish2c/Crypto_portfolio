import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/screens/tab_screen/tab_screen.dart';
import '../../../model/coin_model.dart';
import '../../../provider/data_provider.dart';
import '../../../custom_widgets/helper_methods.dart';
import '../../../custom_widgets/custom_big_btn.dart';
import '../widgets/transactions_bottom_sheet_row.dart';
import 'package:provider/provider.dart';

class TransactionsBottomSheet extends StatefulWidget {
  const TransactionsBottomSheet({Key? key, required this.coin, required this.indexTransaction, required this.popPage}) : super(key: key);

  final CoinModel coin;
  final Function popPage;
  final int indexTransaction;

  @override
  State<TransactionsBottomSheet> createState() => _TransactionsBottomSheetState();
}

class _TransactionsBottomSheetState extends State<TransactionsBottomSheet> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Transaction transaction = widget.coin.transactions![widget.indexTransaction];

    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 32),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Transaction Details',
            style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: defaultPadding),
          TransactionsBottomSheetRow(
            title1: 'Type',
            title2: transaction.isSell ? 'Sell' : 'Buy',
          ),
          const Divider(
            color: Colors.grey,
          ),
          const SizedBox(height: 8),
          TransactionsBottomSheetRow(
            title1: 'Date',
            title2: DateFormat('d, MMM, y, h:m a').format(transaction.dateTime),
          ),
          const Divider(
            color: Colors.grey,
          ),
          const SizedBox(height: 8),
          TransactionsBottomSheetRow(
            title1: 'Price Per Coin',
            title2: currencyConverter(transaction.buyPrice),
          ),
          const Divider(
            color: Colors.grey,
          ),
          const SizedBox(height: 8),
          TransactionsBottomSheetRow(
            title1: 'Quantity',
            title2: currencyConverter(transaction.amount, isCurrency: false),
          ),
          const Divider(
            color: Colors.grey,
          ),
          const SizedBox(height: 8),
          const TransactionsBottomSheetRow(
            title1: 'Fee',
            title2: 'No Fee',
          ),
          const Divider(
            color: Colors.grey,
          ),
          const SizedBox(height: 8),
          TransactionsBottomSheetRow(
            title1: 'Total Cost',
            title2: currencyConverter(transaction.amount * transaction.buyPrice),
          ),
          const Divider(
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          CustomBigBtn(
            text: 'Edit Transaction',
            bgColor: Colors.blue[900],
            textColor: Colors.white,
            onTap: isLoading
                ? null
                : () {
                    Navigator.of(context).pop();
                    if (transaction.isSell) {
                      Navigator.of(context).pushNamed(TabScreen.routeName, arguments: {
                        'coinModel': widget.coin,
                        'indexTransaction': widget.indexTransaction,
                        'initialPage': 1,
                      });
                    } else {
                      Navigator.of(context).pushNamed(TabScreen.routeName, arguments: {
                        'coinModel': widget.coin,
                        'indexTransaction': widget.indexTransaction,
                        'initialPage': 0,
                      });
                    }
                  },
          ),
          const SizedBox(height: 8),
          CustomBigBtn(
            text: 'Remove Transaction',
            bgColor: Colors.red[900],
            textColor: Colors.white,
            onTap: isLoading
                ? null
                : () async {
                    setState(() {
                      isLoading = true;
                    });

                    final bool lastTransaction = await context.read<DataProvider>().removeTransaction(coin: widget.coin, transactionIndex: widget.indexTransaction);

                    if (context.mounted) Navigator.of(context).pop();

                    if (!lastTransaction) return;

                    widget.popPage();
                  },
            child: isLoading ? const SizedBox(height: 25, width: 25, child: CircularProgressIndicator(color: Colors.white)) : null,
          ),
        ],
      ),
    );
  }
}