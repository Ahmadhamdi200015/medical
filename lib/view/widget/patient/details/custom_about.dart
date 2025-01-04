import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicall/controller/patient/details_controller.dart';
import 'package:medicall/view/widget/handlingdataview.dart';

class CustomAbout extends GetView<DetailsController> {
  const CustomAbout({super.key});

  @override
  Widget build(BuildContext context) {
    DetailsController controller = Get.put(DetailsController());
    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(
            text:
                'the doctor the greatest ${controller.doctorRole}\nSpecialist since 2005 at Bristol Hospital in south England. He has achieved several awards for his wonderful contribution his own field ..',
            style: const TextStyle(fontSize: 16),
          ),
          maxLines: 3,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final isOverflowing = textPainter.didExceedMaxLines;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GetBuilder<DetailsController>(
                builder: (controller) => Text(
                  maxLines: controller.isExpanded ? null : 3,
                  overflow: controller.isExpanded
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                  'the doctor the greatest ${controller.doctorRole}\nSpecialist since 2005 at Bristol Hospital in south England. He has achieved several awards for his wonderful contribution his own field',
                  style: const TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ),
              if (isOverflowing)
                GestureDetector(
                    onTap: () {
                      controller.toggleExpanded();
                    },
                    child: GetBuilder<DetailsController>(
                      builder: (controller) => Text(
                        controller.isExpanded ? "Less" : "More",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.lightBlue,
                        ),
                      ),
                    )),
              Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: const Text(
                    'Reservations',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )),
              GetBuilder<DetailsController>(
                builder: (controller) {
                  return HandlingDataView(
                      statusRequest: controller.statusRequest,
                      widget: ListView.separated(
                        shrinkWrap: true,
                        itemCount: controller.appointments.length,
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 5,
                        ),
                        itemBuilder: (context, index) {
                          return Card(
                              color: Colors.white,
                              child: ListTile(
                                title: const Text(
                                  'Medical examination',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                    '${controller.appointments[index]['appointmentTime']} pm- ${controller.appointments[index]['appointmentEnd']}pm'),
                              ));
                        },
                      ));
                },
              ),
              const Spacer(),
              MaterialButton(
                minWidth: MediaQuery.sizeOf(context).width / 1,
                padding: const EdgeInsets.symmetric(vertical: 15),
                color: Colors.lightBlueAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onPressed: () {
                  Get.bottomSheet(Container(
                    height: MediaQuery.sizeOf(context).height / 8,
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(color: Colors.grey, offset: Offset(-1, -1))
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade200,
                          child: IconButton(
                              onPressed: () {
                                controller.showTimePickerDialog(context);
                              },
                              icon: const Icon(Icons.access_time_outlined)),
                        ),
                        MaterialButton(
                          color: Colors.lightBlue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () {
                            controller.bookAppointment();
                            controller.update();
                            Get.back();
                          },
                          child: const Text(
                            'Book Appointment',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ));
                },
                child: const Text(
                  'Book an Appointment',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
