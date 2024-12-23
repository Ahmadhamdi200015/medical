import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicall/view/widget/handlingdataview.dart';
import 'package:medicall/view/widget/patient/details/custom_about.dart';
import 'package:medicall/view/widget/patient/details/custom_review.dart';

import '../../../controller/patient/details_controller.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    DetailsController controller = Get.put(DetailsController());
    bool isExpanded = false;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: ListTile(
                title: Text(
                  'Dr: ${controller.doctorName}',
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                subtitle: const Text(
                  'Shefa Hospital',
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                trailing: Text(
                  controller.doctorRole!,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
                leading: const Icon(
                  Icons.person,
                  size: 25,
                ),
              ),
            ),
            TabBar(
              labelColor: Colors.lightBlueAccent,
              unselectedLabelColor: Colors.grey,
              controller: controller.tabController,
              tabs: const [
                Tab(
                  text: 'About',
                ),
                Tab(
                  text: 'Review',
                ),
                Tab(
                  text: 'Pending',
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  const CustomAbout(),
                  const CustomReview(),
                  GetBuilder<DetailsController>(
                    builder: (controller) {
                      return HandlingDataView(
                          statusRequest: controller.statusRequest,
                          widget: ListView.separated(
                            shrinkWrap: true,
                            itemCount: controller.appointmentsPending.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 5,
                            ),
                            itemBuilder: (context, index) {
                              return Card(
                                color: Colors.white,
                                child: ListTile(
                                  trailing: MaterialButton(
                                    color: Colors.lightBlueAccent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    onPressed: () {
                                      controller.deleteAppointmentById(
                                          controller.appointmentsPending[index]
                                              ['appointmentId']);
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  leading: const Icon(Icons.person),
                                  title: Text(
                                      controller.appointmentsPending[index]
                                          ['doctorName']),
                                  subtitle: Text(controller
                                      .appointmentsPending[index]['specialty']),
                                ),
                              );
                            },
                          ));
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
