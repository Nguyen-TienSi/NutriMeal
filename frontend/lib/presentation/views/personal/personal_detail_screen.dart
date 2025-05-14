import 'package:flutter/material.dart';
import 'package:nutriai_app/data/models/user_detail_data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutriai_app/data/repositories/json_patch.dart';
import 'package:nutriai_app/presentation/views/personal/personal_info_card.dart';
import 'package:nutriai_app/service/api-service/user_service.dart';
import 'package:nutriai_app/utils/enums.dart';
import 'package:nutriai_app/presentation/views/personal/personal_name_update_popup.dart';
import 'package:nutriai_app/presentation/views/personal/personal_health_goal_update_popop.dart';
import 'package:nutriai_app/presentation/views/personal/personal_gender_update_popop.dart';
import 'package:nutriai_app/presentation/views/personal/personal_activity_level_update_popup.dart';
import 'package:nutriai_app/presentation/views/personal/personal_body_metrics_update_popup.dart';

class PersonalDetailScreen extends StatefulWidget {
  const PersonalDetailScreen({super.key, this.userDetailData});

  final UserDetailData? userDetailData;

  @override
  State<PersonalDetailScreen> createState() => _PersonalDetailScreenState();
}

class _PersonalDetailScreenState extends State<PersonalDetailScreen> {
  Future<UserDetailData?> updateUserDetailData(JsonPatch jsonPatch) async {
    if (!mounted) return null;
    try {
      final userDetailData = await UserService().patchUserDetailData(jsonPatch);
      if (userDetailData == null) {
        throw Exception('Failed to update user detail data');
      }
      return userDetailData;
    } catch (e) {
      debugPrint('Failed to update user detail data: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.userDetailData;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3ED),
      appBar: AppBar(
        title: const Text('Personal Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.r),
        children: [
          // Goal Card
          Text('YOUR GOAL',
              style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.brown[200],
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1)),
          SizedBox(height: 8.h),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            child: PersonalInfoCard(
              label: 'Goal',
              value: _goalString(user?.healthGoal),
              onTap: () async {
                await showDialog<HealthGoal>(
                  context: context,
                  builder: (context) => PersonalHealthGoalUpdatePopup(
                    currentGoal: user?.healthGoal,
                    onSave: (goal) async {
                      final patch = JsonPatch().replace('/healthGoal',
                          goal.toString().split('.').last.toUpperCase());
                      final updated = await updateUserDetailData(patch);
                      if (updated != null) {
                        setState(() {
                          widget.userDetailData?.healthGoal = goal;
                        });
                      }
                    },
                  ),
                );
              },
              showArrow: true,
            ),
          ),
          SizedBox(height: 28.h),
          // Details Section
          Text('DETAILS',
              style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFFB6AFA5),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1)),
          SizedBox(height: 8.h),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            child: Column(
              children: [
                PersonalInfoCard(
                  label: 'First name',
                  value: user?.name ?? '-',
                  onTap: () async {
                    await showDialog<String>(
                      context: context,
                      builder: (context) => PersonalNameUpdatePopup(
                        currentName: user?.name ?? '',
                        onSave: (name) async {
                          // Update backend
                          final patch = JsonPatch().replace('/name', name);
                          final updated = await updateUserDetailData(patch);
                          if (updated != null) {
                            setState(() {
                              widget.userDetailData?.name = name;
                            });
                          }
                        },
                      ),
                    );
                  },
                  showArrow: true,
                ),
                _divider(),
                PersonalInfoCard(
                  label: 'Current weight',
                  value: user?.currentWeight != null
                      ? '${user!.currentWeight} kg'
                      : '-',
                  onTap: () async {
                    await showDialog<int>(
                      context: context,
                      builder: (context) => PersonalBodyMetricsUpdatePopup(
                        label: 'Current weight',
                        initialValue: user?.currentWeight,
                        unit: 'kg',
                        onSave: (weight) async {
                          final patch =
                              JsonPatch().replace('/currentWeight', weight);
                          final updated = await updateUserDetailData(patch);
                          if (updated != null) {
                            setState(() {
                              widget.userDetailData?.currentWeight = weight;
                            });
                          }
                        },
                      ),
                    );
                  },
                  showArrow: true,
                ),
                _divider(),
                PersonalInfoCard(
                  label: 'Target weight',
                  value: user?.targetWeight != null
                      ? '${user!.targetWeight} kg'
                      : '-',
                  onTap: () async {
                    await showDialog<int>(
                      context: context,
                      builder: (context) => PersonalBodyMetricsUpdatePopup(
                        label: 'Target weight',
                        initialValue: user?.targetWeight,
                        unit: 'kg',
                        onSave: (weight) async {
                          final patch =
                              JsonPatch().replace('/targetWeight', weight);
                          final updated = await updateUserDetailData(patch);
                          if (updated != null) {
                            setState(() {
                              widget.userDetailData?.targetWeight = weight;
                            });
                          }
                        },
                      ),
                    );
                  },
                  showArrow: true,
                ),
                _divider(),
                PersonalInfoCard(
                  label: 'Height',
                  value: user?.currentHeight != null
                      ? '${user!.currentHeight} cm'
                      : '-',
                  onTap: () async {
                    await showDialog<int>(
                      context: context,
                      builder: (context) => PersonalBodyMetricsUpdatePopup(
                        label: 'Height',
                        initialValue: user?.currentHeight,
                        unit: 'cm',
                        onSave: (height) async {
                          final patch =
                              JsonPatch().replace('/currentHeight', height);
                          final updated = await updateUserDetailData(patch);
                          if (updated != null) {
                            setState(() {
                              widget.userDetailData?.currentHeight = height;
                            });
                          }
                        },
                      ),
                    );
                  },
                  showArrow: true,
                ),
                _divider(),
                PersonalInfoCard(
                  label: 'Date of birth',
                  value: user?.dateOfBirth != null
                      ? user!.dateOfBirth!.toIso8601String().split('T').first
                      : '-',
                  onTap: () async {
                    final initialDate =
                        user?.dateOfBirth ?? DateTime(2000, 1, 1);
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: initialDate,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null && picked != user?.dateOfBirth) {
                      final patch = JsonPatch()
                          .replace('/dateOfBirth', picked.toIso8601String());
                      final updated = await updateUserDetailData(patch);
                      if (updated != null) {
                        setState(() {
                          widget.userDetailData?.dateOfBirth = picked;
                        });
                      }
                    }
                  },
                  showArrow: true,
                ),
                _divider(),
                PersonalInfoCard(
                  label: 'Gender',
                  value: _genderString(user?.gender),
                  onTap: () async {
                    await showDialog<Gender>(
                      context: context,
                      builder: (context) => PersonalGenderUpdatePopup(
                        currentGender: user?.gender,
                        onSave: (gender) async {
                          final patch = JsonPatch().replace(
                              '/gender', gender.toString().split('.').last);
                          final updated = await updateUserDetailData(patch);
                          if (updated != null) {
                            setState(() {
                              widget.userDetailData?.gender = gender;
                            });
                          }
                        },
                      ),
                    );
                  },
                  showArrow: true,
                ),
                _divider(),
                PersonalInfoCard(
                  label: 'Activity Level',
                  value: _activityLevelString(user?.activityLevel),
                  onTap: () async {
                    await showDialog<ActivityLevel>(
                      context: context,
                      builder: (context) => PersonalActivityLevelUpdatePopup(
                        currentLevel: user?.activityLevel,
                        onSave: (level) async {
                          final patch = JsonPatch().replace('/activityLevel',
                              level.toString().split('.').last.toUpperCase());
                          final updated = await updateUserDetailData(patch);
                          if (updated != null) {
                            setState(() {
                              widget.userDetailData?.activityLevel = level;
                            });
                          }
                        },
                      ),
                    );
                  },
                  showArrow: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Divider(
        height: 0,
        thickness: 1.h,
        color: const Color(0xFFF7F3ED),
        indent: 20.w,
        endIndent: 20.w,
      );

  String _goalString(healthGoal) {
    switch (healthGoal) {
      case HealthGoal.weightLoss:
        return 'Lose weight';
      case HealthGoal.weightGain:
        return 'Gain weight';
      case HealthGoal.maintain:
        return 'Maintain weight';
      default:
        return '-';
    }
  }

  String _genderString(gender) {
    switch (gender) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      default:
        return 'Other';
    }
  }

  String _activityLevelString(activityLevel) {
    switch (activityLevel) {
      case ActivityLevel.inActive:
        return 'Inactive';
      case ActivityLevel.normal:
        return 'Normal';
      case ActivityLevel.active:
        return 'Active';
      default:
        return '-';
    }
  }
}
