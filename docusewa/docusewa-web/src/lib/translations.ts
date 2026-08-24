export type Language = 'en' | 'hi' | 'pa';

export interface TranslationDict {
  // Header & Brand
  brandName: string;
  brandTagline: string;
  govBadge: string;
  verifiedCitizen: string;
  verifiedAccount: string;
  searchPlaceholder: string;
  signOut: string;
  close: string;
  cancel: string;
  saveChanges: string;
  editProfile: string;

  // Categories
  allServices: string;
  govtDocs: string;
  govtExams: string;
  issuedVault: string;
  citizenProfile: string;

  // Sections
  identityDocsTitle: string;
  identityDocsBadge: string;
  directPortals: string;
  examsTitle: string;
  examsBadge: string;
  admitCardsBadge: string;
  financeTitle: string;
  financeBadge: string;
  bankingBadge: string;

  // Vault
  vaultTitle: string;
  vaultSubtitle: string;
  docNumber: string;
  docStatus: string;
  viewDoc: string;
  downloadDoc: string;
  verifiedBadge: string;

  // Modal / Fetch
  docIssuedSuccess: string;
  docIssuedDesc: string;
  viewInVault: string;
  officialPortal: string;
  visitSite: string;
  requiredDetails: string;
  fetchDocument: string;
  pullingDoc: string;

  // Profile - Top Banner
  citizenOfIndia: string;
  citizenId: string;
  kycTier: string;
  syncGateway: string;
  syncing: string;
  aadhaarSeeded: string;
  panNumber: string;
  vaultRecords: string;
  securityStatus: string;
  secHigh: string;

  // Profile - Tabs
  tabDigitalPass: string;
  tabPersonalKYC: string;
  tabLinkedPortals: string;
  tabSecurity: string;
  tabPreferences: string;

  // Profile - DigiCard
  govtOfIndia: string;
  citizenPass: string;
  digilockerVerified: string;
  cardName: string;
  cardDob: string;
  cardGender: string;
  cardCitizenId: string;
  copyId: string;
  downloadPass: string;
  copied: string;
  trustBadgesTitle: string;
  trustDigiLocker: string;
  trustDigiLockerDesc: string;
  trustAadhaar: string;
  trustAadhaarDesc: string;
  trustGovt: string;
  trustGovtDesc: string;

  // Profile - Personal Details
  personalTitle: string;
  personalSubtitle: string;
  lblFullName: string;
  lblPhone: string;
  lblEmail: string;
  lblDobGender: string;
  lblBloodGroup: string;
  lblFather: string;
  lblAddress: string;

  // Profile - Linked Accounts
  linkedTitle: string;
  linkedSubtitle: string;
  syncAllPortals: string;
  lblLinked: string;
  reverify: string;
  manage: string;

  // Profile - Security
  securityTitle: string;
  securitySubtitle: string;
  twoFactorTitle: string;
  twoFactorDesc: string;
  bioLockTitle: string;
  bioLockDesc: string;
  consentTitle: string;
  revokeAccess: string;
  authorized: string;
  revoked: string;

  // Profile - Preferences
  preferencesTitle: string;
  preferencesSubtitle: string;
  portalLanguage: string;
  alertsTitle: string;
  whatsappAlerts: string;
  smsAlerts: string;
  dataPortability: string;
  dataPortabilityDesc: string;
  exportData: string;

  // Services Names & Types
  itdName: string;
  itdDoc: string;
  eciName: string;
  eciDoc: string;
  uidaiName: string;
  uidaiDoc: string;
  morthName: string;
  morthDoc: string;
  pmjayName: string;
  pmjayDoc: string;
  meaName: string;
  meaDoc: string;
  pdsName: string;
  pdsDoc: string;
  revenueName: string;
  revenueDoc: string;
  upscName: string;
  upscDoc: string;
  sscName: string;
  sscDoc: string;
  ntaName: string;
  ntaDoc: string;
  rrbName: string;
  rrbDoc: string;
  ibpsName: string;
  ibpsDoc: string;
  cbseName: string;
  cbseDoc: string;
  ugcName: string;
  ugcDoc: string;
  pscName: string;
  pscDoc: string;
  epfoName: string;
  epfoDoc: string;
  licName: string;
  licDoc: string;
  sbiName: string;
  sbiDoc: string;
}

