import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/helper_widget.dart';
import '../model/request_models/item_list_request_body_model.dart';
import '../model/response_models/item_list_model.dart';
import '../service/common_post_api_handler.dart';
import '../view_model/item_fetch_vm.dart';
import 'helper_widget.dart';
import 'order_summary.dart';
import 'search.dart';

class FoodDeliveryListing extends StatefulWidget {
  const FoodDeliveryListing({super.key});

  @override
  State<FoodDeliveryListing> createState() => _FoodDeliveryListingState();
}

class _FoodDeliveryListingState extends State<FoodDeliveryListing> {

  @override
  initState() {
    super.initState();
    final foodItemsVM = Provider.of<FoodItemsVM>(context, listen: false);
    Future.delayed(Duration.zero, () async => await foodItemsVM.fetchItemList(ItemListRequestModel(page: 1, count: 10)));
  }

  TextEditingController controller = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Consumer<FoodItemsVM>(
      builder: (c, viewModel, _) {
        List<Cuisines>? cuisines = viewModel.itemsListModel?.cuisines;
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {},
              ),
              title: Row(
                children: [
                  ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Image.asset('assets/images/onebanc_logo.jpeg', width: 40, height: 40,fit: BoxFit.cover,),
                    )
                  ), 
                  const SizedBox(width: 5,),
                  Text('Food Court',style: TextStyle(color: Colors.black)),
                ],
              ),
              actions: [
                Stack(
                  children: [
                    IconButton(
                      icon: Icon(Icons.shopping_cart, color: Colors.black),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (  context) => OrderSummaryPage()));
                      },
                    ),
                    // Badge overlay
                    showCartItems(viewModel.cartItems.length),
                  ],
                ),
              ],
            ),
            body: Column(
              children: [
                // Search Bar with Filter and Sort Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    children: [
                      // Expanded(
                      //   child: TextField(
                      //     decoration: InputDecoration(
                      //       hintText: 'Search',
                      //       prefixIcon: Icon(Icons.search),
                      //       border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(8.0),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SearchScreen(),
                      SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () {
                          log('Filter button pressed');
                        },
                        style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
                        child: Icon(Icons.filter_list,color: Colors.black),
                      ),
                      SizedBox(width: 8),
                      // Sort Button
                      OutlinedButton(
                        onPressed: () {
                          // Handle sort button functionality
                          log('Sort button pressed');
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Icon(
                          Icons.swap_vert,
                          color: Colors.black, // Adjust the icon color if needed
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: viewModel.state == RequestState.loading ? const FoodLoader() : viewType(viewModel,cuisines)
                ),
                
              ],
            )
              
          ),
        );
      }
    );
  }

  Widget viewType(FoodItemsVM viewModel, List<Cuisines>? foodList) => CuisinesAccordion(foodList: foodList ?? [],); 

  Widget showCartItems(int items) {
    return Positioned(
      right: 4,
      top: 4,
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(color: Colors.red,shape: BoxShape.circle,),
        child: Text('${items}',style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold,),
        ),
      ),
    );
  }

}