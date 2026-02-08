import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AppRatingWidget extends StatefulWidget {
  const AppRatingWidget({Key? key}) : super(key: key);

  @override
  State<AppRatingWidget> createState() => _AppRatingWidgetState();
}

class _AppRatingWidgetState extends State<AppRatingWidget> {
  final _feedbackUrl = dotenv.env['FEEDBACK_URL']!;
  final _appStoreId = dotenv.env['APP_STORE_ID']!;
  final InAppReview _inAppReview = InAppReview.instance;

  static const ratingKey = 'app_rating';
  double _rating = 5.0;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _rating = prefs.getDouble(ratingKey) ?? 5.0;
    });
  }

  Future<void> _saveRating(double rating) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(ratingKey, rating);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Ваша оценка'),
        const SizedBox(height: 8.0),
        RatingBar.builder(
          initialRating: _rating,
          minRating: 1,
          allowHalfRating: false,
          itemCount: 5,
          itemSize: 32,
          unratedColor: Colors.amber.withValues(alpha: 0.2),
          itemBuilder: (context, _) =>
              const Icon(Icons.star, color: Colors.amber),
          onRatingUpdate: (rating) async {
            setState(() {
              _rating = rating;
            });

            await _saveRating(rating);

            if (rating >= 4) {
              _inAppReview.openStoreListing(appStoreId: _appStoreId);
            } else {
              final url = Uri.parse(_feedbackUrl);
              launchUrl(url);
            }
          },
        ),
      ],
    );
  }
}
