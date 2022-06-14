import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './widgets/Chart.dart';
import './widgets/InputElements.dart';
import './models/Transactions.dart';
import './widgets/InfoTx.dart';

void main(List<String> args) {
  //FIXME: LANDSCAPE MODU IPTAL ETME.
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Personal Expenses",
      home: MyHomePage(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.purple,
          secondary: Colors.amber,
        ),
        fontFamily: "Quicksand",
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: const TextStyle(
                fontFamily: "OpenSans",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 15),
                onPrimary: Colors.white)),
        appBarTheme: const AppBarTheme().copyWith(
          color: Colors.purple,
          titleTextStyle: const TextStyle(
            fontFamily: "OpenSans",
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(primary: Colors.teal.shade300),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    print(state);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  final List<Transactions> _transactions = [];
  int txId = 0;

  List<Transactions> get _recentTransactions {
    return _transactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addTransaction(String txTitle, double txAmount, DateTime txDate) {
    Transactions transaction = Transactions(
      id: "$txId",
      title: txTitle,
      amount: txAmount,
      date: txDate,
    );
    setState(() {
      _transactions.add(transaction);
    });
    txId++;
  }

  void _deleteTransaction(String txId) {
    setState(() {
      _transactions.removeWhere((tx) {
        return tx.id == txId;
      });
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return InputElements(_addTransaction);
      },
    );
  }

  bool _showChart = false;

  List<Widget> _buildPortraitContent(
    double appFreeArea,
    Widget txListWidget,
  ) {
    return [
      Container(
        child: Chart(_recentTransactions),
        height: appFreeArea * 0.3,
      ),
      txListWidget,
    ];
  }

  List<Widget> _buildLandscapeContent(
    double appFreeArea,
    Widget txListWidget,
  ) {
    return [
      Row(
        children: [
          Text(
            "Show Chart",
            style: Theme.of(context).textTheme.headline6,
          ),
          Switch.adaptive(
              value: _showChart,
              onChanged: (val) {
                setState(() {
                  _showChart = val;
                });
              }),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
      _showChart == true
          ? Container(
              child: Chart(_recentTransactions),
              height: appFreeArea * 0.7,
            )
          : txListWidget,
    ];
  }

  Widget _buildAppBar() {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text(
              "Personal Expenses",
            ),
            trailing: Row(
              children: [
                GestureDetector(
                  child: const Icon(CupertinoIcons.add),
                  onTap: () {
                    _startAddNewTransaction(context);
                  },
                ),
              ],
              mainAxisSize: MainAxisSize.min,
            ),
          )
        : AppBar(
            title: const Text(
              "Personal Expenses",
            ),
            iconTheme: const IconThemeData(color: Colors.yellow),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  _startAddNewTransaction(context);
                },
              ),
            ],
          ) as PreferredSizeWidget;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = _buildAppBar() as PreferredSizeWidget;

    var appFreeArea = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height;
    final txListWidget = Container(
      child: InfoTx(_transactions, _deleteTransaction),
      height: appFreeArea * 0.7,
    );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandscape)
              ..._buildLandscapeContent(appFreeArea, txListWidget),
            if (!isLandscape)
              ..._buildPortraitContent(appFreeArea, txListWidget),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar as ObstructingPreferredSizeWidget,
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButton: FloatingActionButton(
              onPressed: (() {
                return _startAddNewTransaction(context);
              }),
              child: const Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
