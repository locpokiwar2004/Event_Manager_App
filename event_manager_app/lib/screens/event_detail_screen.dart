import 'package:flutter/material.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xBC1B1B1C),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE6661A),
        elevation: 0,
        title: const Text(
          'Event Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: const Color(0xFF989898),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 16),
          // Club Info
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey[700],
                child: const Text('avt', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Founders Running Club',
                      style: TextStyle(
                        color: Color(0xFF001D45),
                        fontSize: 20,
                        fontFamily: 'Kalnia',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '1,5K Follower',
                      style: TextStyle(
                        color: Color(0xFF001D45),
                        fontSize: 15,
                        fontFamily: 'Kalnia',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE6661A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {},
                child: const Text('Follow', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Club Description
          const Text(
            'Global community and weekly runs for 30k+ founders, investors, operators and creators in 40+ cities. SF, Dubai, Cape Town, London, São Paulo',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 24),
          // Date & Time
          const Text(
            'Select date and time',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _DateCard(day: '31', month: 'MAY', weekday: 'Saturday', time: '6:30 AM', highlight: true),
              const SizedBox(width: 12),
              _DateCard(day: '7', month: 'JUN', weekday: 'Saturday', time: '6:30 AM'),
              const SizedBox(width: 12),
              _DateCard(day: '16', month: 'MAY', weekday: 'Saturday', time: '6:30 AM'),
            ],
          ),
          const SizedBox(height: 24),
          // Location
          const Text(
            'Location',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Early Morning Sala',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w400,
            ),
          ),
          const Text(
            'Ho Chi Minh City',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 24),
          // Ticket Class
          RichText(
            text: const TextSpan(
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w400,
              ),
              children: [
                TextSpan(text: 'Chose your ticket class'),
                TextSpan(
                  text: '*',
                  style: TextStyle(color: Color(0xFFFF3F00)),
                ),
                TextSpan(text: ':'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _TicketClassCard(
            title: 'General Admission - GA',
            price: '100.000 đ',
          ),
          const SizedBox(height: 12),
          _TicketClassCard(
            title: 'Priority / Early Access',
            price: '150.000 đ',
          ),
          const SizedBox(height: 12),
          _TicketClassCard(
            title: 'VIP',
            price: '200.000 đ',
          ),
          const SizedBox(height: 12),
          _TicketClassCard(
            title: 'Super VIP',
            price: '300.000 đ',
          ),
          const SizedBox(height: 24),
          // About
          const Text(
            'About this event',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Founders Running Club (FRC) brings founders, investors, tech, creative people and startup enthusiasts together for weekly easy runs and networking. We like to be comfortable when we run and finish with coffee and conversations. Choose your pace or follow a pacer—pets, friends, family, are welcome.\nJoin the community ',
                ),
                TextSpan(
                  text: 'http://foundersrc.com/chats\n',
                  style: TextStyle(
                    color: Color(0xFF79A9ED),
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(
                  text: 'Stay updated: Instagram ',
                ),
                TextSpan(
                  text: 'http://instagram.com/foundersrc/\n',
                  style: TextStyle(
                    color: Color(0xFF79A9ED),
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(
                  text: 'LinkedIn ',
                ),
                TextSpan(
                  text: 'http://linkedin.com/company/foundersrc/\n',
                  style: TextStyle(
                    color: Color(0xFF79A9ED),
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(
                  text: 'Strava ',
                ),
                TextSpan(
                  text: 'http://strava.com/clubs/foundersRC\n',
                  style: TextStyle(
                    color: Color(0xFF79A9ED),
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(
                  text: 'Website ',
                ),
                TextSpan(
                  text: 'http://foundersrc.com/',
                  style: TextStyle(
                    color: Color(0xFF79A9ED),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 24),
          // Report Button
          Center(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFE6661A),
                side: const BorderSide(color: Color(0xFF79A9ED), width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: () {},
              child: const Text(
                'Report this event',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateCard extends StatelessWidget {
  final String day, month, weekday, time;
  final bool highlight;
  const _DateCard({
    required this.day,
    required this.month,
    required this.weekday,
    required this.time,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 135,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: highlight ? const Color(0xFFE6661A) : const Color(0xFFBABABA),
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 18,
            top: 18,
            child: Text(
              weekday,
              style: const TextStyle(
                color: Color(0xFF001D45),
                fontSize: 16,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Positioned(
            left: 11,
            top: 39,
            child: SizedBox(
              width: 78,
              child: Text(
                month,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF001D45),
                  fontSize: 16,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Positioned(
            left: 11,
            top: 101,
            child: SizedBox(
              width: 78,
              child: Text(
                time,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF001D45),
                  fontSize: 16,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w400,
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
              decoration: BoxDecoration(
                color: highlight ? const Color(0xFFE6661A) : const Color(0xFFBABABA),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: 33,
            top: 72,
            child: SizedBox(
              width: 34,
              child: Text(
                day,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketClassCard extends StatelessWidget {
  final String title;
  final String price;
  const _TicketClassCard({required this.title, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 82,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: title == 'General Admission - GA'
              ? const Color(0xFFE6661A)
              : Colors.transparent,
          width: title == 'General Admission - GA' ? 3 : 0,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Kalnia',
              fontWeight: FontWeight.w700,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Ticket price ',
                style: TextStyle(
                  color: Color.fromARGB(148, 0, 0, 0),
                  fontSize: 14,
                  fontFamily: 'Kalnia',
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                price,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Kalnia',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}