import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicall/view/widget/handlingdataview.dart';

import '../../../controller/doctor/friend_request_controller.dart';

class RequestFriendsPage extends StatelessWidget {
  const RequestFriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    FriendRequestController controller = Get.put(FriendRequestController());
    return Scaffold(
        appBar: AppBar(
          title: const Text("Request Friends"),
          centerTitle: true,
        ),
        body: GetBuilder<FriendRequestController>(
          builder: (controller) {
            if (controller.friendRequests.isEmpty) {
              return const Center(
                child: Text(
                  'NoRequestFound',
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
              );
            }
            return HandlingDataView(
                statusRequest: controller.statusRequest,
                widget: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: ListView.builder(
                      itemCount: controller.friendRequests.length,
                      itemBuilder: (context, index) {
                        return controller.friendRequests[index]['senderID'] !=
                                    controller.userId.toString() &&
                                controller.friendRequests[index]
                                        ['receiverID'] ==
                                    controller.userId.toString()
                            ? Card(
                                child: ListTile(
                                  title: Text(controller.friendRequests[index]
                                      ['senderName']),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.check,
                                            color: Colors.green),
                                        onPressed: () =>
                                            controller.acceptRequest(controller
                                                .friendRequests[index].id),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close,
                                            color: Colors.red),
                                        onPressed: () =>
                                            controller.rejectRequest(controller
                                                .friendRequests[index].id),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container();
                      }),
                ));
          },
        ));
  }
}
