import 'package:flutter/material.dart';

final ValueNotifier<String> appLanguageNotifier = ValueNotifier<String>('en');

class AppStrings {
  final String brandName;
  final String brandTagline;
  final String verifiedCitizen;
  final String verifiedAccount;
  final String searchPlaceholder;
  final String signOut;
  final String close;
  final String cancel;
  final String saveChanges;
  final String editDetails;

  // Nav
  final String navHome;
  final String navDocs;
  final String navExams;
  final String navProfile;

  // Sections
  final String identityDocsTitle;
  final String identityDocsBadge;
  final String examsTitle;
  final String examsBadge;
  final String financeTitle;
  final String financeBadge;
  final String directPortals;
  final String admitCardsBadge;
  final String bankingBadge;

  // Modal / Actions
  final String visitSite;
  final String fetchDocument;
  final String pullingDoc;
  final String done;
  final String docIssuedSuccess;
  final String docIssuedDesc;
  final String requiredDetails;
  final String officialPortal;
  final String viewInVault;

  // Vault
  final String vaultTitle;
  final String vaultSubtitle;
  final String docNumber;
  final String docStatus;
  final String viewDoc;
  final String downloadDoc;
  final String verifiedBadge;

  // Profile
  final String citizenPass;
  final String govtOfIndia;
  final String digilockerVerified;
  final String copyId;
  final String downloadPass;
  final String copiedId;
  final String aadhaarSeeded;
  final String panNumber;
  final String vaultRecords;
  final String securityStatus;
  final String secHigh;

  // Tabs
  final String tabDigitalPass;
  final String tabPersonalKYC;
  final String tabLinkedPortals;
  final String tabSecurity;
  final String tabSettings;

  // Personal
  final String personalTitle;
  final String lblFullName;
  final String lblPhone;
  final String lblEmail;
  final String lblDob;
  final String lblGender;
  final String lblBloodGroup;
  final String lblFather;
  final String lblState;
  final String lblAddress;

  // Linked
  final String linkedTitle;
  final String syncAll;
  final String syncing;
  final String lblLinked;

  // Security
  final String securityTitle;
  final String twoFactorTitle;
  final String twoFactorDesc;
  final String bioLockTitle;
  final String bioLockDesc;
  final String consentTitle;
  final String revoke;

  // Preferences
  final String preferencesTitle;
  final String portalLanguage;
  final String alertsTitle;
  final String whatsappAlerts;
  final String smsAlerts;
  final String exportData;

  const AppStrings({
    required this.brandName,
    required this.brandTagline,
    required this.verifiedCitizen,
    required this.verifiedAccount,
    required this.searchPlaceholder,
    required this.signOut,
    required this.close,
    required this.cancel,
    required this.saveChanges,
    required this.editDetails,
    required this.navHome,
    required this.navDocs,
    required this.navExams,
    required this.navProfile,
    required this.identityDocsTitle,
    required this.identityDocsBadge,
    required this.examsTitle,
    required this.examsBadge,
    required this.financeTitle,
    required this.financeBadge,
    required this.directPortals,
    required this.admitCardsBadge,
    required this.bankingBadge,
    required this.visitSite,
    required this.fetchDocument,
    required this.pullingDoc,
    required this.done,
    required this.docIssuedSuccess,
    required this.docIssuedDesc,
    required this.requiredDetails,
    required this.officialPortal,
    required this.viewInVault,
    required this.vaultTitle,
    required this.vaultSubtitle,
    required this.docNumber,
    required this.docStatus,
    required this.viewDoc,
    required this.downloadDoc,
    required this.verifiedBadge,
    required this.citizenPass,
    required this.govtOfIndia,
    required this.digilockerVerified,
    required this.copyId,
    required this.downloadPass,
    required this.copiedId,
    required this.aadhaarSeeded,
    required this.panNumber,
    required this.vaultRecords,
    required this.securityStatus,
    required this.secHigh,
    required this.tabDigitalPass,
    required this.tabPersonalKYC,
    required this.tabLinkedPortals,
    required this.tabSecurity,
    required this.tabSettings,
    required this.personalTitle,
    required this.lblFullName,
    required this.lblPhone,
    required this.lblEmail,
    required this.lblDob,
    required this.lblGender,
    required this.lblBloodGroup,
    required this.lblFather,
    required this.lblState,
    required this.lblAddress,
    required this.linkedTitle,
    required this.syncAll,
    required this.syncing,
    required this.lblLinked,
    required this.securityTitle,
    required this.twoFactorTitle,
    required this.twoFactorDesc,
    required this.bioLockTitle,
    required this.bioLockDesc,
    required this.consentTitle,
    required this.revoke,
    required this.preferencesTitle,
    required this.portalLanguage,
    required this.alertsTitle,
    required this.whatsappAlerts,
    required this.smsAlerts,
    required this.exportData,
  });

  static AppStrings of(BuildContext context) {
    return getStrings(appLanguageNotifier.value);
  }

  static AppStrings getStrings(String code) {
    switch (code) {
      case 'hi':
        return _hindi;
      case 'pa':
        return _punjabi;
      case 'en':
      default:
        return _english;
    }
  }

