import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'messenger_page_widget.dart' show MessengerPageWidget;
import 'package:flutter/material.dart';

class MessengerPageModel extends FlutterFlowModel<MessengerPageWidget> {
  ///  Local state fields for this page.

  bool creatingChat = false;

  bool searchingChat = false;

  bool searchingUser = false;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // State field(s) for chatTitle widget.
  FocusNode? chatTitleFocusNode;
  TextEditingController? chatTitleTextController;
  String? Function(BuildContext, String?)? chatTitleTextControllerValidator;
  // State field(s) for DropDown widget.
  List<int>? dropDownValue;
  FormFieldController<List<int>>? dropDownValueController;
  // State field(s) for isPrivate widget.
  bool? isPrivateValue;
  // Stores action output result for [Backend Call - API (createChat)] action in IconButton widget.
  ApiCallResponse? createChatRes;
  // State field(s) for queryChat widget.
  FocusNode? queryChatFocusNode;
  TextEditingController? queryChatTextController;
  String? Function(BuildContext, String?)? queryChatTextControllerValidator;
  // Stores action output result for [Backend Call - API (joinChat)] action in IconButton widget.
  ApiCallResponse? joinChatRes;
  // State field(s) for queryUser widget.
  FocusNode? queryUserFocusNode;
  TextEditingController? queryUserTextController;
  String? Function(BuildContext, String?)? queryUserTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    tabBarController?.dispose();
    chatTitleFocusNode?.dispose();
    chatTitleTextController?.dispose();

    queryChatFocusNode?.dispose();
    queryChatTextController?.dispose();

    queryUserFocusNode?.dispose();
    queryUserTextController?.dispose();
  }
}
