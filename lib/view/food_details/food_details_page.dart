import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/request_models/make_payment_request_model.dart';
import '../../model/response_models/item_details_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../view_model/item_fetch_vm.dart';
import '../order_summary.dart';

class ItemDetailsWidget extends StatefulWidget {
  final ItemDetailsResponseModel itemDetails;

  const ItemDetailsWidget({Key? key, required this.itemDetails}) : super(key: key);

  @override
  State<ItemDetailsWidget> createState() => _ItemDetailsWidgetState();
}

class _ItemDetailsWidgetState extends State<ItemDetailsWidget> {

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<FoodItemsVM>(context, listen: false);
    Future.delayed(Duration.zero, () async {
      await viewModel.setCartValue(0);
      await viewModel.removeAllCartItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: SizedBox(
              height: 300.0,
              width: MediaQuery.of(context).size.width, 
              child: Image.network(
                widget.itemDetails.itemImageUrl ?? '',
                fit: BoxFit.cover, 
                errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            'Cuisine: ${widget.itemDetails.cuisineName}',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            widget.itemDetails.itemName ?? '',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          RatingBar.builder(
            initialRating: widget.itemDetails.itemRating ?? 0,
            minRating: 0,
            allowHalfRating: true,
            direction: Axis.horizontal,
            itemCount: 5,
            itemSize: 20,
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
            },
          ),
          Text( '₹ ${widget.itemDetails.itemPrice}', style: TextStyle( fontSize: 35.0, fontWeight: FontWeight.bold)),
          SizedBox(height: 20.0),
          Consumer<FoodItemsVM>(
            builder: (context, viewModel, _) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if(viewModel.cartItems.isNotEmpty)
                ElevatedButton(
                  onPressed: () async {
                    final object = MakePaymentRequestModel(
                      data: viewModel.cartItems
                    );
                    Navigator.push(context, MaterialPageRoute(builder: (context) => OrderSummaryPage(itemDetails: object,)));
                  },
                  style: ElevatedButton.styleFrom( backgroundColor: Colors.green),
                  child: Text('Place Order', style: TextStyle(color: Colors.white),),
                ),
                Visibility(
                  visible: viewModel.addToCartValue > 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Decrement Button
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () async {
                          await viewModel.decrementCartValue();
                          await viewModel.popLastCartItem();
                        }
                      ),
                      // Quantity Display
                      Text(
                        '${viewModel.addToCartValue}',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      // Increment Button
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () async {
                          await viewModel.setCartItems(Data(cuisineId: int.parse(widget.itemDetails.cuisineId ?? ''), itemId: widget.itemDetails.itemId, itemPrice: widget.itemDetails.itemPrice, itemQuantity: 1));
                          await viewModel.incrementCartValue();
                        },
                      ),
                    ],
                  ),
                  replacement: ElevatedButton(
                    onPressed: () async {
                      await viewModel.setCartItems(Data(cuisineId: int.parse(widget.itemDetails.cuisineId ?? ''), itemId: widget.itemDetails.itemId, itemPrice: widget.itemDetails.itemPrice, itemQuantity: 1));
                      await viewModel.incrementCartValue();
                    },
                    style: ElevatedButton.styleFrom( backgroundColor: Colors.blue),
                    child: Text('Add', style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}