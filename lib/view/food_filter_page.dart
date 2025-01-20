import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:provider/provider.dart';

import '../view_model/item_fetch_vm.dart';

// Reusable Text Field Widget Function with Border
Widget textFieldInput({
  required String label,
  required TextEditingController controller,
  required String hintText,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Colors.grey[700]),
      ),
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[500]!, width: 1), // Grey border
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none, // Remove default border
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
        ),
      ),
      SizedBox(height: 16),
    ],
  );
}

Widget dropdownSearchInput({
  required String label,
  required String hintText,
  required List<String> options,
  required Function(String?) onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Colors.grey[700]),
      ),
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[500]!, width: 1), // Grey border
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownSearch<String>(
          // key: dropDownKey,
          selectedItem: "Cuisine Type",
          items: (filter, infiniteScrollProps) => options,
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          popupProps: PopupProps.menu(fit: FlexFit.loose, constraints: BoxConstraints()),
        ),
      ),
      SizedBox(height: 16),
    ],
  );
}


// Reusable Range Slider Widget Function with Border
Widget rangeSliderInput({
  required String label,
  required double minPrice,
  required double maxPrice,
  required ValueChanged<RangeValues> onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Colors.grey[700]),
      ),
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[500]!, width: 1), // Grey border
          borderRadius: BorderRadius.circular(8),
        ),
        child: RangeSlider(
          values: RangeValues(minPrice, maxPrice),
          min: 0,
          max: 1000,
          divisions: 100,
          labels: RangeLabels(
            minPrice.toString(),
            maxPrice.toString(),
          ),
          onChanged: onChanged,
        ),
      ),
      SizedBox(height: 16),
    ],
  );
}

// Reusable Rating Stars Widget Function with Border
Widget ratingInput({
  required String label,
  required double initialRating,
  required ValueChanged<double> onRatingUpdate,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24, color: Colors.grey[700]),
      ),
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[500]!, width: 1), // Grey border
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
        child: RatingBar.builder(
          initialRating: initialRating,
          minRating: 0,
          itemSize: 25,
          allowHalfRating: true,
          itemCount: 5,
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: onRatingUpdate,
        ),
      ),
      SizedBox(height: 16),
    ],
  );
}

// Main Filter Page Stateful Widget
class FilterPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onApplyFilter;

  const FilterPage({Key? key, required this.onApplyFilter}) : super(key: key);

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  TextEditingController _cuisineController = TextEditingController();
  double _minPrice = 0;
  double _maxPrice = 1000;
  double _rating = 0;

  // Function to handle Apply filter
  void _applyFilter() {
    Map<String, dynamic> filterData = {
      'cuisine_name': _cuisineController.text,
      'price_range': {'min': _minPrice, 'max': _maxPrice},
      'rating': _rating,
    };
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filter"),
        backgroundColor: const Color.fromARGB(255, 241, 223, 168),
      ),
      body: Consumer<FoodItemsVM>(
        builder: (context, viewModel, child) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Use widget functions for each field
                dropdownSearchInput(
                  label: 'Cuisine Type',
                  hintText: 'Select Cuisine',
                  options: viewModel.cuisineTypes,
                  onChanged: (value) {
                    setState(() {
                      _cuisineController.text = value ?? '';
                    });
                  },
                ),
                rangeSliderInput(
                  label: "Price Range",
                  minPrice: _minPrice,
                  maxPrice: _maxPrice,
                  onChanged: (values) {
                    setState(() {
                      _minPrice = values.start;
                      _maxPrice = values.end;
                    });
                  },
                ),
                ratingInput(
                  label: "Minimum Rating",
                  initialRating: _rating,
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                ),
                SizedBox(height: 16),
                // Apply Filter Button
                
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                _cuisineController.clear();
                _minPrice = 0;
                _maxPrice = 1000;
                _rating = 0;
              });
            },
            child: Text("Reset", style: TextStyle(color: Colors.white,fontSize: 20,),),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[500],
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
          ),
          ElevatedButton(
            onPressed: _applyFilter,
            child: Text("Apply", style: TextStyle(color: Colors.white,fontSize: 20,),),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
          ),
        ],
      )
    );
  }
}
