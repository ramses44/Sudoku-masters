import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/components/chat_shimmer_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/instant_timer.dart';
import 'chat_page_widget.dart' show ChatPageWidget;
import 'package:flutter/material.dart';

class ChatPageModel extends FlutterFlowModel<ChatPageWidget> {
  ///  Local state fields for this page.

  MessageListStruct? messageList;
  void updateMessageListStruct(Function(MessageListStruct) updateFn) =>
      updateFn(messageList ??= MessageListStruct());

  bool seeingParticipants = false;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Backend Call - API (storeMessages)] action in ChatPage widget.
  ApiCallResponse? initMessagesResponse;
  InstantTimer? instantTimer;
  // Stores action output result for [Backend Call - API (storeMessages)] action in ListView widget.
  ApiCallResponse? storeMessagesResp;
  // Stores action output result for [Backend Call - API (gameFromSudoku)] action in Button widget.
  ApiCallResponse? createGameRes;
  // Stores action output result for [Backend Call - API (gameFromSudoku)] action in Button widget.
  ApiCallResponse? createGameRes1;
  // Model for chatShimmer component.
  late ChatShimmerModel chatShimmerModel;
  // State field(s) for messageText widget.
  FocusNode? messageTextFocusNode;
  TextEditingController? messageTextTextController;
  String? Function(BuildContext, String?)? messageTextTextControllerValidator;
  // Stores action output result for [Backend Call - API (sendMessage)] action in IconButton widget.
  ApiCallResponse? sendMessageRes;
  // State field(s) for DropDown widget.
  int? dropDownValue;
  FormFieldController<int>? dropDownValueController;
  // Stores action output result for [Backend Call - API (addToChat)] action in DropDown widget.
  ApiCallResponse? addToChatRes;

  @override
  void initState(BuildContext context) {
    chatShimmerModel = createModel(context, () => ChatShimmerModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    instantTimer?.cancel();
    chatShimmerModel.dispose();
    messageTextFocusNode?.dispose();
    messageTextTextController?.dispose();
  }
}
