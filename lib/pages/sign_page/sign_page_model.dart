import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'sign_page_widget.dart' show SignPageWidget;
import 'package:flutter/material.dart';

class SignPageModel extends FlutterFlowModel<SignPageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // State field(s) for username widget.
  FocusNode? usernameFocusNode;
  TextEditingController? usernameTextController;
  String? Function(BuildContext, String?)? usernameTextControllerValidator;
  // State field(s) for password widget.
  FocusNode? passwordFocusNode;
  TextEditingController? passwordTextController;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? passwordTextControllerValidator;
  // Stores action output result for [Backend Call - API (signIn)] action in Button widget.
  ApiCallResponse? signinResult;
  // State field(s) for usernameNew widget.
  FocusNode? usernameNewFocusNode;
  TextEditingController? usernameNewTextController;
  String? Function(BuildContext, String?)? usernameNewTextControllerValidator;
  // State field(s) for aliasNew widget.
  FocusNode? aliasNewFocusNode;
  TextEditingController? aliasNewTextController;
  String? Function(BuildContext, String?)? aliasNewTextControllerValidator;
  // State field(s) for passwordNew widget.
  FocusNode? passwordNewFocusNode;
  TextEditingController? passwordNewTextController;
  late bool passwordNewVisibility;
  String? Function(BuildContext, String?)? passwordNewTextControllerValidator;
  // Stores action output result for [Backend Call - API (signUp)] action in Button widget.
  ApiCallResponse? signupResult;

  @override
  void initState(BuildContext context) {
    passwordVisibility = false;
    passwordNewVisibility = false;
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    tabBarController?.dispose();
    usernameFocusNode?.dispose();
    usernameTextController?.dispose();

    passwordFocusNode?.dispose();
    passwordTextController?.dispose();

    usernameNewFocusNode?.dispose();
    usernameNewTextController?.dispose();

    aliasNewFocusNode?.dispose();
    aliasNewTextController?.dispose();

    passwordNewFocusNode?.dispose();
    passwordNewTextController?.dispose();
  }
}
