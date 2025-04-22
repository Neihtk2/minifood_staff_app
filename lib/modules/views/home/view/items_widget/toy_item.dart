import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:minifood_admin/data/models/dished_model.dart';

class DishedCard extends StatelessWidget {
  final DishedModel dish;

  const DishedCard({super.key, required this.dish});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,

      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(
                dish.image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 120.h,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(child: Icon(Icons.error, color: Colors.red));
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dish.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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

                //     ),
                // SizedBox(width: 4),
                // if (watch.isFavorite)
                //   Container(
                //     padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                //     decoration: BoxDecoration(
                //       color: Colors.red[700]!.withOpacity(0.1),
                //       borderRadius: BorderRadius.circular(2),
                //     ),
                //     child: Text(
                //       'Yêu thích',
                //       style: TextStyle(color: Colors.red[700], fontSize: 10),
                //     ),
                //   ),
                //   ],
                // ),
                SizedBox(height: 4),
                Text(
                  dish.price.toString(),
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
                // Text(
                //   '${watch.rating}',
                //   style: TextStyle(color: Colors.grey, fontSize: 12),
                // ),
                // SizedBox(width: 4),
                // Text(
                //   'Đã bán ${watch.soldCount}',
                //   style: TextStyle(color: Colors.grey, fontSize: 10),
                // ),
                //   ],
                // ),
                // SizedBox(height: 4),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       watch.origin,
                //       style: TextStyle(color: Colors.grey, fontSize: 10),
                //     ),
                //     Container(
                //       padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                //       decoration: BoxDecoration(
                //         color: Colors.red.withOpacity(0.1),
                //         borderRadius: BorderRadius.circular(2),
                //       ),
                //       child: Text(
                //         '-${watch.discountPercent}%',
                //         style: TextStyle(color: Colors.red, fontSize: 10),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
