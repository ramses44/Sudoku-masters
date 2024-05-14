import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'user_info_page_widget.dart' show UserInfoPageWidget;
import 'package:flutter/material.dart';

class UserInfoPageModel extends FlutterFlowModel<UserInfoPageWidget> {
  ///  Local state fields for this page.

  bool sharing = false;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Backend Call - API (deleteContact)] action in IconButton widget.
  ApiCallResponse? deleteContactRes;
  // Stores action output result for [Backend Call - API (addContact)] action in IconButton widget.
  ApiCallResponse? addContactRes;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // Stores action output result for [Backend Call - API (shareContact)] action in Container widget.
  ApiCallResponse? shareContactRes;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
