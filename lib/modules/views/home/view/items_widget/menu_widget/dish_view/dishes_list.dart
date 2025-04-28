import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:minifood_staff/data/models/dished_model.dart';
import 'package:minifood_staff/modules/views/home/view/items_widget/menu_widget/dish_view/dished_detail.dart';

class ToyCard extends StatelessWidget {
  final DishedModel product;
  const ToyCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return InkWell(
      onTap: () {
        Get.to(DishDetailScreen(dishId: product.id));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),

                    Text(
                      currency.format(product.price),

                      style: TextStyle(
                        color: Colors.blueGrey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    product.averageRating != 0
                        ? Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange),
                            SizedBox(width: 4),
                            Text(
                              '${product.averageRating.toStringAsFixed(1)}/5 (${product.ratingCount})',
                            ),
                          ],
                        )
                        : Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange),
                            SizedBox(width: 4),
                            Text(
                              'Chưa có đánh giá',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                    SizedBox(height: 4),
                  ],
                ),
              ),
            ),
            // Ảnh sản phẩm
            Image.network(
              product.image,
              width: 130,
              height: 130,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
