import 'package:flutter/material.dart';
import 'package:munch/service/common_post_api_handler.dart';
import 'package:provider/provider.dart';
import '../helpers/helper_widget.dart';
import '../model/request_models/item_details_request_body_mode.l.dart';
import '../model/response_models/item_details_model.dart';
import '../model/response_models/item_list_model.dart';
import '../view_model/item_fetch_vm.dart';
import 'food_details/food_details_page.dart';

class CuisinesAccordion extends StatelessWidget {
  final List<Cuisines> foodList;

  const CuisinesAccordion({Key? key, required this.foodList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: foodList.length,
      itemBuilder: (context, index) {
        final food = foodList[index];
        return AccordionCard(food: food);
      },
    );
  }
}

class AccordionCard extends StatefulWidget {
  final Cuisines food;

  const AccordionCard({Key? key, required this.food}) : super(key: key);

  @override
  _AccordionCardState createState() => _AccordionCardState();
}

class _AccordionCardState extends State<AccordionCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          // Accordion Header
          ListTile(
            leading: Image.network(
              widget.food.cuisineImageUrl ?? '',
              width: 70,
              height: 70,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
            ),
            title: Text(widget.food.cuisineName ?? ''),
            trailing: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),

          // Accordion Body (Food Items List)
          if (_isExpanded && (widget.food.items?.isNotEmpty ?? false))
            Column(
              children: [
                Divider(color: Colors.grey[700],height: 0.6,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.food.items?.length,
                    itemBuilder: (context, index) {
                      final item = widget.food.items![index];
                      Widget main = InkWell(
                        onTap: () async { 
                          Future.delayed(Duration.zero, () async {
                            var result = await showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                              builder: (context) => FractionallySizedBox(
                                heightFactor: 1,
                                child: CommonBottomSheet(
                                  item: item
                                )
                              ),
                            );
                          });
                        },
                        child: ListTile(
                          leading: Image.network(
                            item.imageUrl ?? '',
                            width: 60,
                            height: 60,
                            errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item.name ?? 'No name'),
                              Text('${item.rating ?? ''} ⭐'),
                            ],
                          ),
                          subtitle: Text('Price: ${item.price ?? 'N/A'}'),
                        ),
                      );
                      return Column(
                        children: [
                          main,
                          Divider(color: Colors.grey[500],height: 0.3,),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class CommonBottomSheet extends StatefulWidget {
  final Items item;
  const CommonBottomSheet({ Key? key, required this.item }) : super(key: key);

  @override
  _CommonBottomSheetState createState() => _CommonBottomSheetState();
}

class _CommonBottomSheetState extends State<CommonBottomSheet> {

  @override
  void initState() {
    super.initState();
    final foodItemsVM = Provider.of<FoodItemsVM>(context, listen: false);
    int value = int.parse(widget.item.id ?? '');
    Future.delayed(Duration.zero, () async {
      await foodItemsVM.getItemById(ItemListDetailsRequestBodyModel(itemId: value));
    });
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<FoodItemsVM>(
      builder: (context, viewModel, _) => SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Visibility(
            visible: viewModel.state == RequestState.completed,
            replacement: const FoodLoader(),
            child: 
              ItemDetailsWidget(itemDetails: viewModel.itemDetails ?? ItemDetailsResponseModel(),)
          ),
        ),
      ),
    );
  }
}
