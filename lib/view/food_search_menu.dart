import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/helper_widget.dart';
import '../helpers/snackbar_bottom.dart';
import '../model/request_models/item_filter_request_model.dart';
import '../model/request_models/item_list_request_body_model.dart';
import '../model/response_models/item_list_model.dart';
import '../service/common_post_api_handler.dart';
import '../view_model/item_fetch_vm.dart';
import 'food_filter_page.dart';
import 'helper_widget.dart';
import 'lanugage_selector.dart';
import 'order_summary.dart';
import 'search.dart';

class FoodDeliveryListing extends StatefulWidget {
  const FoodDeliveryListing({super.key});

  @override
  State<FoodDeliveryListing> createState() => _FoodDeliveryListingState();
}

class _FoodDeliveryListingState extends State<FoodDeliveryListing> {
  bool? result;

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
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              leadingWidth: 45,
              leading: Row(
                children: [
                  const SizedBox(width: 4,),
                  ClipOval(
                    child: Image.asset('assets/images/onebanc_logo.jpeg', width: 40, height: 40,fit: BoxFit.cover,)
                  ), 
                ],
              ),
              title: Text('Food Court',style: TextStyle(color: Colors.grey[700], fontSize: 20)),
              actions: [
                LanguageSelector(onLanguageChanged: (val) {},),
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
                const SizedBox(width: 5,),
              ],
            ),
            body: Column(
              children: [
                // Search Bar with Filter Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    children: [
                      SearchScreen(),
                      SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () async {
                          try {
                            result = await showModalBottomSheet<dynamic>(
                              context: context,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                              builder: (context) => FractionallySizedBox(
                                heightFactor: 1,
                                child: FilterPage()
                              ),
                            );
                            if (result == true) {
                              showCustomSnackbar(context, text: "Items filtered");
                            }
                          } catch(obj) {
                            log('not done anything');
                          }
                          setState(() {});
                          log('viewModel.selectedFilterItems?.isFilterSelected :- ${viewModel.selectedFilterItems?.isFilterSelected}');
                        },
                        style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)), iconColor: viewModel.selectedFilterItems != ItemsFilterRequestModel() ?  Colors.blue : Colors.grey[600]),
                        child: Icon((viewModel.selectedFilterItems?.isFilterSelected == true || result == true) ?  Icons.filter_alt : Icons.filter_alt_outlined, color: Colors.black),
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