  static const _english = AppStrings(
    brandName: 'DocuSewa',
    brandTagline: 'Citizen Services & Document Portal',
    verifiedCitizen: 'Verified 🇮🇳',
    verifiedAccount: '✓ Verified Citizen Account',
    searchPlaceholder: 'Search exam admit cards, IDs, certificates…',
    signOut: 'Sign Out from DocuSewa',
    close: 'Close',
    cancel: 'Cancel',
    saveChanges: 'Save Changes',
    editDetails: 'Edit Details',

    navHome: 'Home',
    navDocs: 'Documents',
    navExams: 'Exams',
    navProfile: 'Profile',

    identityDocsTitle: 'Identity & Official Records',
    identityDocsBadge: 'Services',
    examsTitle: 'Exams & Education',
    examsBadge: 'Boards',
    financeTitle: 'Finance & Welfare',
    financeBadge: 'Services',
    directPortals: 'Direct Portals',
    admitCardsBadge: 'Admit Cards & Results',
    bankingBadge: 'Banking & Welfare',

    visitSite: 'Visit Site',
    fetchDocument: 'Fetch Document',
    pullingDoc: 'Fetching document...',
    done: 'Done',
    docIssuedSuccess: 'Document Saved Successfully!',
    docIssuedDesc: 'Your document has been securely saved to your citizen vault.',
    requiredDetails: 'Required Verification Details:',
    officialPortal: 'Direct Official Portal',
    viewInVault: 'View in Vault',

    vaultTitle: 'Saved Citizen Vault',
    vaultSubtitle: 'Encrypted digital certificates and verified documents from public portals',
    docNumber: 'DOCUMENT NO',
    docStatus: 'STATUS',
    viewDoc: 'View Document',
    downloadDoc: 'Download PDF',
    verifiedBadge: '● Verified',

    citizenPass: 'DocuSewa Citizen Pass',
    govtOfIndia: 'DOCUSEWA CITIZEN CARD',
    digilockerVerified: 'VERIFIED CITIZEN',
    copyId: 'Copy ID',
    downloadPass: 'Download Card',
    copiedId: 'Copied Citizen ID to clipboard!',
    aadhaarSeeded: 'AADHAAR VERIFIED',
    panNumber: 'PAN',
    vaultRecords: 'VAULT',
    securityStatus: 'SECURITY',
    secHigh: '● 2FA Active',

    tabDigitalPass: '🪪 Digital Pass',
    tabPersonalKYC: '👤 Personal & KYC',
    tabLinkedPortals: '🔗 Linked Portals',
    tabSecurity: '🛡️ Security',
    tabSettings: '⚙️ Settings',

    personalTitle: 'Citizen Profile Records',
    lblFullName: 'Full Legal Name',
    lblPhone: 'Registered Mobile',
    lblEmail: 'Email Address',
    lblDob: 'Date of Birth',
    lblGender: 'Gender',
    lblBloodGroup: 'Blood Group',
    lblFather: 'Father / Guardian',
    lblState: 'State / Domicile',
    lblAddress: 'Residence Address',

    linkedTitle: 'Connected Department Portals',
    syncAll: 'Sync All',
    syncing: 'Syncing...',
    lblLinked: '● Linked',

    securityTitle: 'Security & Privacy Protection',
    twoFactorTitle: 'Two-Factor Authentication (2FA)',
    twoFactorDesc: 'Require OTP for every document pull',
    bioLockTitle: 'Biometric Access Lock',
    bioLockDesc: 'Prevent unauthorized access attempts',
    consentTitle: 'Active Portal Sharing & Authorizations',
    revoke: 'Revoke',

    preferencesTitle: 'Citizen Preferences',
    portalLanguage: 'Portal Language',
    alertsTitle: 'Expiry & Renewal Alerts',
    whatsappAlerts: 'WhatsApp alerts for Licence & Admit Cards',
    smsAlerts: 'SMS alerts on registered mobile',
    exportData: 'Export Citizen Data Archive',
  );

  static const _hindi = AppStrings(
    brandName: 'दस्तावेज़ सेवा (DocuSewa)',
    brandTagline: 'नागरिक सेवा एवं दस्तावेज़ पोर्टल',
    verifiedCitizen: 'सत्यापित 🇮🇳',
    verifiedAccount: '✓ सत्यापित नागरिक खाता',
    searchPlaceholder: 'परीक्षा प्रवेश पत्र, पहचान पत्र, प्रमाण पत्र खोजें…',
    signOut: 'DocuSewa से साइन आउट करें',
    close: 'बंद करें',
    cancel: 'रद्द करें',
    saveChanges: 'परिवर्तन सहेजें',
    editDetails: 'विवरण संपादित करें',

    navHome: 'होम',
    navDocs: 'दस्तावेज़',
    navExams: 'परीक्षाएं',
    navProfile: 'प्रोफ़ाइल',

    identityDocsTitle: 'पहचान एवं आधिकारिक रिकॉर्ड',
    identityDocsBadge: 'सेवाएं',
    examsTitle: 'परीक्षाएं एवं शिक्षा बोर्ड',
    examsBadge: 'बोर्ड्स',
    financeTitle: 'वित्तीय एवं कल्याण सेवाएं',
    financeBadge: 'सेवाएं',
    directPortals: 'सीधे पोर्टल',
    admitCardsBadge: 'प्रवेश पत्र एवं परिणाम',
    bankingBadge: 'बैंकिंग एवं कल्याण',

    visitSite: 'साइट खोलें',
    fetchDocument: 'दस्तावेज़ प्राप्त करें',
    pullingDoc: 'दस्तावेज़ प्राप्त किया जा रहा है...',
    done: 'पूर्ण',
    docIssuedSuccess: 'दस्तावेज़ सुरक्षित सहेजा गया!',
    docIssuedDesc: 'आपका दस्तावेज़ सीधे आपके नागरिक वॉल्ट में जोड़ दिया गया है।',
    requiredDetails: 'आवश्यक सत्यापन विवरण:',
    officialPortal: 'सीधा आधिकारिक पोर्टल',
    viewInVault: 'वॉल्ट में देखें',

    vaultTitle: 'सुरक्षित नागरिक वॉल्ट',
    vaultSubtitle: 'सार्वजनिक पोर्टलों से प्राप्त एन्क्रिप्टेड डिजिटल प्रमाण पत्र एवं दस्तावेज़',
    docNumber: 'दस्तावेज़ संख्या',
    docStatus: 'स्थिति',
    viewDoc: 'दस्तावेज़ देखें',
    downloadDoc: 'पीडीएफ डाउनलोड करें',
    verifiedBadge: '● सत्यापित',

    citizenPass: 'दस्तावेज़ सेवा नागरिक पास',
    govtOfIndia: 'दस्तावेज़ सेवा नागरिक कार्ड',
    digilockerVerified: 'सत्यापित नागरिक',
    copyId: 'आईडी कॉपी करें',
    downloadPass: 'कार्ड डाउनलोड करें',
    copiedId: 'नागरिक आईडी क्लिपबोर्ड पर कॉपी हो गई!',
    aadhaarSeeded: 'आधार सत्यापित',
    panNumber: 'पैन संख्या',
    vaultRecords: 'वॉल्ट',
    securityStatus: 'सुरक्षा',
    secHigh: '● 2FA सक्रिय',

    tabDigitalPass: '🪪 डिजिटल पास',
    tabPersonalKYC: '👤 व्यक्तिगत एवं केवाईसी',
    tabLinkedPortals: '🔗 जुड़े हुए पोर्टल',
    tabSecurity: '🛡️ सुरक्षा',
    tabSettings: '⚙️ सेटिंग्स',

    personalTitle: 'नागरिक प्रोफ़ाइल रिकॉर्ड',
    lblFullName: 'पूरा कानूनी नाम',
    lblPhone: 'पंजीकृत मोबाइल',
    lblEmail: 'ईमेल पता',
    lblDob: 'जन्म तिथि',
    lblGender: 'लिंग',
    lblBloodGroup: 'रक्त समूह',
    lblFather: 'पिता / अभिभावक',
    lblState: 'राज्य / मूल निवास',
    lblAddress: 'स्थायी निवास पता',

    linkedTitle: 'जुड़े हुए विभाग पोर्टल',
    syncAll: 'सभी सिंक करें',
    syncing: 'सिंक हो रहा है...',
    lblLinked: '● जुड़ा हुआ',

    securityTitle: 'सुरक्षा एवं गोपनीयता संरक्षण',
    twoFactorTitle: 'दो-चरणीय प्रमाणीकरण (2FA)',
    twoFactorDesc: 'प्रत्येक दस्तावेज़ प्राप्ति के लिए ओटीपी आवश्यक',
    bioLockTitle: 'बायोमेट्रिक सुरक्षा लॉक',
    bioLockDesc: 'अनधिकृत पहुंच प्रयासों को रोकें',
    consentTitle: 'सक्रिय पोर्टल प्राधिकरण एवं सहमति',
    revoke: 'निरस्त करें',

    preferencesTitle: 'नागरिक प्राथमिकताएं',
    portalLanguage: 'पोर्टल भाषा',
    alertsTitle: 'नवीनीकरण एवं प्रवेश पत्र अलर्ट',
    whatsappAlerts: 'ड्राइविंग लाइसेंस एवं प्रवेश पत्र हेतु व्हाट्सएप अलर्ट',
    smsAlerts: 'पंजीकृत मोबाइल पर एसएमएस अलर्ट',
    exportData: 'नागरिक डेटा बैकअप निर्यात करें (JSON)',
  );

