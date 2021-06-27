import 'package:flutter/material.dart';

const COLOR_PRIMARY = Colors.lightBlue;
const COLOR_SECOND = Colors.deepOrange;
const COLOR_GRAY = Color.fromRGBO(245, 245, 245, 1.0);
const COLOR_OVERLAY = Color.fromRGBO(0, 0, 0, 0.42);
const COLOR_SUBTILE = Colors.grey;

const TITLE_HEADER = 14.0;
const heightAppBar = 56.0;

const TOKEN_KEY = 'tokenKey';
const SECURITY_KEY = 'securityKey';
const USER_NAME_KEY = 'userName';
const PASSWORD_KEY = 'password';
const FULLNAME_KEY = 'fullname';

enum APPBAR{
  LIST_DASHBOARD,
  DASHBOARD
}

//sqlite

const DB_NAME = 'fc_collect.db';
const TABLE_DATA = 'tb_data';
const TABLE_DATA_ID = 'id';
const TABLE_DATA_KEY = 'key';
const TABLE_DATA_DATA = 'data';
const TABLE_DATA_USERNAME = 'username';

const DATA_TABLE_LISTDASHBOARD = 'document_dasboard';
const DATA_TABLE_DASHBOARD = 'dashboard';
const DATA_ACTION_CODE = 'data_action_code';
const DATA_RESULT_CODE = 'data_result_code';
const DATA_REASON_DELINQUINCY = 'data_reason_deliquincy';
const DATA_LIST_DOCUMENT = 'data_list_document';