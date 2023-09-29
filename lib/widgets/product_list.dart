import 'package:flutter/material.dart';
import 'package:shoes_shop_app/global_variables.dart';
import 'package:shoes_shop_app/widgets/product_card.dart';
import 'package:shoes_shop_app/pages/product_details_page.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final List<String> filters = const [
    'All',
    'Addidas',
    'Nike',
    'Bata'
  ];

  late String selectedFilter;
  List<Map<String, dynamic>> filteredProducts = [];

  int currenPage = 0;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedFilter = filters[0];
    filteredProducts = products;
  }

  void filterProducts(String filter, String query) {
    setState(() {
      selectedFilter = filter;
      filteredProducts = products.where((product) {
        final companyMatches = filter == 'All' || product['company'] == filter;
        final titleMatches = query.isEmpty || (product['title']?.toString().toLowerCase() ?? '').contains(query.toLowerCase());
        return companyMatches && titleMatches;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderSide: BorderSide(
        // color: Color.fromRGBO(255, 255, 255, 1),
        color: Colors.black12,
      ),
      borderRadius: BorderRadius.horizontal(
        left: Radius.circular(50), // Curve the left side
      ),
    );
    return SafeArea(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
            child: Row(
              children: [
                Text(
                  'Shoes\nCollection',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: searchController, // Bind the controller
                    onChanged: (query) {
                      filterProducts(selectedFilter, query); // Update filter when user types
                    },
                    onSubmitted: (query) {
                      filterProducts(selectedFilter, query); // Update filter when user clicks on the search button
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: border,
                      enabledBorder: border,
                      focusedBorder: border,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              itemCount: filters.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final filter = filters[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      filterProducts(filter, searchController.text);
                    },
                    child: Chip(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      backgroundColor: selectedFilter == filter ? Theme.of(context).colorScheme.primary : const Color.fromRGBO(245, 247, 249, 1),
                      side: const BorderSide(
                        color: Color.fromRGBO(245, 247, 249, 1),
                      ),
                      label: Text(
                        filter,
                      ),
                      labelStyle: const TextStyle(
                        fontSize: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: ((context, index) {
                final product = filteredProducts[index];
                final convertedProduct = Map<String, Object>.from(product);
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsPage(
                          product: convertedProduct,
                        ),
                      ),
                    );
                  },
                  child: ProductCard(
                    id: product['id'] as String,
                    title: product['title'] as String,
                    price: product['price'] as double,
                    imageUrl: product['imageUrl'] as String,
                    backgroundColor: index.isEven ? const Color.fromRGBO(216, 240, 253, 1) : const Color.fromRGBO(245, 247, 249, 1),
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
