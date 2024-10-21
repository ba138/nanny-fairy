import 'package:flutter/foundation.dart';

class ProviderSearchModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String bio;
  final String dob;
  final String education;
  final String address;
  final String houseNumber;
  final String postCode;
  final String phoneNumber;
  final String hoursrate;
  final String profile;
  final List<String> passions;
  final Map<String, Map<String, bool>> availability;
  final IdPics idPics;
  final Reference reference;
  final Time time;
  final double averageRating;
  final int totalRatings;

  ProviderSearchModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.bio,
    required this.dob,
    required this.education,
    required this.address,
    required this.houseNumber,
    required this.postCode,
    required this.phoneNumber,
    required this.hoursrate,
    required this.profile,
    required this.passions,
    required this.availability,
    required this.idPics,
    required this.reference,
    required this.time,
    required this.averageRating,
    required this.totalRatings,
  });

  factory ProviderSearchModel.fromMap(Map<String, dynamic> data, String uid) {
    try {
      Map<String, dynamic> referenceData =
          Map<String, dynamic>.from(data['Reference'] ?? {});
      Map<String, dynamic> idPicsData =
          Map<String, dynamic>.from(data['IdPics'] ?? {});
      Map<String, dynamic> timeData =
          Map<String, dynamic>.from(data['Time'] ?? {});

      double averageRating = calculateAverageRating(data['reviews'] ?? {});
      int totalRatings = (data['reviews'] != null)
          ? Map<String, dynamic>.from(data['reviews']).length
          : 0;

      return ProviderSearchModel(
        uid: uid,
        firstName: data['firstName'] ?? '',
        lastName: data['lastName'] ?? '',
        email: data['email'] ?? '',
        bio: data['bio'] ?? '',
        dob: data['dob'] ?? '',
        education: data['education'] ?? '',
        address: data['address'] ?? '',
        houseNumber: data['houseNumber'] ?? '',
        postCode: data['postCode'] ?? '',
        phoneNumber: data['phoneNumber'] ?? '',
        hoursrate: data['hoursrate'] ?? '',
        profile: data['profile'] ?? '',
        passions: List<String>.from(data['Passions'] ?? []),
        availability: _parseAvailability(
            Map<String, dynamic>.from(data['Availability'] ?? {})),
        idPics: IdPics.fromMap(idPicsData),
        reference: Reference.fromMap(referenceData),
        time: Time.fromMap(timeData),
        averageRating: averageRating,
        totalRatings: totalRatings,
      );
    } catch (e) {
      debugPrint('Error processing provider $uid: $e');
      throw e; // Rethrow to handle the error higher up if necessary
    }
  }

  static Map<String, Map<String, bool>> _parseAvailability(
      Map<String, dynamic> availability) {
    Map<String, Map<String, bool>> parsedAvailability = {};
    availability.forEach((timeOfDay, daysMap) {
      if (daysMap is Map<String, dynamic>) {
        Map<String, bool> parsedDays = {};
        daysMap.forEach((day, value) {
          if (value is bool) {
            parsedDays[day] = value;
          }
        });
        parsedAvailability[timeOfDay] = parsedDays;
      }
    });
    return parsedAvailability;
  }

  static double calculateAverageRating(Map<dynamic, dynamic> reviews) {
    if (reviews.isEmpty) return 0.0;
    double totalRating = 0.0;
    reviews.forEach((key, review) {
      totalRating += review['countRatingStars'] ?? 0.0;
    });
    return totalRating / reviews.length;
  }

  // Method to get available days as a formatted string
  List<String> getAvailableDays() {
    Set<String> daysSet = {};

    // Iterate through each time of day and its corresponding availability map
    availability.forEach((timeOfDay, daysMap) {
      daysMap.forEach((day, isAvailable) {
        // Check if the provider is available on the given day
        if (isAvailable) {
          // Get the first letter of the day
          String dayInitial = day.substring(0, 1).toUpperCase();
          daysSet.add(dayInitial);
        }
      });
    });

    // Convert the set to a sorted list
    List<String> sortedDays = daysSet.toList()..sort();

    return sortedDays;
  }
}

class IdPics {
  final String backPic;
  final String frontPic;

  IdPics({required this.backPic, required this.frontPic});

  factory IdPics.fromMap(Map<String, dynamic> data) {
    return IdPics(
      backPic: data['backPic'] ?? '',
      frontPic: data['frontPic'] ?? '',
    );
  }
}

class Reference {
  final String experience;
  final String job;
  final String land;
  final String phoneNumber;
  final String skill;

  Reference({
    required this.experience,
    required this.job,
    required this.land,
    required this.phoneNumber,
    required this.skill,
  });

  factory Reference.fromMap(Map<String, dynamic> data) {
    return Reference(
      experience: data['experience'] ?? '',
      job: data['job'] ?? '',
      land: data['land'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      skill: data['skill'] ?? '',
    );
  }
}

class Time {
  final String morningStart;
  final String morningEnd;
  final String afternoonStart;
  final String afternoonEnd;
  final String eveningStart;
  final String eveningEnd;

  Time({
    required this.morningStart,
    required this.morningEnd,
    required this.afternoonStart,
    required this.afternoonEnd,
    required this.eveningStart,
    required this.eveningEnd,
  });

  factory Time.fromMap(Map<String, dynamic> data) {
    return Time(
      morningStart: data['MorningStart'] ?? '',
      morningEnd: data['MorningEnd'] ?? '',
      afternoonStart: data['AfternoonStart'] ?? '',
      afternoonEnd: data['AfternoonEnd'] ?? '',
      eveningStart: data['EveningStart'] ?? '',
      eveningEnd: data['EveningEnd'] ?? '',
    );
  }
}
