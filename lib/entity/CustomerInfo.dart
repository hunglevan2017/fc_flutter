import 'dart:convert';
import 'dart:ffi';

import 'package:fc_collection/entity/CustomerInfoStatus.dart';
import 'package:fc_collection/entity/DetailContractEntity.dart';

class CustomerInfo{
  final String agreementID;
  final String amount;
  final String companyName;
  final String companyOfficeAddress;
  final String companyOfficePhone;
  final String currentAddress;
  final String currentCity;
  final String currentProvince;
  final String currentWard;
  final String customerDOB;
  final String customerIDNo;
  final String customerName;
  final String dpd;
  final String dueDay;
  final String emi;
  final String firstInstDay;
  final int id;
  final String insertDate;
  final String lastInstDay;
  final String lastUpdateBy;
  final String lastUpdateDate;
  final String netReceivable;
  final String paidAMT;
  final String permnentCity;
  final String permnentAddress;
  final String permnentProvince;
  final String permnentWard;
  final String principleOutStanding;
  final String product;
  final String reference1Customer;
  final String reference1Phone;
  final String reference2Customer;
  final String reference2Phone;
  final String saleCode;
  final String saleName;
  final String tenure;
  final List<CustomerInfoStatus> listFCHistoryActivity;
  final int uploadFlag;
  final String details;
  final String groupDashboardId;

  CustomerInfo({this.agreementID, this.amount, this.companyName, this.companyOfficeAddress, this.companyOfficePhone, this.currentAddress, this.currentCity, this.currentProvince, this.currentWard, this.customerDOB, this.customerIDNo, this.customerName, this.dpd, this.dueDay, this.emi, this.firstInstDay, this.id, this.insertDate, this.lastInstDay, this.lastUpdateBy,this.lastUpdateDate, this.netReceivable, this.paidAMT, this.permnentCity, this.permnentAddress, this.permnentProvince, this.permnentWard, this.principleOutStanding, this.product, this.reference1Customer, this.reference1Phone, this.reference2Customer, this.reference2Phone, this.saleCode, this.saleName, this.tenure, this.listFCHistoryActivity,this.uploadFlag,this.details,this.groupDashboardId});

  factory CustomerInfo.fromJson(Map<String,dynamic> json){
    return CustomerInfo(
        agreementID: json['agreement_id'] as String,
        amount: json['amount'] as String,
        companyName: json['company_name'] as String,
        companyOfficeAddress: json['company_office_address'] as String,
        companyOfficePhone: json['company_office_phone'] as String,
        currentAddress: json['current_address'] as String,
        currentCity: json['current_city'] as String,
        currentProvince: json['current_province'] as String,
        currentWard: json['current_ward'] as String,
        customerDOB: json['customer_dob'] as String,
        customerIDNo: json['customer_id_no'] as String,
        customerName: json['customer_name'] as String,
        dpd: json['dpd'] as String,
        dueDay: json['dueday'] as String,
        emi: json['emi'] as String,
        firstInstDay: json['first_inst_day'] as String,
        id: json['id'] as int,
        insertDate: json['insert_date'] as String,
        lastInstDay: json['last_inst_day'] as String,
        lastUpdateBy: json['last_update_by'] as String,
        lastUpdateDate: json['last_update_date'] as String,
        netReceivable: json['net_receivable'] as String,
        paidAMT: json['paid_amt'] as String,
        permnentCity: json['permnent_city'] as String,
        permnentAddress: json['permnent_address'] as String,
        permnentProvince: json['permnent_province'] as String,
        permnentWard: json['permnent_ward'] as String,
        principleOutStanding: json['principle_outstanding'] as String,
        product: json['product'] as String,
        reference1Customer: json['reference1_customer'] as String,
        reference1Phone: json['reference1_phone'] as String,
        reference2Customer: json['reference2_customer'] as String,
        reference2Phone: json['reference2_phone'] as String,
        saleCode: json['sale_code'] as String,
        saleName: json['sale_name'] as String,
        tenure: json['tenure'] as String,
        listFCHistoryActivity: json['history_activitys'],
        uploadFlag: json['upload_flag'] as int,
        details: json['details'],
        groupDashboardId: json['group_dashboard_id']
    );
  }

}