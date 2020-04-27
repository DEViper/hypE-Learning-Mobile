import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/courses.dart';

class CourseDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);
  static const routeName = '/course-detail';


  @override
  Widget build(BuildContext context) {
    final courseId =
        ModalRoute.of(context).settings.arguments as int; // is the id!
    final loadedCourse = Provider.of<Courses>(
      context,
      listen: false,
    ).findById(courseId);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedCourse.title),
              background: Hero(
                tag: loadedCourse.id,
                child: Image.network(
                  'https://hypelearning.s3.eu-central-1.amazonaws.com/god_its_me.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10),
                Text(
                  '${loadedCourse.description}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    loadedCourse.announcement,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                SizedBox(height: 800,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