export const translations: Record<Language, TranslationDict> = {
  en: {
    brandName: 'DocuSewa',
    brandTagline: 'Citizen Services & Document Portal',
    govBadge: 'PORTAL',
    verifiedCitizen: 'Verified 🇮🇳',
    verifiedAccount: '✓ Verified Citizen Account',
    searchPlaceholder: 'Search exam admit cards, IDs, certificates, boards...',
    signOut: 'Sign Out from DocuSewa',
    close: 'Close',
    cancel: 'Cancel',
    saveChanges: 'Save Changes',
    editProfile: 'Edit Profile',

    allServices: 'All Services',
    govtDocs: '📄 Official Documents',
    govtExams: '🎓 Exams & Boards',
    issuedVault: '📁 Citizen Vault',
    citizenProfile: '👤 Citizen Profile',

    identityDocsTitle: 'Identity & Official Records',
    identityDocsBadge: 'Services',
    directPortals: 'Direct Portals',
    examsTitle: 'Exams & Education',
    examsBadge: 'Boards',
    admitCardsBadge: 'Admit Cards & Results',
    financeTitle: 'Finance & Welfare',
    financeBadge: 'Services',
    bankingBadge: 'Banking & Insurance',

    vaultTitle: '📁 Saved Citizen Vault',
    vaultSubtitle: 'Encrypted digital certificates and verified documents from public portals',
    docNumber: 'DOC NUMBER',
    docStatus: 'STATUS',
    viewDoc: 'View',
    downloadDoc: 'Download',
    verifiedBadge: '✓ Verified',

    docIssuedSuccess: 'Document Saved Successfully!',
    docIssuedDesc: 'Your document has been pulled and securely saved to your citizen vault.',
    viewInVault: 'View in Vault',
    officialPortal: 'Direct Official Portal',
    visitSite: 'Visit Site',
    requiredDetails: 'Required Verification Details:',
    fetchDocument: 'Fetch Document',
    pullingDoc: 'Pulling Document…',

    citizenOfIndia: '🇮🇳 Citizen Profile',
    citizenId: 'Citizen ID',
    kycTier: 'DocuSewa Tier 3 KYC',
    syncGateway: 'Sync Gateway',
    syncing: 'Syncing...',
    aadhaarSeeded: 'AADHAAR VERIFIED',
    panNumber: 'PAN NUMBER',
    vaultRecords: 'VAULT RECORDS',
    securityStatus: 'SECURITY STATUS',
    secHigh: '● High (2FA Active)',

    tabDigitalPass: '🪪 Digital Citizen Card',
    tabPersonalKYC: '👤 Personal & KYC Data',
    tabLinkedPortals: '🔗 Linked Portals',
    tabSecurity: '🛡️ Security & Consents',
    tabPreferences: '⚙️ Preferences',

    govtOfIndia: 'DocuSewa Citizen Pass',
    citizenPass: 'Digital ID Card',
    digilockerVerified: 'VERIFIED CITIZEN',
    cardName: 'NAME',
    cardDob: 'DOB',
    cardGender: 'GENDER',
    cardCitizenId: 'CITIZEN ID NUMBER',
    copyId: 'Copy Citizen ID',
    downloadPass: 'Download Card',
    copied: 'Copied!',
    trustBadgesTitle: 'Security & Integration Badges',
    trustDigiLocker: 'DigiLocker Format Compatible',
    trustDigiLockerDesc: 'Standard digital document viewer & locker integration',
    trustAadhaar: 'Aadhaar OTP Verified',
    trustAadhaarDesc: 'Mobile OTP verified citizen profile',
    trustGovt: 'Direct Portal Redirection',
    trustGovtDesc: 'Instant access and direct linking to 19+ authority portals',

    personalTitle: 'Citizen Demographics & Contact Records',
    personalSubtitle: 'Personal registration profile mapped with your verified locker credentials',
    lblFullName: 'FULL LEGAL NAME (AS PER ID)',
    lblPhone: 'REGISTERED MOBILE NUMBER',
    lblEmail: 'EMAIL ADDRESS',
    lblDobGender: 'DATE OF BIRTH & GENDER',
    lblBloodGroup: 'BLOOD GROUP',
    lblFather: 'FATHER / GUARDIAN NAME',
    lblAddress: 'PERMANENT RESIDENCE ADDRESS & DOMICILE',

    linkedTitle: 'Connected Department Portals & Registries',
    linkedSubtitle: 'Real-time synchronization for seamless instant document issuance and admit card pulls',
    syncAllPortals: 'Sync All Portals',
    lblLinked: '● Linked',
    reverify: 'Re-verify',
    manage: 'Manage',

    securityTitle: 'Citizen Privacy, Biometrics & Authorization Log',
    securitySubtitle: 'Control third-party portal access to your certificates and manage your security keys',
    twoFactorTitle: 'Two-Factor Authentication (2FA)',
    twoFactorDesc: 'Require 6-digit OTP for every document pull',
    bioLockTitle: 'Biometric Protection Lock',
    bioLockDesc: 'Prevent unauthorized authentication attempts',
    consentTitle: 'Recent Portal Sharing & Consent Authorizations',
    revokeAccess: 'Revoke Access',
    authorized: 'Authorized',
    revoked: 'Revoked',

    preferencesTitle: 'Citizen Preferences & Notification Channels',
    preferencesSubtitle: 'Configure regional language and automated alerts for document renewals',
    portalLanguage: 'Regional Portal Language',
    alertsTitle: 'Alerts & Expiry Notifications',
    whatsappAlerts: 'WhatsApp alerts for Driving Licence, Insurance, and Exam hall tickets',
    smsAlerts: 'SMS notifications on registered mobile',
    dataPortability: 'Data Portability & Backup',
    dataPortabilityDesc: 'Download an encrypted archive of your profile metadata and linked certificates',
    exportData: 'Export Citizen Data (JSON)',

    itdName: 'Income Tax Department',
    itdDoc: 'PAN Verification Record (e-PAN)',
    eciName: 'Election Commission of India',
    eciDoc: 'Electoral Photo Identity Card (e-EPIC)',
    uidaiName: 'Unique Identification Authority (UIDAI)',
    uidaiDoc: 'Aadhaar Digital Copy',
    morthName: 'Ministry of Road Transport & Highways',
    morthDoc: 'Driving Licence & Vehicle RC',
    pmjayName: 'National Health Authority',
    pmjayDoc: 'ABHA Health Card (₹5 Lakh Cover)',
    meaName: 'Ministry of External Affairs',
    meaDoc: 'Passport Verification & PCC',
    pdsName: 'Dept of Food & Public Distribution',
    pdsDoc: 'Family Ration Card',
    revenueName: 'Department of Land Resources & Revenue',
    revenueDoc: 'Income, Caste & Domicile Certificate',
    upscName: 'Union Public Service Commission (UPSC)',
    upscDoc: 'e-Admit Card & Selection Marksheet',
    sscName: 'Staff Selection Commission (SSC)',
    sscDoc: 'Exam Hall Ticket & Score Card',
    ntaName: 'National Testing Agency (NTA)',
    ntaDoc: 'NTA Admit Card & Official Scorecard',
    rrbName: 'Railway Recruitment Control Board (RRB)',
    rrbDoc: 'E-Call Letter & CBT Score Summary',
    ibpsName: 'Banking Personnel Selection (IBPS)',
    ibpsDoc: 'Call Letter & Combined Result Record',
    cbseName: 'Central Board of Secondary Education (CBSE)',
    cbseDoc: 'Class X & XII Digital Marksheet',
    ugcName: 'University Grants Commission (UGC-NET)',
    ugcDoc: 'E-Certificate & JRF Award Letter',
    pscName: 'State Public Service Commissions',
    pscDoc: 'State PSC Admit Card & Interview Call',
    epfoName: 'Employees’ Provident Fund Organisation',
    epfoDoc: 'UAN Card & Member Passbook',
    licName: 'Life Insurance Corporation of India',
    licDoc: 'LIC Policy Document',
    sbiName: 'State Bank of India',
    sbiDoc: 'Account Statement & Passbook',
  },
  hi: {
    brandName: 'दस्तावेज़ सेवा (DocuSewa)',
    brandTagline: 'नागरिक सेवा एवं दस्तावेज़ पोर्टल',
    govBadge: 'पोर्टल',
    verifiedCitizen: 'सत्यापित 🇮🇳',
    verifiedAccount: '✓ सत्यापित नागरिक खाता',
    searchPlaceholder: 'परीक्षा प्रवेश पत्र, पहचान पत्र, प्रमाण पत्र खोजें...',
    signOut: 'DocuSewa से साइन आउट करें',
    close: 'बंद करें',
    cancel: 'रद्द करें',
    saveChanges: 'परिवर्तन सहेजें',
    editProfile: 'प्रोफ़ाइल संपादित करें',

    allServices: 'सभी सेवाएं',
    govtDocs: '📄 आधिकारिक दस्तावेज़',
    govtExams: '🎓 परीक्षाएं एवं बोर्ड',
    issuedVault: '📁 नागरिक वॉल्ट',
    citizenProfile: '👤 नागरिक प्रोफ़ाइल',

    identityDocsTitle: 'पहचान एवं आधिकारिक रिकॉर्ड',
    identityDocsBadge: 'सेवाएं',
    directPortals: 'प्रत्यक्ष पोर्टल',
    examsTitle: 'परीक्षाएं एवं शिक्षा बोर्ड',
    examsBadge: 'बोर्ड्स',
    admitCardsBadge: 'प्रवेश पत्र एवं परिणाम',
    financeTitle: 'वित्तीय एवं कल्याण सेवाएं',
    financeBadge: 'सेवाएं',
    bankingBadge: 'बैंकिंग एवं बीमा',

    vaultTitle: '📁 सुरक्षित नागरिक वॉल्ट',
    vaultSubtitle: 'सार्वजनिक पोर्टलों से प्राप्त एन्क्रिप्टेड डिजिटल प्रमाण पत्र एवं दस्तावेज़',
    docNumber: 'दस्तावेज़ संख्या',
    docStatus: 'स्थिति',
    viewDoc: 'देखें',
    downloadDoc: 'डाउनलोड',
    verifiedBadge: '✓ सत्यापित',

    docIssuedSuccess: 'दस्तावेज़ सुरक्षित रूप से सहेजा गया!',
    docIssuedDesc: 'आपका दस्तावेज़ सफलतापूर्वक आपके नागरिक वॉल्ट में जोड़ दिया गया है।',
    viewInVault: 'वॉल्ट में देखें',
    officialPortal: 'सीधा आधिकारिक पोर्टल',
    visitSite: 'वेबसाइट खोलें',
    requiredDetails: 'आवश्यक सत्यापन विवरण:',
    fetchDocument: 'दस्तावेज़ प्राप्त करें',
    pullingDoc: 'दस्तावेज़ लाया जा रहा है...',

    citizenOfIndia: '🇮🇳 नागरिक प्रोफ़ाइल',
    citizenId: 'नागरिक आईडी',
    kycTier: 'DocuSewa टियर 3 केवाईसी',
    syncGateway: 'गेटवे सिंक करें',
    syncing: 'सिंक हो रहा है...',
    aadhaarSeeded: 'आधार सत्यापित',
    panNumber: 'पैन संख्या',
    vaultRecords: 'वॉल्ट रिकॉर्ड्स',
    securityStatus: 'सुरक्षा स्थिति',
    secHigh: '● उच्च (2FA सक्रिय)',

    tabDigitalPass: '🪪 डिजिटल नागरिक कार्ड',
    tabPersonalKYC: '👤 व्यक्तिगत एवं केवाईसी डेटा',
    tabLinkedPortals: '🔗 जुड़े हुए पोर्टल',
    tabSecurity: '🛡️ सुरक्षा एवं सहमति',
    tabPreferences: '⚙️ भाषा एवं प्राथमिकताएं',

    govtOfIndia: 'DocuSewa नागरिक पास',
    citizenPass: 'डिजिटल आईडी कार्ड',
    digilockerVerified: 'सत्यापित नागरिक',
    cardName: 'नाम',
    cardDob: 'जन्म तिथि',
    cardGender: 'लिंग',
    cardCitizenId: 'नागरिक पहचान संख्या',
    copyId: 'आईडी कॉपी करें',
    downloadPass: 'कार्ड डाउनलोड करें',
    copied: 'कॉपी हो गया!',
    trustBadgesTitle: 'सुरक्षा एवं एकीकरण बैज',
    trustDigiLocker: 'डिजिलॉकर प्रारूप संगत',
    trustDigiLockerDesc: 'मानक डिजिटल दस्तावेज़ दर्शक एवं लॉकर एकीकरण',
    trustAadhaar: 'आधार ओटीपी सत्यापित',
    trustAadhaarDesc: 'मोबाइल ओटीपी सत्यापित नागरिक प्रोफ़ाइल',
    trustGovt: 'सीधे पोर्टल रीडायरेक्शन',
    trustGovtDesc: '19+ आधिकारिक सार्वजनिक पोर्टलों तक त्वरित सीधी पहुंच',

    personalTitle: 'नागरिक विवरण एवं संपर्क रिकॉर्ड',
    personalSubtitle: 'सत्यापित डिजिटल क्रेडेंशियल्स के साथ मैप की गई नागरिक प्रोफ़ाइल',
    lblFullName: 'पूरा कानूनी नाम (आईडी के अनुसार)',
    lblPhone: 'पंजीकृत मोबाइल नंबर',
    lblEmail: 'ईमेल पता',
    lblDobGender: 'जन्म तिथि एवं लिंग',
    lblBloodGroup: 'रक्त समूह',
    lblFather: 'पिता / अभिभावक का नाम',
    lblAddress: 'स्थायी निवास पता एवं मूल निवास',

    linkedTitle: 'जुड़े हुए विभाग पोर्टल एवं रजिस्ट्री',
    linkedSubtitle: 'दस्तावेज़ और प्रवेश पत्र प्राप्त करने के लिए रीयल-टाइम सिंक्रोनाइज़ेशन',
    syncAllPortals: 'सभी पोर्टल सिंक करें',
    lblLinked: '● जुड़ा हुआ',
    reverify: 'पुनः सत्यापित करें',
    manage: 'प्रबंधित करें',

    securityTitle: 'नागरिक गोपनीयता, बायोमेट्रिक्स एवं प्राधिकरण',
    securitySubtitle: 'अपने प्रमाणपत्रों तक तृतीय-पक्ष पोर्टल पहुंच को नियंत्रित करें',
    twoFactorTitle: 'दो-चरणीय प्रमाणीकरण (2FA)',
    twoFactorDesc: 'प्रत्येक दस्तावेज़ प्राप्ति के लिए 6-अंकीय ओटीपी आवश्यक',
    bioLockTitle: 'बायोमेट्रिक सुरक्षा लॉक',
    bioLockDesc: 'अनधिकृत पहुंच प्रयासों को रोकें',
    consentTitle: 'हालिया पोर्टल साझाकरण एवं सहमति इतिहास',
    revokeAccess: 'पहुंच निरस्त करें',
    authorized: 'अधिकृत',
    revoked: 'निरस्त',

    preferencesTitle: 'नागरिक प्राथमिकताएं एवं सूचना चैनल',
    preferencesSubtitle: 'क्षेत्रीय भाषा एवं दस्तावेज़ नवीनीकरण अलर्ट कॉन्फ़िगर करें',
    portalLanguage: 'पोर्टल भाषा चुनें',
    alertsTitle: 'सूचनाएं एवं नवीनीकरण अलर्ट',
    whatsappAlerts: 'ड्राइविंग लाइसेंस, बीमा एवं प्रवेश पत्र हेतु व्हाट्सएप अलर्ट',
    smsAlerts: 'पंजीकृत मोबाइल नंबर पर एसएमएस सूचनाएं',
    dataPortability: 'डेटा बैकअप एवं पोर्टेबिलिटी',
    dataPortabilityDesc: 'अपने प्रोफ़ाइल मेटाडेटा और प्रमाणपत्रों का एन्क्रिप्टेड बैकअप डाउनलोड करें',
    exportData: 'नागरिक डेटा निर्यात करें (JSON)',

    itdName: 'आयकर विभाग (Income Tax)',
    itdDoc: 'पैन सत्यापन रिकॉर्ड (e-PAN)',
    eciName: 'भारत निर्वाचन आयोग (ECI)',
    eciDoc: 'मतदाता फोटो पहचान पत्र (e-EPIC)',
    uidaiName: 'भारतीय विशिष्ट पहचान प्राधिकरण (UIDAI)',
    uidaiDoc: 'आधार डिजिटल प्रति',
    morthName: 'सड़क परिवहन एवं राजमार्ग मंत्रालय',
    morthDoc: 'ड्राइविंग लाइसेंस एवं वाहन आरसी',
    pmjayName: 'राष्ट्रीय स्वास्थ्य प्राधिकरण (NHA)',
    pmjayDoc: 'आयुष्मान भारत आभा कार्ड (₹5 लाख बीमा)',
    meaName: 'विदेश मंत्रालय (Passport Seva)',
    meaDoc: 'पासपोर्ट सत्यापन एवं पीसीसी',
    pdsName: 'खाद्य एवं सार्वजनिक वितरण विभाग',
    pdsDoc: 'पारिवारिक राशन कार्ड',
    revenueName: 'भूमि संसाधन एवं राजस्व विभाग',
    revenueDoc: 'आय, जाति एवं मूल निवास प्रमाण पत्र',
    upscName: 'संघ लोक सेवा आयोग (UPSC)',
    upscDoc: 'ई-प्रवेश पत्र एवं अंतिम चयन अंकतालिका',
    sscName: 'कर्मचारी चयन आयोग (SSC)',
    sscDoc: 'परीक्षा हॉल टिकट एवं स्कोर कार्ड',
    ntaName: 'राष्ट्रीय परीक्षण एजेंसी (NTA)',
    ntaDoc: 'एनटीए प्रवेश पत्र एवं आधिकारिक स्कोरकार्ड',
    rrbName: 'रेलवे भर्ती नियंत्रण बोर्ड (RRB)',
    rrbDoc: 'ई-कॉल लेटर एवं सीबीटी स्कोर सारांश',
    ibpsName: 'बैंकिंग कार्मिक चयन संस्थान (IBPS)',
    ibpsDoc: 'कॉल लेटर एवं संयुक्त परिणाम रिकॉर्ड',
    cbseName: 'केंद्रीय माध्यमिक शिक्षा बोर्ड (CBSE)',
    cbseDoc: 'कक्षा 10वीं एवं 12वीं डिजिटल अंकतालिका',
    ugcName: 'विश्वविद्यालय अनुदान आयोग (UGC-NET)',
    ugcDoc: 'ई-प्रमाणपत्र एवं जेआरएफ अवार्ड लेटर',
    pscName: 'राज्य लोक सेवा आयोग',
    pscDoc: 'राज्य पीएससी प्रवेश पत्र एवं साक्षात्कार कॉल',
    epfoName: 'कर्मचारी भविष्य निधि संगठन (EPFO)',
    epfoDoc: 'यूएएन कार्ड एवं सदस्य पासबुक',
    licName: 'भारतीय जीवन बीमा निगम (LIC)',
    licDoc: 'एलआईसी पॉलिसी दस्तावेज़',
    sbiName: 'भारतीय स्टेट बैंक (SBI)',
    sbiDoc: 'खाता विवरण एवं पासबुक',
  },
  pa: {
    brandName: 'ਦਸਤਾਵੇਜ਼ ਸੇਵਾ (DocuSewa)',
    brandTagline: 'ਨਾਗਰਿਕ ਸੇਵਾਵਾਂ ਅਤੇ ਦਸਤਾਵੇਜ਼ ਪੋਰਟਲ',
    govBadge: 'ਪੋਰਟਲ',
    verifiedCitizen: 'ਪ੍ਰਮਾਣਿਤ 🇮🇳',
    verifiedAccount: '✓ ਪ੍ਰਮਾਣਿਤ ਨਾਗਰਿਕ ਖਾਤਾ',
    searchPlaceholder: 'ਇਮਤਿਹਾਨ ਐਡਮਿਟ ਕਾਰਡ, ਪਛਾਣ ਪੱਤਰ, ਸਰਟੀਫਿਕੇਟ ਖੋਜੋ...',
    signOut: 'DocuSewa ਤੋਂ ਸਾਈਨ ਆਊਟ ਕਰੋ',
    close: 'ਬੰਦ ਕਰੋ',
    cancel: 'ਰੱਦ ਕਰੋ',
    saveChanges: 'ਤਬਦੀਲੀਆਂ ਸੰਭਾਲੋ',
    editProfile: 'ਪ੍ਰੋਫਾਈਲ ਸੋਧੋ',

    allServices: 'ਸਾਰੀਆਂ ਸੇਵਾਵਾਂ',
    govtDocs: '📄 ਅਧਿਕਾਰਤ ਦਸਤਾਵੇਜ਼',
    govtExams: '🎓 ਪ੍ਰੀਖਿਆਵਾਂ ਅਤੇ ਬੋਰਡ',
    issuedVault: '📁 ਨਾਗਰਿਕ ਵਾਲਟ',
    citizenProfile: '👤 ਨਾਗਰਿਕ ਪ੍ਰੋਫਾਈਲ',

    identityDocsTitle: 'ਪਛਾਣ ਅਤੇ ਅਧਿਕਾਰਤ ਰਿਕਾਰਡ',
    identityDocsBadge: 'ਸੇਵਾਵਾਂ',
    directPortals: 'ਸਿੱਧੇ ਪੋਰਟਲ',
    examsTitle: 'ਪ੍ਰੀਖਿਆਵਾਂ ਅਤੇ ਸਿੱਖਿਆ ਬੋਰਡ',
    examsBadge: 'ਬੋਰਡ',
    admitCardsBadge: 'ਐਡਮਿਟ ਕਾਰਡ ਅਤੇ ਨਤੀਜੇ',
    financeTitle: 'ਵਿੱਤੀ ਅਤੇ ਭਲਾਈ ਸੇਵਾਵਾਂ',
    financeBadge: 'ਸੇਵਾਵਾਂ',
    bankingBadge: 'ਬੈਂਕਿੰਗ ਅਤੇ ਬੀਮਾ',

    vaultTitle: '📁 ਸੁਰੱਖਿਅਤ ਨਾਗਰਿਕ ਵਾਲਟ',
    vaultSubtitle: 'ਪਬਲਿਕ ਪੋਰਟਲਾਂ ਤੋਂ ਪ੍ਰਾਪਤ ਐਨਕ੍ਰਿਪਟਡ ਡਿਜੀਟਲ ਸਰਟੀਫਿਕੇਟ ਅਤੇ ਦਸਤਾਵੇਜ਼',
    docNumber: 'ਦਸਤਾਵੇਜ਼ ਨੰਬਰ',
    docStatus: 'ਸਥਿਤੀ',
    viewDoc: 'ਵੇਖੋ',
    downloadDoc: 'ਡਾਊਨਲੋਡ',
    verifiedBadge: '✓ ਪ੍ਰਮਾਣਿਤ',

    docIssuedSuccess: 'ਦਸਤਾਵੇਜ਼ ਸੁਰੱਖਿਅਤ ਰੂਪ ਵਿੱਚ ਸੁਰੱਖਿਅਤ ਕੀਤਾ ਗਿਆ!',
    docIssuedDesc: 'ਤੁਹਾਡਾ ਦਸਤਾਵੇਜ਼ ਤੁਹਾਡੇ ਨਾਗਰਿਕ ਵਾਲਟ ਵਿੱਚ ਸ਼ਾਮਲ ਕੀਤਾ ਗਿਆ ਹੈ।',
    viewInVault: 'ਵਾਲਟ ਵਿੱਚ ਵੇਖੋ',
    officialPortal: 'ਸਿੱਧਾ ਅਧਿਕਾਰਤ ਪੋਰਟਲ',
    visitSite: 'ਸਾਈਟ ਖੋਲ੍ਹੋ',
    requiredDetails: 'ਲੋੜੀਂਦੇ ਵੇਰਵੇ:',
    fetchDocument: 'ਦਸਤਾਵੇਜ਼ ਪ੍ਰਾਪਤ ਕਰੋ',
    pullingDoc: 'ਦਸਤਾਵੇਜ਼ ਲਿਆਂਦਾ ਜਾ ਰਿਹਾ ਹੈ...',

    citizenOfIndia: '🇮🇳 ਨਾਗਰਿਕ ਪ੍ਰੋਫਾਈਲ',
    citizenId: 'ਨਾਗਰਿਕ ਆਈਡੀ',
    kycTier: 'DocuSewa ਟੀਅਰ 3 ਕੇਵਾਈਸੀ',
    syncGateway: 'ਗੇਟਵੇ ਸਿੰਕ ਕਰੋ',
    syncing: 'ਸਿੰਕ ਹੋ ਰਿਹਾ ਹੈ...',
    aadhaarSeeded: 'ਆਧਾਰ ਪ੍ਰਮਾਣਿਤ',
    panNumber: 'ਪੈਨ ਨੰਬਰ',
    vaultRecords: 'ਵਾਲਟ ਰਿਕਾਰਡ',
    securityStatus: 'ਸੁਰੱਖਿਆ ਸਥਿਤੀ',
    secHigh: '● ਉੱਚ (2FA ਸਰਗਰਮ)',

    tabDigitalPass: '🪪 ਡਿਜੀਟਲ ਨਾਗਰਿਕ ਕਾਰਡ',
    tabPersonalKYC: '👤 ਨਿੱਜੀ ਅਤੇ ਕੇਵਾਈਸੀ ਡੇਟਾ',
    tabLinkedPortals: '🔗 ਜੁੜੇ ਹੋਏ ਪੋਰਟਲ',
    tabSecurity: '🛡️ ਸੁਰੱਖਿਆ ਅਤੇ ਸਹਿਮਤੀ',
    tabPreferences: '⚙️ ਭਾਸ਼ਾ ਅਤੇ ਤਰਜੀਹਾਂ',

    govtOfIndia: 'DocuSewa ਨਾਗਰਿਕ ਪਾਸ',
    citizenPass: 'ਡਿਜੀਟਲ ਆਈਡੀ ਕਾਰਡ',
    digilockerVerified: 'ਪ੍ਰਮਾਣਿਤ ਨਾਗਰਿਕ',
    cardName: 'ਨਾਮ',
    cardDob: 'ਜਨਮ ਮਿਤੀ',
    cardGender: 'ਲਿੰਗ',
    cardCitizenId: 'ਨਾਗਰਿਕ ਪਛਾਣ ਨੰਬਰ',
    copyId: 'ਆਈਡੀ ਕਾਪੀ ਕਰੋ',
    downloadPass: 'ਕਾਰਡ ਡਾਊਨਲੋਡ ਕਰੋ',
    copied: 'ਕਾਪੀ ਹੋ ਗਿਆ!',
    trustBadgesTitle: 'ਸੁਰੱਖਿਆ ਅਤੇ ਏਕੀਕਰਨ ਬੈਜ',
    trustDigiLocker: 'ਡਿਜੀਲਾਕਰ ਫਾਰਮੈਟ ਅਨੁਕੂਲ',
    trustDigiLockerDesc: 'ਮਿਆਰੀ ਡਿਜੀਟਲ ਦਸਤਾਵੇਜ਼ ਦਰਸ਼ਕ ਅਤੇ ਲਾਕਰ ਏਕੀਕਰਨ',
    trustAadhaar: 'ਆਧਾਰ ਓਟੀਪੀ ਪ੍ਰਮਾਣਿਤ',
    trustAadhaarDesc: 'ਮੋਬਾਈਲ ਓਟੀਪੀ ਪ੍ਰਮਾਣਿਤ ਨਾਗਰਿਕ ਪ੍ਰੋਫਾਈਲ',
    trustGovt: 'ਸਿੱਧਾ ਪੋਰਟਲ ਰੀਡਾਇਰੈਕਸ਼ਨ',
    trustGovtDesc: '19+ ਅਧਿਕਾਰਤ ਪਬਲਿਕ ਪੋਰਟਲਾਂ ਤੱਕ ਤੁਰੰਤ ਸਿੱਧੀ ਪਹੁੰਚ',

    personalTitle: 'ਨਾਗਰਿਕ ਵੇਰਵੇ ਅਤੇ ਸੰਪਰਕ ਰਿਕਾਰਡ',
    personalSubtitle: 'ਪ੍ਰਮਾਣਿਤ ਡਿਜੀਟਲ ਵੇਰਵਿਆਂ ਨਾਲ ਜੁੜਿਆ ਨਾਗਰਿਕ ਪ੍ਰੋਫਾਈਲ',
    lblFullName: 'ਪੂਰਾ ਕਾਨੂੰਨੀ ਨਾਮ (ਆਈਡੀ ਅਨੁਸਾਰ)',
    lblPhone: 'ਰਜਿਸਟਰਡ ਮੋਬਾਈਲ ਨੰਬਰ',
    lblEmail: 'ਈਮੇਲ ਪਤਾ',
    lblDobGender: 'ਜਨਮ ਮਿਤੀ ਅਤੇ ਲਿੰਗ',
    lblBloodGroup: 'ਬਲੱਡ ਗਰੁੱਪ',
    lblFather: 'ਪਿਤਾ / ਸਰਪ੍ਰਸਤ ਦਾ ਨਾਮ',
    lblAddress: 'ਪੱਕਾ ਰਿਹਾਇਸ਼ੀ ਪਤਾ ਅਤੇ ਮੂਲ ਨਿਵਾਸ',

    linkedTitle: 'ਜੁੜੇ ਹੋਏ ਵਿਭਾਗ ਪੋਰਟਲ ਅਤੇ ਰਜਿਸਟਰੀਆਂ',
    linkedSubtitle: 'ਦਸਤਾਵੇਜ਼ ਅਤੇ ਐਡਮਿਟ ਕਾਰਡ ਪ੍ਰਾਪਤ ਕਰਨ ਲਈ ਰੀਅਲ-ਟਾਈਮ ਸਿੰਕ੍ਰੋਨਾਈਜ਼ੇਸ਼ਨ',
    syncAllPortals: 'ਸਾਰੇ ਪੋਰਟਲ ਸਿੰਕ ਕਰੋ',
    lblLinked: '● ਜੁੜਿਆ ਹੋਇਆ',
    reverify: 'ਮੁੜ ਪ੍ਰਮਾਣਿਤ ਕਰੋ',
    manage: 'ਪ੍ਰਬੰਧਿਤ ਕਰੋ',

    securityTitle: 'ਨਾਗਰਿਕ ਗੋਪਨੀਯਤਾ, ਬਾਇਓਮੈਟ੍ਰਿਕਸ ਅਤੇ ਅਧਿਕਾਰ',
    securitySubtitle: 'ਆਪਣੇ ਸਰਟੀਫਿਕੇਟਾਂ ਤੱਕ ਤੀਜੀ-ਧਿਰ ਦੀ ਪਹੁੰਚ ਨੂੰ ਨਿਯੰਤਰਿਤ ਕਰੋ',
    twoFactorTitle: 'ਦੋ-ਪੜਾਵੀ ਪ੍ਰਮਾਣੀਕਰਨ (2FA)',
    twoFactorDesc: 'ਹਰੇਕ ਦਸਤਾਵੇਜ਼ ਲਈ 6-ਅੰਕਾਂ ਵਾਲਾ ਓਟੀਪੀ ਲਾਜ਼ਮੀ',
    bioLockTitle: 'ਬਾਇਓਮੈਟ੍ਰਿਕ ਸੁਰੱਖਿਆ ਲਾਕ',
    bioLockDesc: 'ਅਣਅਧਿਕਾਰਤ ਪਹੁੰਚ ਰੋਕੋ',
    consentTitle: 'ਹਾਲੀਆ ਪੋਰਟਲ ਸਾਂਝਾਕਰਨ ਅਤੇ ਸਹਿਮਤੀ ਇਤਿਹਾਸ',
    revokeAccess: 'ਪਹੁੰਚ ਰੱਦ ਕਰੋ',
    authorized: 'ਅਧਿਕਾਰਤ',
    revoked: 'ਰੱਦ ਕੀਤਾ ਗਿਆ',

    preferencesTitle: 'ਨਾਗਰਿਕ ਤਰਜੀਹਾਂ ਅਤੇ ਨੋਟੀਫਿਕੇਸ਼ਨ ਚੈਨਲ',
    preferencesSubtitle: 'ਖੇਤਰੀ ਭਾਸ਼ਾ ਅਤੇ ਦਸਤਾਵੇਜ਼ ਨਵਿਆਉਣ ਸੰਬੰਧੀ ਅਲਰਟ ਸੈੱਟ ਕਰੋ',
    portalLanguage: 'ਪੋਰਟਲ ਭਾਸ਼ਾ ਚੁਣੋ',
    alertsTitle: 'ਨੋਟੀਫਿਕੇਸ਼ਨ ਅਤੇ ਨਵਿਆਉਣ ਅਲਰਟ',
    whatsappAlerts: 'ਡਰਾਈਵਿੰਗ ਲਾਇਸੈਂਸ, ਬੀਮਾ ਅਤੇ ਐਡਮਿਟ ਕਾਰਡਾਂ ਲਈ ਵਟਸਐਪ ਅਲਰਟ',
    smsAlerts: 'ਰਜਿਸਟਰਡ ਮੋਬਾਈਲ ਨੰਬਰ ਤੇ ਐਸਐਮਐਸ ਨੋਟੀਫਿਕੇਸ਼ਨ',
    dataPortability: 'ਡੇਟਾ ਬੈਕਅੱਪ ਅਤੇ ਪੋਰਟੇਬਿਲਟੀ',
    dataPortabilityDesc: 'ਆਪਣੇ ਪ੍ਰੋਫਾਈਲ ਮੈਟਾਡੇਟਾ ਅਤੇ ਸਰਟੀਫਿਕੇਟਾਂ ਦਾ ਏਨਕ੍ਰਿਪਟਡ ਬੈਕਅੱਪ ਡਾਊਨਲੋਡ ਕਰੋ',
    exportData: 'ਨਾਗਰਿਕ ਡੇਟਾ ਨਿਰਯਾਤ ਕਰੋ (JSON)',

    itdName: 'ਇਨਕਮ ਟੈਕਸ ਵਿਭਾਗ (Income Tax)',
    itdDoc: 'ਪੈਨ ਵੈਰੀਫਿਕੇਸ਼ਨ ਰਿਕਾਰਡ (e-PAN)',
    eciName: 'ਭਾਰਤ ਚੋਣ ਕਮਿਸ਼ਨ (ECI)',
    eciDoc: 'ਵੋਟਰ ਫੋਟੋ ਸ਼ਨਾਖਤੀ ਕਾਰਡ (e-EPIC)',
    uidaiName: 'ਵਿਲੱਖਣ ਪਛਾਣ ਅਥਾਰਟੀ (UIDAI)',
    uidaiDoc: 'ਆਧਾਰ ਡਿਜੀਟਲ ਕਾਪੀ',
    morthName: 'ਸੜਕ ਆਵਾਜਾਈ ਅਤੇ ਰਾਜਮਾਰਗ ਮੰਤਰਾਲਾ',
    morthDoc: 'ਡਰਾਈਵਿੰਗ ਲਾਇਸੈਂਸ ਅਤੇ ਵਾਹਨ ਆਰ.ਸੀ.',
    pmjayName: 'ਰਾਸ਼ਟਰੀ ਸਿਹਤ ਅਥਾਰਟੀ (NHA)',
    pmjayDoc: 'ਆਯੁਸ਼ਮਾਨ ਭਾਰਤ ਆਭਾ ਕਾਰਡ (₹5 ਲੱਖ ਕਵਰ)',
    meaName: 'ਵਿਦੇਸ਼ ਮੰਤਰਾਲਾ (Passport Seva)',
    meaDoc: 'ਪਾਸਪੋਰਟ ਤਸਦੀਕ ਅਤੇ ਪੀ.ਸੀ.ਸੀ.',
    pdsName: 'ਖੁਰਾਕ ਅਤੇ ਜਨਤਕ ਵੰਡ ਵਿਭਾਗ',
    pdsDoc: 'ਪਰਿਵਾਰਕ ਰਾਸ਼ਨ ਕਾਰਡ',
    revenueName: 'ਜ਼ਮੀਨੀ ਸਰੋਤ ਅਤੇ ਮਾਲ ਵਿਭਾਗ',
    revenueDoc: 'ਆਮਦਨ, ਜਾਤੀ ਅਤੇ ਰਿਹਾਇਸ਼ ਸਰਟੀਫਿਕੇਟ',
    upscName: 'ਯੂਨੀਅਨ ਲੋਕ ਸੇਵਾ ਕਮਿਸ਼ਨ (UPSC)',
    upscDoc: 'ਈ-ਐਡਮਿਟ ਕਾਰਡ ਅਤੇ ਮਾਰਕਸ਼ੀਟ',
    sscName: 'ਸਟਾਫ ਸਿਲੈਕਸ਼ਨ ਕਮਿਸ਼ਨ (SSC)',
    sscDoc: 'ਇਮਤਿਹਾਨ ਹਾਲ ਟਿਕਟ ਅਤੇ ਸਕੋਰ ਕਾਰਡ',
    ntaName: 'ਨੈਸ਼ਨਲ ਟੈਸਟਿੰਗ ਏਜੰਸੀ (NTA)',
    ntaDoc: 'ਐਨਟੀਏ ਐਡਮਿਟ ਕਾਰਡ ਅਤੇ ਅਧਿਕਾਰਤ ਸਕੋਰਕਾਰਡ',
    rrbName: 'ਰੇਲਵੇ ਭਰਤੀ ਕੰਟਰੋਲ ਬੋਰਡ (RRB)',
    rrbDoc: 'ਈ-ਕਾਲ ਲੈਟਰ ਅਤੇ ਸੀਬੀਟੀ ਸਕੋਰ',
    ibpsName: 'ਬੈਂਕਿੰਗ ਕਰਮਚਾਰੀ ਚੋਣ ਸੰਸਥਾ (IBPS)',
    ibpsDoc: 'ਕਾਲ ਲੈਟਰ ਅਤੇ ਸੰਯੁਕਤ ਨਤੀਜਾ',
    cbseName: 'ਕੇਂਦਰੀ ਸੈਕੰਡਰੀ ਸਿੱਖਿਆ ਬੋਰਡ (CBSE)',
    cbseDoc: '10ਵੀਂ ਅਤੇ 12ਵੀਂ ਡਿਜੀਟਲ ਮਾਰਕਸ਼ੀਟ',
    ugcName: 'ਯੂਨੀਵਰਸਿਟੀ ਗ੍ਰਾਂਟਸ ਕਮਿਸ਼ਨ (UGC-NET)',
    ugcDoc: 'ਈ-ਸਰਟੀਫਿਕੇਟ ਅਤੇ ਜੇਆਰਐਫ ਅਵਾਰਡ ਪੱਤਰ',
    pscName: 'ਰਾਜ ਲੋਕ ਸੇਵਾ ਕਮਿਸ਼ਨ',
    pscDoc: 'ਸਟੇਟ ਪੀਐਸਸੀ ਐਡਮਿਟ ਕਾਰਡ ਅਤੇ ਇੰਟਰਵਿਊ ਕਾਲ',
    epfoName: 'ਕਰਮਚਾਰੀ ਭਵਿੱਖ ਨਿਧੀ ਸੰਗਠਨ (EPFO)',
    epfoDoc: 'ਯੂਏਐਨ ਕਾਰਡ ਅਤੇ ਮੈਂਬਰ ਪਾਸਬੁੱਕ',
    licName: 'ਲਾਈਫ ਇੰਸ਼ੋਰੈਂਸ ਕਾਰਪੋਰੇਸ਼ਨ ਆਫ ਇੰਡੀਆ (LIC)',
    licDoc: 'ਐਲਆਈਸੀ ਪਾਲਿਸੀ ਦਸਤਾਵੇਜ਼',
    sbiName: 'ਸਟੇਟ ਬੈਂਕ ਆਫ਼ ਇੰਡੀਆ (SBI)',
    sbiDoc: 'ਖਾਤਾ ਸਟੇਟਮੈਂਟ ਅਤੇ ਪਾਸਬੁੱਕ',
  },
};

