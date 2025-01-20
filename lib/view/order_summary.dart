import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/snackbar_bottom.dart';
import '../model/request_models/make_payment_request_model.dart';
import '../view_model/item_fetch_vm.dart';

class OrderSummaryPage extends StatefulWidget {
  final MakePaymentRequestModel itemDetails;

  const OrderSummaryPage({Key? key, required this.itemDetails}) : super(key: key);

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {

  @override
  void initState() {
    super.initState();
    widget.itemDetails.calculateTotalAmount();
    widget.itemDetails.calculateTotalItems();
  }
  Future<void> _makePayment(BuildContext context) async {
    final viewModel = Provider.of<FoodItemsVM>(context, listen: false);
    await viewModel.makePayment(
      MakePaymentRequestModel(
        totalAmount: widget.itemDetails.totalAmount?.toString(),
        totalItems: widget.itemDetails.totalItems,
        data: widget.itemDetails.data,
      ),
    );
    if (viewModel.makePaymentResponseModel?.responseCode == 200) {
      showCustomSnackbar(context, text: "Order placed successfully!");
    } else {
      showCustomSnackbar(context, text: "Couldn't place order");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item Details Section
            Text( 'Item Summary', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            (widget.itemDetails.data ?? []).isEmpty
            ? const Text('No items in the order.')
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Item Id', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Cuisine Id', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: (widget.itemDetails.data ?? []).map((item) {
                    return DataRow(cells: [
                      DataCell(Text('${item.itemId ?? 'Unknown'}')), 
                      DataCell(Text('${item.cuisineId ?? 'Unknown'}')), 
                      DataCell(Text('\$${item.itemPrice}')),
                    ]);
                  }).toList(),
                ),
              ),
            Text('Quantity: ${widget.itemDetails.totalItems}'),
            const SizedBox(height: 24),
            Text( 'Total Amount: \$${widget.itemDetails.totalAmount}', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            const Spacer(),
            ElevatedButton(
              onPressed: () => _makePayment(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Center(child: Text('Make Payment', style: TextStyle(color: Colors.white),)),
            ),
          ],
        ),
      ),
    );
  }
}
