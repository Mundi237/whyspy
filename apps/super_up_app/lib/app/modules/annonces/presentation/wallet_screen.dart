import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:super_up/app/modules/annonces/cores/appstate.dart';
import 'package:super_up/app/modules/annonces/datas/models/credi_wallet.dart';
import 'package:super_up/app/modules/annonces/datas/models/package_transaction.dart';
import 'package:super_up/app/modules/annonces/datas/utils.dart';
import 'package:super_up/app/modules/annonces/presentation/credit_pay_bottom_sheet.dart';
import 'package:super_up/app/modules/annonces/providers/credit_provider.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CreditProvider controller = GetIt.I<CreditProvider>();
      controller.fetchTransactions();
      if (controller.wallet.value.data == null) {
        controller.getWallet();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CreditProvider controller = GetIt.I.get<CreditProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Portefeuille',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        centerTitle: false,
        // leading: SizedBox.shrink(),
        // leadingWidth: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WalletComponent(
              onRefillWalletPressed: _refillCredit,
            ),
            SizedBox(height: 20),
            Text(
              "Histoire",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ValueListenableBuilder<AppState<List<PackageTransaction>>>(
                  valueListenable:
                      GetIt.I<CreditProvider>().packageTransactionsList,
                  builder: (context, value, child) {
                    if (value.isLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (value.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 50),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                value.errorModel!.error,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.red.shade500, fontSize: 18),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            IconButton(
                                onPressed: () {
                                  controller.fetchTransactions();
                                },
                                icon: Icon(
                                  Icons.refresh,
                                  size: 30,
                                ))
                          ],
                        ),
                      );
                    }
                    if ((value.data ?? []).isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 50.0),
                          child: Column(
                            children: [
                              Text(
                                'Aucune annonce ne correspond à vos filtres.',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              IconButton(
                                  onPressed: () {
                                    controller.fetchTransactions();
                                  },
                                  icon: Icon(
                                    Icons.refresh,
                                    size: 30,
                                  ))
                            ],
                          ),
                        ),
                      );
                    }
                    final List<PackageTransaction> transactions =
                        value.data ?? [];
                    return ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        return TransactionHistoryComponent(
                            transaction: transaction);
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  // Refil credit
  void _refillCredit() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: CreditPayBottomSheet(),
      ),
    );
  }
}

class TransactionHistoryComponent extends StatelessWidget {
  const TransactionHistoryComponent({
    super.key,
    required this.transaction,
  });

  final PackageTransaction transaction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.all(0),
          leading: Image.asset(
            transaction.isDeposit
                ? "assets/trx-credit.png"
                : "assets/trx-debit.png",
            width: 40,
            height: 40,
          ),
          title: Text(
            "Achat de ${transaction.credits} crédits",
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            DateFormat('dd MMM yyyy – kk:mm')
                .format(transaction.createdAt ?? DateTime.now()),
          ),
          trailing: Column(
            children: [
              Text(
                "${transaction.isDeposit ? "+ " : "- "}${transaction.amount} FCFA",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color:
                      transaction.status == TransactionStatus.success.value &&
                              transaction.isDeposit
                          ? null
                          : Colors.red,
                ),
              ),
              Text(
                transaction.status.capitilizeFirstLetter(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Divider(
            color: Colors.grey.shade600,
            thickness: 0.5,
            radius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}

class WalletComponent extends StatelessWidget {
  final VoidCallback? onRefillWalletPressed;
  const WalletComponent({
    super.key,
    this.onRefillWalletPressed,
  });

  @override
  Widget build(BuildContext context) {
    CreditProvider controller = GetIt.I.get<CreditProvider>();
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage("assets/wallet-bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: ValueListenableBuilder<AppState<CrediWallet>>(
              valueListenable: controller.wallet,
              builder: (context, value, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset("assets/wallet.item.png",
                            width: 40, height: 40),
                        SizedBox(width: 1),
                        Text(
                          "CrediFlow",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Image.asset("assets/wallet.item.png",
                            width: 40, height: 40),
                      ],
                    ),
                    SizedBox(height: 15),
                    if (value.isLoading)
                      CircularProgressIndicator(
                        color: Colors.white,
                      )
                    else if (value.hasNotNullData)
                      Text(
                        "${value.data?.credits.toInt() ?? 0}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    else if (value.hasError)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.error, color: Colors.red),
                          SizedBox(width: 5),
                          Text(
                            "Erreur de chargement",
                            style: TextStyle(color: Colors.red),
                          ),
                          SizedBox(width: 5),
                          IconButton(
                            onPressed: () {
                              controller.getWallet();
                            },
                            icon: Icon(Icons.refresh, color: Colors.red),
                          ),
                        ],
                      )
                    else
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Rafraîchir le solde",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(width: 5),
                          IconButton(
                            onPressed: () {
                              controller.getWallet();
                            },
                            icon: Icon(Icons.refresh, color: Colors.white),
                          ),
                        ],
                      ),
                    SizedBox(height: 20),
                    Text(
                      "Crédits disponibles",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                );
              }),
        ),
        Positioned(
          right: 20,
          bottom: 20,
          child: OutlinedButton(
            onPressed: onRefillWalletPressed,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.white),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/wallet.item.png", width: 20, height: 20),
                SizedBox(width: 5),
                Text("Acheter des crédits"),
              ],
            ),
          ),
        )
      ],
    );
  }
}
