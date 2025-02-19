import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttd/models/rest/responses/hallway/Hallway.dart';
import 'HallwayPageViewModel.dart';

class HallwayPage extends StatelessWidget {
  final HallwayPageViewModel viewModel = Get.put(HallwayPageViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Koridorlar'),
        ),
        body: FutureBuilder<List<Hallway>>(
            future: viewModel.getHallwaysByUserId(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No hallways available'));
              } else {
                List<Hallway> hallwayList = snapshot.data!;
                return ListView.builder(
                  itemCount: hallwayList.length,
                  itemBuilder: (context, index) {
                    String hallwayName =
                        hallwayList[index].hallwayName ?? "Unknown";
                    return ListTile(
                      title: Text(hallwayName),
                      onTap: () {
                        // Koridor detayına gitmek için gereken işlemler burada yapılabilir
                      },
                    );
                  },
                );
              }
            },
            ),
        );
    }
}