import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ToyDetailScreen extends StatefulWidget {
  @override
  _ToyDetailScreenState createState() => _ToyDetailScreenState();
}

class _ToyDetailScreenState extends State<ToyDetailScreen> {
  int currentIndex = 0;
  final List<String> images = [
    'https://www.manhattantoy.com/cdn/shop/products/Untitled-1.jpg?v=1673024231&width=1000',
    'https://www.manhattantoy.com/cdn/shop/products/Untitled-1.jpg?v=1673024231&width=1000'
    'https://www.manhattantoy.com/cdn/shop/products/Untitled-1.jpg?v=1673024231&width=1000' // Thay bằng link ảnh giày
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          "Toy Store",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_bag_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            // Hình ảnh giày
            Center(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 200,
                    child: PageView.builder(
                      itemCount: images.length,
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Image.network(images[index], fit: BoxFit.contain);
                      },
                    ),
                  ),
                  // Hiệu ứng chỉ số hình ảnh
                  Positioned(
                    bottom: 8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        images.length,
                        (index) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          width: currentIndex == index ? 12 : 8,
                          height: currentIndex == index ? 12 : 8,
                          decoration: BoxDecoration(
                            color: currentIndex == index ? Colors.blue : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Thông tin sản phẩm
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "BEST SELLER",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Nike Air Jordan",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "\$967.800",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Air Jordan is an American brand of basketball shoes, athletic, casual, and style clothing produced by Nike...",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Gallery",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: images.map((img) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            img,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Phần hiển thị giá
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Price",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 5),
              Text(
                "\$890",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),

          // Nút "Add To Cart"
          ElevatedButton(
            onPressed:() {
              
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text(
              "Add To Cart",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    ),
          ],
        ),
      ),
      
    );
  }
}
