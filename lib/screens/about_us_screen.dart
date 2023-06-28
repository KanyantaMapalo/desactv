import 'package:flutter/material.dart';


class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About us")
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("DESAC APP",style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.deepOrange
              ),),
              Text("AFRICA’S PREMIER VIDEO STREAMING APP",style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.deepOrange
              ),),
              Text("DESAC App is a video Streaming TV and an African Online Movie Streaming platform. It features contents of African creators only, showcasing the best of African talent and boosting the outreach of the African Film Industry including TV and Radio stations. While the African entertainment industry is no slouch, best which is why platforms like DESAC Streaming TV are necessary to steer us towards that fulfilment. As technology grows and more people come online, we want the variety of movies and shows they love to be at their fingertips, without the drawbacks of queuing or searching for them. With online movie streaming sites still a rarity, we are determined to see this through and see ourselves setting the premium standard for others to follow. WHAT IS ONLINE STREAMING? A DESCRIPTION OF THE FAST GROWING INDUSTR Streaming is a technology used to deliver content to computers and mobile devices over the Internet. Streaming transmits data--- usually audio and video, but increasingly other kinds as well--- as a continuous flow, which allows the recipient to begin to watch or listen almost immediately. Streaming allows you to start using the content before the entire file is downloaded. Take music: when you stream a song from Apple Music or Spotify, you can click play and start listening almost immediately. You don’t have to wait for the song to download before the music starts. This is one of the major advantages of streaming.it delivers data to you as you need it. WHY CHOOSE US? A LOOK AT WHAT SETS DESAC APP APART. Despite being widely popular oversees, streaming services are still an upcoming industry in Africa, meaning there is only one handful of websites and android apps offering the services-- and even fewer tailored to African content. This is what sets DESAC APP apart from the lot of them. We believe in the potential of African Cinema and have resolved to investing time and resources into making sure it reaches as many people as possible. Unlike the rest of the competition, our ambition is to inspire, discover and promote African Film creators with a platform dedicated to showcase their hard work to the rest of the world. Piracy and cost of production have been major hindrances, and we are the answer. HOW DO I BEGIN STREAMING? REQUIREMENTS TO GET YOU STARTED. 1. First, you need to get a hold of an Internet enabled device with video streaming capabilities. These include but aren’t limited to smart phones, tablets, PCs, desktops and Laptops. 2. Second, you need a stable internet connection and a good data plan. If mobile data proves expensive, try using public Wi-Fi hotspots. As long as it’s not below 1Mbps, it will do. 3. Using a good web browser such as Chrome, Mozilla Firefox or Opermini, visit our official site here to begin streaming African Movies click get started register an account then select a paid plan then you are good to watch your favourite movies and documentateries. WHAT YOU SHOULD EXPECT OUR PROMISE TO YOU. With a capable administration, a skilled technical team and a great number of content providers signing on each and every day, you can be rest assured that DESAC APP will be your home of variety and quality when it comes to streaming African cinema. We guarantee you a large free browsing experience and a great collection of carefully selected material that you can watch alone or with family, all presented using the best and latest streaming technologies to ensure you have no viewing complaints We want you to be happy and as such we pride ourselves in giving a film watching experience deserving of your love for African cinema. Count on it!"),
            ],
          ),
        ),
      )

    );
  }
}
