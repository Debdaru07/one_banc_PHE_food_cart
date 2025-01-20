import 'package:flutter/material.dart';
import '../../model/response_models/item_details_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ItemDetailsWidget extends StatefulWidget {
  final ItemDetailsResponseModel itemDetails;

  const ItemDetailsWidget({Key? key, required this.itemDetails}) : super(key: key);

  @override
  State<ItemDetailsWidget> createState() => _ItemDetailsWidgetState();
}

class _ItemDetailsWidgetState extends State<ItemDetailsWidget> {
  bool isAddedToCart = false;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text( '₹ ${widget.itemDetails.itemPrice}', style: TextStyle( fontSize: 35.0, fontWeight: FontWeight.bold)),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isAddedToCart = !isAddedToCart;
                  });
                },
                child: Text(isAddedToCart ? 'Added' : 'Add to Cart'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientChip(String ingredient) {
    return Chip(
      label: Text(ingredient),
      backgroundColor: Colors.grey[200],
    );
  }
}