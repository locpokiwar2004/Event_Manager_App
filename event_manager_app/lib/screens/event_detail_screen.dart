import 'package:flutter/material.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Detail'),
        backgroundColor: const Color(0xFFE6661A),
      ),
      body: SingleChildScrollView(
        child: Event(),
      ),
    );
  }
}

class Event extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xBC1B1B1C),
      child: Column(
        children: [
          Container(
            width: 390,
            height: 844,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(color: const Color(0xBC1B1B1C)),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: 390,
                    height: 112,
                    decoration: BoxDecoration(color: const Color(0xFFE6661A)),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: 390,
                    height: 46,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: 390,
                            height: 46,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: Container(width: 390, height: 46),
                                ),
                                Positioned(
                                  left: 265,
                                  top: -4,
                                  child: Container(
                                    width: 125,
                                    height: 54,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: 74,
                                          top: 23,
                                          child: Opacity(
                                            opacity: 0.35,
                                            child: Container(
                                              width: 25,
                                              height: 13,
                                              decoration: ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(width: 1, color: Colors.white),
                                                  borderRadius: BorderRadius.circular(4.30),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 76,
                                          top: 25,
                                          child: Container(
                                            width: 21,
                                            height: 9,
                                            decoration: ShapeDecoration(
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(2.50),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 31,
                                  top: 18,
                                  child: Container(width: 38, height: 22),
                                ),
                                Positioned(
                                  left: 50,
                                  top: 14,
                                  child: Text(
                                    '8:09',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      height: 1.29,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 333,
                  top: 56,
                  child: Container(
                    width: 36,
                    height: 34,
                    decoration: ShapeDecoration(
                      color: const Color(0x00D9D9D9),
                      shape: OvalBorder(
                        side: BorderSide(
                          width: 1,
                          color: Colors.white.withValues(alpha: 0.33),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 112,
                  child: Container(
                    width: 390,
                    height: 207,
                    decoration: BoxDecoration(color: const Color(0xFF989898)),
                  ),
                ),
                Positioned(
                  left: 172,
                  top: 331,
                  child: Container(
                    width: 11,
                    height: 11,
                    decoration: ShapeDecoration(
                      color: Colors.white.withValues(alpha: 0.70),
                      shape: OvalBorder(),
                    ),
                  ),
                ),
                Positioned(
                  left: 190,
                  top: 331,
                  child: Container(
                    width: 11,
                    height: 11,
                    decoration: ShapeDecoration(
                      color: Colors.white.withValues(alpha: 0.70),
                      shape: OvalBorder(),
                    ),
                  ),
                ),
                Positioned(
                  left: 172,
                  top: 331,
                  child: Container(
                    width: 11,
                    height: 11,
                    decoration: ShapeDecoration(
                      color: Colors.white.withValues(alpha: 0.70),
                      shape: OvalBorder(),
                    ),
                  ),
                ),
                Positioned(
                  left: 190,
                  top: 331,
                  child: Container(
                    width: 11,
                    height: 11,
                    decoration: ShapeDecoration(
                      color: Colors.white.withValues(alpha: 0.70),
                      shape: OvalBorder(),
                    ),
                  ),
                ),
                Positioned(
                  left: 208,
                  top: 331,
                  child: Container(
                    width: 11,
                    height: 11,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFE6661A),
                      shape: OvalBorder(),
                    ),
                  ),
                ),
                Positioned(
                  left: 11,
                  top: 354,
                  child: SizedBox(
                    width: 172,
                    height: 22,
                    child: Text(
                      'Begin in:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w400,
                        height: 1.38,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 254,
                  top: 354,
                  child: SizedBox(
                    width: 135,
                    height: 22,
                    child: Text(
                      'Saturday, May 31',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w400,
                        height: 1.38,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 422,
                  child: Container(
                    width: 389,
                    height: 422,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(),
                  ),
                ),
                Positioned(
                  left: -4,
                  top: 411,
                  child: Container(
                    width: 389,
                    height: 422,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 98,
                          top: 1373,
                          child: Container(
                            width: 200,
                            height: 50,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFE6661A),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 2,
                                  color: const Color(0xFF79A9ED),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 127,
                          top: 1387,
                          child: Text(
                            'Report this event',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w400,
                              height: 1.38,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20,
                          top: 11,
                          child: SizedBox(
                            width: 356,
                            height: 44,
                            child: Text(
                              'Founders Running Club Ho Chi Minh City',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontFamily: 'Kalnia',
                                fontWeight: FontWeight.w700,
                                height: 0.88,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 13,
                          top: 67,
                          child: Container(
                            width: 360,
                            height: 127,
                            decoration: ShapeDecoration(
                              color: const Color(0xFF989898),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 51,
                          top: 102,
                          child: Text(
                            'avt',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Kalnia',
                              fontWeight: FontWeight.w400,
                              height: 1.22,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 116,
                          top: 98,
                          child: Text(
                            'Founders Running Club',
                            style: TextStyle(
                              color: const Color(0xFF001D45),
                              fontSize: 20,
                              fontFamily: 'Kalnia',
                              fontWeight: FontWeight.w400,
                              height: 1.10,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 24,
                          top: 155,
                          child: Text(
                            '1,5K Follower',
                            style: TextStyle(
                              color: const Color(0xFF001D45),
                              fontSize: 15,
                              fontFamily: 'Kalnia',
                              fontWeight: FontWeight.w400,
                              height: 1.47,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 199,
                          top: 145,
                          child: Container(
                            width: 154,
                            height: 41,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFE6661A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 249,
                          top: 155,
                          child: Text(
                            'Follow',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Kalnia',
                              fontWeight: FontWeight.w400,
                              height: 1.38,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 13,
                          top: 206,
                          child: SizedBox(
                            width: 362,
                            height: 87,
                            child: Text(
                              'Global community and weekly runs for 30k+ founders, investors, operators and creators in 40+ cities. SF, Dubai, Cape Town, London, São Paulo',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.w400,
                                height: 1.47,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20,
                          top: 303,
                          child: Text(
                            'Select date and time',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w400,
                              height: 1.10,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 23,
                          top: 515,
                          child: Text(
                            'Location',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w400,
                              height: 1.10,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 28,
                          top: 1046,
                          child: Text(
                            'About this event',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w400,
                              height: 1.10,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 51,
                          top: 542,
                          child: Text(
                            'Early Morning Sala',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w400,
                              height: 1.47,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 28,
                          top: 1071,
                          child: SizedBox(
                            width: 348,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Founders Running Club (FRC) brings founders, investors, tech, creative people and startup enthusiasts together for weekly easy runs and networking. We like to be comfortable when we run and finish with coffee and conversations. Choose your pace or follow a pacer—pets, friends, family, are welcome.\nJoin the community ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w400,
                                      height: 1.47,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'http://foundersrc.com/chats\n',
                                    style: TextStyle(
                                      color: const Color(0xFF79A9ED),
                                      fontSize: 15,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w400,
                                      decoration: TextDecoration.underline, // Sửa lại: phải là 'decoration' thay vì 'textDecoration'
                                      height: 1.47,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Stay updated:                                  Instagram',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w400,
                                      height: 1.47,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' ',
                                    style: TextStyle(
                                      color: const Color(0xFF79A9ED),
                                      fontSize: 15,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w400,
                                      height: 1.47,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'http://instagram.com/foundersrc/',
                                    style: TextStyle(
                                      color: const Color(0xFF79A9ED),
                                      fontSize: 15,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w400,
                                      decoration: TextDecoration.underline,
                                      height: 1.47,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '                                  LinkedIn',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w400,
                                      height: 1.47,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' ',
                                    style: TextStyle(
                                      color: const Color(0xFF79A9ED),
                                      fontSize: 15,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w400,
                                      height: 1.47,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'http://linkedin.com/company/foundersrc/',
                                    style: TextStyle(
                                      color: const Color(0xFF79A9ED),
                                      fontSize: 15,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w400,
                                      decoration: TextDecoration.underline,
                                      height: 1.47,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '                                  Strava ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w400,
                                      height: 1.47,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'http://strava.com/clubs/foundersRC',
                                    style: TextStyle(
                                      color: const Color(0xFF79A9ED),
                                      fontSize: 15,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w400,
                                      decoration: TextDecoration.underline,
                                      height: 1.47,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '                                  ',
                                    style: TextStyle(
                                      color: const Color(0xFF79A9ED),
                                      fontSize: 15,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w400,
                                      height: 1.47,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Website',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w400,
                                      height: 1.47,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' ',
                                    style: TextStyle(
                                      color: const Color(0xFF79A9ED),
                                      fontSize: 15,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w400,
                                      height: 1.47,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'http://foundersrc.com/',
                                    style: TextStyle(
                                      color: const Color(0xFF79A9ED),
                                      fontSize: 15,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w400,
                                      decoration: TextDecoration.underline,
                                      height: 1.47,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 51,
                          top: 564,
                          child: Text(
                            'Ho Chi Minh City',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w400,
                              height: 1.47,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 23,
                          top: 330,
                          child: Text(
                            'Saturday, May 31 · 6:30 - 8am',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w400,
                              height: 1.47,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 23,
                          top: 366,
                          child: Container(
                            width: 100,
                            height: 135,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: Container(
                                    width: 100,
                                    height: 135,
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 2,
                                          color: const Color(0xFFE6661A),
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 18,
                                  top: 18,
                                  child: SizedBox(
                                    width: 78,
                                    height: 18,
                                    child: Text(
                                      'Saturday',
                                      style: TextStyle(
                                        color: const Color(0xFF001D45),
                                        fontSize: 16,
                                        fontFamily: 'Manrope',
                                        fontWeight: FontWeight.w400,
                                        height: 1.38,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 11,
                                  top: 39,
                                  child: SizedBox(
                                    width: 78,
                                    height: 18,
                                    child: Text(
                                      'MAY',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: const Color(0xFF001D45),
                                        fontSize: 16,
                                        fontFamily: 'Manrope',
                                        fontWeight: FontWeight.w400,
                                        height: 1.38,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 11,
                                  top: 101,
                                  child: SizedBox(
                                    width: 78,
                                    height: 18,
                                    child: Text(
                                      '6:30 AM',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: const Color(0xFF001D45),
                                        fontSize: 16,
                                        fontFamily: 'Manrope',
                                        fontWeight: FontWeight.w400,
                                        height: 1.38,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 35,
                                  top: 68,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFE6661A),
                                      shape: OvalBorder(),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 33,
                                  top: 72,
                                  child: SizedBox(
                                    width: 34,
                                    height: 22,
                                    child: Text(
                                      '31',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Manrope',
                                        fontWeight: FontWeight.w400,
                                        height: 1.38,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 147,
                          top: 366,
                          child: Container(
                            width: 100,
                            height: 135,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: Container(
                                    width: 100,
                                    height: 135,
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 2,
                                          color: const Color(0xFFBABABA),
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 15,
                                  top: 18,
                                  child: SizedBox(
                                    width: 78,
                                    height: 18,
                                    child: Text(
                                      'Saturday',
                                      style: TextStyle(
                                        color: const Color(0xFF001D45),
                                        fontSize: 16,
                                        fontFamily: 'Manrope',
                                        fontWeight: FontWeight.w400,
                                        height: 1.38,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 11,
                                  top: 39,
                                  child: SizedBox(
                                    width: 78,
                                    height: 18,
                                    child: Text(
                                      'JUN',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: const Color(0xFF001D45),
                                        fontSize: 16,
                                        fontFamily: 'Manrope',
                                        fontWeight: FontWeight.w400,
                                        height: 1.38,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 11,
                                  top: 101,
                                  child: SizedBox(
                                    width: 78,
                                    height: 18,
                                    child: Text(
                                      '6:30 AM',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: const Color(0xFF001D45),
                                        fontSize: 16,
                                        fontFamily: 'Manrope',
                                        fontWeight: FontWeight.w400,
                                        height: 1.38,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 35,
                                  top: 68,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFBABABA),
                                      shape: OvalBorder(),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 33,
                                  top: 72,
                                  child: SizedBox(
                                    width: 34,
                                    height: 22,
                                    child: Text(
                                      '7',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Manrope',
                                        fontWeight: FontWeight.w400,
                                        height: 1.38,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 273,
                          top: 366,
                          child: Container(
                            width: 100,
                            height: 136,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 2,
                                  color: const Color(0xFFBABABA),
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 291,
                          top: 384,
                          child: SizedBox(
                            width: 78,
                            height: 18,
                            child: Text(
                              'Saturday',
                              style: TextStyle(
                                color: const Color(0xFF001D45),
                                fontSize: 16,
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.w400,
                                height: 1.38,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 287,
                          top: 405,
                          child: SizedBox(
                            width: 78,
                            height: 18,
                            child: Text(
                              'MAY',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFF001D45),
                                fontSize: 16,
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.w400,
                                height: 1.38,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 287,
                          top: 467,
                          child: SizedBox(
                            width: 78,
                            height: 18,
                            child: Text(
                              '6:30 AM',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFF001D45),
                                fontSize: 16,
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.w400,
                                height: 1.38,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 23,
                          top: 592.15,
                          child: SizedBox(
                            width: 313,
                            height: 18.75,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Chose your ticket class',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w400,
                                      height: 1.10,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: const Color(0xFFFF3F00),
                                      fontSize: 20,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w400,
                                      height: 1.10,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ':',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w400,
                                      height: 1.10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 15,
                          top: 633.13,
                          child: Container(
                            width: 339,
                            height: 81.91,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFD9D9D9),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 3,
                                  color: const Color(0xFFE6661A),
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 15,
                          top: 727.87,
                          child: Container(
                            width: 339,
                            height: 82.90,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFD9D9D9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          top: 822.62,
                          child: Container(
                            width: 339,
                            height: 82.90,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFD9D9D9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          top: 924.27,
                          child: Container(
                            width: 339,
                            height: 81.91,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFD9D9D9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 29,
                          top: 652.87,
                          child: SizedBox(
                            width: 231,
                            height: 19.74,
                            child: Text(
                              'General Admission - GA',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Kalnia',
                                fontWeight: FontWeight.w700,
                                height: 1.38,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 29,
                          top: 748.60,
                          child: SizedBox(
                            width: 217,
                            height: 18.75,
                            child: Text(
                              'Priority / Early Access',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Kalnia',
                                fontWeight: FontWeight.w700,
                                height: 1.38,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 30,
                          top: 842.36,
                          child: SizedBox(
                            width: 52,
                            height: 20.73,
                            child: Text(
                              'VIP',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Kalnia',
                                fontWeight: FontWeight.w700,
                                height: 1.38,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 30,
                          top: 944.01,
                          child: SizedBox(
                            width: 121,
                            height: 18.75,
                            child: Text(
                              'Super VIP',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Kalnia',
                                fontWeight: FontWeight.w700,
                                height: 1.38,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 29,
                          top: 685.44,
                          child: SizedBox(
                            width: 139,
                            height: 18.75,
                            child: Text(
                              'Ticket price ',
                              style: TextStyle(
                                color: Colors.black.withValues(alpha: 0.58),
                                fontSize: 14,
                                fontFamily: 'Kalnia',
                                fontWeight: FontWeight.w700,
                                height: 1.57,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 29,
                          top: 779.19,
                          child: SizedBox(
                            width: 134,
                            height: 20.73,
                            child: Text(
                              'Ticket price ',
                              style: TextStyle(
                                color: Colors.black.withValues(alpha: 0.58),
                                fontSize: 14,
                                fontFamily: 'Kalnia',
                                fontWeight: FontWeight.w700,
                                height: 1.57,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 30,
                          top: 874.92,
                          child: SizedBox(
                            width: 118,
                            height: 18.75,
                            child: Text(
                              'Ticket price ',
                              style: TextStyle(
                                color: Colors.black.withValues(alpha: 0.58),
                                fontSize: 14,
                                fontFamily: 'Kalnia',
                                fontWeight: FontWeight.w700,
                                height: 1.57,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 30,
                          top: 975.59,
                          child: SizedBox(
                            width: 133,
                            height: 18.75,
                            child: Text(
                              'Ticket price ',
                              style: TextStyle(
                                color: Colors.black.withValues(alpha: 0.58),
                                fontSize: 14,
                                fontFamily: 'Kalnia',
                                fontWeight: FontWeight.w700,
                                height: 1.57,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 268,
                          top: 684.45,
                          child: SizedBox(
                            width: 83,
                            height: 29.61,
                            child: Text(
                              '100.000 đ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Kalnia',
                                fontWeight: FontWeight.w400,
                                height: 1.57,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 268,
                          top: 775.25,
                          child: SizedBox(
                            width: 92,
                            height: 29.61,
                            child: Text(
                              '150.000 đ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Kalnia',
                                fontWeight: FontWeight.w400,
                                height: 1.57,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 268,
                          top: 873.94,
                          child: SizedBox(
                            width: 86,
                            height: 29.61,
                            child: Text(
                              '200.000 đ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Kalnia',
                                fontWeight: FontWeight.w400,
                                height: 1.57,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 270,
                          top: 971.64,
                          child: SizedBox(
                            width: 78,
                            height: 29.61,
                            child: Text(
                              '300.000 đ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Kalnia',
                                fontWeight: FontWeight.w400,
                                height: 1.57,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 311,
                          top: 435,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFBABABA),
                              shape: OvalBorder(),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 309,
                          top: 439,
                          child: SizedBox(
                            width: 34,
                            height: 22,
                            child: Text(
                              '16',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.w400,
                                height: 1.38,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}