import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_task/application_layer/App_colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../application_layer/app_functions.dart';
import '../../application_layer/my_icons.dart';
import '../profile/profile_screen.dart';

class YoutubeVideosScreen extends StatelessWidget {
  YoutubeVideosScreen({super.key});

  final List<VideoItem> videos = [
    VideoItem(
      name: 'lecture 2',
      description: 'Indefinite integrals ( Integration of fractional functions ) - تكامل الدوال الكسريه',
      videoUrl: 'https://www.youtube.com/watch?v=eGDZTdlf_Xk&list=PLR2RsKKRngz44PFKJwNTQt_HEkOlG6bW-&index=2&ab_channel=KimCamAcademy',
      thumbnail: 'https://i3.ytimg.com/vi/eGDZTdlf_Xk/hqdefault.jpg',
    ),
    VideoItem(
      name: 'Working of Transistors',
      description: 'Analog Electronics: Working of Transistors',
      videoUrl: 'https://www.youtube.com/watch?v=yOmPCjPlaEg&list=PLG99TJz7QrIWjqJwfaKYb_T8Qqqls-KiN&index=3',
      thumbnail: 'https://i3.ytimg.com/vi/yOmPCjPlaEg/maxresdefault.jpg',
    ),
    VideoItem(
      name: 'Computer Organization |MIPS Instruction Set Architecture (ISA)',
      description: 'يتناول الفيديو الثاني من سلسلة شروحات مادة تنظيم حاسوب الحديث عن instruction set architecture (ISA)'
          'الذي يمثل الواجهة التي تربط بين عالم البرمجيات وعالم المعدات , وانتقلنا للحديث عن مفهوم اMIPS الذي يعتبر ك وحدة سرعة لتعبر عن عدد التعليمات المنفذة خلال وحدة الزمن .',
      videoUrl: 'https://www.youtube.com/watch?v=wWmB_BDoItY&ab_channel=ElCoMHU',
      thumbnail: 'https://i3.ytimg.com/vi/wWmB_BDoItY/maxresdefault.jpg',
    ),
    VideoItem(
      name: 'Introduction to Convolution Operation',
      description: 'Signal and System: Introduction to Convolution Operation'
      'Topics Discussed:'
    '1. Use of convolution.'
    '2. Definition of convolution'
    '3. The formula of convolution'
    '4. Five steps to perform the convolution operation.'
    '5. Example of the convolution operation.'
    '6. Animation of the convolution operation.',
      videoUrl: 'https://www.youtube.com/watch?v=_HATc2zAhcY&pp=ygUfY29udm9sdXRpb24gc2lnbmFscyBhbmQgc3lzdGVtcw%3D%3D',
      thumbnail: 'https://i3.ytimg.com/vi/_HATc2zAhcY/maxresdefault.jpg',
    ),
    VideoItem(
      name: 'MATLAB Lesson 1/18',
      description: 'simple math operations variables who clc clear help rounding شرح ماتلاب عربى',
      videoUrl: 'https://www.youtube.com/watch?v=_di_oaAdEZM&list=PLhx4zaYkEjI_UDzrbLqeaqPisFz1OPnoQ&ab_channel=HashimEduTech',
      thumbnail: 'https://i3.ytimg.com/vi/_di_oaAdEZM/maxresdefault.jpg',
    ),
    VideoItem(
      name: 'ATMEL 8051 Tutorial 2: Nested Loops in Assembly programming Language',
      description: 'شرح وافى بطرقة مبسطة لتمرين على الحلقات التكرارية Loops باستخدام لغة التجميع Assembly',
      videoUrl: 'https://www.youtube.com/watch?v=ORhCVUlBytU&list=PLGoRyE_fvpFPf2cYKcKps1nwbbs3vhHjw&index=3',
      thumbnail: 'https://i3.ytimg.com/vi/ORhCVUlBytU/maxresdefault.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                appBarTitle(context, 'Youtube Videos'),
                const Spacer(),
                appBarProfileButton(context),
              ],
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: GridView.builder(
                itemCount: videos.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1/1.2.h
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _launchURL(videos[index].videoUrl);
                    },
                    child: VideoItemWidget(videoItem: videos[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget appBarTitle(context, title) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .displayMedium!
          .copyWith(color: AppColors.thirdColor, fontWeight: FontWeight.w600),
    );
  }

  Widget appBarProfileButton(context) {
    return IconButton(
        onPressed: () {
          AppFunctions.navigateTo(context, UserProfileScreen());
        },
        icon: const Icon(
          MyIcons.profile,
          size: 30,
        ));
  }

  void _launchURL(String url) async {
    if (await launchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}

class VideoItem {
  final String name;
  final String description;
  final String videoUrl;
  final String thumbnail;

  VideoItem({
    required this.name,
    required this.description,
    required this.videoUrl,
    required this.thumbnail,
  });
}

class VideoItemWidget extends StatelessWidget {
  final VideoItem videoItem;

  const VideoItemWidget({super.key, required this.videoItem});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.r),
        topRight: Radius.circular(20.r),
      ),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.r),
                  topRight: Radius.circular(15.r),
                ),
                child: Image.network(
                  videoItem.thumbnail,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object object, StackTrace? stack){
                    return const SizedBox(
                      child: Center(child: Text('Image not found')),
                    );
                },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    videoItem.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: AppColors.thirdColor,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    videoItem.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
