class VaultDoc {
  final String id;
  final String title;
  final String category; // identity, signature, education, health, finance, vehicle, other
  final String issuer;
  final String docNumber;
  final String issueDate;
  final String? expiryDate;
  final String? fileUrl;
  final String? fileName;
  final String? fileSize;
  final bool isVerified;
  final String logoType; // uidai, itd, morth, eci, signature, photo, cbse, pmjay, etc. or 'custom'
  final String storageSource; // phone_upload, camera_scan, gov_import, digital_sign
  final String? notes;
  final String? extraDetails;
  final String? holderName;
  final String? dob;
  final String? gender;
  final String? bloodGroup;
  final DateTime createdAt;

  const VaultDoc({
    required this.id,
    required this.title,
    required this.category,
    required this.issuer,
    required this.docNumber,
    required this.issueDate,
    this.expiryDate,
    this.fileUrl,
    this.fileName,
    this.fileSize,
    this.isVerified = true,
    this.logoType = 'custom',
    this.storageSource = 'gov_import',
    this.notes,
    this.extraDetails,
    this.holderName,
    this.dob,
    this.gender,
    this.bloodGroup,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'issuer': issuer,
      'doc_number': docNumber,
      'issue_date': issueDate,
      'expiry_date': expiryDate,
      'file_url': fileUrl,
      'file_name': fileName,
      'file_size': fileSize,
      'is_verified': isVerified,
      'logo_type': logoType,
      'storage_source': storageSource,
      'notes': notes,
      'extra_details': extraDetails,
      'holder_name': holderName,
      'dob': dob,
      'gender': gender,
      'blood_group': bloodGroup,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory VaultDoc.fromJson(Map<String, dynamic> json) {
    return VaultDoc(
      id: json['id'] as String,
      title: json['title'] as String? ?? 'Document',
      category: json['category'] as String? ?? 'identity',
      issuer: json['issuer'] as String? ?? 'Issued Authority',
      docNumber: json['doc_number'] as String? ?? 'DOC-${DateTime.now().millisecond}',
      issueDate: json['issue_date'] as String? ?? 'Recent',
      expiryDate: json['expiry_date'] as String?,
      fileUrl: json['file_url'] as String?,
      fileName: json['file_name'] as String?,
      fileSize: json['file_size'] as String?,
      isVerified: json['is_verified'] as bool? ?? true,
      logoType: json['logo_type'] as String? ?? 'custom',
      storageSource: json['storage_source'] as String? ?? 'phone_upload',
      notes: json['notes'] as String?,
      extraDetails: json['extra_details'] as String?,
      holderName: json['holder_name'] as String?,
      dob: json['dob'] as String?,
      gender: json['gender'] as String?,
      bloodGroup: json['blood_group'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  VaultDoc copyWith({
    String? id,
    String? title,
    String? category,
    String? issuer,
    String? docNumber,
    String? issueDate,
    String? expiryDate,
    String? fileUrl,
    String? fileName,
    String? fileSize,
    bool? isVerified,
    String? logoType,
    String? storageSource,
    String? notes,
    String? extraDetails,
    String? holderName,
    String? dob,
    String? gender,
    String? bloodGroup,
    DateTime? createdAt,
  }) {
    return VaultDoc(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      issuer: issuer ?? this.issuer,
      docNumber: docNumber ?? this.docNumber,
      issueDate: issueDate ?? this.issueDate,
      expiryDate: expiryDate ?? this.expiryDate,
      fileUrl: fileUrl ?? this.fileUrl,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      isVerified: isVerified ?? this.isVerified,
      logoType: logoType ?? this.logoType,
      storageSource: storageSource ?? this.storageSource,
      notes: notes ?? this.notes,
      extraDetails: extraDetails ?? this.extraDetails,
      holderName: holderName ?? this.holderName,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
