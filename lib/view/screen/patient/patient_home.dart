import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicall/controller/patient/patient_controller.dart';
import 'package:medicall/view/widget/handlingdataview.dart';

class PatientHome extends StatelessWidget {
  const PatientHome({super.key});

  @override
  Widget build(BuildContext context) {
    PatientController controller = Get.put(PatientController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Container(
            height: MediaQuery.sizeOf(context).height / 2,
            margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [

                Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                    child: const Text(
                      textAlign: TextAlign.start,
                      'How Are you feeling \ntoday ?',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    )),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25))),
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
                  height: MediaQuery.sizeOf(context).height / 5.5,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                      color: Colors.lightBlue.shade400,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: const ListTile(
                              leading: Icon(Icons.person),
                              title: Text(
                                'Dr:Howard web',
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                ' Surgery',
                                style: TextStyle(color: Colors.white),
                              ),
                              trailing: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(Icons.phone_enabled_outlined),
                              ))),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(10)),
                        margin: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 20),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              '8:00 - 2:00 Pm',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text("tel : 0598330425",
                                style: TextStyle(color: Colors.white))
                          ],
                        ),
                      ),
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
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                height: MediaQuery.sizeOf(context).height / 20,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 10,
                  ),
                  itemCount: controller.specialties.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){
                        controller.getDoctorsBySpecialty(controller.specialties[index]['id']);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20)),
                        child:  Text(controller.specialties[index]['name']),
                      ),
                    );
                  },
                ),
              ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: GetBuilder<PatientController>(
              builder: (controller) {
                return HandlingDataView(statusRequest: controller.statusRequest, widget: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.doctors.length,
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
                  itemBuilder: (context, index) {
                    final doctor = controller.doctors[index];
                    return InkWell(
                      onTap: (){
                        controller.goToDetailsPage(doctor['doctorId'],doctor['doctorName'],doctor['doctorSpecialty']);
                      },
                      child: ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(doctor['doctorName'] ?? 'Unknown Name'),
                        // اسم المستخدم
                        subtitle: Text('Role: ${doctor['doctorSpecialty']}'),
                        // دور المستخدم
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.lightBlueAccent,
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Text(
                                'BookAppoinment',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),

                          ],
                        ), // البريد الإلكتروني
                      ),
                    );
                  },
                ));
              },
            ),
          )
        ]),
      ),
    );
  }
}
