import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutriai_app/data/models/streak_data.dart';
import 'package:nutriai_app/data/models/user_detail_data.dart';
import 'package:nutriai_app/presentation/views/health-progress-tracking/favorite_recipe_screen.dart';
import 'package:nutriai_app/presentation/views/health-progress-tracking/statistic_chart_screen.dart';
import 'package:nutriai_app/presentation/views/health-progress-tracking/streak_section.dart';
import 'package:nutriai_app/presentation/views/health-progress-tracking/statistic_navigation_card.dart';
import 'package:nutriai_app/presentation/views/health-progress-tracking/weight_gauge_chart.dart';
import 'package:nutriai_app/service/api-service/statistic_service.dart';
import 'package:nutriai_app/service/api-service/user_service.dart';

class HealthProgressTrackingScreen extends StatefulWidget {
  const HealthProgressTrackingScreen({super.key, this.refreshKey});

  final GlobalKey<RefreshIndicatorState>? refreshKey;

  @override
  State<HealthProgressTrackingScreen> createState() =>
      _HealthProgressTrackingScreenState();
}

class _HealthProgressTrackingScreenState
    extends State<HealthProgressTrackingScreen> {
  UserDetailData? userDetailData;
  StreakData? streakData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    if (!mounted) return;
    try {
      setState(() => isLoading = true);
      final userDetailData = await UserService().getUserDetailData();
      final streakData = await StatisticService().getStreakData();
      debugPrint(userDetailData.toString());
      setState(() {
        this.userDetailData = userDetailData;
        this.streakData = streakData;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() => isLoading = false);
    }
  }

  void handleNavigate(Widget widget) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : userDetailData == null
                ? const Center(child: Text('No data available'))
                : RefreshIndicator(
                    key: widget.refreshKey,
                    onRefresh: fetchData,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: WeightGaugeChart(
                                  userDetailData: userDetailData!),
                            ),
                            SizedBox(height: 10.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: StreakSection(streakData: streakData!),
                            ),
                            SizedBox(height: 10.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: StatisticNavigationCard(
                                onTap: () => handleNavigate(
                                  const FavoriteRecipeScreen(),
                                ),
                                icon: Icon(Icons.favorite,
                                    color: Colors.green, size: 32.sp),
                                title: 'Favorites',
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: StatisticNavigationCard(
                                onTap: () => handleNavigate(
                                  const StatisticChartScreen(),
                                ),
                                icon: Icon(Icons.bar_chart,
                                    color: Colors.blue, size: 32.sp),
                                title: 'Statistic Chart',
                              ),
                            ),
                            SizedBox(height: 10.h),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
