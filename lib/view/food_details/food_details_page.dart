import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/snackbar_bottom.dart';
import '../../model/food_model.dart';
import '../../view_model/search_food_view_model.dart';

class FoodDetails extends StatefulWidget {
  final Food food;
  const FoodDetails({super.key, required this.food});

  @override
  State<FoodDetails> createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {
  var description = "This mouth-watering dish combines a hearty chickpea patty with fresh lettuce, juicy tomatoes, and a tangy vegan mayo. Topped with crisp onions and served on a toasted whole-grain bun, it's a wholesome and satisfying meal packed with flavor";
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.asset(
                widget.food.thumNailAssetPath,
                width: double.infinity,
                height: 170,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  widget.food.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange
                  ),
                ),
                const SizedBox(width: 10,),
                Icon(Icons.circle,color: Colors.grey[800],size: 8),
                const SizedBox(width: 2,),
                Text(
                  '\$${widget.food.price}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700]
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(description, maxLines: 4,style: TextStyle(fontSize: 14, color: Colors.grey[700], ),),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.store_outlined,color: Colors.yellow[800],size: 25,),
                const SizedBox(width: 2,),
                Text(widget.food.businessName, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500,color: Colors.grey[900], ) ),
                const SizedBox(width: 8,),
                Icon(Icons.circle,color: Colors.grey[900],size: 5),
                const SizedBox(width: 4,),
                Text('5 km away', style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal,color: Colors.grey[700], ) )
              ]
            ),
            const Spacer(),
            Consumer<FoodViewModel>(
              builder: (context, viewModel, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () async =>  { viewModel.setCartItems(widget.food), Navigator.pop(context), showCustomSnackbar(context, text: 'Added to cart')},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                      child: const Text( 'Add to Cart', style: TextStyle(color: Colors.black),),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        showCustomSnackbar(context, text: 'Order placed successfully');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                      child: const Text('Order', style: TextStyle(color: Colors.white),),
                    ),
                  ],
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}