export function translateServiceState(state: string, lang: Language): string {
  if (lang === 'en') return state;

  const stateMap: Record<string, { hi: string; pa: string }> = {
    'Central Government': { hi: 'केंद्र सरकार', pa: 'ਕੇਂਦਰ ਸਰਕਾਰ' },
    'All States': { hi: 'समस्त राज्य एवं केंद्र शासित प्रदेश', pa: 'ਸਾਰੇ ਰਾਜ ਅਤੇ ਕੇਂਦਰ ਸ਼ਾਸਤ ਪ੍ਰਦੇਸ਼' },
    'State Governments': { hi: 'राज्य सरकारें', pa: 'ਰਾਜ ਸਰਕਾਰਾਂ' },
    'MoRTH — Parivahan': { hi: 'परिवहन सेवा (MoRTH)', pa: 'ਟਰਾਂਸਪੋਰਟ ਸੇਵਾ (MoRTH)' },
    'Ayushman Bharat PM-JAY': { hi: 'आयुष्मान भारत पीएम-जय', pa: 'ਆਯੁਸ਼ਮਾਨ ਭਾਰਤ ਪੀਐਮ-ਜੇਏਵਾਈ' },
    'Passport Seva': { hi: 'पासपोर्ट सेवा केंद्र', pa: 'ਪਾਸਪੋਰਟ ਸੇਵਾ ਕੇਂਦਰ' },
    'NFSA / PDS Portal': { hi: 'राष्ट्रीय खाद्य सुरक्षा पोर्टल', pa: 'ਰਾਸ਼ਟਰੀ ਖੁਰਾਕ ਸੁਰੱਖਿਆ ਪੋਰਟਲ' },
    'Civil Services / NDA / CDS': { hi: 'सिविल सेवा / एनडीए / सीडीएस', pa: 'ਸਿਵਲ ਸੇਵਾਵਾਂ / ਐਨਡੀਏ / ਸੀਡੀਐਸ' },
    'CGL / CHSL / MTS / GD': { hi: 'सीजीएल / सीएचएसएल / एमटीएस / जीडी', pa: 'ਸੀਜੀਐਲ / ਸੀਐਚਐਸਐਲ / ਐਮਟੀਐਸ / ਜੀਡੀ' },
    'JEE Main / NEET-UG / CUET': { hi: 'जेईई मेन / नीट-यूजी / सीयूईटी', pa: 'ਜੇਈਈ ਮੇਨ / ਨੀਟ-ਯੂਜੀ / ਸੀਯੂਈਟੀ' },
    'NTPC / Group D / ALP Exams': { hi: 'एनटीपीसी / ग्रुप डी / एएलपी परीक्षाएं', pa: 'ਐਨਟੀਪੀਸੀ / ਗਰੁੱਪ ਡੀ / ਏਐਲਪੀ ਪ੍ਰੀਖਿਆਵਾਂ' },
    'PO / Clerk / Specialist Officer': { hi: 'पीओ / क्लर्क / विशेषज्ञ अधिकारी', pa: 'ਪੀਓ / ਕਲਰਕ / ਮਾਹਰ ਅਧਿਕਾਰੀ' },
    'CBSE / All India': { hi: 'सीबीएसई / अखिल भारतीय', pa: 'ਸੀਬੀਐਸਈ / ਆਲ ਇੰਡੀਆ' },
    'National Eligibility & JRF': { hi: 'राष्ट्रीय पात्रता परीक्षा एवं जेआरएफ', pa: 'ਰਾਸ਼ਟਰੀ ਯੋਗਤਾ ਪ੍ਰੀਖਿਆ ਅਤੇ ਜੇਆਰਐਫ' },
    'State Administrative & Police Services': { hi: 'राज्य प्रशासनिक एवं पुलिस सेवाएं', pa: 'ਰਾਜ ਪ੍ਰਸ਼ਾਸਕੀ ਅਤੇ ਪੁਲਿਸ ਸੇਵਾਵਾਂ' },
    'Ministry of Labour': { hi: 'श्रम एवं रोजगार मंत्रालय', pa: 'ਕਿਰਤ ਅਤੇ ਰੁਜ਼ਗਾਰ ਮੰਤਰਾਲਾ' },
  };

  return stateMap[state]?.[lang] || state;
}

