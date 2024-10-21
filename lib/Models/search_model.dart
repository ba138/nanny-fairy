class SearchModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String address;
  final String houseNumber;
  final String postCode;
  final String bio;
  final String dob;
  final String profile;
  final List<String> passions;
  final IdPics idPics;
  final int totalRatings;
  final double averageRating;

  SearchModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.houseNumber,
    required this.postCode,
    required this.bio,
    required this.dob,
    required this.profile,
    required this.passions,
    required this.idPics,
    required this.totalRatings,
    required this.averageRating,
  });

  factory SearchModel.fromMap(Map<dynamic, dynamic> data, String uid) {
    Map<dynamic, dynamic> reviews = data['reviews'] ?? {};
    int totalRatings = reviews.length;
    double averageRating = totalRatings > 0
        ? reviews.values
                .map((review) => review['countRatingStars'] ?? 0.0)
                .reduce((a, b) => a + b) /
            totalRatings
        : 0.0;

    return SearchModel(
      uid: uid,
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      address: data['address'] ?? '',
      houseNumber: data['houseNumber'] ?? '',
      postCode: data['postCode'] ?? '',
      bio: data['bio'] ?? '',
      dob: data['dob'] ?? '',
      profile: data['profile'] ?? '',
      passions: List<String>.from(data['FamilyPassions'] ?? []),
      idPics: IdPics.fromMap(data['IdPicsFamily'] ?? {}),
      totalRatings: totalRatings,
      averageRating: averageRating,
    );
  }
}

class IdPics {
  final String frontPic;
  final String backPic;

  IdPics({required this.frontPic, required this.backPic});

  factory IdPics.fromMap(Map<dynamic, dynamic> data) {
    return IdPics(
      frontPic: data['frontPic'] ?? '',
      backPic: data['backPic'] ?? '',
    );
  }
}
