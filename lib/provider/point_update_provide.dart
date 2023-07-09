import 'package:flutter/cupertino.dart';
import 'package:ipoint/model/invoice_pay_model.dart';

class InvoicePoint extends ChangeNotifier {
  InvoicePayModel? invoicePayModel;
  InvoicePayModel? get GetInvoicePayModel => invoicePayModel;
  void setinvoicemodel(InvoicePayModel modelpoint) {
    invoicePayModel = modelpoint;
    notifyListeners();
  }
}