export function translateRequiredDoc(doc: string, lang: Language): string {
  if (lang === 'en') return doc;

  const docMap: Record<string, { hi: string; pa: string }> = {
    'Aadhaar Card': { hi: 'आधार कार्ड', pa: 'ਆਧਾਰ ਕਾਰਡ' },
    'Passport Photograph': { hi: 'पासपोर्ट साइज फोटो', pa: 'ਪਾਸਪੋਰਟ ਸਾਈਜ਼ ਫੋਟੋ' },
    'Signature Proof': { hi: 'हस्ताक्षर प्रमाण', pa: 'ਦਸਤਖਤ ਸਬੂਤ' },
    'Age Proof': { hi: 'आयु प्रमाण पत्र', pa: 'ਉਮਰ ਦਾ ਸਬੂਤ' },
    'Address Proof': { hi: 'निवास प्रमाण पत्र', pa: 'ਰਿਹਾਇਸ਼ੀ ਸਬੂਤ' },
    'Passport Photo': { hi: 'पासपोर्ट फोटो', pa: 'ਪਾਸਪੋਰਟ ਫੋਟੋ' },
    'Registered Mobile OTP': { hi: 'पंजीकृत मोबाइल ओटीपी', pa: 'ਰਜਿਸਟਰਡ ਮੋਬਾਈਲ ਓਟੀਪੀ' },
    'Aadhaar Number / VID': { hi: 'आधार संख्या / वर्चुअल आईडी', pa: 'ਆਧਾਰ ਨੰਬਰ / ਵਰਚੁਅਲ ਆਈਡੀ' },
    'Form 1 Medical Declaration': { hi: 'फॉर्म 1 मेडिकल घोषणा पत्र', pa: 'ਫਾਰਮ 1 ਮੈਡੀਕਲ ਘੋਸ਼ਣਾ ਪੱਤਰ' },
    'Blood Group': { hi: 'रक्त समूह विवरण', pa: 'ਬਲੱਡ ਗਰੁੱਪ ਵੇਰਵਾ' },
    'Aadhaar Number': { hi: 'आधार संख्या', pa: 'ਆਧਾਰ ਨੰਬਰ' },
    'Linked Mobile OTP': { hi: 'आधार से जुड़ा मोबाइल ओटीपी', pa: 'ਆਧਾਰ ਨਾਲ ਜੁੜਿਆ ਮੋਬਾਈਲ ਓਟੀਪੀ' },
    'PAN Card': { hi: 'पैन कार्ड', pa: 'ਪੈਨ ਕਾਰਡ' },
    'Bank Passbook': { hi: 'बैंक पासबुक', pa: 'ਬੈਂਕ ਪਾਸਬੁੱਕ' },
    'Family Head Aadhaar': { hi: 'परिवार के मुखिया का आधार', pa: 'ਪਰਿਵਾਰ ਦੇ ਮੁਖੀ ਦਾ ਆਧਾਰ' },
    'LPG Connection Bill': { hi: 'एलपीजी गैस कनेक्शन रसीद', pa: 'ਐਲਪੀਜੀ ਗੈਸ ਕੁਨੈਕਸ਼ਨ ਰਸੀਦ' },
    'Income Proof': { hi: 'आय प्रमाण पत्र', pa: 'ਆਮਦਨ ਸਰਟੀਫਿਕੇਟ' },
    'Salary Slip / ITR / Form 16': { hi: 'वेतन पर्ची / आईटीआर / फॉर्म 16', pa: 'ਤਨਖਾਹ ਸਲਿੱਪ / ITR / ਫਾਰਮ 16' },
    'Ration Card': { hi: 'राशन कार्ड', pa: 'ਰਾਸ਼ਨ ਕਾਰਡ' },
    'Self Declaration': { hi: 'स्व-घोषणा पत्र', pa: 'ਸਵੈ-ਘੋਸ਼ਣਾ ਪੱਤਰ' },
    'Registration ID / Roll No.': { hi: 'पंजीकरण संख्या / अनुक्रमांक', pa: 'ਰਜਿਸਟ੍ਰੇਸ਼ਨ ਆਈਡੀ / ਰੋਲ ਨੰਬਰ' },
    'Date of Birth': { hi: 'जन्म तिथि', pa: 'ਜਨਮ ਮਿਤੀ' },
    'Aadhaar ID': { hi: 'आधार पहचान पत्र', pa: 'ਆਧਾਰ ਪਛਾਣ ਪੱਤਰ' },
    'SSC Registration Number': { hi: 'एसएससी पंजीकरण संख्या', pa: 'ਐਸਐਸਸੀ ਰਜਿਸਟ੍ਰੇਸ਼ਨ ਨੰਬਰ' },
    'Password / DOB': { hi: 'पासवर्ड / जन्म तिथि', pa: 'ਪਾਸਵਰਡ / ਜਨਮ ਮਿਤੀ' },
    'Application Number': { hi: 'आवेदन संख्या', pa: 'ਅਰਜ਼ੀ ਨੰਬਰ' },
    'Security PIN': { hi: 'सुरक्षा पिन', pa: 'ਸੁਰੱਖਿਆ ਪਿੰਨ' },
    'Registration ID': { hi: 'पंजीकरण संख्या', pa: 'ਰਜਿਸਟ੍ਰੇਸ਼ਨ ਆਈਡੀ' },
    'User Password / DOB': { hi: 'उपयोगकर्ता पासवर्ड / जन्म तिथि', pa: 'ਯੂਜ਼ਰ ਪਾਸਵਰਡ / ਜਨਮ ਮਿਤੀ' },
    'Registration Number': { hi: 'पंजीकरण संख्या', pa: 'ਰਜਿਸਟ੍ਰੇਸ਼ਨ ਨੰਬਰ' },
    'Roll Number & DOB': { hi: 'रोल नंबर एवं जन्म तिथि', pa: 'ਰੋਲ ਨੰਬਰ ਅਤੇ ਜਨਮ ਮਿਤੀ' },
    'Roll Number': { hi: 'रोल नंबर / अनुक्रमांक', pa: 'ਰੋਲ ਨੰਬਰ' },
    'Passing Year': { hi: 'उत्तीर्ण होने का वर्ष', pa: 'ਪਾਸ ਹੋਣ ਦਾ ਸਾਲ' },
    'School Code': { hi: 'स्कूल कोड', pa: 'ਸਕੂਲ ਕੋਡ' },
    'Exam Session': { hi: 'परीक्षा सत्र', pa: 'ਪ੍ਰੀਖਿਆ ਸੈਸ਼ਨ' },
    'State OTR ID': { hi: 'राज्य ओटीआर संख्या', pa: 'ਰਾਜ ਓਟੀਆਰ ਨੰਬਰ' },
    'Candidate Roll Number': { hi: 'अभ्यर्थी रोल नंबर', pa: 'ਉਮੀਦਵਾਰ ਰੋਲ ਨੰਬਰ' },
    '12-Digit UAN': { hi: '12-अंकीय यूएएन नंबर', pa: '12-ਅੰਕਾਂ ਵਾਲਾ ਯੂਏਐਨ ਨੰਬਰ' },
    'Aadhaar Linked Mobile OTP': { hi: 'आधार लिंक्ड मोबाइल ओटीपी', pa: 'ਆਧਾਰ ਲਿੰਕਡ ਮੋਬਾਈਲ ਓਟੀਪੀ' },
    'Policy Number': { hi: 'बीमा पॉलिसी संख्या', pa: 'ਬੀਮਾ ਪਾਲਿਸੀ ਨੰਬਰ' },
    'Registered Mobile Number': { hi: 'पंजीकृत मोबाइल नंबर', pa: 'ਰਜਿਸਟਰਡ ਮੋਬਾਈਲ ਨੰਬਰ' },
    'Account Number': { hi: 'बैंक खाता संख्या', pa: 'ਬੈਂਕ ਖਾਤਾ ਨੰਬਰ' },
  };

  return docMap[doc]?.[lang] || doc;
}

