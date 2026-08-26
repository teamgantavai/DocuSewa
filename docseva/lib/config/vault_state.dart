import 'package:flutter/foundation.dart';
import 'package:docusewa/models/vault_doc.dart';

class VaultState {
  static final List<VaultDoc> initialDocs = [
    VaultDoc(
      id: 'v-apaar',
      title: 'APAAR ID',
      category: 'education',
      issuer: 'Academic Bank of Credits',
      docNumber: '110XXXXXX743',
      issueDate: '10 Jan 2024',
      isVerified: true,
      logoType: 'abc',
      storageSource: 'gov_import',
      fileName: 'apaar_card_abc.pdf',
      fileSize: '1.1 MB',
      extraDetails: 'APAAR / ABC ID: 110-8291-7439 | Ministry of Education',
      holderName: 'Rajesh Kumar Sharma',
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
    ),
    VaultDoc(
      id: 'v-aadhaar',
      title: 'Aadhaar Card',
      category: 'identity',
      issuer: 'Unique Identification Authority of India (UIDAI)',
      docNumber: '************',
      issueDate: '12 Jan 2024',
      isVerified: true,
      logoType: 'uidai',
      storageSource: 'gov_import',
      fileName: 'eAadhaar_digital.pdf',
      fileSize: '1.4 MB',
      extraDetails: 'VID: 9102-4820-1920-5819 | Mobile Linked',
      holderName: 'Rajesh Kumar Sharma',
      dob: '15/08/1996',
      gender: 'Male',
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
    ),
    VaultDoc(
      id: 'v-pan',
      title: 'PAN Verification Record',
      category: 'identity',
      issuer: 'Income Tax Department',
      docNumber: 'DFXXXXXX7B',
      issueDate: '04 Mar 2023',
      isVerified: true,
      logoType: 'itd',
      storageSource: 'gov_import',
      fileName: 'ePAN_signed_tax_card.pdf',
      fileSize: '890 KB',
      extraDetails: 'Tax Status: Individual Active | Aadhaar Seeded',
      holderName: 'Rajesh Kumar Sharma',
      dob: '15/08/1996',
      gender: 'Male',
      createdAt: DateTime.now().subtract(const Duration(days: 240)),
    ),
    VaultDoc(
      id: 'v-pseb',
      title: 'Class X Marksheet',
      category: 'education',
      issuer: 'Punjab School Education Board',
      docNumber: 'PSEB/2020/89210',
      issueDate: '24 May 2020',
      isVerified: true,
      logoType: 'pseb',
      storageSource: 'gov_import',
      fileName: 'class_10_marksheet.pdf',
      fileSize: '2.3 MB',
      extraDetails: 'Roll No: 6281902 | Result: PASS (92.4%)',
      holderName: 'Rajesh Kumar Sharma',
      createdAt: DateTime.now().subtract(const Duration(days: 500)),
    ),
    VaultDoc(
      id: 'v-signature',
      title: 'Candidate Digital Signature',
      category: 'signature',
      issuer: 'Self Attested & Digital e-Signed',
      docNumber: 'SIGN-SHA256-8921',
      issueDate: '18 Feb 2024',
      isVerified: true,
      logoType: 'signature',
      storageSource: 'digital_sign',
      fileName: 'official_signature_transparent.png',
      fileSize: '145 KB',
      extraDetails: 'Format: High-Res PNG (300 DPI) | Valid for all Govt Applications',
      holderName: 'Rajesh Kumar Sharma',
      notes: 'Legally valid for SSC, UPSC, NTA & Bank form submissions under IT Act 2000.',
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
    ),
    VaultDoc(
      id: 'v-photo',
      title: 'Passport Size Photograph',
      category: 'signature',
      issuer: 'Biometric Standards (ISO/IEC 19794-5)',
      docNumber: 'PHOTO-BIO-2024-09',
      issueDate: '10 Feb 2024',
      isVerified: true,
      logoType: 'photo',
      storageSource: 'phone_upload',
      fileName: 'passport_photo_white_bg.jpg',
      fileSize: '85 KB',
      extraDetails: 'Size: 3.5cm x 4.5cm (600x800 px) | White Background',
      holderName: 'Rajesh Kumar Sharma',
      notes: '80% Face coverage with neutral expression for all Govt competitive applications.',
      createdAt: DateTime.now().subtract(const Duration(days: 50)),
    ),
    VaultDoc(
      id: 'v-dl',
      title: 'Driving Licence & RC',
      category: 'vehicle',
      issuer: 'Ministry of Road Transport and Highways',
      docNumber: 'DL-04202100892',
      issueDate: '18 Aug 2021',
      expiryDate: '17 Aug 2041',
      isVerified: true,
      logoType: 'morth',
      storageSource: 'gov_import',
      fileName: 'digital_dl_smartcard.pdf',
      fileSize: '2.1 MB',
      extraDetails: 'Class: LMV / MCWG | Transport Dept Delhi',
      holderName: 'Rajesh Kumar Sharma',
      bloodGroup: 'O+',
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
    ),
    VaultDoc(
      id: 'v-health',
      title: 'ABHA Digital Health Card',
      category: 'health',
      issuer: 'National Health Authority (NHA)',
      docNumber: '91-8821-4902-1249',
      issueDate: '02 Feb 2024',
      isVerified: true,
      logoType: 'pmjay',
      storageSource: 'gov_import',
      fileName: 'abha_health_id.pdf',
      fileSize: '650 KB',
      extraDetails: 'ABHA Address: rajesh.sharma@abdm | Blood Group: O+',
      holderName: 'Rajesh Kumar Sharma',
      bloodGroup: 'O+',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
  ];

  static final ValueNotifier<List<VaultDoc>> vaultDocsNotifier =
      ValueNotifier<List<VaultDoc>>(List.from(initialDocs));

  static void addDocument(VaultDoc doc) {
    final currentList = List<VaultDoc>.from(vaultDocsNotifier.value);
    currentList.insert(0, doc);
    vaultDocsNotifier.value = currentList;
  }

  static void updateDocument(VaultDoc updatedDoc) {
    final currentList = List<VaultDoc>.from(vaultDocsNotifier.value);
    final index = currentList.indexWhere((d) => d.id == updatedDoc.id);
    if (index != -1) {
      currentList[index] = updatedDoc;
      vaultDocsNotifier.value = currentList;
    }
  }

  static void deleteDocument(String id) {
    final currentList = List<VaultDoc>.from(vaultDocsNotifier.value);
    currentList.removeWhere((d) => d.id == id);
    vaultDocsNotifier.value = currentList;
  }

  static double get totalStorageMB {
    double total = 0.0;
    for (final doc in vaultDocsNotifier.value) {
      final sizeStr = doc.fileSize ?? '1.0 MB';
      if (sizeStr.contains('MB')) {
        total += double.tryParse(sizeStr.replaceAll('MB', '').trim()) ?? 1.0;
      } else if (sizeStr.contains('KB')) {
        total += (double.tryParse(sizeStr.replaceAll('KB', '').trim()) ?? 500.0) / 1024.0;
      }
    }
    return total;
  }
}
