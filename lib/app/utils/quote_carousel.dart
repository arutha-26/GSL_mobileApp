import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class QuoteCarousel extends StatelessWidget {
  final List<String> quotes = [
    'Keberhasilan dimulai dari tekad yang kuat dan tindakan konsisten.',
    'Setiap kesalahan adalah peluang untuk belajar dan berkembang.',
    'Jadilah orang yang memberikan energi positif di sekitarmu.',
    'Kesuksesan bukan akhir perjalanan, tapi hasil dari usaha terus-menerus.',
    'Jangan takut mencoba hal baru, karena di situlah peluang terbesar.',
    'Ketika hidup memberimu alasan untuk menyerah, berikanlah alasan untuk tetap melangkah.',
    'Percayalah pada dirimu sendiri, karena orang lain mungkin ragu.',
    'Jadilah seseorang yang memberikan lebih banyak daripada yang diharapkan.',
    'Waktu terbaik untuk memulai adalah sekarang, jangan tunda-tunda lagi.',
    'Jangan biarkan kegagalan hari ini menghentikan impianmu untuk besok.'
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: quotes.map((quote) {
        return Container(
          alignment: AlignmentDirectional.center,
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            // boxShadow: const [
            //   BoxShadow(
            //     color: Color(0xFFC6FFEE),
            //   )
            // ],
            border: Border.all(color: Colors.greenAccent),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(
            quote,
            style: const TextStyle(
              fontSize: 16.0,
              fontStyle: FontStyle.italic,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
      options: CarouselOptions(
        height: 200.0,
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(milliseconds: 1500),
        pauseAutoPlayOnTouch: true,
      ),
    );
  }
}
