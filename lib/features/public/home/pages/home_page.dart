import 'package:flutter/material.dart';
import '../widgets/hero_welcome.dart';
import '../widgets/stat_section.dart';
import '../widgets/featured_property.dart';
import '../widgets/why_rentwise.dart';
import '../widgets/how_it_works.dart';
import '../widgets/testimonial_section.dart';
import '../widgets/final_cta_section.dart';
import '../../../../shared/widgets/app_footer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeroSection(),
            StatSection(),
            FeaturedPropertySection(),
            WhyRentWiseSection(),
            HowItWorks(),
            TestimonialsSection(),
            FinalCtaSection(),
            AppFooter(),
          ],
        ),
      ),
    );
  }
}