  static const _punjabi = AppStrings(
    brandName: 'ਦਸਤਾਵੇਜ਼ ਸੇਵਾ (DocuSewa)',
    brandTagline: 'ਨਾਗਰਿਕ ਸੇਵਾਵਾਂ ਅਤੇ ਦਸਤਾਵੇਜ਼ ਪੋਰਟਲ',
    verifiedCitizen: 'ਪ੍ਰਮਾਣਿਤ 🇮🇳',
    verifiedAccount: '✓ ਪ੍ਰਮਾਣਿਤ ਨਾਗਰਿਕ ਖਾਤਾ',
    searchPlaceholder: 'ਇਮਤਿਹਾਨ ਐਡਮਿਟ ਕਾਰਡ, ਪਛਾਣ ਪੱਤਰ, ਸਰਟੀਫਿਕੇਟ ਖੋਜੋ…',
    signOut: 'DocuSewa ਤੋਂ ਸਾਈਨ ਆਊਟ ਕਰੋ',
    close: 'ਬੰਦ ਕਰੋ',
    cancel: 'ਰੱਦ ਕਰੋ',
    saveChanges: 'ਤਬਦੀਲੀਆਂ ਸੰਭਾਲੋ',
    editDetails: 'ਵੇਰਵੇ ਸੋਧੋ',

    navHome: 'ਹੋਮ',
    navDocs: 'ਦਸਤਾਵੇਜ਼',
    navExams: 'ਪ੍ਰੀਖਿਆਵਾਂ',
    navProfile: 'ਪ੍ਰੋਫਾਈਲ',

    identityDocsTitle: 'ਪਛਾਣ ਅਤੇ ਅਧਿਕਾਰਤ ਰਿਕਾਰਡ',
    identityDocsBadge: 'ਸੇਵਾਵਾਂ',
    examsTitle: 'ਪ੍ਰੀਖਿਆਵਾਂ ਅਤੇ ਸਿੱਖਿਆ ਬੋਰਡ',
    examsBadge: 'ਬੋਰਡ',
    financeTitle: 'ਵਿੱਤੀ ਅਤੇ ਭਲਾਈ ਸੇਵਾਵਾਂ',
    financeBadge: 'ਸੇਵਾਵਾਂ',
    directPortals: 'ਸਿੱਧੇ ਪੋਰਟਲ',
    admitCardsBadge: 'ਐਡਮਿਟ ਕਾਰਡ ਅਤੇ ਨਤੀਜੇ',
    bankingBadge: 'ਬੈਂਕਿੰਗ ਅਤੇ ਭਲਾਈ',

    visitSite: 'ਸਾਈਟ ਖੋਲ੍ਹੋ',
    fetchDocument: 'ਦਸਤਾਵੇਜ਼ ਪ੍ਰਾਪਤ ਕਰੋ',
    pullingDoc: 'ਦਸਤਾਵੇਜ਼ ਲਿਆਇਆ ਜਾ ਰਿਹਾ ਹੈ...',
    done: 'ਮੁਕੰਮਲ',
    docIssuedSuccess: 'ਦਸਤਾਵੇਜ਼ ਸੁਰੱਖਿਅਤ ਕੀਤਾ ਗਿਆ!',
    docIssuedDesc: 'ਤੁਹਾਡਾ ਦਸਤਾਵੇਜ਼ ਸਿੱਧਾ ਵਾਲਟ ਵਿੱਚ ਸ਼ਾਮਲ ਹੋ ਗਿਆ ਹੈ।',
    requiredDetails: 'ਲੋੜੀਂਦੇ ਵੇਰਵੇ:',
    officialPortal: 'ਸਿੱਧਾ ਅਧਿਕਾਰਤ ਪੋਰਟਲ',
    viewInVault: 'ਵਾਲਟ ਵਿੱਚ ਦੇਖੋ',

    vaultTitle: 'ਸੁਰੱਖਿਅਤ ਨਾਗਰਿਕ ਵਾਲਟ',
    vaultSubtitle: 'ਪਬਲਿਕ ਪੋਰਟਲਾਂ ਤੋਂ ਪ੍ਰਾਪਤ ਐਨਕ੍ਰਿਪਟਡ ਡਿਜੀਟਲ ਸਰਟੀਫਿਕੇਟ',
    docNumber: 'ਦਸਤਾਵੇਜ਼ ਨੰਬਰ',
    docStatus: 'ਸਥਿਤੀ',
    viewDoc: 'ਦਸਤਾਵੇਜ਼ ਦੇਖੋ',
    downloadDoc: 'ਪੀਡੀਐਫ ਡਾਊਨਲੋਡ ਕਰੋ',
    verifiedBadge: '● ਪ੍ਰਮਾਣਿਤ',

    citizenPass: 'ਦਸਤਾਵੇਜ਼ ਸੇਵਾ ਨਾਗਰਿਕ ਪਾਸ',
    govtOfIndia: 'ਦਸਤਾਵੇਜ਼ ਸੇਵਾ ਨਾਗਰਿਕ ਕਾਰਡ',
    digilockerVerified: 'ਪ੍ਰਮਾਣਿਤ ਨਾਗਰਿਕ',
    copyId: 'ਆਈਡੀ ਕਾਪੀ ਕਰੋ',
    downloadPass: 'ਕਾਰਡ ਡਾਊਨਲੋਡ ਕਰੋ',
    copiedId: 'ਨਾਗਰਿਕ ਆਈਡੀ ਕਾਪੀ ਹੋ ਗਈ!',
    aadhaarSeeded: 'ਆਧਾਰ ਪ੍ਰਮਾਣਿਤ',
    panNumber: 'ਪੈਨ ਨੰਬਰ',
    vaultRecords: 'ਵਾਲਟ',
    securityStatus: 'ਸੁਰੱਖਿਆ',
    secHigh: '● 2FA ਸਰਗਰਮ',

    tabDigitalPass: '🪪 ਡਿਜੀਟਲ ਪਾਸ',
    tabPersonalKYC: '👤 ਨਿੱਜੀ ਅਤੇ ਕੇਵਾਈਸੀ',
    tabLinkedPortals: '🔗 ਜੁੜੇ ਹੋਏ ਪੋਰਟਲ',
    tabSecurity: '🛡️ ਸੁਰੱਖਿਆ',
    tabSettings: '⚙️ ਸੈਟਿੰਗਾਂ',

    personalTitle: 'ਨਾਗਰਿਕ ਪ੍ਰੋਫਾਈਲ ਰਿਕਾਰਡ',
    lblFullName: 'ਪੂਰਾ ਕਾਨੂੰਨੀ ਨਾਮ',
    lblPhone: 'ਰਜਿਸਟਰਡ ਮੋਬਾਈਲ',
    lblEmail: 'ਈਮੇਲ ਪਤਾ',
    lblDob: 'ਜਨਮ ਮਿਤੀ',
    lblGender: 'ਲਿੰਗ',
    lblBloodGroup: 'ਬਲੱਡ ਗਰੁੱਪ',
    lblFather: 'ਪਿਤਾ / ਸਰਪ੍ਰਸਤ',
    lblState: 'ਰਾਜ / ਮੂਲ ਨਿਵਾਸ',
    lblAddress: 'ਪੱਕਾ ਰਿਹਾਇਸ਼ੀ ਪਤਾ',

    linkedTitle: 'ਜੁੜੇ ਹੋਏ ਵਿਭਾਗ ਪੋਰਟਲ',
    syncAll: 'ਸਾਰੇ ਸਿੰਕ ਕਰੋ',
    syncing: 'ਸਿੰਕ ਹੋ ਰਿਹਾ ਹੈ...',
    lblLinked: '● ਜੁੜਿਆ ਹੋਇਆ',

    securityTitle: 'ਸੁਰੱਖਿਆ ਅਤੇ ਗੋਪਨੀਯਤਾ ਸੁਰੱਖਿਆ',
    twoFactorTitle: 'ਦੋ-ਪੜਾਵੀ ਪ੍ਰਮਾਣੀਕਰਨ (2FA)',
    twoFactorDesc: 'ਹਰੇਕ ਦਸਤਾਵੇਜ਼ ਲਈ ਓਟੀਪੀ ਲਾਜ਼ਮੀ',
    bioLockTitle: 'ਬਾਇਓਮੈਟ੍ਰਿਕ ਸੁਰੱਖਿਆ ਲਾਕ',
    bioLockDesc: 'ਅਣਅਧਿਕਾਰਤ ਪਹੁੰਚ ਰੋਕੋ',
    consentTitle: 'ਸਰਗਰਮ ਪੋਰਟਲ ਅਧਿਕਾਰ ਅਤੇ ਸਹਿਮਤੀ',
    revoke: 'ਰੱਦ ਕਰੋ',

    preferencesTitle: 'ਨਾਗਰਿਕ ਤਰਜੀਹਾਂ',
    portalLanguage: 'ਪੋਰਟਲ ਭਾਸ਼ਾ',
    alertsTitle: 'ਨਵਿਆਉਣ ਅਤੇ ਐਡਮਿਟ ਕਾਰਡ ਅਲਰਟ',
    whatsappAlerts: 'ਲਾਇਸੈਂਸ ਅਤੇ ਐਡਮਿਟ ਕਾਰਡਾਂ ਲਈ ਵਟਸਐਪ ਅਲਰਟ',
    smsAlerts: 'ਰਜਿਸਟਰਡ ਮੋਬਾਈਲ ਤੇ ਐਸਐਮਐਸ ਅਲਰਟ',
    exportData: 'ਨਾਗਰਿਕ ਡੇਟਾ ਬੈਕਅੱਪ (JSON)',
  );
}

