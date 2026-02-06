import 'package:diamate/constant.dart';
import 'package:diamate/core/utils/mini/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AutherMedia extends StatelessWidget {
  const AutherMedia({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF6C5CE7).withOpacity(0.1),
            const Color(0xFF00CEC9).withOpacity(0.1),
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Text(
              'Meet the Developer',
              style: TextStyle(
                fontFamily: K.sg,
                color: const Color.fromARGB(255, 66, 35, 159),
                fontWeight: FontWeight.w700,
                fontSize: 22.sp,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 24.h),

            // Profile Card
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(20.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Profile Image
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF6C5CE7),
                          width: 3.w,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6C5CE7).withOpacity(0.3),
                            blurRadius: 15.r,
                            spreadRadius: 2.r,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 70.r,
                        backgroundColor: Colors.grey[200],
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(70.r),
                          child: Image.asset(
                            'images/Men3em.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Name
                    Text(
                      'Abdelmoneim Adel',
                      style: TextStyle(
                        fontFamily: K.sg,
                        color: const Color(0xFF2D3436),
                        fontWeight: FontWeight.w700,
                        fontSize: 20.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Title
                    Text(
                      'Software Mobile Application Engineer',
                      style: TextStyle(
                        fontFamily: K.sg,
                        color: const Color(0xFF00CEC9),
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Social Links
                    SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 12.w,
                        runSpacing: 12.h,
                        children: [
                          _buildSocialButton(
                            context,
                            FontAwesomeIcons.whatsapp,
                            Colors.green,
                            () async {
                              const whatsapp = '+201556878109';
                              await urlLauncher(
                                context,
                                'whatsapp://send?phone=$whatsapp',
                              );
                            },
                          ),
                          _buildSocialButton(
                            context,
                            FontAwesomeIcons.facebook,
                            Colors.blue,
                            () async {
                              await urlLauncher(
                                context,
                                'https://www.facebook.com/abdelmenam.adel.10',
                              );
                            },
                          ),
                          _buildSocialButton(
                            context,
                            FontAwesomeIcons.github,
                            Colors.black,
                            () async {
                              await urlLauncher(
                                context,
                                'https://github.com/AbdelmenamAdel/',
                              );
                            },
                          ),
                          _buildSocialButton(
                            context,
                            FontAwesomeIcons.linkedinIn,
                            Colors.blue[700]!,
                            () async {
                              await urlLauncher(
                                context,
                                'https://www.linkedin.com/in/abdelmoneim-adel',
                              );
                            },
                          ),
                          _buildSocialButton(
                            context,
                            FontAwesomeIcons.googlePlay,
                            const Color(0xFF1F2937),
                            () async {
                              await urlLauncher(
                                context,
                                'https://play.google.com/store/apps/dev?id=5304471113374404966',
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8.r,
            spreadRadius: 1.r,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
            ),
            child: FaIcon(icon, color: color, size: 20.sp),
          ),
        ),
      ),
    );
  }
}
