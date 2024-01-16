import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class QuoteCarousel extends StatelessWidget {
  final List<String> quotes = [
    'Bekerja dengan tekad kuat adalah kunci menuju keberhasilan di Green Spirit Laundry.',
    'Setiap tantangan adalah peluang untuk belajar dan tumbuh bersama tim.',
    'Sebagai bagian dari Green Spirit Laundry, jadilah sumber energi positif untuk rekan kerjamu.',
    'Kesuksesan bukan tujuan akhir, tapi hasil dari kerja keras dan kerjasama tim yang terus-menerus.',
    'Jangan ragu untuk mencoba hal baru di dunia laundry, karena di situlah peluang terbesar kita.',
    'Ketika pekerjaan menantangmu, berikan alasan untuk terus maju dan berkembang.',
    'Percayalah pada kemampuanmu, Green Spirit Laundry membutuhkan kontribusi unikmu.',
    'Berikan lebih dari yang diharapkan, karena semangat kerjasama membangun kesuksesan bersama.',
    'Waktu terbaik untuk memberikan yang terbaik adalah sekarang, tanpa penundaan.',
    'Kegagalan hari ini hanyalah batu loncatan menuju impian besar Green Spirit Laundry untuk hari besok.'
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
        height: 230.0,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 7),
        autoPlayAnimationDuration: const Duration(milliseconds: 1500),
        pauseAutoPlayOnTouch: true,
      ),
    );
  }
}