class ServiceTranslator {
  static String getServiceName(String id, String langCode) {
    if (langCode == 'hi') {
      switch (id) {
        case 'pan-card': return 'आयकर विभाग (Income Tax)';
        case 'voter-id': return 'भारतीय चुनाव आयोग (ECI)';
        case 'uidai-aadhaar': return 'भारतीय विशिष्ट पहचान प्राधिकरण (UIDAI)';
        case 'morth-dl': return 'सड़क परिवहन एवं राजमार्ग मंत्रालय';
        case 'pmjay-health': return 'राष्ट्रीय स्वास्थ्य प्राधिकरण (NHA)';
        case 'mea-passport': return 'विदेश मंत्रालय (Passport Seva)';
        case 'nfsa-pds': return 'खाद्य एवं सार्वजनिक वितरण विभाग';
        case 'revenue-dept': return 'भूमि संसाधन एवं राजस्व विभाग';
        case 'upsc-exam': return 'संघ लोक सेवा आयोग (UPSC)';
        case 'ssc-exam': return 'कर्मचारी चयन आयोग (SSC)';
        case 'nta-testing': return 'राष्ट्रीय परीक्षा एजेंसी (NTA)';
        case 'rrb-railway': return 'रेलवे भर्ती नियंत्रण बोर्ड (RRB)';
        case 'ibps-bank': return 'बैंकिंग कार्मिक चयन संस्थान (IBPS)';
        case 'cbse-board': return 'केंद्रीय माध्यमिक शिक्षा बोर्ड (CBSE)';
        case 'ugc-net': return 'विश्वविद्यालय अनुदान आयोग (UGC-NET)';
        case 'state-psc': return 'राज्य लोक सेवा आयोग';
        case 'epfo-uan': return 'कर्मचारी भविष्य निधि संगठन (EPFO)';
        case 'lic-insurance': return 'भारतीय जीवन बीमा निगम (LIC)';
        case 'sbi-bank': return 'भारतीय स्टेट बैंक (SBI)';
        default: return id;
      }
    } else if (langCode == 'pa') {
      switch (id) {
        case 'pan-card': return 'ਇਨਕਮ ਟੈਕਸ ਵਿਭਾਗ (Income Tax)';
        case 'voter-id': return 'ਭਾਰਤ ਚੋਣ ਕਮਿਸ਼ਨ (ECI)';
        case 'uidai-aadhaar': return 'ਵਿਲੱਖਣ ਪਛਾਣ ਅਥਾਰਟੀ (UIDAI)';
        case 'morth-dl': return 'ਸੜਕ ਆਵਾਜਾਈ ਅਤੇ ਰਾਜਮਾਰਗ ਮੰਤਰਾਲਾ';
        case 'pmjay-health': return 'ਰਾਸ਼ਟਰੀ ਸਿਹਤ ਅਥਾਰਟੀ (NHA)';
        case 'mea-passport': return 'ਵਿਦੇਸ਼ ਮੰਤਰਾਲਾ (Passport Seva)';
        case 'nfsa-pds': return 'ਖੁਰਾਕ ਅਤੇ ਜਨਤਕ ਵੰਡ ਵਿਭਾਗ';
        case 'revenue-dept': return 'ਜ਼ਮੀਨੀ ਸਰੋਤ ਅਤੇ ਮਾਲ ਵਿਭਾਗ';
        case 'upsc-exam': return 'ਯੂਨੀਅਨ ਲੋਕ ਸੇਵਾ ਕਮਿਸ਼ਨ (UPSC)';
        case 'ssc-exam': return 'ਸਟਾਫ ਸਿਲੈਕਸ਼ਨ ਕਮਿਸ਼ਨ (SSC)';
        case 'nta-testing': return 'ਨੈਸ਼ਨਲ ਟੈਸਟਿੰਗ ਏਜੰਸੀ (NTA)';
        case 'rrb-railway': return 'ਰੇਲਵੇ ਭਰਤੀ ਕੰਟਰੋਲ ਬੋਰਡ (RRB)';
        case 'ibps-bank': return 'ਬੈਂਕਿੰਗ ਕਰਮਚਾਰੀ ਚੋਣ ਸੰਸਥਾ (IBPS)';
        case 'cbse-board': return 'ਕੇਂਦਰੀ ਸੈਕੰਡਰੀ ਸਿੱਖਿਆ ਬੋਰਡ (CBSE)';
        case 'ugc-net': return 'ਯੂਨੀਵਰਸਿਟੀ ਗ੍ਰਾਂਟਸ ਕਮਿਸ਼ਨ (UGC-NET)';
        case 'state-psc': return 'ਰਾਜ ਲੋਕ ਸੇਵਾ ਕਮਿਸ਼ਨ';
        case 'epfo-uan': return 'ਕਰਮਚਾਰੀ ਭਵਿੱਖ ਨਿਧੀ ਸੰਗਠਨ (EPFO)';
        case 'lic-insurance': return 'ਲਾਈਫ ਇੰਸ਼ੋਰੈਂਸ ਕਾਰਪੋਰੇਸ਼ਨ ਆਫ ਇੰਡੀਆ (LIC)';
        case 'sbi-bank': return 'ਸਟੇਟ ਬੈਂਕ ਆਫ਼ ਇੰਡੀਆ (SBI)';
        default: return id;
      }
    } else {
      switch (id) {
        case 'pan-card': return 'Income Tax Department (ITD)';
        case 'voter-id': return 'Election Commission of India (ECI)';
        case 'uidai-aadhaar': return 'UIDAI (Aadhaar Portal)';
        case 'morth-dl': return 'Ministry of Road Transport (Parivahan)';
        case 'pmjay-health': return 'National Health Authority (NHA)';
        case 'mea-passport': return 'Passport Seva (MEA)';
        case 'nfsa-pds': return 'Dept of Food & Public Distribution';
        case 'revenue-dept': return 'Department of Land Resources & Revenue';
        case 'upsc-exam': return 'Union Public Service Commission (UPSC)';
        case 'ssc-exam': return 'Staff Selection Commission (SSC)';
        case 'nta-testing': return 'National Testing Agency (NTA)';
        case 'rrb-railway': return 'Railway Recruitment Control Board (RRB)';
        case 'ibps-bank': return 'Institute of Banking Personnel Selection (IBPS)';
        case 'cbse-board': return 'Central Board of Sec. Education (CBSE)';
        case 'ugc-net': return 'University Grants Commission (UGC-NET)';
        case 'state-psc': return 'State Public Service Commissions';
        case 'epfo-uan': return 'Employees Provident Fund (EPFO)';
        case 'lic-insurance': return 'Life Insurance Corp. (LIC)';
        case 'sbi-bank': return 'State Bank of India (SBI)';
        default: return id;
      }
    }
  }

