import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late final ScrollController _controller;
  final size = 80.0;
  int categoryIndex = 0;
  final products = [
    {'title': 'Cheddar Bacon', 'category': 'hamburger'},
    {'title': 'Cheddar Bacon', 'category': 'hamburger'},
    {'title': 'Cheddar Bacon', 'category': 'hamburger'},
    {'title': 'Cheddar Bacon', 'category': 'hamburger'},
    {'title': 'Cheddar Bacon', 'category': 'hamburger'},
    {'title': 'Cheddar Bacon', 'category': 'hamburger'},
    {'title': 'Cheddar Bacon', 'category': 'hamburger'},
    {'title': 'Cheddar Bacon', 'category': 'hamburger'},
    {'title': 'Cheddar Bacon', 'category': 'hamburger'},
    {'title': 'Cheddar Bacon', 'category': 'hamburger'},
    {'title': 'Coca cola 1l', 'category': 'bebidas'},
    {'title': 'Coca cola 1l', 'category': 'bebidas'},
    {'title': 'Coca cola 1l', 'category': 'bebidas'},
    {'title': 'Brownie', 'category': 'sobremesa'},
    {'title': 'Brownie', 'category': 'sobremesa'},
    {'title': 'Brownie', 'category': 'sobremesa'},
    {'title': 'Brownie', 'category': 'sobremesa'},
    {'title': 'Brownie', 'category': 'sobremesa'},
  ];
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Material(
              color: Colors.white,
              elevation: 1,
              child: SizedBox.fromSize(
                size: Size(double.infinity, 60),
                child: _buildTabs(),
              ),
            ),
            SizedBox(height: 4),
            Expanded(
              flex: 5,
              child: ListProducts(
                controller: _controller,
                products: products,
                size: size,
                onScroll: (metrics) {
                  categories.asMap().entries.forEach((tuple) {
                    final index = tuple.key;
                    final element = tuple.value;

                    if (metrics.pixels > element['position']) {
                      setState(() {
                        categoryIndex = index;
                      });
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView _buildTabs() {
    final List<Map<String, dynamic>> newCategories = [];
    products.asMap().entries.forEach((tuple) {
      final index = tuple.key;
      if (index == 0 ||
          products[index - 1]['category'] != tuple.value['category']) {
        newCategories.add({
          'category': tuple.value['category'],
          'position': size * index,
        });
      }
    });
    setState(() {
      categories = newCategories;
    });
    return ListView.builder(
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.only(bottom: 3),
            color: categoryIndex == index ? Colors.red : Colors.transparent,
            child: Container(
              color: Colors.white,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    categoryIndex = index;
                  });
                  _controller.animateTo(
                    index == 0 ? 0.0 : categories[index]['position'] + 24,
                    duration: Duration(seconds: 1),
                    curve: Curves.easeInOut,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    categories[index]['category'],
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class ListProducts extends StatelessWidget {
  const ListProducts({
    Key? key,
    required ScrollController controller,
    required this.products,
    required this.size,
    required this.onScroll,
  })  : _controller = controller,
        super(key: key);

  final ScrollController _controller;
  final List<Map<String, String>> products;
  final void Function(ScrollMetrics) onScroll;
  final double size;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification) {
        this.onScroll(ScrollNotification.metrics);
        return false;
      },
      child: ListView(
        controller: _controller,
        children: [
          ...products.asMap().entries.map((tuple) {
            final index = tuple.key;
            if (index == 0 ||
                products[index - 1]['category'] != tuple.value['category']) {
              return Column(
                children: [
                  Text(
                    tuple.value['category']!,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ListTile(
                    minVerticalPadding: size / 2,
                    title: Text(tuple.value['title']!),
                  )
                ],
              );
            }

            return ListTile(
              minVerticalPadding: size / 2,
              title: Text(tuple.value['title']!),
            );
          }).toList()
        ],
      ),
    );
  }
}
