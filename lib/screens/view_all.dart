import 'package:desactvapp3/screens/preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/db_ops.dart';


class ViewAll extends StatelessWidget {
  final category;
  DBOPS dbops = DBOPS();
  ViewAll(this.category);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/backtrailer.jpeg"),
            fit: BoxFit.cover
          )
        ),
        child: Container(
          color: Colors.black87,
          child: FutureBuilder(
            future: dbops.fetchAllMovies(category),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.data == null){
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 2,
                            child: LinearProgressIndicator()
                        ),
                        SizedBox(height: 10,),
                        Text("Fetching...")
                      ],
                    )
                  );
                }else{
                  return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3
                  ),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                       return GestureDetector(
                         onTap: ()=>Get.to(()=>Preview(snapshot.data[index])),
                         child: Card(
                           elevation: 10,
                           child: Container(
                                  
                                 clipBehavior: Clip.hardEdge,
                                 width: MediaQuery.of(context).size.width,
                                 decoration: BoxDecoration(
                                   color: Colors.grey,
                                   borderRadius: BorderRadius.circular(10),
                                   image: DecorationImage(
                                     fit: BoxFit.cover,
                                     image: NetworkImage(
                                       snapshot.data[index].cover
                                     )
                                   )
                                 ),
                               )
                         ),
                       );
                    },
                  );
                }
          }),
        ),
      )

    );
  }
}
