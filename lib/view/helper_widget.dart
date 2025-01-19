import 'package:flutter/material.dart';

import '../model/response_models/item_list_model.dart';

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
                      Widget main = ListTile(
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
