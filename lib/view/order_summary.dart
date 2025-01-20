import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/snackbar_bottom.dart';
import '../model/request_models/make_payment_request_model.dart';
import '../view_model/item_fetch_vm.dart';
import 'food_search_menu.dart';

class OrderSummaryPage extends StatefulWidget {
  final MakePaymentRequestModel? itemDetails;

  const OrderSummaryPage({Key? key, this.itemDetails}) : super(key: key);

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  double gst = 0.0;
  double cgst = 0.0;
  MakePaymentRequestModel? itemDetails;

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<FoodItemsVM>(context, listen: false);
    itemDetails = widget.itemDetails ?? MakePaymentRequestModel(data: viewModel.cartItems);
    itemDetails?.calculateTotalAmount();
    itemDetails?.calculateTotalItems();
   
  }
  Future<void> callPaymentPOSTAPI(BuildContext context) async {
    final viewModel = Provider.of<FoodItemsVM>(context, listen: false);
    await viewModel.makePayment(
      MakePaymentRequestModel(
        totalAmount: itemDetails?.totalAmount?.toString(),
        totalItems: itemDetails?.totalItems,
        data: itemDetails?.data,
      ),
    );
    if (viewModel.makePaymentResponseModel?.responseCode == 200) {
      showCustomSnackbar(context, text: "Order placed successfully!");
      await Future.delayed(const Duration(milliseconds: 800));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FoodDeliveryListing()));
    } else {
      showCustomSnackbar(context, text: "Couldn't place order", textColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FoodItemsVM>(
      builder: (context, viewModel, _) {
        MakePaymentRequestModel? itemDetails = widget.itemDetails ?? MakePaymentRequestModel(data: viewModel.cartItems);
        itemDetails.calculateTotalAmount();
        itemDetails.calculateTotalItems();
        return Scaffold(
          appBar: AppBar(
            title: const Text('Order Summary'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text( 'Item Summary', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                (itemDetails.data ?? []).isEmpty
                ? const Text('No items in the order.')
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Item Id', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Cuisine Id', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: (itemDetails.data ?? []).map((item) {
                        return DataRow(cells: [
                          DataCell(
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text('${item.itemId ?? 'Unknown'}'),
                            ),
                          ),
                          DataCell(
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text('${item.cuisineId ?? 'Unknown'}'),
                            ),
                          ),
                          DataCell(
                            Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text('₹ ${item.itemPrice}'),
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                if((itemDetails.data ?? []).isNotEmpty) Divider(color: Colors.grey[700], height: 1,),
                const SizedBox(height: 12),
                commonLabelValueRow('Total Quantity', '${itemDetails.totalItems}'),
                const SizedBox(height: 12),
                commonLabelValueRow('Sum Total', '₹ ${itemDetails.sumAmount}'),
                const SizedBox(height: 12),
                commonLabelValueRow('GST (2.5%)', '₹ ${itemDetails.gst}'),
                const SizedBox(height: 12),
                commonLabelValueRow('CGST (2.5%)', '₹ ${itemDetails.cgst}'),
                const SizedBox(height: 12),
                Divider(color: Colors.grey[700], height: 1,),
                const SizedBox(height: 12),
                commonLabelValueRow('Total Amount Payable', '₹ ${itemDetails.totalAmount}'),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => callPaymentPOSTAPI(context),
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
    );
  }

  Widget commonLabelValueRow(String label, String value) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        // Value
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
}
