import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Components {
  SliverAppBar sliverAppBar(List imgList, String title) {
    return SliverAppBar(
      expandedHeight: 400,
      flexibleSpace: FlexibleSpaceBar(
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          background: CarouselSlider(
            options: CarouselOptions(
              height: 400,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.3,
              scrollDirection: Axis.horizontal,
            ),
            items: imgList.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 18),
                    child: Image.asset(
                      "$i",
                    ),
                  );
                },
              );
            }).toList(),
          )),
      backgroundColor: Color(0xFFB60000),
      floating: true,
      snap: true,
      pinned: true,
    );
  }
}
