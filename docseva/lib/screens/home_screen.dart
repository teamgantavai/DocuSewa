import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:docusewa/services/auth_service.dart';
import 'package:docusewa/theme/app_colors.dart';
import 'package:docusewa/screens/profile_screen.dart';
import 'package:docusewa/config/translations.dart';

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
  ),

  // --- SECTION: GOVT EXAMS & EDUCATION ---
  ServiceData(
    id: 'upsc-exam',
    name: 'Union Public Service Commission (UPSC)',
    state: 'Civil Services / NDA / CDS',
    category: 'exams',
    section: 'govt-exams',
    documentType: 'e-Admit Card & Results',
    logoType: 'upsc',
    tag: 'Civil Services',
    iconEmoji: '🎓',
    requiredDocs: ['Registration ID / Roll No.', 'Date of Birth', 'Aadhaar ID'],
    portalUrl: 'https://upsconline.nic.in/',
    portalDomain: 'upsconline.nic.in',
  ),
  ServiceData(
    id: 'ssc-exam',
    name: 'Staff Selection Commission (SSC)',
    state: 'CGL / CHSL / MTS / GD',
    category: 'exams',
    section: 'govt-exams',
    documentType: 'Hall Ticket & Scorecard',
    logoType: 'ssc',
    tag: 'Central Exams',
    iconEmoji: '📋',
    requiredDocs: ['SSC Registration Number', 'Password / DOB'],
    portalUrl: 'https://ssc.gov.in/',
    portalDomain: 'ssc.gov.in',
  ),
  ServiceData(
    id: 'nta-testing',
    name: 'National Testing Agency (NTA)',
    state: 'JEE Main / NEET-UG / CUET',
    category: 'exams',
    section: 'govt-exams',
    documentType: 'JEE / NEET / CUET Admit Card',
    logoType: 'nta',
    tag: 'Entrance Exams',
    iconEmoji: '🔬',
    requiredDocs: ['Application Number', 'Date of Birth', 'Security PIN'],
    portalUrl: 'https://exams.nta.ac.in/',
    portalDomain: 'exams.nta.ac.in',
  ),
  ServiceData(
    id: 'cbse-board',
    name: 'Central Board of Sec. Education (CBSE)',
    state: 'CBSE / All India',
    category: 'exams',
    section: 'govt-exams',
    documentType: '10th & 12th Marksheets',
    logoType: 'cbse',
    tag: 'Board Results',
    iconEmoji: '📚',
    requiredDocs: ['Roll Number', 'Passing Year', 'School Code'],
    portalUrl: 'https://www.cbse.gov.in/',
    portalDomain: 'cbse.gov.in',
  ),
  ServiceData(
    id: 'rrb-railway',
    name: 'Railway Recruitment Control Board (RRB)',
    state: 'NTPC / Group D / ALP Exams',
    category: 'exams',
    section: 'govt-exams',
    documentType: 'E-Call Letter & CBT Score Summary',
    logoType: 'rrb',
    tag: 'Railways',
    iconEmoji: '🚆',
    requiredDocs: ['Registration ID', 'User Password / DOB'],
    portalUrl: 'https://www.rrbapply.gov.in/',
    portalDomain: 'rrbapply.gov.in',
  ),
  ServiceData(
    id: 'ibps-bank',
    name: 'Institute of Banking Personnel Selection (IBPS)',
    state: 'PO / Clerk / Specialist Officer',
    category: 'exams',
    section: 'govt-exams',
    documentType: 'Call Letter & Combined Result Record',
    logoType: 'ibps',
    tag: 'Banking',
    iconEmoji: '💼',
    requiredDocs: ['Registration Number', 'Roll Number & DOB'],
    portalUrl: 'https://www.ibps.in/',
    portalDomain: 'ibps.in',
  ),
  ServiceData(
    id: 'ugc-net',
    name: 'University Grants Commission (UGC-NET)',
    state: 'National Eligibility & JRF',
    category: 'exams',
    section: 'govt-exams',
    documentType: 'E-Certificate & JRF Award Letter',
    logoType: 'ugc',
    tag: 'Research',
    iconEmoji: '🎓',
    requiredDocs: ['Application Number', 'Roll Number', 'Exam Session'],
    portalUrl: 'https://ugcnet.nta.ac.in/',
    portalDomain: 'ugcnet.nta.ac.in',
  ),
  ServiceData(
    id: 'state-psc',
    name: 'State Public Service Commissions',
    state: 'State Administrative & Police Services',
    category: 'exams',
    section: 'govt-exams',
    documentType: 'State PSC Admit Card & Interview Call',
    logoType: 'psc',
    tag: 'State Exams',
    iconEmoji: '⚖️',
    requiredDocs: ['State OTR ID', 'Candidate Roll Number'],
    portalUrl: 'https://serviceonline.gov.in/',
    portalDomain: 'serviceonline.gov.in',
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

  final List<IssuedDoc> _vaultDocs = [
    const IssuedDoc(
      id: 'v-1',
      title: 'Aadhaar Digital Card',
      issuer: 'UIDAI Govt of India',
      docNumber: 'XXXX-XXXX-8921',
      issueDate: 'Issued 12 Jan 2024',
      logoType: 'uidai',
    ),
    const IssuedDoc(
      id: 'v-2',
      title: 'PAN Verification Record',
      issuer: 'Income Tax Department',
      docNumber: 'ABCDE1234F',
      issueDate: 'Issued 04 Mar 2023',
      logoType: 'itd',
    ),
    const IssuedDoc(
      id: 'v-3',
      title: 'Driving Licence & RC',
      issuer: 'MoRTH — Parivahan',
      docNumber: 'DL-04202100892',
      issueDate: 'Valid till 2041',
      logoType: 'morth',
    ),
  ];

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

  Widget _buildOrgLogo(String logoType, {double size = 52}) {
    IconData icon;
    Color iconColor;
    Color circleBg;
    Color borderColor;

    switch (logoType) {
      case 'itd':
        icon = Icons.star_rounded;
        iconColor = const Color(0xFFFACC15);
        circleBg = const Color(0xFF1E3A8A);
        borderColor = const Color(0xFF0D9488);
        break;
      case 'eci':
        icon = Icons.check_box_rounded;
        iconColor = const Color(0xFF16A34A);
        circleBg = const Color(0xFFFFFFFF);
        borderColor = const Color(0xFFE11D48);
        break;
      case 'uidai':
        icon = Icons.wb_sunny_rounded;
        iconColor = const Color(0xFFEA580C);
        circleBg = const Color(0xFFFFF7ED);
        borderColor = const Color(0xFFEA580C);
        break;
      case 'morth':
        icon = Icons.sports_motorsports_rounded;
        iconColor = const Color(0xFF047857);
        circleBg = const Color(0xFFF0FDF4);
        borderColor = const Color(0xFF16A34A);
        break;
      case 'pmjay':
        icon = Icons.spa_rounded;
        iconColor = const Color(0xFF16A34A);
        circleBg = const Color(0xFFFAF5FF);
        borderColor = const Color(0xFF9333EA);
        break;
      case 'mea':
        icon = Icons.star_rounded;
        iconColor = const Color(0xFFFACC15);
        circleBg = const Color(0xFF0F172A);
        borderColor = const Color(0xFF0F172A);
        break;
      case 'upsc':
        icon = Icons.military_tech_rounded;
        iconColor = const Color(0xFF1D4ED8);
        circleBg = const Color(0xFFEFF6FF);
        borderColor = const Color(0xFF1D4ED8);
        break;
      case 'ssc':
        icon = Icons.assignment_turned_in_rounded;
        iconColor = const Color(0xFF15803D);
        circleBg = const Color(0xFFF0FDF4);
        borderColor = const Color(0xFF15803D);
        break;
      case 'nta':
        icon = Icons.auto_stories_rounded;
        iconColor = const Color(0xFFC2410C);
        circleBg = const Color(0xFFFFF7ED);
        borderColor = const Color(0xFFC2410C);
        break;
      case 'rrb':
        icon = Icons.train_rounded;
        iconColor = const Color(0xFFB91C1C);
        circleBg = const Color(0xFFFEF2F2);
        borderColor = const Color(0xFFB91C1C);
        break;
      case 'ibps':
        icon = Icons.account_balance_rounded;
        iconColor = const Color(0xFF0369A1);
        circleBg = const Color(0xFFEFF6FF);
        borderColor = const Color(0xFF0369A1);
        break;
      case 'cbse':
        icon = Icons.school_rounded;
        iconColor = const Color(0xFF1D4ED8);
        circleBg = const Color(0xFFEFF6FF);
        borderColor = const Color(0xFF2563EB);
        break;
      case 'ugc':
        icon = Icons.psychology_rounded;
        iconColor = const Color(0xFF7E22CE);
        circleBg = const Color(0xFFFAF5FF);
        borderColor = const Color(0xFF7E22CE);
        break;
      case 'psc':
        icon = Icons.workspace_premium_rounded;
        iconColor = const Color(0xFFBE185D);
        circleBg = const Color(0xFFFDF2F8);
        borderColor = const Color(0xFFBE185D);
        break;
      case 'epfo':
        icon = Icons.circle_outlined;
        iconColor = const Color(0xFFCA8A04);
        circleBg = const Color(0xFFFEFCE8);
        borderColor = const Color(0xFFCA8A04);
        break;
      case 'lic':
        icon = Icons.security_rounded;
        iconColor = const Color(0xFFDC2626);
        circleBg = const Color(0xFFFEF2F2);
        borderColor = const Color(0xFFDC2626);
        break;
      case 'sbi':
        icon = Icons.circle_rounded;
        iconColor = const Color(0xFF0284C7);
        circleBg = const Color(0xFFEFF6FF);
        borderColor = const Color(0xFF0284C7);
        break;
      case 'pds':
        icon = Icons.grass_rounded;
        iconColor = const Color(0xFFD97706);
        circleBg = const Color(0xFFFFFBEB);
        borderColor = const Color(0xFFD97706);
        break;
      case 'revenue':
      default:
        icon = Icons.check_circle_outline_rounded;
        iconColor = const Color(0xFF0D9488);
        circleBg = const Color(0xFFF0FDFA);
        borderColor = const Color(0xFF0D9488);
        break;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: circleBg,
        border: Border.all(color: borderColor, width: 2.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Icon(icon, size: size * 0.52, color: iconColor),
      ),
    );
  }

  void _showServiceModal(ServiceData service) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final langCode = appLanguageNotifier.value;
    final strings = AppStrings.getStrings(langCode);
    final serviceName = ServiceTranslator.getServiceName(service.id, langCode);
    final serviceDoc = ServiceTranslator.getServiceDoc(service.id, langCode);
    bool isSubmitting = false;
    bool isSuccess = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface(isDark),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.tealSubtle),
            ),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: SingleChildScrollView(
              child: isSuccess
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFDCFCE7),
                            ),
                            child: const Center(
                              child: Icon(Icons.check_rounded, color: Color(0xFF16A34A), size: 34),
                            ),
                          ),
                          Text(
                            strings.docIssuedSuccess,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary(isDark),
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            strings.docIssuedDesc,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: isDark ? Colors.white70 : const Color(0xFF64748B),
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                                setState(() => _currentNavIndex = 1);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.tealPrimary,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 44),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                elevation: 0,
                              ),
                              child: Text(strings.viewInVault, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 14)),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 36,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: AppColors.border(isDark),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),

                        // Header preview in modal
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.border(isDark)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: Text(service.iconEmoji, style: const TextStyle(fontSize: 22)),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      serviceName,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textPrimary(isDark),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      serviceDoc,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12.5,
                                        color: AppColors.tealPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Official Government Portal Box
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF042F2E) : const Color(0xFFF0FDFA),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isDark ? const Color(0xFF115E59) : const Color(0xFFCCFBF1)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.verified_rounded, size: 14, color: AppColors.tealPrimary),
                                      const SizedBox(width: 5),
                                      Text(
                                        strings.officialPortal,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.tealPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                    decoration: BoxDecoration(
                                      color: AppColors.tealPrimary.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      service.portalDomain,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.tealPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      service.portalUrl,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? Colors.white70 : const Color(0xFF0F766E),
                                        decoration: TextDecoration.underline,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () async {
                                      final uri = Uri.parse(service.portalUrl);
                                      try {
                                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                                      } catch (_) {}
                                    },
                                    borderRadius: BorderRadius.circular(6),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: AppColors.tealPrimary,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            strings.visitSite,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(width: 3),
                                          const Icon(Icons.open_in_new_rounded, size: 11, color: Colors.white),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Required Docs Box
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.border(isDark)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                strings.requiredDetails,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary(isDark),
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...service.requiredDocs.map(
                                (doc) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.check_circle_rounded, size: 15, color: AppColors.tealPrimary),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          ServiceTranslator.getRequiredDoc(doc, langCode),
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 12,
                                            color: AppColors.textSecondary(isDark),
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
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.of(ctx).pop(),
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 44),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  side: BorderSide(color: AppColors.border(isDark)),
                                ),
                                child: Text(strings.close, style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary(isDark), fontWeight: FontWeight.w600)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: isSubmitting
                                    ? null
                                    : () {
                                        setModalState(() => isSubmitting = true);
                                        Future.delayed(const Duration(milliseconds: 750), () {
                                          if (ctx.mounted) {
                                            // Add to vault
                                            final newDoc = IssuedDoc(
                                              id: 'v-${DateTime.now().millisecondsSinceEpoch}',
                                              title: serviceDoc,
                                              issuer: serviceName,
                                              docNumber: 'DIGI-${100000 + (DateTime.now().millisecond * 800) % 900000}',
                                              issueDate: 'Issued Just Now',
                                              logoType: service.logoType,
                                            );
                                            setState(() {
                                              _vaultDocs.insert(0, newDoc);
                                            });
                                            setModalState(() {
                                              isSubmitting = false;
                                              isSuccess = true;
                                            });
                                          }
                                        });
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.tealPrimary,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 44),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  elevation: 0,
                                ),
                                child: isSubmitting
                                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                    : Text(strings.fetchDocument, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
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

  Widget _buildVaultSliverList(bool isDark, AppStrings strings, String langCode) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final doc = _vaultDocs[index];
            final title = ServiceTranslator.getVaultDocTitle(doc.logoType, doc.title, langCode);
            final issuer = ServiceTranslator.getVaultDocIssuer(doc.logoType, doc.issuer, langCode);
            final date = ServiceTranslator.getVaultDocDate(doc.issueDate, langCode);

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface(isDark),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border(isDark)),
              ),
              child: Row(
                children: [
                  _buildOrgLogo(doc.logoType, size: 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                title,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary(isDark),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              strings.verifiedBadge,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF16A34A),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          issuer,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: AppColors.textSecondary(isDark),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              doc.docNumber,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white70 : const Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              date,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.tealPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          childCount: _vaultDocs.length,
        ),
      ),
    );
  }

  Widget _buildProfileView(bool isDark, DocuSewaAuthService auth) {
    return SliverToBoxAdapter(
      child: ProfileScreen(
        vaultCount: _vaultDocs.length,
        onNavigateToVault: () => setState(() => _currentNavIndex = 1),
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
                          // Avatar circle with DocuSewa icon
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.primaryGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.tealPrimary.withValues(alpha: 0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.account_balance_rounded, color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 12),
                          // Greeting + app name
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  langCode == 'hi' ? 'नमस्ते, नागरिक' : langCode == 'pa' ? 'ਸਤਿ ਸ੍ਰੀ ਅਕਾਲ, ਨਾਗਰਿਕ' : 'Hello, Citizen',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textSecondary(isDark),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.location_on_rounded, size: 13, color: AppColors.tealPrimary),
                                    const SizedBox(width: 2),
                                    Text(
                                      langCode == 'hi' ? 'भारत सरकार · DocuSewa' : langCode == 'pa' ? 'ਭਾਰਤ ਸਰਕਾਰ · DocuSewa' : 'Govt of India · DocuSewa',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textPrimary(isDark),
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
                                // Decorative circles — positioned relative to a non-Positioned row
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
                                // The non-Positioned child drives the Stack's height
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
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white.withValues(alpha: 0.82),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            GestureDetector(
                                              onTap: () => setState(() => _currentNavIndex = 1),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  langCode == 'hi' ? 'अभी देखें' : langCode == 'pa' ? 'ਹੁਣੇ ਦੇਖੋ' : 'View My Docs',
                                                  style: GoogleFonts.plusJakartaSans(
                                                    fontSize: 12.5,
                                                    fontWeight: FontWeight.w800,
                                                    color: AppColors.tealPrimary,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Emoji illustration — right side
                                      const Text('🏛️', style: TextStyle(fontSize: 60)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  // ── QUICK CATEGORIES ────────────────────────────────────────
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

                  // Vault Documents Banner (if on vault tab index 1)
                  if (_currentNavIndex == 1) ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '📁 ${strings.navDocs}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary(isDark),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              strings.docIssuedDesc,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: AppColors.textSecondary(isDark),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildVaultSliverList(isDark, strings, langCode),
                  ],

                  // ── SECTION HEADER: Govt Documents ─────────────────────────
                  if ((_currentNavIndex == 0 || _currentNavIndex == 1) && govtDocs.isNotEmpty) ...[
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
                      activeIcon: Icons.article_rounded,
                      inactiveIcon: Icons.article_outlined,
                      label: strings.navDocs,
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
}
