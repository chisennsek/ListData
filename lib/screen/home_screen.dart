import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:homework_mobile_app_week5/model/product.dart';
import 'package:homework_mobile_app_week5/repository/main_repository.dart';
import 'package:homework_mobile_app_week5/screen/detail_product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  List<Product> list = [];
  final MainRepository _repo = MainRepository();

  @override
  void initState() {
    getProduct();
    super.initState();
  }

  void getProduct() async {
    setState(() {
      isLoading = true;
    });
    _repo.getProduct().then(
      (data) {
        setState(() {
          list = data.products;
          isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : list.isEmpty
              ? const Center(child: Text('No products available'))
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    var data = list[index];
                    return Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailProductScreen(pro: data),
                          ),
                        ),
                        leading: CachedNetworkImage(
                          imageUrl: data.thumbnail,
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(data.title),
                      ),
                    );
                  },
                ),
    );
  }
}