  static String getServiceDoc(String id, String langCode) {
    if (langCode == 'hi') {
      switch (id) {
        case 'pan-card': return 'पैन सत्यापन रिकॉर्ड (e-PAN)';
        case 'voter-id': return 'मतदाता फोटो पहचान पत्र (e-EPIC)';
        case 'uidai-aadhaar': return 'आधार डिजिटल प्रति';
        case 'morth-dl': return 'ड्राइविंग लाइसेंस एवं वाहन आर.सी.';
        case 'pmjay-health': return 'आयुष्मान भारत आभा कार्ड (₹5 लाख सुरक्षा)';
        case 'mea-passport': return 'पासपोर्ट सत्यापन एवं पीसीसी';
        case 'nfsa-pds': return 'पारिवारिक राशन कार्ड';
        case 'revenue-dept': return 'आय, जाति एवं निवास प्रमाण पत्र';
        case 'upsc-exam': return 'ई-प्रवेश पत्र एवं अंतिम चयन अंकतालिका';
        case 'ssc-exam': return 'परीक्षा हॉल टिकट एवं स्कोर कार्ड';
        case 'nta-testing': return 'एनटीए एडमिट कार्ड एवं स्कोरकार्ड';
        case 'rrb-railway': return 'ई-कॉल लेटर एवं सीबीटी स्कोर';
        case 'ibps-bank': return 'कॉल लेटर एवं परिणाम विवरण';
        case 'cbse-board': return '10वीं व 12वीं डिजिटल मार्कशीट व प्रमाण पत्र';
        case 'ugc-net': return 'ई-प्रमाण पत्र एवं जेआरएफ अवार्ड पत्र';
        case 'state-psc': return 'राज्य पीएससी प्रवेश पत्र एवं साक्षात्कार पत्र';
        case 'epfo-uan': return 'यूएएन कार्ड एवं सदस्य पासबुक';
        case 'lic-insurance': return 'एलआईसी पॉलिसी दस्तावेज़';
        case 'sbi-bank': return 'खाता विवरण एवं पासबुक';
        default: return id;
      }
    } else if (langCode == 'pa') {
      switch (id) {
        case 'pan-card': return 'ਪੈਨ ਵੈਰੀਫਿਕੇਸ਼ਨ ਰਿਕਾਰਡ (e-PAN)';
        case 'voter-id': return 'ਵੋਟਰ ਫੋਟੋ ਸ਼ਨਾਖਤੀ ਕਾਰਡ (e-EPIC)';
        case 'uidai-aadhaar': return 'ਆਧਾਰ ਡਿਜੀਟਲ ਕਾਪੀ';
        case 'morth-dl': return 'ਡਰਾਈਵਿੰਗ ਲਾਇਸੈਂਸ ਅਤੇ ਵਾਹਨ ਆਰ.ਸੀ.';
        case 'pmjay-health': return 'ਆਯੁਸ਼ਮਾਨ ਭਾਰਤ ਆਭਾ ਕਾਰਡ (₹5 ਲੱਖ ਕਵਰ)';
        case 'mea-passport': return 'ਪਾਸਪੋਰਟ ਤਸਦੀਕ ਅਤੇ ਪੀ.ਸੀ.ਸੀ.';
        case 'nfsa-pds': return 'ਪਰਿਵਾਰਕ ਰਾਸ਼ਨ ਕਾਰਡ';
        case 'revenue-dept': return 'ਆਮਦਨ, ਜਾਤੀ ਅਤੇ ਰਿਹਾਇਸ਼ ਸਰਟੀਫਿਕੇਟ';
        case 'upsc-exam': return 'ਈ-ਐਡਮਿਟ ਕਾਰਡ ਅਤੇ ਮਾਰਕਸ਼ੀਟ';
        case 'ssc-exam': return 'ਇਮਤਿਹਾਨ ਹਾਲ ਟਿਕਟ ਅਤੇ ਸਕੋਰ ਕਾਰਡ';
        case 'nta-testing': return 'ਐਨਟੀਏ ਐਡਮਿਟ ਕਾਰਡ ਅਤੇ ਅਧਿਕਾਰਤ ਸਕੋਰਕਾਰਡ';
        case 'rrb-railway': return 'ਈ-ਕਾਲ ਲੈਟਰ ਅਤੇ ਸੀਬੀਟੀ ਸਕੋਰ';
        case 'ibps-bank': return 'ਕਾਲ ਲੈਟਰ ਅਤੇ ਸੰਯੁਕਤ ਨਤੀਜਾ';
        case 'cbse-board': return '10ਵੀਂ ਅਤੇ 12ਵੀਂ ਡਿਜੀਟਲ ਮਾਰਕਸ਼ੀਟ';
        case 'ugc-net': return 'ਈ-ਸਰਟੀਫਿਕੇਟ ਅਤੇ ਜੇਆਰਐਫ ਅਵਾਰਡ ਪੱਤਰ';
        case 'state-psc': return 'ਸਟੇਟ ਪੀਐਸਸੀ ਐਡਮਿਟ ਕਾਰਡ ਅਤੇ ਇੰਟਰਵਿਊ ਕਾਲ';
        case 'epfo-uan': return 'ਯੂਏਐਨ ਕਾਰਡ ਅਤੇ ਮੈਂਬਰ ਪਾਸਬੁੱਕ';
        case 'lic-insurance': return 'ਐਲਆਈਸੀ ਪਾਲਿਸੀ ਦਸਤਾਵੇਜ਼';
        case 'sbi-bank': return 'ਖਾਤਾ ਸਟੇਟਮੈਂਟ ਅਤੇ ਪਾਸਬੁੱਕ';
        default: return id;
      }
    } else {
      switch (id) {
        case 'pan-card': return 'e-PAN Card Verification';
        case 'voter-id': return 'e-EPIC Voter Card';
        case 'uidai-aadhaar': return 'Digital Aadhaar Copy';
        case 'morth-dl': return 'Driving Licence & RC';
        case 'pmjay-health': return 'Ayushman Bharat ABHA Card';
        case 'mea-passport': return 'Passport Verification & PCC';
        case 'nfsa-pds': return 'Family Ration Card';
        case 'revenue-dept': return 'Income, Caste & Domicile Certificate';
        case 'upsc-exam': return 'e-Admit Card & Results';
        case 'ssc-exam': return 'Hall Ticket & Scorecard';
        case 'nta-testing': return 'JEE / NEET / CUET Admit Card';
        case 'rrb-railway': return 'E-Call Letter & CBT Score Summary';
        case 'ibps-bank': return 'Call Letter & Combined Result Record';
        case 'cbse-board': return '10th & 12th Marksheets';
        case 'ugc-net': return 'E-Certificate & JRF Award Letter';
        case 'state-psc': return 'State PSC Admit Card & Interview Call';
        case 'epfo-uan': return 'UAN Card & Member Passbook';
        case 'lic-insurance': return 'Policy Bonds & Premium Status';
        case 'sbi-bank': return 'Account Statement & Passbook';
        default: return id;
      }
    }
  }

