import 'package:flutter/material.dart';
import 'package:scroll_tabs/widgets/list_products.dart';

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
                // Funcao executada quando há um scroll
                onScroll: (metrics) {
                  // converte em map para gerar um tupla de [index, value]
                  categories.asMap().entries.forEach((tuple) {
                    final index = tuple.key;
                    final element = tuple.value;
                    // verifica se a posição do scroll é maior
                    // que a posicao inicial da categoria
                    if (metrics.pixels > element['position']) {
                      // se sim seta a index da categoria em exibicao
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
    // converte em map para gerar um tupla de [index, value]
    products.asMap().entries.forEach((tuple) {
      final index = tuple.key;
      if (index == 0 ||
          products[index - 1]['category'] != tuple.value['category']) {
        // adiciona no array as categorias encontradas no
        // array de produtos
        newCategories.add({
          'category': tuple.value['category'],
          // seta a posicao como sendo o produto entre
          // o tamanho do item da lista, pela quantidade de itens
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
                  // Manda o listview ir para a posicao onde a categoria se inicia
                  // De forma animada.
                  _controller.animateTo(
                    index == 0
                        ? 0.0
                        : categories[index]['position'] +
                            24, // 24 é a altura do titulo
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
