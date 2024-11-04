import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:homework_mobile_app_week5/model/category.dart';
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
  bool isCategoriesLoading = false;
  bool isPaginating = false;
  List<Product> list = [];
  List<CategoriesResponse> categories = [];
  final MainRepository _repo = MainRepository();
  int? selectedCategoryIndex;
  int currentPage = 1;
  int limit = 3;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    getProduct();
    getCategories();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isPaginating) {
        loadMoreProducts();
      }
    });
    super.initState();
  }

  void getCategories() async {
    setState(() {
      isCategoriesLoading = true;
    });
    try {
      // Fetch categories from the API
      categories = await _repo.getAllCategories();

      // Create an "All" category and insert it at index 0
      var allCategory = CategoriesResponse(
        slug: 'all', // You can set this to whatever you need
        name: 'All', // Name to display
        url: '', // Set this if you need a URL or leave empty
      );

      categories.insert(0, allCategory); // Insert "All" at index 0

      setState(() {
        isCategoriesLoading = false;
      });
    } catch (e) {
      setState(() {
        isCategoriesLoading = false;
      });
      print("Error fetching categories: $e");
    }
  }

  void getProduct() async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await _repo.getProduct(limit, currentPage);

      setState(() {
        list = data.products;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void loadMoreProducts() async {
    setState(() {
      isPaginating = true;
    });
    try {
      final data = await _repo.getProductByCategory(
        categories[selectedCategoryIndex ?? 0].slug,
        currentPage + 1,
        limit,
      );
      setState(() {
        list.addAll(data);
        currentPage++;
        isPaginating = false;
      });
    } catch (e) {
      setState(() {
        isPaginating = false;
      });
    }
  }

  void getProductByCategory(String categorySlug) async {
    print("Selected Category Slug: $categorySlug");
    print("Current Page: $currentPage, Limit: $limit");

    setState(() {
      isLoading = true;
      currentPage = 1;
      list.clear();
    });

    try {
      final products =
          await _repo.getProductByCategory(categorySlug, currentPage, limit);
      setState(() {
        list = products;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching products: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 70,
            child: isCategoriesLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      var category = categories[index];
                      bool isSelected = selectedCategoryIndex == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategoryIndex =
                                index; // Set the selected index
                          });

                          // Check if the selected category is "All"
                          if (category.slug == 'all') {
                            getProduct(); // Fetch all products when "All" is selected
                          } else {
                            // Fetch products by selected category
                            getProductByCategory(category.slug);
                          }
                        },
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blueAccent : Colors.blue,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: const EdgeInsets.all(8),
                          child: Center(
                            child: Text(
                              category.name ??
                                  'Unknown', // Use a default if name is null
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: list.length + (isPaginating ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == list.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  var data = list[index];
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DetailProductScreen(pro: data),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            imageUrl: data.thumbnail ??
                                '', // Handle if thumbnail is null
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            data.title ?? 'No Title', // Handle if title is null
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