  static String getServiceTag(String id, String langCode) {
    if (langCode == 'hi') {
      switch (id) {
        case 'pan-card':
        case 'uidai-aadhaar':
        case 'voter-id':
          return 'Identity';
        case 'morth-dl':
          return 'Transport';
        case 'upsc-exam':
          return 'Civil Services';
        case 'ssc-exam':
          return 'Central Exams';
        case 'nta-testing':
          return 'Entrance Exams';
        case 'cbse-board':
          return 'Board Results';
        case 'pmjay-health':
          return 'Health Insurance';
        case 'epfo-uan':
          return 'Pensions';
        case 'lic-insurance':
          return 'Insurance';
        case 'sbi-bank':
          return 'Banking';
        default:
          return 'Identity';
      }
    } else if (langCode == 'pa') {
      switch (id) {
        case 'pan-card':
        case 'uidai-aadhaar':
        case 'voter-id':
          return 'Identity';
        case 'morth-dl':
          return 'Transport';
        case 'upsc-exam':
          return 'Civil Services';
        case 'ssc-exam':
          return 'Central Exams';
        case 'nta-testing':
          return 'Entrance Exams';
        case 'cbse-board':
          return 'Board Results';
        case 'pmjay-health':
          return 'Health Insurance';
        case 'epfo-uan':
          return 'Pensions';
        case 'lic-insurance':
          return 'Insurance';
        case 'sbi-bank':
          return 'Banking';
        default:
          return 'Identity';
      }
    } else {
      switch (id) {
        case 'pan-card':
        case 'uidai-aadhaar':
        case 'voter-id':
          return 'Identity';
        case 'morth-dl':
          return 'Transport';
        case 'upsc-exam':
          return 'Civil Services';
        case 'ssc-exam':
          return 'Central Exams';
        case 'nta-testing':
          return 'Entrance Exams';
        case 'cbse-board':
          return 'Board Results';
        case 'pmjay-health':
          return 'Health Insurance';
        case 'epfo-uan':
          return 'Pensions';
        case 'lic-insurance':
          return 'Insurance';
        case 'sbi-bank':
          return 'Banking';
        case 'mea-passport':
          return 'Passport';
        case 'nfsa-pds':
          return 'Food Security';
        case 'revenue-dept':
          return 'Certificates';
        case 'rrb-railway':
          return 'Railways';
        case 'ibps-bank':
          return 'Banking';
        case 'ugc-net':
          return 'Research';
        case 'state-psc':
          return 'State Exams';
        default:
          return 'Portal';
      }
    }
  }

