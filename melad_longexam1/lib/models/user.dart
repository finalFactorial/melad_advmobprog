class User {
  final int id;
  final String name;
  final String username;
  final String avatarUrl;
  final String coverUrl;
  final String bio;
  final String work;
  final String education;
  final String livesIn;
  final String relationshipStatus;
  final int followerCount;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.avatarUrl,
    this.coverUrl = 'https://picsum.photos/800/400?random=99',
    this.bio = 'Welcome to my Facebook profile!',
    this.work = 'Software Engineer at Meta',
    this.education = 'Computer Science Graduate',
    this.livesIn = 'Manila, Philippines',
    this.relationshipStatus = 'Single',
    this.followerCount = 1250,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final firstName = json['firstName'] ?? json['first_name'] ?? 'User';
    final lastName = json['lastName'] ?? json['last_name'] ?? '${json['id'] ?? ''}';
    final fullName = json['name'] ?? '$firstName $lastName'.trim();

    return User(
      id: json['id'] ?? 0,
      name: fullName.isEmpty ? 'User' : fullName,
      username: json['username'] ?? 'user_${json['id'] ?? 0}',
      avatarUrl: json['image'] ?? json['avatarUrl'] ?? 'https://i.pravatar.cc/300?img=${(json['id'] ?? 1) % 70}',
      coverUrl: json['coverUrl'] ?? 'https://picsum.photos/800/400?random=${(json['id'] ?? 1)}',
      bio: json['bio'] ?? json['company']?['title'] ?? 'Passionate developer & tech enthusiast.',
      work: json['work'] ?? (json['company'] != null ? '${json['company']['title']} at ${json['company']['name']}' : 'Software Engineer'),
      education: json['education'] ?? (json['university'] ?? 'University Graduate'),
      livesIn: json['livesIn'] ?? (json['address'] != null ? '${json['address']['city']}, ${json['address']['country'] ?? ''}' : 'Manila, Philippines'),
      relationshipStatus: json['relationshipStatus'] ?? 'Single',
      followerCount: json['followerCount'] ?? (100 + ((json['id'] ?? 1) * 37)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'avatarUrl': avatarUrl,
      'coverUrl': coverUrl,
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
