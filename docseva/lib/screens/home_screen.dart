import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:docusewa/services/auth_service.dart';
import 'package:docusewa/theme/app_colors.dart';
import 'package:docusewa/screens/profile_screen.dart';
import 'package:docusewa/screens/vault_screen.dart';
import 'package:docusewa/screens/exam_detail_screen.dart';
import 'package:docusewa/screens/service_detail_screen.dart';
import 'package:docusewa/models/vault_doc.dart';
import 'package:docusewa/config/translations.dart';
import 'package:docusewa/config/profile_state.dart';
import 'package:docusewa/config/vault_state.dart';

class ServiceData {
  final String id;
  final String name;
  final String state;
  final String category; // 'docs', 'exams', 'finance'
  final String section; // 'govt-docs', 'govt-exams', 'finance-welfare'
  final String documentType;
  final String logoType;
  final String tag;
  final String iconEmoji;
  final List<String> requiredDocs;
  final String portalUrl;
  final String portalDomain;
  final String price;
  final String processingTime;
  final List<String> procedure;
  final String? applyUrl;
  final String? eligibility;
  final String? ageLimit;
  final String? examDates;
  final String? lastDateToApply;
  final String? vacancyCount;
  final String? examMode;
  final String? salaryScale;

  const ServiceData({
    required this.id,
    required this.name,
    required this.state,
    required this.category,
    required this.section,
    required this.documentType,
    required this.logoType,
    required this.tag,
    required this.iconEmoji,
    required this.requiredDocs,
    required this.portalUrl,
    required this.portalDomain,
    required this.price,
    required this.processingTime,
    required this.procedure,
    this.applyUrl,
    this.eligibility,
    this.ageLimit,
    this.examDates,
    this.lastDateToApply,
    this.vacancyCount,
    this.examMode,
    this.salaryScale,
  });
}

class IssuedDoc {
  final String id;
  final String title;
  final String issuer;
  final String docNumber;
  final String issueDate;
  final String logoType;

  const IssuedDoc({
    required this.id,
    required this.title,
    required this.issuer,
    required this.docNumber,
    required this.issueDate,
    required this.logoType,
  });
}

