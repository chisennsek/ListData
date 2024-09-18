import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:homework_mobile_app_week5/model/product.dart';

class DetailProductScreen extends StatefulWidget {
  const DetailProductScreen({super.key, required this.pro});

  final Product pro;

  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: CachedNetworkImage(
          imageUrl: widget.pro.thumbnail,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
