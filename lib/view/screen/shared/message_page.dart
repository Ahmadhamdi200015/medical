import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicall/core/stripe_payment/payment_manger.dart';
import 'package:medicall/view/widget/handlingdataview.dart';

import '../../../controller/shared/message_page_controller.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    MessagePageController controller = Get.put(MessagePageController());
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: AppBar(
          title: const Text("MessagePage"),
          centerTitle: true,
        ),
        body: GetBuilder<MessagePageController>(
            builder: (controller) => HandlingDataView(
                statusRequest: controller.statusRequest,
                widget: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListView.builder(
                      itemCount: controller.friends.length,
                      itemBuilder: (context, index) {
                        var friends = controller.friends[index];
                        return GestureDetector(
                          onLongPress: () {},
                          onTap: () {
                            friends['receiverID'] ==
                                    controller.userId
                                ? controller.goToChat(
                                    friends['senderID'],
                                    friends['senderName'],
                                    friends['doctorStatus'])
                                : controller.goToChat(
                                    friends['receiverID'],
                                    friends['receiverName'],
                                    friends['doctorStatus']);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            margin: const EdgeInsets.only(bottom: 5),
                            color: Colors.grey.shade300,
                            child: ListTile(
                                leading: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    child: Icon(Icons.person,
                                        size: 25,
                                        color: colorScheme.secondary)),
                                title: Text(friends['receiverID'] ==
                                        controller.userId
                                    ? friends['senderName']
                                    : friends['receiverName']),
                                trailing: friends['receiverID'] ==
                                        controller.userId
                                    ? Switch(
                                        value: friends['doctorStatus'],
                                        onChanged: (val) {
                                          controller.changeStatus(val);
                                          if (val == true) {
                                            controller.openMessage(friends.id);
                                          } else {
                                            controller.closeMessage(friends.id);
                                          }
                                        })
                                    : friends['doctorStatus']
                                        ? null
                                        : MaterialButton(
                                            color: Colors.lightBlueAccent,
                                            onPressed: () async{
                                            await  controller.payForService(friends.id);
                                            },
                                            child: const Text(
                                              'pay for talk',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )),
                          ),
                        );
                      }),
                ))));
  }
}
