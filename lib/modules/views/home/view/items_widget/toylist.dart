import 'package:flutter/material.dart';
import 'package:minifood_admin/data/models/dished_model.dart';

class ToyCard extends StatelessWidget {
  final DishedModel product;
  const ToyCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Thông tin sản phẩm
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  // Row(
                  //   children: [
                  //     Container(
                  //       padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  //       decoration: BoxDecoration(
                  //         color: Colors.blueGrey[800]!.withOpacity(0.1),
                  //         borderRadius: BorderRadius.circular(2),
                  //       ),
                  //       child: Text(
                  //         product.brand,
                  //         style: TextStyle(color: Colors.blueGrey[800], fontSize: 10),
                  //       ),
                  //     ),
                  //     SizedBox(width: 4),
                  //     if (product.isFavorite)
                  //       Container(
                  //         padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  //         decoration: BoxDecoration(
                  //           color: Colors.red[700]!.withOpacity(0.1),
                  //           borderRadius: BorderRadius.circular(2),
                  //         ),
                  //         child: Text(
                  //           'Yêu thích',
                  //           style: TextStyle(color: Colors.red[700], fontSize: 10),
                  //         ),
                  //       ),
                  //   ],
                  // ),
                  // SizedBox(height: 4),
                  Text(
                    product.price.toString(),
                    style: TextStyle(
                      color: Colors.blueGrey[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  // Row(
                  //   children: [
                  //     Icon(Icons.star, color: Colors.amber, size: 14),
                  //     SizedBox(width: 2),
                  //     Text(
                  //       '${product.rating}',
                  //       style: TextStyle(color: Colors.grey, fontSize: 12),
                  //     ),
                  //     SizedBox(width: 4),
                  //     Text(
                  //       'Đã bán ${product.soldCount}',
                  //       style: TextStyle(color: Colors.grey, fontSize: 10),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(height: 4),
                  // Row(
                  //   children: [
                  //     Text(
                  //       product.origin,
                  //       style: TextStyle(color: Colors.grey, fontSize: 10),
                  //     ),
                  //     SizedBox(width: 20),
                  //     Container(
                  //       padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  //       decoration: BoxDecoration(
                  //         color: Colors.red.withOpacity(0.1),
                  //         borderRadius: BorderRadius.circular(2),
                  //       ),
                  //       child: Text(
                  //         '-${product.discountPercent}%',
                  //         style: TextStyle(color: Colors.red, fontSize: 10),
                  //       ),
                  //     ),
                  //   ],
                  // ),
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
    );
  }
}
