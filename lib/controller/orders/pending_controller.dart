
import 'package:admin_app/core/class/statusrequest.dart';
import 'package:admin_app/core/functions/handingdatacontroller.dart';
import 'package:admin_app/core/services/services.dart';
import 'package:admin_app/data/datasource/remote/orders/pending_data.dart';
import 'package:admin_app/data/model/ordersmodel.dart';
import 'package:get/get.dart';

class OrdersPendingController extends GetxController {

  OrdersPendingData ordersPendingData = OrdersPendingData(Get.find());

  List<OrdersModel> data = [];

  late StatusRequest statusRequest;

  MyServices myServices = Get.find();

  String printOrderType(String val) {
    if (val == "0") {
      return "delivery";
    } else {
      return "Recive";
    }
  }

  String printPaymentMethod(String val) {
    if (val == "0") {
      return "Cash On Delivery";
    } else {
      return "Payment Card";
    }
  }

  String printOrderStatus(String val) {
    if (val == "0") {
      return "Pending Approval";
    } else if (val == "1") {
      return "The Order is being Prepared ";
    } else if (val == "2") {
      return "Ready To Picked up by Delivery man";
    }  else if (val == "3") {
      return "On The Way";
    } else {
      return "Archive";
    }
  }
  getOrders() async {
    data.clear();
    statusRequest = StatusRequest.loading;
    update();
    var response = await ordersPendingData
        .getData();
    print("=============================== Controller $response ");
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      // Start backend
      if (response['status'] == "success") {
        List listdata = response['data'];
        data.addAll(listdata.map((e) => OrdersModel.fromJson(e)));
      } else {
        statusRequest = StatusRequest.failure;
      }
      // End
    }
    update();
  }

  approveOrders(String userid, String orderid) async {
    data.clear();
    statusRequest = StatusRequest.loading;
    update();
    var response = await ordersPendingData.approveOrder(
      userid,
      orderid,
    );
    print(response);
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      if (response['status'] == "success") {
        getOrders();
      } else {
        statusRequest = StatusRequest.failure;
      }
    }
    update();
  }

  refrehOrder() {
    getOrders();
  }

  @override
  void onInit() {
    getOrders();
    super.onInit();
  }
}