export function translateVaultDoc(
  doc: { title: string; issuer: string; type: string; issueDate: string },
  lang: Language
): { title: string; issuer: string; issueDate: string } {
  const t = translations[lang] || translations.en;

  let title = doc.title;
  let issuer = doc.issuer;

  switch (doc.type) {
    case 'uidai':
      title = t.uidaiDoc;
      issuer = t.uidaiName;
      break;
    case 'itd':
      title = t.itdDoc;
      issuer = t.itdName;
      break;
    case 'morth':
      title = t.morthDoc;
      issuer = t.morthName;
      break;
    case 'eci':
      title = t.eciDoc;
      issuer = t.eciName;
      break;
    case 'pmjay':
      title = t.pmjayDoc;
      issuer = t.pmjayName;
      break;
    case 'mea':
      title = t.meaDoc;
      issuer = t.meaName;
      break;
    case 'pds':
      title = t.pdsDoc;
      issuer = t.pdsName;
      break;
    case 'revenue':
      title = t.revenueDoc;
      issuer = t.revenueName;
      break;
    case 'upsc':
      title = t.upscDoc;
      issuer = t.upscName;
      break;
    case 'ssc':
      title = t.sscDoc;
      issuer = t.sscName;
      break;
    case 'nta':
      title = t.ntaDoc;
      issuer = t.ntaName;
      break;
    case 'rrb':
      title = t.rrbDoc;
      issuer = t.rrbName;
      break;
    case 'ibps':
      title = t.ibpsDoc;
      issuer = t.ibpsName;
      break;
    case 'cbse':
      title = t.cbseDoc;
      issuer = t.cbseName;
      break;
    case 'ugc':
      title = t.ugcDoc;
      issuer = t.ugcName;
      break;
    case 'psc':
      title = t.pscDoc;
      issuer = t.pscName;
      break;
    case 'epfo':
      title = t.epfoDoc;
      issuer = t.epfoName;
      break;
    case 'lic':
      title = t.licDoc;
      issuer = t.licName;
      break;
    case 'sbi':
      title = t.sbiDoc;
      issuer = t.sbiName;
      break;
  }

  let issueDate = doc.issueDate;
  if (lang === 'hi') {
    issueDate = issueDate
      .replace('Issued', 'जारी')
      .replace('Valid till', 'वैधता')
      .replace('Issued Just Now', 'अभी जारी किया गया');
  } else if (lang === 'pa') {
    issueDate = issueDate
      .replace('Issued', 'ਜਾਰੀ ਕੀਤਾ')
      .replace('Valid till', 'ਮਿਆਦ')
      .replace('Issued Just Now', 'ਹੁਣੇ ਜਾਰੀ ਕੀਤਾ ਗਿਆ');
  }

  return { title, issuer, issueDate };
}