  static String getServiceState(String state, String langCode) {
    if (langCode == 'en') return state;

    final stateMap = {
      'Central Government': {'hi': 'केंद्र सरकार', 'pa': 'ਕੇਂਦਰ ਸਰਕਾਰ'},
      'All States': {'hi': 'समस्त राज्य एवं केंद्र शासित प्रदेश', 'pa': 'ਸਾਰੇ ਰਾਜ ਅਤੇ ਕੇਂਦਰ ਸ਼ਾਸਤ ਪ੍ਰਦੇਸ਼'},
      'State Governments': {'hi': 'राज्य सरकारें', 'pa': 'ਰਾਜ ਸਰਕਾਰਾਂ'},
      'MoRTH — Parivahan': {'hi': 'परिवहन सेवा (MoRTH)', 'pa': 'ਟਰਾਂਸਪੋਰਟ ਸੇਵਾ (MoRTH)'},
      'Ayushman Bharat PM-JAY': {'hi': 'आयुष्मान भारत पीएम-जय', 'pa': 'ਆਯੁਸ਼ਮਾਨ ਭਾਰਤ ਪੀਐਮ-ਜੇਏਵਾਈ'},
      'Passport Seva': {'hi': 'पासपोर्ट सेवा केंद्र', 'pa': 'ਪਾਸਪੋਰਟ ਸੇਵਾ ਕੇਂਦਰ'},
      'NFSA / PDS Portal': {'hi': 'खाद्य सुरक्षा पोर्टल', 'pa': 'ਖੁਰਾਕ ਸੁਰੱਖਿਆ ਪੋਰਟਲ'},
      'Civil Services / NDA / CDS': {'hi': 'सिविल सेवा / एनडीए / सीडीएस', 'pa': 'ਸਿਵਲ ਸੇਵਾਵਾਂ / ਐਨਡੀਏ / ਸੀਡੀਐਸ'},
      'CGL / CHSL / MTS / GD': {'hi': 'सीजीएल / सीएचएसएल / जीडी', 'pa': 'ਸੀਜੀਐਲ / ਸੀਐਚਐਸਐਲ / ਜੀਡੀ'},
      'JEE Main / NEET-UG / CUET': {'hi': 'जेईई मेन / नीट / सीयूईटी', 'pa': 'ਜੇਈਈ ਮੇਨ / ਨੀਟ / ਸੀਯੂਈਟੀ'},
      'NTPC / Group D / ALP Exams': {'hi': 'एनटीपीसी / ग्रुप डी परीक्षाएं', 'pa': 'ਐਨਟੀਪੀਸੀ / ਗਰੁੱਪ ਡੀ ਪ੍ਰੀਖਿਆਵਾਂ'},
      'PO / Clerk / Specialist Officer': {'hi': 'पीओ / क्लर्क / अधिकारी', 'pa': 'ਪੀਓ / ਕਲਰਕ / ਅਧਿਕਾਰੀ'},
      'CBSE / All India': {'hi': 'सीबीएसई / अखिल भारतीय', 'pa': 'ਸੀਬੀਐਸਈ / ਆਲ ਇੰਡੀਆ'},
      'National Eligibility & JRF': {'hi': 'राष्ट्रीय पात्रता परीक्षा / जेआरएफ', 'pa': 'ਰਾਸ਼ਟਰੀ ਯੋਗਤਾ ਪ੍ਰੀਖਿਆ / ਜੇਆਰਐਫ'},
      'State Administrative & Police Services': {'hi': 'राज्य प्रशासनिक व पुलिस सेवाएं', 'pa': 'ਰਾਜ ਪ੍ਰਸ਼ਾਸਕੀ ਤੇ ਪੁਲਿਸ ਸੇਵਾਵਾਂ'},
      'Ministry of Labour': {'hi': 'श्रम एवं रोजगार मंत्रालय', 'pa': 'ਕਿਰਤ ਅਤੇ ਰੁਜ਼ਗਾਰ ਮੰਤਰਾਲਾ'},
    };

    return stateMap[state]?[langCode] ?? state;
  }

