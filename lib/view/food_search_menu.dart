import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/helper_widget.dart';
import '../model/request_models/item_list_request_body_model.dart';
import '../model/response_models/item_list_model.dart';
import '../service/common_post_api_handler.dart';
import '../view_model/item_fetch_vm.dart';
import 'helper_widget.dart';

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
            body: 
              viewModel.state == RequestState.loading ? const FoodLoader()
            : viewType(viewModel,cuisines)
          ),
        );
      }
    );
  }

  Widget viewType(FoodItemsVM viewModel, List<Cuisines>? foodList) => CuisinesAccordion(foodList: foodList ?? [],); 

}