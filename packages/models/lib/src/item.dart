class Item {
  final String id;
  final String slug;
  final AlternativeSlugs alternativeSlugs;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int width;
  final int height;
  final String color;
  final String blurHash;
  final String? description;
  final String altDescription;
  final List<dynamic> breadcrumbs;
  final Urls urls;
  final Links links;
  final int likes;
  final bool likedByUser;
  final List<dynamic> currentUserCollections;
  final dynamic sponsorship;
  final Map<String, dynamic> topicSubmissions;
  final String assetType;
  final User user;

  const Item({
    required this.id,
    required this.slug,
    required this.alternativeSlugs,
    required this.createdAt,
    required this.updatedAt,
    required this.width,
    required this.height,
    required this.color,
    required this.blurHash,
    this.description,
    required this.altDescription,
    required this.breadcrumbs,
    required this.urls,
    required this.links,
    required this.likes,
    required this.likedByUser,
    required this.currentUserCollections,
    this.sponsorship,
    required this.topicSubmissions,
    required this.assetType,
    required this.user,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json['id'] as String,
    slug: json['slug'] as String,
    alternativeSlugs: AlternativeSlugs.fromJson(
      json['alternative_slugs'] as Map<String, dynamic>,
    ),
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
    width: json['width'] as int,
    height: json['height'] as int,
    color: json['color'] as String,
    blurHash: json['blur_hash'] as String,
    description: json['description'] as String?,
    altDescription: json['alt_description'] as String,
    breadcrumbs: List<dynamic>.from(json['breadcrumbs'] as List),
    urls: Urls.fromJson(json['urls'] as Map<String, dynamic>),
    links: Links.fromJson(json['links'] as Map<String, dynamic>),
    likes: json['likes'] as int,
    likedByUser: json['liked_by_user'] as bool,
    currentUserCollections: List<dynamic>.from(
      json['current_user_collections'] as List,
    ),
    sponsorship: json['sponsorship'],
    topicSubmissions: Map<String, dynamic>.from(
      json['topic_submissions'] as Map,
    ),
    assetType: json['asset_type'] as String,
    user: User.fromJson(json['user'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'slug': slug,
    'alternative_slugs': alternativeSlugs.toJson(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'width': width,
    'height': height,
    'color': color,
    'blur_hash': blurHash,
    'description': description,
    'alt_description': altDescription,
    'breadcrumbs': breadcrumbs,
    'urls': urls.toJson(),
    'links': links.toJson(),
    'likes': likes,
    'liked_by_user': likedByUser,
    'current_user_collections': currentUserCollections,
    'sponsorship': sponsorship,
    'topic_submissions': topicSubmissions,
    'asset_type': assetType,
    'user': user.toJson(),
  };

  static List<Item> listFromJson(list) =>
      List<Item>.from(list.map((x) => Item.fromJson(x)));
}

class AlternativeSlugs {
  final String? en, es, ja, fr, it, ko, de, pt; // Made nullable

  const AlternativeSlugs({
    this.en, // Removed required
    this.es,
    this.ja,
    this.fr,
    this.it,
    this.ko,
    this.de,
    this.pt,
  });

  factory AlternativeSlugs.fromJson(Map<String, dynamic> json) =>
      AlternativeSlugs(
        en: json['en'] as String?,
        es: json['es'] as String?,
        ja: json['ja'] as String?,
        fr: json['fr'] as String?,
        it: json['it'] as String?,
        ko: json['ko'] as String?,
        de: json['de'] as String?,
        pt: json['pt'] as String?,
      );

  Map<String, dynamic> toJson() => {
    'en': en,
    'es': es,
    'ja': ja,
    'fr': fr,
    'it': it,
    'ko': ko,
    'de': de,
    'pt': pt,
  };
}

class Urls {
  final String? raw, full, regular, small, thumb, smallS3; // Made nullable

  const Urls({
    this.raw, // Removed required
    this.full,
    this.regular,
    this.small,
    this.thumb,
    this.smallS3,
  });

  factory Urls.fromJson(Map<String, dynamic> json) => Urls(
    raw: json['raw'] as String?,
    full: json['full'] as String?,
    regular: json['regular'] as String?,
    small: json['small'] as String?,
    thumb: json['thumb'] as String?,
    smallS3: json['small_s3'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'raw': raw,
    'full': full,
    'regular': regular,
    'small': small,
    'thumb': thumb,
    'small_s3': smallS3,
  };
}

class Links {
  final String? self, html, download, downloadLocation; // Made nullable

  const Links({
    this.self, // Removed required
    this.html,
    this.download,
    this.downloadLocation,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    self: json['self'] as String?,
    html: json['html'] as String?,
    download: json['download'] as String?,
    downloadLocation: json['download_location'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'self': self,
    'html': html,
    'download': download,
    'download_location': downloadLocation,
  };
}

class User {
  final String id;
  final DateTime? updatedAt; // Made nullable
  final String? username; // Made nullable
  final String? name; // Made nullable
  final String? firstName; // Made nullable
  final String? lastName; // Made nullable
  final String? portfolioUrl;
  final String? bio; // Made nullable
  final String? location; // Made nullable
  final UserLinks? links; // Made nullable
  final ProfileImage? profileImage; // Made nullable
  final String? instagramUsername;
  final int? totalCollections; // Made nullable
  final int? totalLikes; // Made nullable
  final int? totalPhotos; // Made nullable
  final int? totalPromotedPhotos; // Made nullable
  final int? totalIllustrations; // Made nullable
  final int? totalPromotedIllustrations; // Made nullable
  final bool? acceptedTos; // Made nullable
  final bool? forHire; // Made nullable

  const User({
    required this.id, // ID should always be required
    this.updatedAt, // Removed required
    this.username,
    this.name,
    this.firstName,
    this.lastName,
    this.portfolioUrl,
    this.bio,
    this.location,
    this.links,
    this.profileImage,
    this.instagramUsername,
    this.totalCollections,
    this.totalLikes,
    this.totalPhotos,
    this.totalPromotedPhotos,
    this.totalIllustrations,
    this.totalPromotedIllustrations,
    this.acceptedTos,
    this.forHire,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as String,
    updatedAt: json['updated_at'] != null
        ? DateTime.parse(json['updated_at'] as String)
        : null,
    username: json['username'] as String?,
    name: json['name'] as String?,
    firstName: json['first_name'] as String?,
    lastName: json['last_name'] as String?,
    portfolioUrl: json['portfolio_url'] as String?,
    bio: json['bio'] as String?,
    location: json['location'] as String?,
    links: json['links'] != null
        ? UserLinks.fromJson(json['links'] as Map<String, dynamic>)
        : null,
    profileImage: json['profile_image'] != null
        ? ProfileImage.fromJson(json['profile_image'] as Map<String, dynamic>)
        : null,
    instagramUsername: json['instagram_username'] as String?,
    totalCollections: json['total_collections'] as int?,
    totalLikes: json['total_likes'] as int?,
    totalPhotos: json['total_photos'] as int?,
    totalPromotedPhotos: json['total_promoted_photos'] as int?,
    totalIllustrations: json['total_illustrations'] as int?,
    totalPromotedIllustrations: json['total_promoted_illustrations'] as int?,
    acceptedTos: json['accepted_tos'] as bool?,
    forHire: json['for_hire'] as bool?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'updated_at': updatedAt?.toIso8601String(),
    'username': username,
    'name': name,
    'first_name': firstName,
    'last_name': lastName,
    'portfolio_url': portfolioUrl,
    'bio': bio,
    'location': location,
    'links': links?.toJson(),
    'profile_image': profileImage?.toJson(),
    'instagram_username': instagramUsername,
    'total_collections': totalCollections,
    'total_likes': totalLikes,
    'total_photos': totalPhotos,
    'total_promoted_photos': totalPromotedPhotos,
    'total_illustrations': totalIllustrations,
    'total_promoted_illustrations': totalPromotedIllustrations,
    'accepted_tos': acceptedTos,
    'for_hire': forHire,
  };
}

class UserLinks {
  final String? self, html, photos, likes, portfolio; // Made nullable

  const UserLinks({
    this.self, // Removed required
    this.html,
    this.photos,
    this.likes,
    this.portfolio,
  });

  factory UserLinks.fromJson(Map<String, dynamic> json) => UserLinks(
    self: json['self'] as String?,
    html: json['html'] as String?,
    photos: json['photos'] as String?,
    likes: json['likes'] as String?,
    portfolio: json['portfolio'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'self': self,
    'html': html,
    'photos': photos,
    'likes': likes,
    'portfolio': portfolio,
  };
}

class ProfileImage {
  final String? small, medium, large; // Made nullable

  const ProfileImage({
    this.small, // Removed required
    this.medium,
    this.large,
  });

  factory ProfileImage.fromJson(Map<String, dynamic> json) => ProfileImage(
    small: json['small'] as String?,
    medium: json['medium'] as String?,
    large: json['large'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'small': small,
    'medium': medium,
    'large': large,
  };
}

class Social {
  final String? instagramUsername;
  final String? portfolioUrl;
  final String? twitterUsername;
  final String? paypalEmail;

  const Social({
    this.instagramUsername,
    this.portfolioUrl,
    this.twitterUsername,
    this.paypalEmail,
  });

  factory Social.fromJson(Map<String, dynamic> json) => Social(
    instagramUsername: json['instagram_username'] as String?,
    portfolioUrl: json['portfolio_url'] as String?,
    twitterUsername: json['twitter_username'] as String?,
    paypalEmail: json['paypal_email'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'instagram_username': instagramUsername,
    'portfolio_url': portfolioUrl,
    'twitter_username': twitterUsername,
    'paypal_email': paypalEmail,
  };
}