  static String getRequiredDoc(String doc, String langCode) {
    if (langCode == 'en') return doc;

    final docMap = {
      'Aadhaar Card': {'hi': 'आधार कार्ड', 'pa': 'ਆਧਾਰ ਕਾਰਡ'},
      'Passport Photograph': {'hi': 'पासपोर्ट साइज फोटो', 'pa': 'ਪਾਸਪੋਰਟ ਸਾਈਜ਼ ਫੋਟੋ'},
      'Signature Proof': {'hi': 'हस्ताक्षर प्रमाण', 'pa': 'ਦਸਤਖਤ ਸਬੂਤ'},
      'Age Proof': {'hi': 'आयु प्रमाण पत्र', 'pa': 'ਉਮਰ ਦਾ ਸਬੂਤ'},
      'Address Proof': {'hi': 'निवास प्रमाण पत्र', 'pa': 'ਰਿਹਾਇਸ਼ੀ ਸਬੂਤ'},
      'Passport Photo': {'hi': 'पासपोर्ट फोटो', 'pa': 'ਪਾਸਪੋਰਟ ਫੋਟੋ'},
      'Registered Mobile OTP': {'hi': 'पंजीकृत मोबाइल ओटीपी', 'pa': 'ਰਜਿਸਟਰਡ ਮੋਬਾਈਲ ਓਟੀਪੀ'},
      'Aadhaar Number / VID': {'hi': 'आधार संख्या / वर्चुअल आईडी', 'pa': 'ਆਧਾਰ ਨੰਬਰ / ਵਰਚੁਅਲ ਆਈਡੀ'},
      'Form 1 Medical Declaration': {'hi': 'फॉर्म 1 मेडिकल घोषणा पत्र', 'pa': 'ਫਾਰਮ 1 ਮੈਡੀਕਲ ਘੋਸ਼ਣਾ ਪੱਤਰ'},
      'Blood Group': {'hi': 'रक्त समूह विवरण', 'pa': 'ਬਲੱਡ ਗਰੁੱਪ ਵੇਰਵਾ'},
      'Aadhaar Number': {'hi': 'आधार संख्या', 'pa': 'ਆਧਾਰ ਨੰਬਰ'},
      'Linked Mobile OTP': {'hi': 'आधार लिंक्ड मोबाइल ओटीपी', 'pa': 'ਆਧਾਰ ਲਿੰਕਡ ਮੋਬਾਈਲ ਓਟੀਪੀ'},
      'PAN Card': {'hi': 'पैन कार्ड', 'pa': 'ਪੈਨ ਕਾਰਡ'},
      'Bank Passbook': {'hi': 'बैंक पासबुक', 'pa': 'ਬੈਂਕ ਪਾਸਬੁੱਕ'},
      'Family Head Aadhaar': {'hi': 'परिवार के मुखिया का आधार', 'pa': 'ਪਰਿਵਾਰ ਦੇ ਮੁਖੀ ਦਾ ਆਧਾਰ'},
      'LPG Connection Bill': {'hi': 'एलपीजी गैस कनेक्शन रसीद', 'pa': 'ਐਲਪੀਜੀ ਗੈਸ ਕੁਨੈਕਸ਼ਨ ਰਸੀਦ'},
      'Income Proof': {'hi': 'आय प्रमाण पत्र', 'pa': 'ਆਮਦਨ ਸਰਟੀਫਿਕੇਟ'},
      'Salary Slip / ITR / Form 16': {'hi': 'वेतन पर्ची / आईटीआर / फॉर्म 16', 'pa': 'ਤਨਖਾਹ ਸਲਿੱਪ / ITR / ਫਾਰਮ 16'},
      'Ration Card': {'hi': 'राशन कार्ड', 'pa': 'ਰਾਸ਼ਨ ਕਾਰਡ'},
      'Self Declaration': {'hi': 'स्व-घोषणा पत्र', 'pa': 'ਸਵੈ-ਘੋਸ਼ਣਾ ਪੱਤਰ'},
      'Registration ID / Roll No.': {'hi': 'पंजीकरण संख्या / अनुक्रमांक', 'pa': 'ਰਜਿਸਟ੍ਰੇਸ਼ਨ ਆਈਡੀ / ਰੋਲ ਨੰਬਰ'},
      'Date of Birth': {'hi': 'जन्म तिथि', 'pa': 'ਜਨਮ ਮਿਤੀ'},
      'Aadhaar ID': {'hi': 'आधार पहचान पत्र', 'pa': 'ਆਧਾਰ ਪਛਾਣ ਪੱਤਰ'},
      'SSC Registration Number': {'hi': 'एसएससी पंजीकरण संख्या', 'pa': 'ਐਸਐਸਸੀ ਰਜਿਸਟ੍ਰੇਸ਼ਨ ਨੰਬਰ'},
      'Password / DOB': {'hi': 'पासवर्ड / जन्म तिथि', 'pa': 'ਪਾਸਵਰਡ / ਜਨਮ ਮਿਤੀ'},
      'Application Number': {'hi': 'आवेदन संख्या', 'pa': 'ਅਰਜ਼ੀ ਨੰਬਰ'},
      'Security PIN': {'hi': 'सुरक्षा पिन', 'pa': 'ਸੁਰੱਖਿਆ ਪਿੰਨ'},
      'Registration ID': {'hi': 'पंजीकरण संख्या', 'pa': 'ਰਜਿਸਟ੍ਰੇਸ਼ਨ ਆਈਡੀ'},
      'User Password / DOB': {'hi': 'उपयोगकर्ता पासवर्ड / जन्म तिथि', 'pa': 'ਯੂਜ਼ਰ ਪਾਸਵਰਡ / ਜਨਮ ਮਿਤੀ'},
      'Registration Number': {'hi': 'पंजीकरण संख्या', 'pa': 'ਰਜਿਸਟ੍ਰੇਸ਼ਨ ਨੰਬਰ'},
      'Roll Number & DOB': {'hi': 'रोल नंबर एवं जन्म तिथि', 'pa': 'ਰੋਲ ਨੰਬਰ ਅਤੇ ਜਨਮ ਮਿਤੀ'},
      'Roll Number': {'hi': 'रोल नंबर / अनुक्रमांक', 'pa': 'ਰੋਲ ਨੰਬਰ'},
      'Passing Year': {'hi': 'उत्तीर्ण होने का वर्ष', 'pa': 'ਪਾਸ ਹੋਣ ਦਾ ਸਾਲ'},
      'School Code': {'hi': 'स्कूल कोड', 'pa': 'ਸਕੂਲ ਕੋਡ'},
      'Exam Session': {'hi': 'परीक्षा सत्र', 'pa': 'ਪ੍ਰੀਖਿਆ ਸੈਸ਼ਨ'},
      'State OTR ID': {'hi': 'राज्य ओटीआर संख्या', 'pa': 'ਰਾਜ ਓਟੀਆਰ ਨੰਬਰ'},
      'Candidate Roll Number': {'hi': 'अभ्यर्थी रोल नंबर', 'pa': 'ਉਮੀਦਵਾਰ ਰੋਲ ਨੰਬਰ'},
      '12-Digit UAN': {'hi': '12-अंकीय यूएएन नंबर', 'pa': '12-ਅੰਕਾਂ ਵਾਲਾ ਯੂਏਐਨ ਨੰਬਰ'},
      'Aadhaar Linked Mobile OTP': {'hi': 'आधार लिंक्ड मोबाइल ओटीपी', 'pa': 'ਆਧਾਰ ਲਿੰਕਡ ਮੋਬਾਈਲ ਓਟੀਪੀ'},
      'Policy Number': {'hi': 'बीमा पॉलिसी संख्या', 'pa': 'ਬੀਮਾ ਪਾਲਿਸੀ ਨੰਬਰ'},
      'Registered Mobile Number': {'hi': 'पंजीकृत मोबाइल नंबर', 'pa': 'ਰਜਿਸਟਰਡ ਮੋਬਾਈਲ ਨੰਬਰ'},
      'Account Number': {'hi': 'बैंक खाता संख्या', 'pa': 'ਬੈਂਕ ਖਾਤਾ ਨੰਬਰ'},
    };

    return docMap[doc]?[langCode] ?? doc;
  }

  static String getVaultDocTitle(String type, String fallback, String langCode) {
    return getServiceDoc(type == 'uidai' ? 'uidai-aadhaar' : type == 'itd' ? 'pan-card' : type == 'morth' ? 'morth-dl' : type, langCode);
  }

  static String getVaultDocIssuer(String type, String fallback, String langCode) {
    return getServiceName(type == 'uidai' ? 'uidai-aadhaar' : type == 'itd' ? 'pan-card' : type == 'morth' ? 'morth-dl' : type, langCode);
  }

  static String getVaultDocDate(String date, String langCode) {
    if (langCode == 'hi') {
      return date.replaceAll('Issued', 'जारी').replaceAll('Valid till', 'वैधता').replaceAll('Issued Just Now', 'अभी जारी किया गया');
    } else if (langCode == 'pa') {
      return date.replaceAll('Issued', 'ਜਾਰੀ ਕੀਤਾ').replaceAll('Valid till', 'ਮਿਆਦ').replaceAll('Issued Just Now', 'ਹੁਣੇ ਜਾਰੀ ਕੀਤਾ ਗਿਆ');
    }
    return date;
  }
}
