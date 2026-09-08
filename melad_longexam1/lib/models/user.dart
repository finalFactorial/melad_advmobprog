class User {
  final int id;
  final String name;
  final String firstName;
  final String lastName;
  final String maidenName;
  final int age;
  final String gender;
  final String email;
  final String phone;
  final String username;
  final String birthDate;
  final String avatarUrl;
  final String coverUrl;
  final String bloodGroup;
  final double height;
  final double weight;
  final String eyeColor;
  final String hairColor;
  final String hairType;
  final String ip;
  final String address;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String macAddress;
  final String university;
  final String companyName;
  final String companyTitle;
  final String companyDepartment;
  final String role;
  final String bio;
  final String work;
  final String education;
  final String livesIn;
  final String relationshipStatus;
  final int followerCount;

  User({
    required this.id,
    required this.name,
    this.firstName = '',
    this.lastName = '',
    this.maidenName = '',
    this.age = 0,
    this.gender = '',
    this.email = '',
    this.phone = '',
    required this.username,
    this.birthDate = '',
    required this.avatarUrl,
    this.coverUrl = 'https://picsum.photos/800/400?random=99',
    this.bloodGroup = '',
    this.height = 0.0,
    this.weight = 0.0,
    this.eyeColor = '',
    this.hairColor = '',
    this.hairType = '',
    this.ip = '',
    this.address = '',
    this.city = '',
    this.state = '',
    this.postalCode = '',
    this.country = '',
    this.macAddress = '',
    this.university = '',
    this.companyName = '',
    this.companyTitle = '',
    this.companyDepartment = '',
    this.role = 'user',
    this.bio = '',
    this.work = '',
    this.education = '',
    this.livesIn = '',
    this.relationshipStatus = 'Single',
    this.followerCount = 1250,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final fName = json['firstName'] ?? json['first_name'] ?? 'User';
    final lName = json['lastName'] ?? json['last_name'] ?? '';
    final fullName = json['name'] ?? '$fName $lName'.trim();

    // Extract address object
    final addrObj = json['address'] is Map ? json['address'] as Map<String, dynamic> : <String, dynamic>{};
    final streetAddr = addrObj['address'] ?? '';
    final cityStr = addrObj['city'] ?? '';
    final stateStr = addrObj['state'] ?? '';
    final postCodeStr = addrObj['postalCode'] ?? '';
    final countryStr = addrObj['country'] ?? '';

    String computedLivesIn = json['livesIn'] ?? '';
    if (computedLivesIn.isEmpty && cityStr.isNotEmpty) {
      computedLivesIn = countryStr.isNotEmpty ? '$cityStr, $countryStr' : cityStr;
    }

    // Extract company object
    final compObj = json['company'] is Map ? json['company'] as Map<String, dynamic> : <String, dynamic>{};
    final compName = compObj['name'] ?? '';
    final compTitle = compObj['title'] ?? '';
    final compDept = compObj['department'] ?? '';

    String computedWork = json['work'] ?? '';
    if (computedWork.isEmpty && (compTitle.isNotEmpty || compName.isNotEmpty)) {
      computedWork = '$compTitle at $compName'.trim();
      if (computedWork.startsWith('at ')) computedWork = compName;
      if (computedWork.endsWith(' at')) computedWork = compTitle;
    }

    // Extract hair object
    final hairObj = json['hair'] is Map ? json['hair'] as Map<String, dynamic> : <String, dynamic>{};
    final hColor = hairObj['color'] ?? '';
    final hType = hairObj['type'] ?? '';

    final uniStr = json['university'] ?? json['education'] ?? '';

    return User(
      id: json['id'] ?? 0,
      name: fullName.isEmpty ? 'User' : fullName,
      firstName: fName,
      lastName: lName,
      maidenName: json['maidenName'] ?? '',
      age: (json['age'] as num?)?.toInt() ?? 0,
      gender: json['gender'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      username: json['username'] ?? 'user_${json['id'] ?? 0}',
      birthDate: json['birthDate'] ?? '',
      avatarUrl: json['image'] ?? json['avatarUrl'] ?? 'https://i.pravatar.cc/300?img=${(json['id'] ?? 1) % 70}',
      coverUrl: json['coverUrl'] ?? 'https://picsum.photos/800/400?random=${(json['id'] ?? 1)}',
      bloodGroup: json['bloodGroup'] ?? '',
      height: (json['height'] as num?)?.toDouble() ?? 0.0,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      eyeColor: json['eyeColor'] ?? '',
      hairColor: hColor,
      hairType: hType,
      ip: json['ip'] ?? '',
      address: streetAddr,
      city: cityStr,
      state: stateStr,
      postalCode: postCodeStr,
      country: countryStr,
      macAddress: json['macAddress'] ?? '',
      university: uniStr,
      companyName: compName,
      companyTitle: compTitle,
      companyDepartment: compDept,
      role: json['role'] ?? 'user',
      bio: json['bio'] ?? computedWork,
      work: computedWork,
      education: uniStr,
      livesIn: computedLivesIn,
      relationshipStatus: json['relationshipStatus'] ?? 'Single',
      followerCount: json['followerCount'] ?? (100 + ((json['id'] ?? 1) * 37)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'firstName': firstName,
      'lastName': lastName,
      'maidenName': maidenName,
      'age': age,
      'gender': gender,
      'email': email,
      'phone': phone,
      'username': username,
      'birthDate': birthDate,
      'avatarUrl': avatarUrl,
      'coverUrl': coverUrl,
      'bloodGroup': bloodGroup,
      'height': height,
      'weight': weight,
      'eyeColor': eyeColor,
      'hairColor': hairColor,
      'hairType': hairType,
      'ip': ip,
      'address': address,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
      'macAddress': macAddress,
      'university': university,
      'companyName': companyName,
      'companyTitle': companyTitle,
      'companyDepartment': companyDepartment,
      'role': role,
      'bio': bio,
      'work': work,
      'education': education,
      'livesIn': livesIn,
      'relationshipStatus': relationshipStatus,
      'followerCount': followerCount,
    };
  }

  static User get sampleUser => User(
        id: 1,
        name: 'Mark Zuckerberg',
        username: 'zuck',
        avatarUrl: 'https://i.pravatar.cc/300?img=12',
        coverUrl: 'https://picsum.photos/800/400?random=10',
        bio: 'Building the metaverse & connecting the world.',
        work: 'CEO at Meta',
        education: 'Harvard University',
        livesIn: 'Palo Alto, California',
        relationshipStatus: 'Married',
        followerCount: 118000000,
      );
}
