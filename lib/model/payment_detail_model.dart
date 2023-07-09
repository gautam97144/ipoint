class ReadPayment {
  String? status;
  List<Result>? result;
  String? message;
  int? totalPages;

  ReadPayment({this.status, this.result, this.message, this.totalPages});

  ReadPayment.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
    message = json['message'];
    totalPages = json['total_pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['total_pages'] = this.totalPages;
    return data;
  }
}

class Result {
  String? txnDate;
  String? mid;
  String? name;
  String? title;
  String? collectionId;
  String? invoiceId;
  String? txnId;
  String? status;
  String? customerName;
  String? currency;
  double? baseAmount;
  double? amount;
  double? amountRefunded;
  String? txnType;
  Null? fpxMode;
  String? fpxBuyerName;
  String? fpxBuyerBankId;
  String? fpxBuyerBankName;
  String? cardHolderName;
  String? cardNumber;
  String? cardExpiry;
  String? cardBrand;
  String? externalTxnId;
  String? response;
  String? authCode;
  String? authNumber;
  String? email;
  String? contactNumber;
  String? address;
  String? postcode;
  String? city;
  String? state;
  String? country;
  String? shippingName;
  String? shippingEmail;
  String? shippingContactNumber;
  String? shippingAddress;
  String? shippingPostcode;
  String? shippingCity;
  String? shippingState;
  String? shippingCountry;
  String? description;
  String? referenceNumber;
  String? mandateReferenceNumber;
  String? collectionNumber;
  String? collectionReferenceNumber;
  String? paymentIntent;
  String? splitAmount;
  String? splitRule;
  String? splitType;
  String? splitDescription;
  String? voidable;

  Result(
      {this.txnDate,
      this.mid,
      this.name,
      this.title,
      this.collectionId,
      this.invoiceId,
      this.txnId,
      this.status,
      this.customerName,
      this.currency,
      this.baseAmount,
      this.amount,
      this.amountRefunded,
      this.txnType,
      this.fpxMode,
      this.fpxBuyerName,
      this.fpxBuyerBankId,
      this.fpxBuyerBankName,
      this.cardHolderName,
      this.cardNumber,
      this.cardExpiry,
      this.cardBrand,
      this.externalTxnId,
      this.response,
      this.authCode,
      this.authNumber,
      this.email,
      this.contactNumber,
      this.address,
      this.postcode,
      this.city,
      this.state,
      this.country,
      this.shippingName,
      this.shippingEmail,
      this.shippingContactNumber,
      this.shippingAddress,
      this.shippingPostcode,
      this.shippingCity,
      this.shippingState,
      this.shippingCountry,
      this.description,
      this.referenceNumber,
      this.mandateReferenceNumber,
      this.collectionNumber,
      this.collectionReferenceNumber,
      this.paymentIntent,
      this.splitAmount,
      this.splitRule,
      this.splitType,
      this.splitDescription,
      this.voidable});

  Result.fromJson(Map<String, dynamic> json) {
    txnDate = json['txn_date'];
    mid = json['mid'];
    name = json['name'];
    title = json['title'];
    collectionId = json['collection_id'];
    invoiceId = json['invoice_id'];
    txnId = json['txn_id'];
    status = json['status'];
    customerName = json['customer_name'];
    currency = json['currency'];
    baseAmount = json['base_amount'];
    amount = json['amount'];
    amountRefunded = json['amount_refunded'];
    txnType = json['txn_type'];
    fpxMode = json['fpx_mode'];
    fpxBuyerName = json['fpx_buyer_name'];
    fpxBuyerBankId = json['fpx_buyer_bank_id'];
    fpxBuyerBankName = json['fpx_buyer_bank_name'];
    cardHolderName = json['card_holder_name'];
    cardNumber = json['card_number'];
    cardExpiry = json['card_expiry'];
    cardBrand = json['card_brand'];
    externalTxnId = json['external_txn_id'];
    response = json['response'];
    authCode = json['auth_code'];
    authNumber = json['auth_number'];
    email = json['email'];
    contactNumber = json['contact_number'];
    address = json['address'];
    postcode = json['postcode'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    shippingName = json['shipping_name'];
    shippingEmail = json['shipping_email'];
    shippingContactNumber = json['shipping_contact_number'];
    shippingAddress = json['shipping_address'];
    shippingPostcode = json['shipping_postcode'];
    shippingCity = json['shipping_city'];
    shippingState = json['shipping_state'];
    shippingCountry = json['shipping_country'];
    description = json['description'];
    referenceNumber = json['reference_number'];
    mandateReferenceNumber = json['mandate_reference_number'];
    collectionNumber = json['collection_number'];
    collectionReferenceNumber = json['collection_reference_number'];
    paymentIntent = json['payment_intent'];
    splitAmount = json['split_amount'];
    splitRule = json['split_rule'];
    splitType = json['split_type'];
    splitDescription = json['split_description'];
    voidable = json['voidable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['txn_date'] = this.txnDate;
    data['mid'] = this.mid;
    data['name'] = this.name;
    data['title'] = this.title;
    data['collection_id'] = this.collectionId;
    data['invoice_id'] = this.invoiceId;
    data['txn_id'] = this.txnId;
    data['status'] = this.status;
    data['customer_name'] = this.customerName;
    data['currency'] = this.currency;
    data['base_amount'] = this.baseAmount;
    data['amount'] = this.amount;
    data['amount_refunded'] = this.amountRefunded;
    data['txn_type'] = this.txnType;
    data['fpx_mode'] = this.fpxMode;
    data['fpx_buyer_name'] = this.fpxBuyerName;
    data['fpx_buyer_bank_id'] = this.fpxBuyerBankId;
    data['fpx_buyer_bank_name'] = this.fpxBuyerBankName;
    data['card_holder_name'] = this.cardHolderName;
    data['card_number'] = this.cardNumber;
    data['card_expiry'] = this.cardExpiry;
    data['card_brand'] = this.cardBrand;
    data['external_txn_id'] = this.externalTxnId;
    data['response'] = this.response;
    data['auth_code'] = this.authCode;
    data['auth_number'] = this.authNumber;
    data['email'] = this.email;
    data['contact_number'] = this.contactNumber;
    data['address'] = this.address;
    data['postcode'] = this.postcode;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['shipping_name'] = this.shippingName;
    data['shipping_email'] = this.shippingEmail;
    data['shipping_contact_number'] = this.shippingContactNumber;
    data['shipping_address'] = this.shippingAddress;
    data['shipping_postcode'] = this.shippingPostcode;
    data['shipping_city'] = this.shippingCity;
    data['shipping_state'] = this.shippingState;
    data['shipping_country'] = this.shippingCountry;
    data['description'] = this.description;
    data['reference_number'] = this.referenceNumber;
    data['mandate_reference_number'] = this.mandateReferenceNumber;
    data['collection_number'] = this.collectionNumber;
    data['collection_reference_number'] = this.collectionReferenceNumber;
    data['payment_intent'] = this.paymentIntent;
    data['split_amount'] = this.splitAmount;
    data['split_rule'] = this.splitRule;
    data['split_type'] = this.splitType;
    data['split_description'] = this.splitDescription;
    data['voidable'] = this.voidable;
    return data;
  }
}
