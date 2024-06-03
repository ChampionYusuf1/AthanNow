import 'package:flutter/material.dart';
import 'package:athannow/commonfunctions/functins.dart';

Future<void> showHadithDialog(
    BuildContext context, Future<Hadiths> futureHadith) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return FutureBuilder<Hadiths>(
        future: futureHadith,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return AlertDialog(
              title: Text('Hadith Of The Day!'),
              content: Center(child: CircularProgressIndicator()),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return AlertDialog(
              title: Text('Hadith Of The Day!'),
              content: Text('Error: ${snapshot.error}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          } else if (!snapshot.hasData) {
            return AlertDialog(
              title: Text('Hadith Of The Day!'),
              content: Text('No data found'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          } else {
            final hadith = snapshot.data!;
            final title = hadith.headingEnglish?.isNotEmpty == true
                ? hadith.headingEnglish!
                : 'Hadith Of The Day!';

            return AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hadith.hadithEnglish!,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Arabic:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(hadith.hadithArabic!),
                    SizedBox(height: 10),
                    Text(
                      'Narrator: ${hadith.englishNarrator}',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          }
        },
      );
    },
  );
}