const List<ServiceData> kServices = [
  // --- SECTION: GOVT DOCUMENTS ---
  ServiceData(
    id: 'pan-card',
    name: 'Income Tax Department (ITD)',
    state: 'Central Government',
    category: 'docs',
    section: 'govt-docs',
    documentType: 'e-PAN Card Verification',
    logoType: 'itd',
    tag: 'Identity',
    iconEmoji: '💳',
    requiredDocs: ['Aadhaar Card', 'Passport Photograph', 'Signature Proof'],
    portalUrl: 'https://eportal.incometax.gov.in/',
    portalDomain: 'incometax.gov.in',
    price: 'Free / ₹0 (Instant e-PAN) | ₹107 (Physical Card)',
    processingTime: 'Instant (e-PAN) | 7-10 Days (Physical Card)',
    procedure: [
      'Visit the official Income Tax e-Filing portal & click on "Instant e-PAN".',
      'Enter your 12-digit Aadhaar Number and verify with Aadhaar-linked mobile OTP.',
      'Validate your Aadhaar e-KYC profile details and confirm submission.',
      'Download your digitally signed e-PAN instantly in PDF format.',
    ],
  ),
  ServiceData(
    id: 'uidai-aadhaar',
    name: 'UIDAI (Aadhaar Portal)',
    state: 'All States',
    category: 'docs',
    section: 'govt-docs',
    documentType: 'Digital Aadhaar Copy',
    logoType: 'uidai',
    tag: 'Identity',
    iconEmoji: '🆔',
    requiredDocs: ['Registered Mobile OTP', 'Aadhaar Number / VID'],
    portalUrl: 'https://myaadhaar.uidai.gov.in/',
    portalDomain: 'myaadhaar.uidai.gov.in',
    price: 'Free (Digital e-Aadhaar) | ₹50 (PVC Smart Card)',
    processingTime: 'Instant Download | 5-7 Days for Speed Post PVC',
    procedure: [
      'Log in to myAadhaar portal using Aadhaar Number and Captcha code.',
      'Enter the 6-digit OTP received on your UIDAI registered mobile number.',
      'Select "Download Aadhaar" for digital PDF or "Order Aadhaar PVC Card".',
      'Download the password-protected PDF (Password: First 4 letters of name in CAPS + Year of Birth).',
    ],
  ),
  ServiceData(
    id: 'voter-id',
    name: 'Election Commission of India (ECI)',
    state: 'All States',
    category: 'docs',
    section: 'govt-docs',
    documentType: 'e-EPIC Voter Card',
    logoType: 'eci',
    tag: 'Identity',
    iconEmoji: '🗳️',
    requiredDocs: ['Age Proof', 'Address Proof', 'Passport Photo'],
    portalUrl: 'https://voters.eci.gov.in/',
    portalDomain: 'voters.eci.gov.in',
    price: 'Free / ₹0 (No Govt Fee)',
    processingTime: 'Instant Download | 10-15 Days for New Registration',
    procedure: [
      'Open the ECI Voters Service Portal (voters.eci.gov.in) and sign in.',
      'Navigate to "E-EPIC Download" and enter your EPIC / Voter Number.',
      'Verify with OTP sent to your ECI-linked mobile number.',
      'Download your verified e-EPIC card with digital QR code verification.',
    ],
  ),
  ServiceData(
    id: 'morth-dl',
    name: 'Ministry of Road Transport (Parivahan)',
    state: 'MoRTH — Parivahan',
    category: 'docs',
    section: 'govt-docs',
    documentType: 'Driving Licence & RC',
    logoType: 'morth',
    tag: 'Transport',
    iconEmoji: '🚗',
    requiredDocs: ['Form 1 Medical Declaration', 'Aadhaar Card', 'Blood Group'],
    portalUrl: 'https://parivahan.gov.in/parivahan/',
    portalDomain: 'parivahan.gov.in',
    price: '₹200 (Learner Licence Test) | ₹500 (Driving Licence Issue)',
    processingTime: 'Same Day (LL) | 7-14 Days (Permanent Driving Licence)',
    procedure: [
      'Visit Sarathi Parivahan portal and select your Home State and RTO.',
      'Fill Application Form for New Learner / Driving Licence.',
      'Upload Form 1 Self Declaration, Age & Address Proofs, and pay application fee online.',
      'Book your RTO driving test appointment slot or take contactless LL exam.',
    ],
  ),
  ServiceData(
    id: 'pmjay-health',
    name: 'National Health Authority (NHA)',
    state: 'Ayushman Bharat PM-JAY',
    category: 'docs',
    section: 'govt-docs',
    documentType: 'Ayushman Bharat ABHA Card',
    logoType: 'pmjay',
    tag: 'Health Insurance',
    iconEmoji: '🏥',
    requiredDocs: ['Aadhaar Number', 'Linked Mobile OTP'],
    portalUrl: 'https://beneficiary.nha.gov.in/',
    portalDomain: 'beneficiary.nha.gov.in',
    price: 'Free / ₹0 (Provides ₹5 Lakh Annual Health Cover)',
    processingTime: 'Instant Digital Health Card Creation',
    procedure: [
      'Access the National Health Authority Beneficiary portal (beneficiary.nha.gov.in).',
      'Select "Create ABHA Number" using your 12-digit Aadhaar.',
      'Verify the OTP received on Aadhaar registered phone number.',
      'Download your 14-digit ABHA Digital Health Card with personalized QR ID.',
    ],
  ),
  ServiceData(
    id: 'mea-passport',
    name: 'Passport Seva (MEA)',
    state: 'Passport Seva',
    category: 'docs',
    section: 'govt-docs',
    documentType: 'Passport Verification & PCC',
    logoType: 'mea',
    tag: 'Passport',
    iconEmoji: '🛂',
    requiredDocs: ['Aadhaar Card', 'PAN Card', 'Bank Passbook'],
    portalUrl: 'https://www.passportindia.gov.in/',
    portalDomain: 'passportindia.gov.in',
    price: '₹1,500 (36-Page Standard) | ₹2,000 (60-Page Jumbo) | ₹3,500 (Tatkaal)',
    processingTime: '7-15 Working Days (Normal) | 1-3 Days (Tatkaal)',
    procedure: [
      'Register on Passport Seva Online Portal (passportindia.gov.in).',
      'Fill the Online Application Form for Fresh Passport / Re-issue / PCC.',
      'Pay required application fee online via NetBanking / UPI / Card.',
      'Book appointment slot and visit designated PSK / POPSK for biometric verification.',
    ],
  ),
  ServiceData(
    id: 'nfsa-pds',
    name: 'Dept of Food & Public Distribution',
    state: 'NFSA / PDS Portal',
    category: 'docs',
    section: 'govt-docs',
    documentType: 'Family Ration Card',
    logoType: 'pds',
    tag: 'Food Security',
    iconEmoji: '🌾',
    requiredDocs: ['Family Head Aadhaar', 'LPG Connection Bill', 'Income Proof'],
    portalUrl: 'https://nfsa.gov.in/',
    portalDomain: 'nfsa.gov.in',
    price: '₹0 - ₹20 (State Statutory Fee)',
    processingTime: '15-30 Working Days',
    procedure: [
      'Access State PDS / NFSA portal and select New Ration Card application.',
      'Provide Family Head details, residential address & LPG connection number.',
      'Add family members with respective Aadhaar numbers & relationships.',
      'Submit form to local Food & Civil Supplies Inspector for field verification.',
    ],
  ),
  ServiceData(
    id: 'revenue-dept',
    name: 'Department of Land Resources & Revenue',
    state: 'State Governments',
    category: 'docs',
    section: 'govt-docs',
    documentType: 'Income, Caste & Domicile Certificate',
    logoType: 'revenue',
    tag: 'Certificates',
    iconEmoji: '📜',
    requiredDocs: ['Salary Slip / ITR / Form 16', 'Ration Card', 'Self Declaration'],
    portalUrl: 'https://serviceonline.gov.in/',
    portalDomain: 'serviceonline.gov.in',
    price: '₹15 - ₹30 (e-District Facilitation Fee)',
    processingTime: '7-15 Working Days',
    procedure: [
      'Log in to State e-District / ServiceOnline citizen portal.',
      'Select required certificate (Income / Caste / Domicile / Character).',
      'Upload salary slip, electricity bill, self-declaration & Aadhaar copy.',
      'Track verification by Revenue Inspector / Tehsildar and download digitally signed certificate.',
    ],
  ),

  // --- SECTION: GOVT EXAMS & EDUCATION ---
  ServiceData(
    id: 'upsc-exam',
    name: 'Union Public Service Commission (UPSC)',
    state: 'Civil Services / NDA / CDS / CMS',
    category: 'exams',
    section: 'govt-exams',
    documentType: 'Online Application & Admit Card',
    logoType: 'upsc',
    tag: 'Civil Services',
    iconEmoji: '🎓',
    requiredDocs: [
      'Scanned Passport Photo (20-50 KB, White BG)',
      'Scanned Signature (10-20 KB, Black Ink)',
      'Aadhaar / Photo ID Proof',
      'Graduation Degree / Final Year Details',
    ],
    portalUrl: 'https://upsconline.nic.in/',
    portalDomain: 'upsconline.nic.in',
    applyUrl: 'https://upsconline.nic.in/',
    price: '₹100 (General/OBC/EWS Male) | ₹0 (Female / SC / ST / PwBD)',
    processingTime: 'Instant OTR & Form Confirmation',
    eligibility: "Bachelor's Degree in any discipline from a recognized University",
    ageLimit: '21 to 32 Years (OBC: +3 yrs, SC/ST: +5 yrs, PwBD: +10 yrs)',
    examDates: 'CSE Prelims: 25 May 2025 | Mains: 19 Sept 2025',
    lastDateToApply: 'Check UPSC Annual Calendar (Usually 6:00 PM)',
    vacancyCount: '1,056+ All India Cadre Posts (IAS, IPS, IFS, IRS, Group A/B)',
    examMode: 'Offline Pen-Paper (Prelims: Objective OMR | Mains: Descriptive)',
    salaryScale: 'Pay Level 10 (₹56,100 - ₹1,77,500/month + DA/HRA)',
    procedure: [
      'Visit upsconline.nic.in and complete One Time Registration (OTR) profile verification.',
      'Log in with OTR ID/Mobile and select active recruitment (CSE / NDA / CDS / CMS).',
      'Fill examination center preference, academic credentials, and upload Photo & Signature.',
      'Pay online fee (₹100) via UPI/Debit/NetBanking & download generated Application Form PDF.',
    ],
  ),
  ServiceData(
    id: 'ssc-exam',
    name: 'Staff Selection Commission (SSC)',
    state: 'CGL / CHSL / MTS / CPO / GD',
    category: 'exams',
    section: 'govt-exams',
    documentType: 'Application Form & Hall Ticket',
    logoType: 'ssc',
    tag: 'Central Exams',
    iconEmoji: '📋',
    requiredDocs: [
      'Live Webcam/Phone Selfie Capture (White BG)',
      'Scanned Signature (10-20 KB)',
      '10th Roll No. & Board Certificate',
      'Aadhaar Card / Govt Photo ID',
    ],
    portalUrl: 'https://ssc.gov.in/',
    portalDomain: 'ssc.gov.in',
    applyUrl: 'https://ssc.gov.in/portal/login',
    price: '₹100 (Gen/OBC Male) | ₹0 (Women / SC / ST / ESM)',
    processingTime: 'Instant Application ID & Admit Card Access',
    eligibility: '10th Pass (MTS) / 12th Pass (CHSL) / Graduate (CGL/CPO)',
    ageLimit: '18 to 27 / 32 Years (as per specific post code & category rules)',
    examDates: 'Tier-1 CBT / Tier-2 Computer Based Exam Cycle',
    lastDateToApply: 'Active Online (As per SSC Official Schedule)',
    vacancyCount: '17,727+ Central Ministries Group B & C Vacancies',
    examMode: 'Computer Based Test (CBT) with Bilingual MCQs',
    salaryScale: 'Pay Level 2 to Level 8 (₹19,900 - ₹1,51,100/month)',
    procedure: [
      'Access the new official SSC portal (ssc.gov.in) and register One-Time Registration (OTR).',
      'Fill personal details, upload live facial photo through mobile camera or webcam.',
      'Select active vacancy notification and choose 3 preferred examination cities.',
      'Complete fee payment via BHIM UPI/Card and save printable registration acknowledgement.',
    ],
  ),
  ServiceData(
    id: 'nta-testing',
    name: 'National Testing Agency (NTA)',
    state: 'JEE Main / NEET-UG / CUET-UG',
    category: 'exams',
    section: 'govt-exams',
    documentType: 'Entrance Form, City Slip & Admit Card',
    logoType: 'nta',
    tag: 'Entrance Exams',
    iconEmoji: '🔬',
    requiredDocs: [
      'Passport Photograph (10-200 KB, 80% face visible)',
      'Candidate Signature (4-30 KB)',
      'Category / PwD Certificate (if applicable)',
      'Class 10th & 12th Marksheet Details',
    ],
    portalUrl: 'https://exams.nta.ac.in/',
    portalDomain: 'exams.nta.ac.in',
    applyUrl: 'https://jeemain.nta.nic.in/',
    price: '₹1,000 (General Male) | ₹800 (Gen Female/EWS) | ₹500 (SC/ST/PwD)',
    processingTime: 'Instant Confirmation Page & Admit Card Generation',
    eligibility: 'Class 12th Appearing or Passed with Physics, Chemistry & Maths/Bio',
    ageLimit: 'No Age Limit for JEE Main / Minimum 17 Years for NEET-UG',
    examDates: 'Session 1 & Session 2 Multi-Shift Examination',
    lastDateToApply: 'Active NTA Registration Window (11:50 PM Deadline)',
    vacancyCount: 'All India IITs, NITs, AIIMS, Central Universities Admissions',
    examMode: 'Computer Based Test (CBT for JEE/CUET) & Pen-Paper (NEET-UG)',
    salaryScale: 'National Level Higher Education Entrance & Merit Scholarships',
    procedure: [
      'Open exams.nta.ac.in or specific exam portal (e.g., jeemain.nta.nic.in / neet.nta.nic.in).',
      'Register with Aadhaar Authentication or APAAR / ABC ID for seamless verification.',
      'Fill academic scores, select question paper medium (Hindi/English/Regional) & test centers.',
      'Upload photo, signature, category certificate and pay online registration fee.',
    ],
  ),
  ServiceData(
    id: 'cbse-board',
    name: 'Central Board of Sec. Education (CBSE)',
    state: 'Class 10th & 12th Board Portal',
    category: 'exams',
    section: 'govt-exams',
    documentType: 'Private Candidate Form & Marksheet',
    logoType: 'cbse',
    tag: 'Board Portal',
    iconEmoji: '📚',
    requiredDocs: [
      'Previous Board Roll Number & Year',
      'School Code & Center Code',
      'Recent Passport Photograph & Signature',
      'Aadhaar / Citizen Identity Number',
    ],
    portalUrl: 'https://www.cbse.gov.in/',
    portalDomain: 'cbse.gov.in',
    applyUrl: 'https://www.cbse.gov.in/cbsenew/parikshasangam.html',
    price: '₹1,500 (5 Subjects) | ₹300 (Additional Subject) | Marksheet: Free',
    processingTime: 'Instant Digital Certificate Fetch / Form Submission',
    eligibility: 'CBSE Registered Regular & Private Students (10th & 12th)',
    ageLimit: 'Standard Secondary & Higher Secondary School Norms',
    examDates: 'Annual Board Exams (Feb 15 - April 10)',
    lastDateToApply: 'LOC / Private Candidate Registration Window',
    vacancyCount: 'Over 39 Lakh Board Candidates Across India & Abroad',
    examMode: 'Offline Pen & Paper Board Examination',
    salaryScale: 'Central Board AISSE & AISSCE Recognized Certification',
    procedure: [
      'Visit cbse.gov.in and enter Pariksha Sangam / Private Candidate Portal.',
      'Select candidate type (Improvement / Compartment / Fail / Additional Subject).',
      'Enter previous year Roll Number, School Number & Center Number to fetch records.',
      'Verify auto-filled details, upload photo/signature and pay online examination fee.',
    ],
  ),
  ServiceData(
    id: 'rrb-railway',
    name: 'Railway Recruitment Control Board (RRB)',
    state: 'NTPC / Group D / ALP / Technicians',
    category: 'exams',
    section: 'govt-exams',
    documentType: 'Online Application & E-Call Letter',
    logoType: 'rrb',
    tag: 'Railways',
    iconEmoji: '🚆',
    requiredDocs: [
      'Live Photo Capture & Scanned Photo (35x45mm)',
      'Scanned Signature on Plain White Paper',
      'SC/ST Certificate (for Free Rail Travel Pass)',
      '10th Marksheet / ITI / Diploma / Degree',
    ],
    portalUrl: 'https://www.rrbapply.gov.in/',
    portalDomain: 'rrbapply.gov.in',
    applyUrl: 'https://www.rrbapply.gov.in/',
    price: '₹500 (₹400 refunded on CBT-1 attendance) | ₹250 (Full Refund for SC/ST/Women)',
    processingTime: 'Instant Application Tracking & City Allotment',
    eligibility: '10th + ITI (ALP/Tech) / 12th (Undergraduate NTPC) / Graduate (NTPC)',
    ageLimit: '18 to 33 / 36 Years (3 Years COVID age relaxation applicable)',
    examDates: 'CBT-1 & CBT-2 Scheduled across nationwide railway zones',
    lastDateToApply: 'Active Online as per CEN Employment Notice',
    vacancyCount: '18,799+ Assistant Loco Pilot & Technician Central Railway Posts',
    examMode: 'Computer Based Test (CBT-1 & CBT-2) with 1/3rd Negative Marking',
    salaryScale: 'Pay Level 2 to Level 6 (₹19,900 - ₹35,400 + Running Allowances)',
    procedure: [
      'Open official Railway application website (rrbapply.gov.in) and Create Account.',
      'Verify mobile OTP & email, then enter Aadhaar verification details.',
      'Select your preferred Railway Recruitment Board (RRB Zone) and post preferences.',
      'Upload live webcam capture, scanned signature and pay test fee with bank refund account.',
    ],
  ),
  ServiceData(
    id: 'ibps-bank',
    name: 'Institute of Banking Personnel Selection (IBPS)',
    state: 'PO / Clerk / SO / RRB Officer',
    category: 'exams',
    section: 'govt-exams',
    documentType: 'CRP Online Application & Result Record',
    logoType: 'ibps',
    tag: 'Banking',
    iconEmoji: '💼',
    requiredDocs: [
      'Passport Size Photograph (20-50 KB)',
      'Candidate Signature (10-20 KB, Black Ink)',
      'Left Thumb Impression (LTI) Scan (20-50 KB)',
      'Handwritten Declaration in English (50-100 KB)',
    ],
    portalUrl: 'https://www.ibps.in/',
    portalDomain: 'ibps.in',
    applyUrl: 'https://ibpsonline.ibps.in/',
    price: '₹850 (General / EWS / OBC) | ₹175 (SC / ST / PwBD)',
    processingTime: 'Instant Registration & E-Call Letter Generation',
    eligibility: 'Graduation in any discipline from a recognized University',
    ageLimit: 'Clerk: 20-28 Years | Probationary Officer (PO): 20-30 Years',
    examDates: 'Prelims in Aug/Oct | Mains in Sept/Nov | Interviews in Jan/Feb',
    lastDateToApply: 'Active IBPS Common Recruitment Process (CRP) Window',
    vacancyCount: '9,995+ Vacancies across 11 Nationalized Public Sector Banks',
    examMode: 'Online Computer Based Test (Prelims Speed Test + Mains In-depth)',
    salaryScale: 'Scale I Officer: ₹52,000 - ₹65,000/month in-hand + Quarters',
    procedure: [
      'Visit ibps.in and click on "Click here for New Registration" under active CRP notification.',
      'Fill basic info, academic marks percentage, and choose bank preference order.',
      'Upload Scanned Photo, Signature, Left Thumb Impression & Handwritten Declaration.',
      'Preview complete application, pay registration fee and download e-receipt.',
    ],
  ),
  ServiceData(
    id: 'ugc-net',
    name: 'University Grants Commission (UGC-NET)',
    state: 'National Eligibility Test & JRF',
    category: 'exams',
    section: 'govt-exams',
    documentType: 'Application Form & E-Certificate',
    logoType: 'ugc',
    tag: 'Research',
    iconEmoji: '🎓',
    requiredDocs: [
      'Passport Photo (10-200 KB) & Signature (4-30 KB)',
      "Master's Degree Marksheet / Pursuing Certificate",
      'Category / EWS / PwD Certificate (if applicable)',
      'Govt Photo ID (Aadhaar / Voter ID / Passport)',
    ],
    portalUrl: 'https://ugcnet.nta.ac.in/',
    portalDomain: 'ugcnet.nta.ac.in',
    applyUrl: 'https://ugcnet.nta.ac.in/',
    price: '₹1,150 (General) | ₹600 (Gen-EWS / OBC-NCL) | ₹325 (SC / ST / PwD / Third Gender)',
    processingTime: 'Instant Application & Digital Certificate Generation',
    eligibility: "Master's Degree or equivalent with at least 55% marks (50% for SC/ST/OBC)",
    ageLimit: 'JRF: Max 30 Years (5 yrs relaxation) | Assistant Professor: No Upper Age Limit',
    examDates: 'Biannual Cycles (June & December National Test)',
    lastDateToApply: 'Active Online NTA Registration Window',
    vacancyCount: 'Eligible for Assistant Professorship & PhD Admissions across all Indian Universities',
    examMode: 'Computer Based Test (Paper 1: Teaching/Research + Paper 2: Subject Specific)',
    salaryScale: 'Junior Research Fellowship (JRF): ₹37,000/month + HRA + Contingency',
    procedure: [
      'Go to ugcnet.nta.ac.in and click "Apply for UGC-NET Online".',
      'Register with APAAR/ABC ID or Aadhaar Card and create login password.',
      'Select your PG subject code, preferred exam cities, and JRF / Assistant Professor option.',
      'Upload documents, pay examination fee via SBI/HDFC gateway & download confirmation page.',
    ],
  ),
  ServiceData(
    id: 'state-psc',
    name: 'State Public Service Commissions',
    state: 'State Administrative & Police Services (PCS / State Civil Services)',
    category: 'exams',
    section: 'govt-exams',
    documentType: 'State PSC Application & Hall Ticket',
    logoType: 'psc',
    tag: 'State Exams',
    iconEmoji: '⚖️',
    requiredDocs: [
      'State One Time Registration (OTR) ID',
      'Passport Photo & Signature with Date Stamp',
      'Domicile & Caste Certificate (for State Quota)',
      'Graduation Degree & 10th Certificate',
    ],
    portalUrl: 'https://serviceonline.gov.in/',
    portalDomain: 'serviceonline.gov.in',
    applyUrl: 'https://serviceonline.gov.in/',
    price: '₹125 - ₹250 (State Examination Fee) | Domicile SC/ST: ₹65 - ₹105',
    processingTime: 'Instant OTR Verification & Admit Card Download',
    eligibility: 'Graduate in any stream from recognized Indian University',
    ageLimit: '21 to 40 Years (State Domicile OBC: +3 yrs, SC/ST: +5 yrs)',
    examDates: 'State Combined Civil Services / Judicial Prelims & Mains',
    lastDateToApply: 'As per State Public Service Commission Advertisement',
    vacancyCount: 'Sub-Divisional Magistrate (SDM), DSP, BDO, Tehsildar & State Group A/B Posts',
    examMode: 'Offline OMR Prelims + Subjective Mains Exam + Personality Interview',
    salaryScale: 'State Pay Matrix Level 7 to Level 12 (₹44,900 - ₹1,77,500/month)',
    procedure: [
      'Open your respective State PSC portal (e.g., UPPSC, BPSC, MPPSC, MPSC, RPSC, TNPSC).',
      'Complete State OTR registration and verify domicile status for reservation benefits.',
      'Apply against active Combined State/Upper Subordinate Services advertisement.',
      'Upload verified documents, pay fee and print official registration slip.',
    ],
  ),

  // --- SECTION: FINANCIAL & WELFARE ---
  ServiceData(
    id: 'epfo-uan',
    name: 'Employees Provident Fund (EPFO)',
    state: 'Ministry of Labour',
    category: 'finance',
    section: 'finance-welfare',
    documentType: 'UAN Card & Member Passbook',
    logoType: 'epfo',
    tag: 'Pensions',
    iconEmoji: '🏦',
    requiredDocs: ['12-Digit UAN', 'Aadhaar Linked Mobile OTP'],
    portalUrl: 'https://unifiedportal-mem.epfindia.gov.in/memberinterface/',
    portalDomain: 'epfindia.gov.in',
    price: 'Free / ₹0 (No fee for UAN Passbook & Online PF Claim)',
    processingTime: 'Instant Passbook | 3-7 Days for PF Claim Settlement',
    procedure: [
      'Access EPFO Member Unified Portal (epfindia.gov.in).',
      'Enter your 12-digit UAN Number, Password and Security Captcha.',
      'Authenticate with OTP sent to Aadhaar-linked registered mobile.',
      'View & download updated Member Passbook, UAN Card or file Form 19/31/10C claim.',
    ],
  ),
  ServiceData(
    id: 'lic-insurance',
    name: 'Life Insurance Corp. (LIC)',
    state: 'All States',
    category: 'finance',
    section: 'finance-welfare',
    documentType: 'Policy Bonds & Premium Status',
    logoType: 'lic',
    tag: 'Insurance',
    iconEmoji: '🛡️',
    requiredDocs: ['Policy Number', 'Registered Mobile Number'],
    portalUrl: 'https://licindia.in/',
    portalDomain: 'licindia.in',
    price: 'Free / ₹0 (Portal Services & Premium Receipt Download)',
    processingTime: 'Instant Premium Receipt & Policy Statement',
    procedure: [
      'Log in to LIC Customer Portal (licindia.in).',
      'Enter Policy Number, Installment Premium and Date of Birth.',
      'View policy status, bonus accumulation, loan eligibility and revival quotes.',
      'Download Premium Paid Certificate for Section 80C tax exemption.',
    ],
  ),
  ServiceData(
    id: 'sbi-bank',
    name: 'State Bank of India (SBI)',
    state: 'All States',
    category: 'finance',
    section: 'finance-welfare',
    documentType: 'Account Statement & Passbook',
    logoType: 'sbi',
    tag: 'Banking',
    iconEmoji: '🏛️',
    requiredDocs: ['Account Number', 'Registered Mobile OTP'],
    portalUrl: 'https://www.onlinesbi.sbi/',
    portalDomain: 'onlinesbi.sbi',
    price: 'Free / ₹0 (Digital e-Statement & NetBanking)',
    processingTime: 'Instant e-Statement Generation',
    procedure: [
      'Log in to OnlineSBI / YONO portal with Username and Password.',
      'Complete 2-Factor Authentication via SMS OTP.',
      'Navigate to "My Accounts & Profile -> Account Statement".',
      'Select date range and download password-protected PDF statement.',
    ],
  ),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ServiceData> _getFilteredServices(String langCode) {
    return kServices.where((s) {
      final matchesNav = _currentNavIndex == 0 ||
          (_currentNavIndex == 1 && s.category == 'docs') ||
          (_currentNavIndex == 2 && s.category == 'exams');

      final q = _searchQuery.toLowerCase().trim();
      if (q.isEmpty) return matchesNav;

      final sName = ServiceTranslator.getServiceName(s.id, langCode).toLowerCase();
      final sDoc = ServiceTranslator.getServiceDoc(s.id, langCode).toLowerCase();
      final sTag = ServiceTranslator.getServiceTag(s.id, langCode).toLowerCase();
      final sState = ServiceTranslator.getServiceState(s.state, langCode).toLowerCase();

      final matchesSearch = s.name.toLowerCase().contains(q) ||
          s.state.toLowerCase().contains(q) ||
          s.tag.toLowerCase().contains(q) ||
          s.documentType.toLowerCase().contains(q) ||
          sName.contains(q) ||
          sDoc.contains(q) ||
          sTag.contains(q) ||
          sState.contains(q);
      return matchesNav && matchesSearch;
    }).toList();
  }



  void _showServiceModal(ServiceData service) {
    if (service.category == 'exams' || service.section == 'govt-exams') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ExamDetailScreen(
            service: service,
            onOpenVault: () => setState(() => _currentNavIndex = 1),
          ),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ServiceDetailScreen(
            service: service,
            onOpenVault: () => setState(() => _currentNavIndex = 1),
          ),
        ),
      );
    }
  }

  Widget _buildGrid(List<ServiceData> items, int crossAxisCount, bool isDark, String langCode) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          mainAxisExtent: 170,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final srv = items[index];
            final srvName = ServiceTranslator.getServiceName(srv.id, langCode);
            final srvTag  = ServiceTranslator.getServiceTag(srv.id, langCode);

            return GestureDetector(
              onTap: () => _showServiceModal(srv),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? const Color(0xFF2D3F55) : const Color(0xFFE8EEF4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Icon + Tag row ──────────────────────────────────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Large icon background
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.tealPrimary.withValues(alpha: 0.15)
                                  : AppColors.tealPrimary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              srv.iconEmoji,
                              style: const TextStyle(fontSize: 22),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Tag pill stacked on right
                          Expanded(
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.tealPrimary.withValues(alpha: 0.15)
                                      : AppColors.tealPrimary.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  srvTag,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? const Color(0xFF2DD4BF) : AppColors.tealPrimary,
                                    letterSpacing: 0.1,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // ── Service name ────────────────────────────────────
                      Text(
                        srvName,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                          height: 1.25,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const Spacer(),

                      // ── Portal ↗ + Fetch row ─────────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: GestureDetector(
                              onTap: () async {
                                final uri = Uri.parse(srv.portalUrl);
                                try {
                                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                                } catch (_) {}
                              },
                              child: Text(
                                'Portal ↗',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.tealPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _showServiceModal(srv),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF334155) : const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(
                                  color: isDark ? const Color(0xFF475569) : const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: Text(
                                langCode == 'hi' ? 'प्राप्त करें' : langCode == 'pa' ? 'ਲਓ' : 'Fetch',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          childCount: items.length,
        ),
      ),
    );
  }

  Widget _buildProfileView(bool isDark, DocuSewaAuthService auth) {
    return SliverToBoxAdapter(
      child: ValueListenableBuilder<List<VaultDoc>>(
        valueListenable: VaultState.vaultDocsNotifier,
        builder: (context, docs, _) {
          return ProfileScreen(
            vaultCount: docs.length,
            onNavigateToVault: () => setState(() => _currentNavIndex = 1),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = DocuSewaAuthService();
    final screenWidth = MediaQuery.of(context).size.width;

    final int crossAxisCount = screenWidth > 1100
        ? 4
        : screenWidth > 800
            ? 3
            : 2; // always 2 columns on phone/tablet

    return ValueListenableBuilder<String>(
      valueListenable: appLanguageNotifier,
      builder: (context, langCode, _) {
        final strings = AppStrings.getStrings(langCode);
        final filteredServices = _getFilteredServices(langCode);
        final govtDocs = filteredServices.where((s) => s.section == 'govt-docs').toList();
        final govtExams = filteredServices.where((s) => s.section == 'govt-exams').toList();
        final finance = filteredServices.where((s) => s.section == 'finance-welfare').toList();

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                if (_currentNavIndex == 3) ...[
                  _buildProfileView(isDark, auth),
                ] else ...[
                  // ── INLINE HEADER ─────────────────────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                      child: Row(
                        children: [
                          // User Profile Avatar with Online Badge
                          GestureDetector(
                            onTap: () {
                              setState(() => _currentNavIndex = 3);
                            },
                            child: ValueListenableBuilder<String>(
                              valueListenable: ProfileState.avatarNotifier,
                              builder: (context, currentAvatar, _) {
                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      width: 46,
                                      height: 46,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: AppColors.primaryGradient,
                                        border: Border.all(
                                          color: AppColors.tealPrimary.withValues(alpha: 0.5),
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.tealPrimary.withValues(alpha: 0.25),
                                            blurRadius: 10,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: ClipOval(
                                        child: Image.network(
                                          currentAvatar,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Center(
                                            child: Text(
                                              'DK',
                                              style: GoogleFonts.plusJakartaSans(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: const Color(0xFF10B981),
                                          border: Border.all(
                                            color: isDark ? const Color(0xFF0F172A) : Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          // User Name + Location
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() => _currentNavIndex = 3);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: ValueListenableBuilder<String>(
                                          valueListenable: ProfileState.fullNameNotifier,
                                          builder: (context, currentName, _) {
                                            return Text(
                                              currentName,
                                              style: GoogleFonts.plusJakartaSans(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w800,
                                                color: AppColors.textPrimary(isDark),
                                                letterSpacing: -0.3,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      const Icon(
                                        Icons.verified_rounded,
                                        size: 15,
                                        color: Color(0xFF0D9488),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_rounded,
                                        size: 13,
                                        color: Color(0xFF0D9488),
                                      ),
                                      const SizedBox(width: 2),
                                      Expanded(
                                        child: Text(
                                          langCode == 'hi'
                                              ? 'नोएडा, उत्तर प्रदेश'
                                              : langCode == 'pa'
                                                  ? 'ਨੋਇਡਾ, ਉੱਤਰ ਪ੍ਰਦੇਸ਼'
                                                  : 'Noida, Uttar Pradesh',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textSecondary(isDark),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Notification bell
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                                border: Border.all(
                                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(
                                    Icons.notifications_outlined,
                                    size: 22,
                                    color: AppColors.textPrimary(isDark),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 9,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFF0D9488),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── TAB 1: FULL CITIZEN DIGITAL VAULT ──────────────────────
                  if (_currentNavIndex == 1) ...[
                    SliverToBoxAdapter(
                      child: VaultScreen(
                        onNavigateToHome: () => setState(() => _currentNavIndex = 0),
                      ),
                    ),
                  ] else ...[
                    // ── SEARCH BAR ─────────────────────────────────────────────
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) => setState(() => _searchQuery = val),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: AppColors.textPrimary(isDark),
                            ),
                            decoration: InputDecoration(
                              hintText: strings.searchPlaceholder,
                              hintStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 13.5,
                                color: AppColors.textMuted(isDark),
                              ),
                              prefixIcon: Container(
                                margin: const EdgeInsets.all(12),
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: AppColors.tealPrimary.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.search_rounded, size: 16, color: AppColors.tealPrimary),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 15),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ── HERO BANNER ─────────────────────────────────────────────
                    if (_currentNavIndex == 0 && _searchQuery.isEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF0D9488), Color(0xFF0F766E), Color(0xFF115E59)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.tealPrimary.withValues(alpha: 0.35),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    right: -20,
                                    top: -20,
                                    child: Container(
                                      width: 110,
                                      height: 110,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withValues(alpha: 0.07),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 30,
                                    bottom: -20,
                                    child: Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withValues(alpha: 0.05),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 20, 16, 20),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                langCode == 'hi'
                                                    ? 'स्मार्ट दस्तावेज़,'
                                                    : langCode == 'pa'
                                                        ? 'ਸਮਾਰਟ ਦਸਤਾਵੇਜ਼,'
                                                        : 'Smart Documents,',
                                                style: GoogleFonts.plusJakartaSans(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.white,
                                                  height: 1.2,
                                                  letterSpacing: -0.4,
                                                ),
                                              ),
                                              Text(
                                                langCode == 'hi'
                                                    ? 'तेज़ पहुँच।'
                                                    : langCode == 'pa'
                                                        ? 'ਤੇਜ਼ ਪਹੁੰਚ।'
                                                        : 'Faster Access.',
                                                style: GoogleFonts.plusJakartaSans(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.white,
                                                  height: 1.2,
                                                  letterSpacing: -0.5,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                langCode == 'hi'
                                                    ? '25+ आधिकारिक पोर्टल'
                                                    : langCode == 'pa'
                                                        ? '25+ ਅਧਿਕਾਰਤ ਪੋਰਟਲ'
                                                        : '25+ Official Portals',
                                                style: GoogleFonts.plusJakartaSans(
                                                  fontSize: 12,
                                                  color: Colors.white.withValues(alpha: 0.85),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => setState(() => _currentNavIndex = 1),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: const Color(0xFF0F766E),
                                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            elevation: 0,
                                          ),
                                          child: Text(
                                            langCode == 'hi' ? 'वॉल्ट खोलें ↗' : 'Open Vault ↗',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                    // ── YOUR ISSUED DOCUMENTS CAROUSEL ──────────────────────────
                    if (_currentNavIndex == 0 && _searchQuery.isEmpty)
                      SliverToBoxAdapter(
                        child: _buildIssuedDocumentsSection(isDark, langCode),
                      ),

                    // ── CATEGORIES ROW ────────────────────────────────────────
                    if (_currentNavIndex == 0 && _searchQuery.isEmpty)
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(18, 20, 18, 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    langCode == 'hi' ? 'श्रेणियाँ' : langCode == 'pa' ? 'ਸ਼੍ਰੇਣੀਆਂ' : 'Service Categories',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary(isDark),
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Text(
                                      langCode == 'hi' ? 'सभी देखें' : langCode == 'pa' ? 'ਸਭ ਦੇਖੋ' : 'See All',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.tealPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 86,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                children: [
                                  _buildCategoryChip(
                                    emoji: '🪪',
                                    label: langCode == 'hi' ? 'पहचान' : langCode == 'pa' ? 'ਪਛਾਣ' : 'Identity',
                                    color: const Color(0xFF0D9488),
                                    isDark: isDark,
                                    onTap: () => setState(() => _currentNavIndex = 1),
                                  ),
                                  _buildCategoryChip(
                                    emoji: '🚗',
                                    label: langCode == 'hi' ? 'परिवहन' : langCode == 'pa' ? 'ਟ੍ਰਾਂਸਪੋਰਟ' : 'Transport',
                                    color: const Color(0xFF2563EB),
                                    isDark: isDark,
                                    onTap: () => setState(() => _currentNavIndex = 1),
                                  ),
                                  _buildCategoryChip(
                                    emoji: '🎓',
                                    label: langCode == 'hi' ? 'परीक्षा' : langCode == 'pa' ? 'ਪ੍ਰੀਖਿਆ' : 'Exams',
                                    color: const Color(0xFF7C3AED),
                                    isDark: isDark,
                                    onTap: () => setState(() => _currentNavIndex = 2),
                                  ),
                                  _buildCategoryChip(
                                    emoji: '🏦',
                                    label: langCode == 'hi' ? 'वित्त' : langCode == 'pa' ? 'ਵਿੱਤ' : 'Finance',
                                    color: const Color(0xFFD97706),
                                    isDark: isDark,
                                    onTap: () {},
                                  ),
                                  _buildCategoryChip(
                                    emoji: '🏥',
                                    label: langCode == 'hi' ? 'स्वास्थ्य' : langCode == 'pa' ? 'ਸਿਹਤ' : 'Health',
                                    color: const Color(0xFFDC2626),
                                    isDark: isDark,
                                    onTap: () {},
                                  ),
                                  _buildCategoryChip(
                                    emoji: '📜',
                                    label: langCode == 'hi' ? 'प्रमाण पत्र' : langCode == 'pa' ? 'ਸਰਟੀਫਿਕੇਟ' : 'Certificates',
                                    color: const Color(0xFF059669),
                                    isDark: isDark,
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    // ── SECTION HEADER: Govt Documents ─────────────────────────
                    if ((_currentNavIndex == 0) && govtDocs.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: _buildSectionHeaderNew(
                          icon: Icons.account_balance_rounded,
                          accentColor: AppColors.tealPrimary,
                          accentGradientEnd: AppColors.tealDark,
                          title: strings.identityDocsTitle,
                          count: govtDocs.length,
                          tag: strings.identityDocsBadge,
                          isDark: isDark,
                        ),
                      ),
                      _buildGrid(govtDocs, crossAxisCount, isDark, langCode),
                    ],

                    // ── SECTION HEADER: Govt Exams ──────────────────────────────
                    if ((_currentNavIndex == 0 || _currentNavIndex == 2) && govtExams.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: _buildSectionHeaderNew(
                          icon: Icons.school_rounded,
                          accentColor: const Color(0xFF2563EB),
                          accentGradientEnd: const Color(0xFF1D4ED8),
                          title: strings.examsTitle,
                          count: govtExams.length,
                          tag: strings.examsBadge,
                          isDark: isDark,
                        ),
                      ),
                      _buildGrid(govtExams, crossAxisCount, isDark, langCode),
                    ],

                  // ── SECTION HEADER: Finance & Welfare ──────────────────────
                  if (_currentNavIndex == 0 && finance.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: _buildSectionHeaderNew(
                        icon: Icons.account_balance_wallet_rounded,
                        accentColor: const Color(0xFFD97706),
                        accentGradientEnd: const Color(0xFFB45309),
                        title: strings.financeTitle,
                        count: finance.length,
                        tag: strings.financeBadge,
                        isDark: isDark,
                      ),
                    ),
                    _buildGrid(finance, crossAxisCount, isDark, langCode),
                  ],
                ],

                // Private Platform Disclaimer Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 20, 18, 10),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceSubtle : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border(isDark)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.tealPrimary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.tealPrimary),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              langCode == 'hi'
                                  ? 'DocuSewa एक स्वतंत्र निजी नागरिक सुविधा मंच है जो आधिकारिक सार्वजनिक पोर्टलों और सेवाओं तक त्वरित पहुंच एवं नेविगेशन को सरल बनाता है। हम किसी भी सरकारी एजेंसी से संबद्ध नहीं हैं।'
                                  : langCode == 'pa'
                                      ? 'DocuSewa ਇੱਕ ਸੁਤੰਤਰ ਨਿੱਜੀ ਨਾਗਰਿਕ ਸੁਵਿਧਾ ਪਲੇਟਫਾਰਮ ਹੈ ਜੋ ਅਧਿਕਾਰਤ ਪਬਲਿਕ ਪੋਰਟਲਾਂ ਤੱਕ ਸਿੱਧੀ ਪਹੁੰਚ ਨੂੰ ਆਸਾਨ ਬਣਾਉਂਦਾ ਹੈ। ਅਸੀਂ ਕਿਸੇ ਵੀ ਸਰਕਾਰੀ ਸੰਸਥਾ ਨਾਲ ਸੰਬੰਧਿਤ ਨਹੀਂ ਹਾਂ।'
                                      : 'DocuSewa is an independent private citizen utility platform designed to simplify navigation and direct access to official public portals. We are not affiliated with or an official government entity.',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                height: 1.45,
                                color: AppColors.textSecondary(isDark),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 30)),
              ],
            ],
          ),
        ),

          // ── BOTTOM NAVIGATION BAR ───────────────────────────────────────────
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: AppColors.surface(isDark),
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                height: 68,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      index: 0,
                      activeIcon: Icons.home_rounded,
                      inactiveIcon: Icons.home_outlined,
                      label: strings.navHome,
                      isDark: isDark,
                    ),
                    _buildNavItem(
                      index: 1,
                      activeIcon: Icons.lock_person_rounded,
                      inactiveIcon: Icons.lock_outline_rounded,
                      label: langCode == 'hi' ? 'वॉल्ट' : langCode == 'pa' ? 'ਵਾਲਟ' : 'Vault',
                      isDark: isDark,
                    ),
                    _buildNavItem(
                      index: 2,
                      activeIcon: Icons.school_rounded,
                      inactiveIcon: Icons.school_outlined,
                      label: strings.navExams,
                      isDark: isDark,
                    ),
                    _buildNavItem(
                      index: 3,
                      activeIcon: Icons.person_rounded,
                      inactiveIcon: Icons.person_outline_rounded,
                      label: strings.navProfile,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ── NEW SECTION HEADER (food-app style: title + count badge + See All) ───────
  Widget _buildSectionHeaderNew({
    required IconData icon,
    required Color accentColor,
    required Color accentGradientEnd,
    required String title,
    required int count,
    required String tag,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [accentColor, accentGradientEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(icon, size: 17, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary(isDark),
                      letterSpacing: -0.2,
                    ),
                  ),
                  Text(
                    '$count $tag',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // "See All" button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: isDark ? 0.18 : 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              'See All',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── CATEGORY CHIP (circular icon + label below) ────────────────────────────
  Widget _buildCategoryChip({
    required String emoji,
    required String label,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 68,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary(isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData activeIcon,
    required IconData inactiveIcon,
    required String label,
    required bool isDark,
  }) {
    final isSelected = _currentNavIndex == index;
    const activeColor = AppColors.tealPrimary;
    final inactiveColor = isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8);

    return InkWell(
      onTap: () => setState(() => _currentNavIndex = index),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pill indicator above icon
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: isSelected ? 28 : 0,
              height: 3,
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              size: 22,
              color: isSelected ? activeColor : inactiveColor,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? activeColor : inactiveColor,
                letterSpacing: -0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── ISSUED DOCUMENTS CAROUSEL ────────────────────────────────────────────────
  Widget _buildIssuedDocumentsSection(bool isDark, String langCode) {
    return ValueListenableBuilder<List<VaultDoc>>(
      valueListenable: VaultState.vaultDocsNotifier,
      builder: (context, docs, _) {
        if (docs.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    langCode == 'hi' ? 'आपके जारी किए गए दस्तावेज़' : 'Your Issued Documents',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF1E1B4B),
                      letterSpacing: -0.2,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _currentNavIndex = 1),
                    child: Text(
                      'VIEW ALL (${docs.length})',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF2563EB),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 116,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  return GestureDetector(
                    onTap: () => setState(() => _currentNavIndex = 1),
                    child: Container(
                      width: 295,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildOrgEmblem(doc.logoType, size: 44),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doc.title,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                                        letterSpacing: -0.2,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      doc.docNumber,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w500,
                                        color: isDark ? Colors.white60 : const Color(0xFF64748B),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Text(
                            doc.issuer,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: isDark ? Colors.white54 : const Color(0xFF94A3B8),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrgEmblem(String logoType, {double size = 44}) {
    switch (logoType) {
      case 'uidai':
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: AadhaarLogoPainter(),
          ),
        );
      case 'itd':
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: IncomeTaxLogoPainter(),
          ),
        );
      case 'abc':
      case 'apaar':
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: AcademicBankLogoPainter(),
          ),
        );
      case 'pseb':
      case 'cbse':
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: EducationBoardLogoPainter(),
          ),
        );
      case 'signature':
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF93C5FD)),
          ),
          child: const Center(
            child: Icon(Icons.draw_rounded, color: Color(0xFF2563EB), size: 24),
          ),
        );
      case 'photo':
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFFDE68A)),
          ),
          child: const Center(
            child: Icon(Icons.portrait_rounded, color: Color(0xFFD97706), size: 24),
          ),
        );
      case 'morth':
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF86EFAC), width: 1.5),
          ),
          child: const Center(
            child: Icon(Icons.directions_car_rounded, color: Color(0xFF16A34A), size: 22),
          ),
        );
      case 'pmjay':
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: const Color(0xFFFAF5FF),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFD8B4FE), width: 1.5),
          ),
          child: const Center(
            child: Icon(Icons.health_and_safety_rounded, color: Color(0xFF7C3AED), size: 22),
          ),
        );
      default:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: const Center(
            child: Icon(Icons.description_rounded, color: Color(0xFF0D9488), size: 22),
          ),
        );
    }
  }
}

