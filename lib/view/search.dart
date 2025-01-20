import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/request_models/item_list_request_body_model.dart';
import '../model/response_models/item_list_model.dart';
import '../view_model/item_fetch_vm.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchTerm = "";
  Timer? _debounceTimer;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Function to handle the search
  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }
    setState(() {
      _searchTerm = query;
    });
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      log('Search for: $_searchTerm');
      _filterData(_searchTerm.trim().toLowerCase());
    });
  }

  // Function to filter data based on search term
  void _filterData(String query) async {
    final foodItemsVM = Provider.of<FoodItemsVM>(context, listen: false);
    if(query.isNotEmpty) {
      final filteredCuisines = foodItemsVM.itemsListModel?.cuisines?.where((cuisine) {
        return (cuisine.cuisineName ?? '').toLowerCase().contains(query) || cuisine.items!.any((item) => (item.name ?? '').toLowerCase().contains(query));
      }).toList();
      await foodItemsVM.setItemsListModel(
        ItemsListModel(
          count: foodItemsVM.itemsListModel?.count,
          outcomeCode: foodItemsVM.itemsListModel?.outcomeCode,
          requesterIp: foodItemsVM.itemsListModel?.requesterIp,
          page: foodItemsVM.itemsListModel?.page,
          timestamp: foodItemsVM.itemsListModel?.timestamp,
          responseCode: foodItemsVM.itemsListModel?.responseCode,
          responseMessage: foodItemsVM.itemsListModel?.responseMessage,
          timetaken: foodItemsVM.itemsListModel?.timetaken,
          totalItems: foodItemsVM.itemsListModel?.totalItems,
          totalPages: foodItemsVM.itemsListModel?.totalPages,
          cuisines: filteredCuisines
        ) 
      );
    } else {
      Future.delayed(Duration.zero, () async => await foodItemsVM.fetchItemList(ItemListRequestModel(page: 1, count: 10)));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,  // Listen to text changes
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
