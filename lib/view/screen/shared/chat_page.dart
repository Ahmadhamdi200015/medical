import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controller/shared/chat_controller.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isCurrentUser;
    ChatController controller = Get.put(ChatController());

    return Scaffold(
        appBar: AppBar(
            title: Text(
              controller.receiverName.toString(),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            centerTitle: true,
            backgroundColor: Colors.grey.shade300),
        body: GetBuilder<ChatController>(
          builder: (controller) {
            return Column(
              children: [
                Expanded(child: GetBuilder<ChatController>(
                  builder: (controller) {
                    return controller.isLoading == true
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : GestureDetector(
                            onTap: () {
                              controller.resetPressed();
                            },
                            child: ListView.builder(
                              controller: controller.scrollController,
                              itemCount: controller.messages!.length,
                              itemBuilder: (context, index) {
                                isCurrentUser = controller.messages[index]
                                        ['senderId'] ==
                                    controller.getCurrentUserId();

                                var message = controller.messages[index];
                                bool isMessagePressed =
                                    controller.pressedMessageIndex == index;

                                return ListTile(
                                  title: GestureDetector(
                                    onLongPress: () {
                                      controller.setPressedMessage(
                                          index, message.id, context);
                                    },
                                    child: Align(
                                      alignment: isCurrentUser
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: IntrinsicWidth(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8, // تحديد العرض الأقصى للرسالة
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: isMessagePressed
                                                  ? [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                        blurRadius: 20,
                                                        offset:
                                                            const Offset(4, 4),
                                                      ),
                                                    ]
                                                  : [],
                                              color: isCurrentUser
                                                  ? Colors.green
                                                  : Colors.grey),
                                          child: message['file'].toString().isEmpty
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      message['message'],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomLeft,
                                                          // محاذاة الوقت لأسفل اليمين
                                                          child: Text(
                                                            message['edited'] ==
                                                                    true
                                                                ? "Edited"
                                                                : '',
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          // محاذاة الوقت لأسفل اليمين
                                                          child: Text(
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 10),
                                                              DateFormat(
                                                                      'HH:mm')
                                                                  .format(message[
                                                                          'timestamp']
                                                                      .toDate())),
                                                        ),
                                                        if (message['senderId'] ==
                                                                controller
                                                                    .getCurrentUserId() &&
                                                            message['isRead'] ==
                                                                true)
                                                          const Icon(
                                                              Icons
                                                                  .done_all_outlined,
                                                              color: Colors
                                                                  .lightBlueAccent,
                                                              size: 16),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              : Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Image.file(
                                                  width: 200,
                                                  height: 150,
                                                  File(message['file'])),
                                              Text(
                                                message['message'],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Align(
                                                    alignment: Alignment
                                                        .bottomLeft,
                                                    // محاذاة الوقت لأسفل اليمين
                                                    child: Text(
                                                      message['edited'] ==
                                                          true
                                                          ? "Edited"
                                                          : '',
                                                      style: const TextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontSize: 10),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Align(
                                                    alignment: Alignment
                                                        .bottomRight,
                                                    // محاذاة الوقت لأسفل اليمين
                                                    child: Text(
                                                        style: const TextStyle(
                                                            color: Colors
                                                                .white,
                                                            fontSize: 10),
                                                        DateFormat(
                                                            'HH:mm')
                                                            .format(message[
                                                        'timestamp']
                                                            .toDate())),
                                                  ),
                                                  if (message['senderId'] ==
                                                      controller
                                                          .getCurrentUserId() &&
                                                      message['isRead'] ==
                                                          true)
                                                    const Icon(
                                                        Icons
                                                            .done_all_outlined,
                                                        color: Colors
                                                            .lightBlueAccent,
                                                        size: 16),
                                                ],
                                              ),
                                            ],
                                          )

                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                  },
                )),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          enabled: controller.isStatus,
                          controller: controller.messageController,
                          decoration: const InputDecoration(
                            hintText: 'Type a message',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed:controller.isStatus==true? () {
                            controller.optionImageSelected();
                          }:null,
                          icon: const Icon(Icons.link)),
                      if (controller.file != null)
                        Image.file(width: 50, height: 50, controller.file!),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          if (controller.file==null) {
                            if (controller.messageController!.text.isNotEmpty) {
                              controller.sendMessage(controller.receiverID,
                                  controller.messageController!.text,'');
                              controller.messageController!.clear();
                            }
                          } else {
                            controller.sendMessage(controller.receiverID,
                                controller.messageController?.text,controller.file!.toString());
                            controller.messageController?.clear();
                            controller.file=null;
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ));
  }
}
