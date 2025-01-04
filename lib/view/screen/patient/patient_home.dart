import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicall/controller/patient/patient_controller.dart';
import 'package:medicall/view/widget/handlingdataview.dart';
import 'package:medicall/view/widget/patient/home/custom_drawer_patient.dart';
import 'package:medicall/view/widget/shared/ctegory_text.dart';

import '../../widget/doctors/custom_drawer.dart';

class PatientHome extends StatelessWidget {
  const PatientHome({super.key});

  @override
  Widget build(BuildContext context) {
    PatientController controller = Get.put(PatientController());
    return Scaffold(
      appBar: AppBar(title: const Text('HomePage'),centerTitle: true,),
      drawer: const CustomDrawerPatient(),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: MediaQuery.sizeOf(context).height / 2.5,
            margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: const Text(
                      textAlign: TextAlign.start,
                      'How Are you feeling \ntoday ?',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    )),
                GetBuilder<PatientController>(
                  builder: (controller) => Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      onChanged: (val) {
                        controller.checkSearch(val);
                      },
                      controller: controller.doctorSearch,
                      decoration: InputDecoration(
                          prefixIcon: IconButton(
                              onPressed: () {
                                controller.onSearchItems();
                              },
                              icon: const Icon(Icons.search_rounded)),
                          hintText: 'Search',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25))),
                    ),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Status',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'See All',
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  height: MediaQuery.sizeOf(context).height / 8,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                      color: Colors.lightBlue.shade400,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child:  ListTile(
                              leading: const Icon(Icons.report_gmailerrorred,color: Colors.white,),
                              title: const Text(
                                'Daily Advice',
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: GetBuilder<PatientController>(builder:(controller) => Text(
                                ' ${controller.tipText}',
                                style: const TextStyle(color: Colors.white,fontSize: 20),
                              ),)
                           )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Find Your Doctor ',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                Text(
                  'See All',
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
          GetBuilder<PatientController>(
            builder: (controller) {
              return Container(
                margin:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                height: MediaQuery.sizeOf(context).height / 22,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 10,
                  ),
                  itemCount: controller.specialties.length,
                  itemBuilder: (context, index) {
                    return  CategoryText(txtCategory:controller.specialties[index]['name'] , i: index);

                  },
                ),
              );
            },
          ),
         GetBuilder<PatientController>(builder: (controller) => HandlingDataView(statusRequest: controller.statusRequest, widget:  Column(
           children: [
             controller.isSearch == false
                 ? GetBuilder<PatientController>(builder:(controller) => HandlingDataView(statusRequest: controller.statusRequest, widget: Container(
                 margin: const EdgeInsets.symmetric(horizontal: 20),
                 child: ListView.separated(
                   shrinkWrap: true,
                   physics: const NeverScrollableScrollPhysics(),
                   itemCount: controller.doctors.length,
                   separatorBuilder: (context, index) => const SizedBox(
                     height: 5,
                   ),
                   itemBuilder: (context, index) {
                     final doctor = controller.doctors[index];
                     return InkWell(
                       onTap: () {
                         controller.goToDetailsPage(
                             doctor['doctorId'],
                             doctor['doctorName'],
                             doctor['doctorSpecialty']);
                       },
                       child: ListTile(
                         leading: const Icon(Icons.person),
                         title:Text(
                             doctor['doctorName'] ?? 'Unknown Name'),
                         // اسم المستخدم
                         subtitle:
                         Text('Role: ${doctor['doctorSpecialty']}'),
                         // دور المستخدم
                         trailing: Row(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                             MaterialButton(
                               shape: RoundedRectangleBorder(
                                   borderRadius:
                                   BorderRadius.circular(10)),
                               color: Colors.lightBlueAccent,
                               onPressed: () async {
                                 print('${doctor['doctorId']}-${doctor['doctorEmail']}-${doctor['doctorName']}');
                                 await controller.requestFriends(
                                   doctor['doctorId'],
                                   doctor['doctorEmail'],
                                   doctor['doctorName'],);
                               },
                               child: const Text(
                                 'Medical examination',
                                 style: TextStyle(color: Colors.white),
                               ),
                             )
                           ],
                         ), // البريد الإلكتروني
                       ),
                     );
                   },
                 ))), )
                 :GetBuilder<PatientController>(builder:(controller) => HandlingDataView(statusRequest: controller.statusRequest, widget: Container(
                 margin: const EdgeInsets.symmetric(horizontal: 20),
                 child: ListView.separated(
                   shrinkWrap: true,
                   physics: const NeverScrollableScrollPhysics(),
                   itemCount: controller.doctorsNames.length,
                   separatorBuilder: (context, index) => const SizedBox(
                     height: 5,
                   ),
                   itemBuilder: (context, index) {
                     final doctorSearch = controller.doctorsNames[index];
                     return InkWell(
                       onTap: ()async {
                       await  controller.goToDetailsPage(
                             doctorSearch['doctorId'],
                             doctorSearch['doctorName'],
                             doctorSearch['doctorSpecialty']);
                       },
                       child: ListTile(
                         leading: const Icon(Icons.person),
                         title: Text(
                             doctorSearch['doctorName'] ?? 'Unknown Name'),
                         // اسم المستخدم
                         subtitle:
                         Text('Role: ${doctorSearch['doctorSpecialty']}'),
                         // دور المستخدم
                         trailing: Row(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                             MaterialButton(
                               shape: RoundedRectangleBorder(
                                   borderRadius:
                                   BorderRadius.circular(10)),
                               color: Colors.lightBlueAccent,
                               onPressed: () async {
                                 await controller.requestFriends(
                                   doctorSearch['doctorId'],
                                   doctorSearch['doctorEmail'],
                                   doctorSearch['doctorName'],);
                               },
                               child: const Text(
                                 'Medical examination',
                                 style: TextStyle(color: Colors.white),
                               ),
                             )
                           ],
                         ), // البريد الإلكتروني
                       ),
                     );
                   },
                 ))), )
           ],
         )),)

        ]),
      ),
    );
  }
}
