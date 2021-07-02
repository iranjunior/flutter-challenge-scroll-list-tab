import 'package:flutter/material.dart';

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
      // Fica escutando as notificacoes geradas pelo scroll
      onNotification: (scrollNotification) {
        // manda para funcao de callback a posicao atual do scroll
        this.onScroll(scrollNotification.metrics);
        // envia para o listener que ainda nao terminou de escutar.
        return false;
      },
      child: ListView(
        controller: _controller,
        children: [
          // converte em map para gerar um tupla de [index, value]
          ...products.asMap().entries.map((tuple) {
            final index = tuple.key;
            // se for o pimeiro item dos produtos
            // ou houver uma mudança nas categoria do produto entra aqui
            if (index == 0 ||
                products[index - 1]['category'] != tuple.value['category']) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      tuple.value['category']!,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
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
