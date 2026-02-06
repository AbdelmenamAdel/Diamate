import 'package:diamate/constant.dart';
import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/generated/app_assets.dart';
import 'package:diamate/core/utils/mini/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutDevelopersView extends StatelessWidget {
  const AboutDevelopersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.h,
            pinned: true,
            leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: context.color.backgroundColor,
              ),
            ),
            backgroundColor: context.color.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,

              title: Text(
                'Meet the Developer',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: K.sg,
                  fontWeight: FontWeight.bold,
                  color: context.color.backgroundColor,
                  fontSize: 18.sp,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      context.color.primaryColor!,
                      context.color.primaryColor!.withBlue(255),
                    ],
                  ),
                ),

                child: Center(
                  child: Icon(
                    Icons.code_rounded,
                    size: 80.sp,
                    color: Colors.white24,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  _DeveloperCard(
                    name: 'Abdelmoneim Adel',
                    role: 'Software Mobile Application Engineer',
                    image: Assets.men3em,
                    bio:
                        'Passionate Flutter developer with a focus on creating beautiful, functional, and user-centric mobile applications.',
                    whatsapp: '+201556878109',
                    facebook: 'https://www.facebook.com/abdelmenam.adel.10',
                    github: 'https://github.com/AbdelmenamAdel/',
                    linkedin: 'https://www.linkedin.com/in/abdelmoneim-adel',
                    playStore:
                        'https://play.google.com/store/apps/dev?id=5304471113374404966',
                  ),
                  SizedBox(height: 30.h),
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: context.color.cardColor,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: context.color.hintColor!.withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.favorite_rounded,
                          color: Colors.redAccent,
                          size: 30.sp,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'Built with Passion',
                          style: TextStyle(
                            fontFamily: K.sg,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: context.color.textColor,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'DiaMate is dedicated to helping people manage their health better through technology.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: K.sg,
                            fontSize: 13.sp,
                            color: context.color.textColor!.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeveloperCard extends StatelessWidget {
  final String name;
  final String role;
  final String image;
  final String bio;
  final String whatsapp;
  final String facebook;
  final String github;
  final String linkedin;
  final String playStore;

  const _DeveloperCard({
    required this.name,
    required this.role,
    required this.image,
    required this.bio,
    required this.whatsapp,
    required this.facebook,
    required this.github,
    required this.linkedin,
    required this.playStore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: context.color.cardColor,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Photo
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [context.color.primaryColor!, const Color(0xFF00CEC9)],
              ),
            ),
            child: CircleAvatar(
              radius: 75.r,
              backgroundColor: Colors.white,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(75.r),
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.person, size: 75.r, color: Colors.grey),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            name,
            textAlign: TextAlign.center,

            style: TextStyle(
              fontFamily: K.sg,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: context.color.textColor,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            role,
            textAlign: TextAlign.center,

            style: TextStyle(
              fontFamily: K.sg,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF00CEC9),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            bio,
            textAlign: TextAlign.center,

            style: TextStyle(
              fontFamily: K.sg,
              fontSize: 14.sp,
              color: context.color.textColor!.withOpacity(0.6),
              height: 1.5,
            ),
          ),
          SizedBox(height: 24.h),
          const Divider(),
          SizedBox(height: 20.h),
          Wrap(
            spacing: 16.w,
            runSpacing: 16.h,
            alignment: WrapAlignment.center,
            children: [
              _SocialIconButton(
                icon: FontAwesomeIcons.whatsapp,
                color: const Color(0xFF25D366),
                onTap: () =>
                    urlLauncher(context, 'whatsapp://send?phone=$whatsapp'),
              ),
              _SocialIconButton(
                icon: FontAwesomeIcons.github,
                color: context.color.textColor!,
                onTap: () => urlLauncher(context, github),
              ),
              _SocialIconButton(
                icon: FontAwesomeIcons.linkedin,
                color: const Color(0xFF0077B5),
                onTap: () => urlLauncher(context, linkedin),
              ),
              _SocialIconButton(
                icon: FontAwesomeIcons.facebook,
                color: const Color(0xFF1877F2),
                onTap: () => urlLauncher(context, facebook),
              ),
              _SocialIconButton(
                icon: FontAwesomeIcons.googlePlay,
                color: const Color(0xFF4285F4),
                onTap: () => urlLauncher(context, playStore),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SocialIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: FaIcon(icon, color: color, size: 22.sp),
      ),
    );
  }
}
