import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:know/components/commonWidgets/app_bar.dart';
import 'package:permission_handler/permission_handler.dart';

class BillsMessage extends StatefulWidget {
  const BillsMessage({Key? key}) : super(key: key);

  @override
  State<BillsMessage> createState() => _BillsMessageState();
}

class _BillsMessageState extends State<BillsMessage> {
  final SmsQuery _query = SmsQuery();
  // List<SmsMessage> _messages = [];
  List<String?> _messages = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SMS Inbox App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(title: 'Bills Messages'),
        ),
        backgroundColor: Colors.white,
        body: Container(
          padding: const EdgeInsets.all(10.0),
          child: _messages.isNotEmpty
              ? _MessagesListView(
                  messages: _messages,
                )
              : Center(
                  child: Text(
                    'No messages to show.\n Tap refresh button...',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var permission = await Permission.sms.status;
            if (permission.isGranted) {
              final messages = await _query.querySms(
                kinds: [
                  SmsQueryKind.inbox,
                  SmsQueryKind.sent,
                ],
                // address: '+254712345789',
                count: 10,
              );
              // Message Flitering Code (credited)
              List<String?> messStrings = [];
              messages.forEach((SmsMessage message) {
                String? body =
                    message.body; // Assuming message.body might be nullable
                List<String> words = body?.split(' ') ?? [];
                for (int i = 0; i < words.length; i++) {
                  words[i] = words[i].toLowerCase();
                }
                debugPrint(words.toString());
                if (words.contains('credited')) {
                  debugPrint('hellooo');
                  messStrings.add(message.body);
                  return;
                }
              });
              debugPrint('sms inbox messages: ${messages.length}');

              // setState(() => _messages = messages);
              setState(() => _messages = messStrings);
            } else {
              await Permission.sms.request();
            }
          },
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}

class _MessagesListView extends StatelessWidget {
  const _MessagesListView({
    Key? key,
    required this.messages,
  }) : super(key: key);

  // final List<SmsMessage> messages;
  final List<String?> messages;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int i) {
        var message = messages[i];

        return ListTile(
          subtitle: Text('$message'),
        );
      },
    );
  }
}
