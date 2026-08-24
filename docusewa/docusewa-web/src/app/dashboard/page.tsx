'use client';

import React, { useState, useMemo } from 'react';
import { useRouter } from 'next/navigation';
import { signOut } from '@/services/auth.service';
import ProfileSection from '@/components/profile/ProfileSection';
import {
  Language,
  translations,
  translateServiceState,
  translateRequiredDoc,
  translateVaultDoc,
} from '@/lib/translations';

interface ServiceItem {
  id: string;
  name: string;
  state: string;
  category: 'docs' | 'exams' | 'finance';
  section: 'govt-docs' | 'govt-exams' | 'finance-welfare';
  documentType: string;
  logoType: string;
  requiredDocs: string[];
  portalUrl: string;
  portalDomain: string;
}

interface IssuedDoc {
  id: string;
  title: string;
  issuer: string;
  docNumber: string;
  issueDate: string;
  verified: boolean;
  type: string;
}

const SERVICES_DATA: ServiceItem[] = [
  // --- SECTION: GOVT DOCUMENTS ---
  {
    id: 'pan-card',
    name: 'Income Tax Department',
    state: 'Central Government',
    category: 'docs',
    section: 'govt-docs',
    documentType: 'PAN Verification Record (e-PAN)',
    logoType: 'itd',
    requiredDocs: ['Aadhaar Card', 'Passport Photograph', 'Signature Proof'],
    portalUrl: 'https://eportal.incometax.gov.in/',
    portalDomain: 'incometax.gov.in',
  },
  {
    id: 'voter-id',
    name: 'Election Commission of India',
    state: 'All States',
    category: 'docs',
    section: 'govt-docs',
    documentType: 'Electoral Photo Identity Card (e-EPIC)',
    logoType: 'eci',
    requiredDocs: ['Age Proof', 'Address Proof', 'Passport Photo'],
    portalUrl: 'https://voters.eci.gov.in/',
    portalDomain: 'voters.eci.gov.in',
  },
  {
    id: 'uidai-aadhaar',
    name: 'Unique Identification Authority (UIDAI)',
    state: 'All States',
    category: 'docs',
    section: 'govt-docs',
    documentType: 'Aadhaar Digital Copy',
    logoType: 'uidai',
    requiredDocs: ['Registered Mobile OTP', 'Aadhaar Number / VID'],
    portalUrl: 'https://myaadhaar.uidai.gov.in/',
    portalDomain: 'myaadhaar.uidai.gov.in',
  },
  {
    id: 'morth-dl',
    name: 'Ministry of Road Transport & Highways',
    state: 'MoRTH — Parivahan',
    category: 'docs',
    section: 'govt-docs',
    documentType: 'Driving Licence & Vehicle RC',
    logoType: 'morth',
    requiredDocs: ['Form 1 Medical Declaration', 'Aadhaar Card', 'Blood Group'],
    portalUrl: 'https://parivahan.gov.in/parivahan/',
    portalDomain: 'parivahan.gov.in',
  },
  {
    id: 'pmjay-health',
    name: 'National Health Authority',
    state: 'Ayushman Bharat PM-JAY',
    category: 'docs',
    section: 'govt-docs',
    documentType: 'ABHA Health Card (₹5 Lakh Cover)',
    logoType: 'pmjay',
    requiredDocs: ['Aadhaar Number', 'Linked Mobile OTP'],
    portalUrl: 'https://beneficiary.nha.gov.in/',
    portalDomain: 'beneficiary.nha.gov.in',
  },
  {
    id: 'mea-passport',
    name: 'Ministry of External Affairs',
    state: 'Passport Seva',
    category: 'docs',
    section: 'govt-docs',
    documentType: 'Passport Verification & PCC',
    logoType: 'mea',
    requiredDocs: ['Aadhaar Card', 'PAN Card', 'Bank Passbook'],
    portalUrl: 'https://www.passportindia.gov.in/',
    portalDomain: 'passportindia.gov.in',
  },
  {
    id: 'nfsa-pds',
    name: 'Dept of Food & Public Distribution',
    state: 'NFSA / PDS Portal',
    category: 'docs',
    section: 'govt-docs',
    documentType: 'Family Ration Card',
    logoType: 'pds',
    requiredDocs: ['Family Head Aadhaar', 'LPG Connection Bill', 'Income Proof'],
    portalUrl: 'https://nfsa.gov.in/',
    portalDomain: 'nfsa.gov.in',
  },
  {
    id: 'revenue-dept',
    name: 'Department of Land Resources & Revenue',
    state: 'State Governments',
    category: 'docs',
    section: 'govt-docs',
    documentType: 'Income, Caste & Domicile Certificate',
    logoType: 'revenue',
    requiredDocs: ['Salary Slip / ITR / Form 16', 'Ration Card', 'Self Declaration'],
    portalUrl: 'https://serviceonline.gov.in/',
    portalDomain: 'serviceonline.gov.in',
  },

  // --- SECTION: GOVT EXAMS & EDUCATION ---
  {
    id: 'upsc-exam',
    name: 'Union Public Service Commission (UPSC)',
    state: 'Civil Services / NDA / CDS',
    category: 'exams',
    section: 'govt-exams',
    documentType: 'e-Admit Card & Final Selection Marksheet',
    logoType: 'upsc',
    requiredDocs: ['Registration ID / Roll No.', 'Date of Birth', 'Aadhaar ID'],
    portalUrl: 'https://upsconline.nic.in/',
    portalDomain: 'upsconline.nic.in',
  },
  {
    id: 'ssc-exam',
    name: 'Staff Selection Commission (SSC)',
    state: 'CGL / CHSL / MTS / GD',
    category: 'exams',
    section: 'govt-exams',
    documentType: 'Exam Hall Ticket & Score Card',
    logoType: 'ssc',
    requiredDocs: ['SSC Registration Number', 'Password / DOB'],
    portalUrl: 'https://ssc.gov.in/',
    portalDomain: 'ssc.gov.in',
  },
  {
    id: 'nta-testing',
    name: 'National Testing Agency (NTA)',
    state: 'JEE Main / NEET-UG / CUET',
    category: 'exams',
    section: 'govt-exams',
    documentType: 'NTA Admit Card & Official Scorecard',
    logoType: 'nta',
    requiredDocs: ['Application Number', 'Date of Birth', 'Security PIN'],
    portalUrl: 'https://exams.nta.ac.in/',
    portalDomain: 'exams.nta.ac.in',
  },
  {
    id: 'rrb-railway',
    name: 'Railway Recruitment Control Board (RRB)',
    state: 'NTPC / Group D / ALP Exams',
    category: 'exams',
    section: 'govt-exams',
    documentType: 'E-Call Letter & CBT Score Summary',
    logoType: 'rrb',
    requiredDocs: ['Registration ID', 'User Password / DOB'],
    portalUrl: 'https://www.rrbapply.gov.in/',
    portalDomain: 'rrbapply.gov.in',
  },
  {
    id: 'ibps-bank',
    name: 'Institute of Banking Personnel Selection (IBPS)',
    state: 'PO / Clerk / Specialist Officer',
    category: 'exams',
    section: 'govt-exams',
    documentType: 'Call Letter & Combined Result Record',
    logoType: 'ibps',
    requiredDocs: ['Registration Number', 'Roll Number & DOB'],
    portalUrl: 'https://www.ibps.in/',
    portalDomain: 'ibps.in',
  },
  {
    id: 'cbse-board',
    name: 'Central Board of Secondary Education (CBSE)',
    state: 'CBSE / All India',
    category: 'exams',
    section: 'govt-exams',
    documentType: 'Class X & XII Digital Marksheet & Certificate',
    logoType: 'cbse',
    requiredDocs: ['Roll Number', 'Passing Year', 'School Code'],
    portalUrl: 'https://www.cbse.gov.in/',
    portalDomain: 'cbse.gov.in',
  },
  {
    id: 'ugc-net',
    name: 'University Grants Commission (UGC-NET)',
    state: 'National Eligibility & JRF',
    category: 'exams',
    section: 'govt-exams',
    documentType: 'E-Certificate & JRF Award Letter',
    logoType: 'ugc',
    requiredDocs: ['Application Number', 'Roll Number', 'Exam Session'],
    portalUrl: 'https://ugcnet.nta.ac.in/',
    portalDomain: 'ugcnet.nta.ac.in',
  },
  {
    id: 'state-psc',
    name: 'State Public Service Commissions',
    state: 'State Administrative & Police Services',
    category: 'exams',
    section: 'govt-exams',
    documentType: 'State PSC Admit Card & Interview Call',
    logoType: 'psc',
    requiredDocs: ['State OTR ID', 'Candidate Roll Number'],
    portalUrl: 'https://serviceonline.gov.in/',
    portalDomain: 'serviceonline.gov.in',
  },

  // --- SECTION: FINANCIAL & WELFARE ---
  {
    id: 'epfo-uan',
    name: 'Employees’ Provident Fund Organisation',
    state: 'Ministry of Labour',
    category: 'finance',
    section: 'finance-welfare',
    documentType: 'UAN Card & Member Passbook',
    logoType: 'epfo',
    requiredDocs: ['12-Digit UAN', 'Aadhaar Linked Mobile OTP'],
    portalUrl: 'https://unifiedportal-mem.epfindia.gov.in/memberinterface/',
    portalDomain: 'epfindia.gov.in',
  },
  {
    id: 'lic-insurance',
    name: 'Life Insurance Corporation of India',
    state: 'All States',
    category: 'finance',
    section: 'finance-welfare',
    documentType: 'LIC Policy Document',
    logoType: 'lic',
    requiredDocs: ['Policy Number', 'Registered Mobile Number'],
    portalUrl: 'https://licindia.in/',
    portalDomain: 'licindia.in',
  },
  {
    id: 'sbi-bank',
    name: 'State Bank of India',
    state: 'All States',
    category: 'finance',
    section: 'finance-welfare',
    documentType: 'Account Statement & Passbook',
    logoType: 'sbi',
    requiredDocs: ['Account Number', 'Registered Mobile OTP'],
    portalUrl: 'https://www.onlinesbi.sbi/',
    portalDomain: 'onlinesbi.sbi',
  },
];

const INITIAL_VAULT_DOCS: IssuedDoc[] = [
  {
    id: 'v-1',
    title: 'Aadhaar Digital Card',
    issuer: 'Unique Identification Authority of India (UIDAI)',
    docNumber: 'XXXX-XXXX-8921',
    issueDate: 'Issued 12 Jan 2024',
    verified: true,
    type: 'uidai',
  },
  {
    id: 'v-2',
    title: 'Permanent Account Number (PAN)',
    issuer: 'Income Tax Department, Govt of India',
    docNumber: 'ABCDE1234F',
    issueDate: 'Issued 04 Mar 2023',
    verified: true,
    type: 'itd',
  },
  {
    id: 'v-3',
    title: 'Driving Licence (Transport)',
    issuer: 'Ministry of Road Transport & Highways',
    docNumber: 'DL-04202100892',
    issueDate: 'Valid till 2041',
    verified: true,
    type: 'morth',
  },
];

function OrgLogo({ type }: { type: string }) {
  switch (type) {
    case 'itd':
      return (
        <svg width="56" height="56" viewBox="0 0 100 100">
          <circle cx="50" cy="50" r="46" fill="#f0fdfa" stroke="#0d9488" strokeWidth="2.5" />
          <circle cx="50" cy="50" r="36" fill="#1e3a8a" />
          <path d="M50 24 L56 38 L72 40 L60 50 L63 66 L50 58 L37 66 L40 50 L28 40 L44 38 Z" fill="#facc15" />
          <text x="50" y="86" textAnchor="middle" fontSize="9" fontWeight="bold" fill="#1e3a8a">
            INCOME TAX
          </text>
        </svg>
      );

    case 'eci':
      return (
        <svg width="56" height="56" viewBox="0 0 100 100">
          <circle cx="50" cy="50" r="46" fill="#fff1f2" stroke="#e11d48" strokeWidth="2.5" />
          <rect x="26" y="28" width="48" height="40" rx="4" fill="#ffffff" stroke="#334155" strokeWidth="2" />
          <path d="M36 48 L46 58 L68 36" fill="none" stroke="#16a34a" strokeWidth="6" strokeLinecap="round" strokeLinejoin="round" />
          <text x="50" y="86" textAnchor="middle" fontSize="9.5" fontWeight="bold" fill="#e11d48">
            ECI INDIA
          </text>
        </svg>
      );

    case 'uidai':
      return (
        <svg width="56" height="56" viewBox="0 0 100 100">
          <circle cx="50" cy="50" r="46" fill="#fff7ed" stroke="#ea580c" strokeWidth="2.5" />
          <circle cx="50" cy="46" r="15" fill="#ea580c" />
          <path d="M50 20 L50 27 M50 65 L50 72 M24 46 L31 46 M69 46 L76 46 M32 28 L37 33 M63 59 L68 64 M32 64 L37 59 M63 33 L68 28" stroke="#ea580c" strokeWidth="3" strokeLinecap="round" />
          <text x="50" y="86" textAnchor="middle" fontSize="9.5" fontWeight="bold" fill="#c2410c">
            AADHAAR
          </text>
        </svg>
      );

    case 'morth':
      return (
        <svg width="56" height="56" viewBox="0 0 100 100">
          <circle cx="50" cy="50" r="46" fill="#f0fdf4" stroke="#16a34a" strokeWidth="2.5" />
          <circle cx="50" cy="46" r="18" fill="none" stroke="#047857" strokeWidth="3.5" />
          <circle cx="50" cy="46" r="6" fill="#047857" />
          <line x1="50" y1="28" x2="50" y2="40" stroke="#047857" strokeWidth="3.5" />
          <line x1="32" y1="46" x2="44" y2="46" stroke="#047857" strokeWidth="3.5" />
          <line x1="56" y1="46" x2="68" y2="46" stroke="#047857" strokeWidth="3.5" />
          <text x="50" y="84" textAnchor="middle" fontSize="9" fontWeight="bold" fill="#047857">
            PARIVAHAN
          </text>
        </svg>
      );

    case 'pmjay':
      return (
        <svg width="56" height="56" viewBox="0 0 100 100">
          <circle cx="50" cy="50" r="46" fill="#faf5ff" stroke="#9333ea" strokeWidth="2.5" />
          <path d="M50 25 C40 38 42 54 50 60 C58 54 60 38 50 25 Z" fill="#16a34a" />
          <path d="M30 38 C32 48 42 56 48 60 C40 53 35 46 30 38 Z" fill="#ea580c" />
          <path d="M70 38 C68 48 58 56 52 60 C60 53 65 46 70 38 Z" fill="#ea580c" />
          <text x="50" y="84" textAnchor="middle" fontSize="9.5" fontWeight="bold" fill="#9333ea">
            PM-JAY
          </text>
        </svg>
      );

    case 'mea':
      return (
        <svg width="56" height="56" viewBox="0 0 100 100">
          <circle cx="50" cy="50" r="46" fill="#0f172a" stroke="#ca8a04" strokeWidth="2.5" />
          <path d="M50 26 L54 36 L65 38 L57 46 L59 56 L50 51 L41 56 L43 46 L35 38 L46 36 Z" fill="#facc15" />
          <text x="50" y="82" textAnchor="middle" fontSize="8.5" fontWeight="bold" fill="#facc15">
            PASSPORT
          </text>
        </svg>
      );

    case 'upsc':
      return (
        <svg width="56" height="56" viewBox="0 0 100 100">
          <circle cx="50" cy="50" r="46" fill="#eff6ff" stroke="#1d4ed8" strokeWidth="2.5" />
          <circle cx="50" cy="46" r="18" fill="#1d4ed8" />
          <polygon points="50,34 54,42 63,43 56,49 58,58 50,53 42,58 44,49 37,43 46,42" fill="#facc15" />
          <text x="50" y="86" textAnchor="middle" fontSize="10" fontWeight="900" fill="#1d4ed8">
            UPSC
          </text>
        </svg>
      );

    case 'ssc':
      return (
        <svg width="56" height="56" viewBox="0 0 100 100">
          <circle cx="50" cy="50" r="46" fill="#f0fdf4" stroke="#15803d" strokeWidth="2.5" />
          <rect x="28" y="32" width="44" height="30" rx="6" fill="#15803d" />
          <text x="50" y="52" textAnchor="middle" fontSize="13" fontWeight="900" fill="#ffffff">
            SSC
          </text>
          <text x="50" y="86" textAnchor="middle" fontSize="8.5" fontWeight="bold" fill="#15803d">
            SELECTION
          </text>
        </svg>
      );

    case 'nta':
      return (
        <svg width="56" height="56" viewBox="0 0 100 100">
          <circle cx="50" cy="50" r="46" fill="#fff7ed" stroke="#c2410c" strokeWidth="2.5" />
          <path d="M30 54 L44 32 L56 50 L64 38 L72 54" fill="none" stroke="#c2410c" strokeWidth="4.5" strokeLinecap="round" strokeLinejoin="round" />
          <text x="50" y="86" textAnchor="middle" fontSize="10.5" fontWeight="900" fill="#c2410c">
            NTA
          </text>
        </svg>
      );

    case 'rrb':
      return (
        <svg width="56" height="56" viewBox="0 0 100 100">
          <circle cx="50" cy="50" r="46" fill="#fef2f2" stroke="#b91c1c" strokeWidth="2.5" />
          <rect x="32" y="30" width="36" height="32" rx="4" fill="#b91c1c" />
          <circle cx="42" cy="52" r="3" fill="#ffffff" />
          <circle cx="58" cy="52" r="3" fill="#ffffff" />
          <line x1="36" y1="40" x2="64" y2="40" stroke="#ffffff" strokeWidth="3" />
          <text x="50" y="86" textAnchor="middle" fontSize="9.5" fontWeight="bold" fill="#b91c1c">
            RRB RAIL
          </text>
        </svg>
      );

    case 'ibps':
      return (
        <svg width="56" height="56" viewBox="0 0 100 100">
          <circle cx="50" cy="50" r="46" fill="#eff6ff" stroke="#0369a1" strokeWidth="2.5" />
          <circle cx="50" cy="46" r="16" fill="#0369a1" />
          <text x="50" y="52" textAnchor="middle" fontSize="10" fontWeight="900" fill="#ffffff">
            BANK
          </text>
          <text x="50" y="86" textAnchor="middle" fontSize="9.5" fontWeight="bold" fill="#0369a1">
            IBPS
          </text>
        </svg>
      );

    case 'cbse':
      return (
        <svg width="56" height="56" viewBox="0 0 100 100">
          <circle cx="50" cy="50" r="46" fill="#eff6ff" stroke="#2563eb" strokeWidth="2.5" />
          <path d="M28 42 L50 28 L72 42 L50 56 Z" fill="#1d4ed8" />
          <path d="M36 50 L36 64 C36 70 64 70 64 64 L64 50" fill="none" stroke="#1d4ed8" strokeWidth="3" />
          <text x="50" y="86" textAnchor="middle" fontSize="10" fontWeight="bold" fill="#1d4ed8">
            CBSE
          </text>
        </svg>
      );

    case 'ugc':
      return (
        <svg width="56" height="56" viewBox="0 0 100 100">
          <circle cx="50" cy="50" r="46" fill="#faf5ff" stroke="#7e22ce" strokeWidth="2.5" />
          <circle cx="50" cy="45" r="16" fill="#7e22ce" />
          <path d="M42 45 L50 35 L58 45" fill="none" stroke="#ffffff" strokeWidth="3" />
          <text x="50" y="86" textAnchor="middle" fontSize="9" fontWeight="bold" fill="#7e22ce">
            UGC NET
          </text>
        </svg>
      );

    case 'psc':
      return (
        <svg width="56" height="56" viewBox="0 0 100 100">
          <circle cx="50" cy="50" r="46" fill="#fdf2f8" stroke="#be185d" strokeWidth="2.5" />
          <circle cx="50" cy="45" r="16" fill="#be185d" />
          <text x="50" y="51" textAnchor="middle" fontSize="10" fontWeight="900" fill="#ffffff">
            PSC
          </text>
          <text x="50" y="86" textAnchor="middle" fontSize="9" fontWeight="bold" fill="#be185d">
            STATE PSC
          </text>
        </svg>
      );

    case 'epfo':
      return (
        <svg width="56" height="56" viewBox="0 0 100 100">
          <circle cx="50" cy="50" r="46" fill="#fefce8" stroke="#ca8a04" strokeWidth="2.5" />
          <circle cx="50" cy="46" r="18" fill="#ca8a04" />
          <circle cx="50" cy="46" r="10" fill="#ffffff" />
          <text x="50" y="86" textAnchor="middle" fontSize="10" fontWeight="bold" fill="#854d0e">
            EPFO
          </text>
        </svg>
      );

    case 'lic':
      return (
        <svg width="56" height="56" viewBox="0 0 100 100">
          <circle cx="50" cy="50" r="46" fill="#fef2f2" stroke="#dc2626" strokeWidth="2.5" />
          <rect x="28" y="32" width="44" height="30" rx="4" fill="#dc2626" />
          <text x="50" y="52" textAnchor="middle" fontSize="14" fontWeight="900" fill="#ffffff">
            LIC
          </text>
          <text x="50" y="84" textAnchor="middle" fontSize="8.5" fontWeight="bold" fill="#dc2626">
            INSURANCE
          </text>
        </svg>
      );

    case 'sbi':
      return (
        <svg width="56" height="56" viewBox="0 0 100 100">
          <circle cx="50" cy="50" r="46" fill="#eff6ff" stroke="#0284c7" strokeWidth="2.5" />
          <circle cx="50" cy="45" r="18" fill="#0284c7" />
          <circle cx="50" cy="45" r="6" fill="#ffffff" />
          <rect x="47" y="45" width="6" height="18" fill="#ffffff" />
          <text x="50" y="86" textAnchor="middle" fontSize="11" fontWeight="900" fill="#0369a1">
            SBI
          </text>
        </svg>
      );

    case 'pds':
      return (
        <svg width="56" height="56" viewBox="0 0 100 100">
          <circle cx="50" cy="50" r="46" fill="#fffbeb" stroke="#f59e0b" strokeWidth="2.5" />
          <path d="M50 24 C45 34 45 44 50 56 C55 44 55 34 50 24 Z" fill="#d97706" />
          <line x1="50" y1="56" x2="50" y2="70" stroke="#d97706" strokeWidth="4" strokeLinecap="round" />
          <text x="50" y="86" textAnchor="middle" fontSize="9.5" fontWeight="bold" fill="#b45309">
            NFSA PDS
          </text>
        </svg>
      );

    case 'revenue':
    default:
      return (
        <svg width="56" height="56" viewBox="0 0 100 100">
          <circle cx="50" cy="50" r="46" fill="#f0fdfa" stroke="#0d9488" strokeWidth="2.5" />
          <circle cx="50" cy="45" r="16" fill="#f0fdfa" stroke="#0d9488" strokeWidth="2.5" />
          <path d="M42 45 L48 51 L58 39" fill="none" stroke="#0d9488" strokeWidth="3" strokeLinecap="round" />
          <text x="50" y="84" textAnchor="middle" fontSize="8.5" fontWeight="bold" fill="#0d9488">
            REVENUE
          </text>
        </svg>
      );
  }
}

export default function DashboardPage() {
  const router = useRouter();
  const [language, setLanguage] = useState<Language>('en');
  const t = translations[language] || translations.en;

  const [selectedCategory, setSelectedCategory] = useState<'all' | 'docs' | 'exams' | 'vault' | 'profile'>('all');
  const [searchQuery, setSearchQuery] = useState<string>('');
  const [activeModalService, setActiveModalService] = useState<ServiceItem | null>(null);
  const [isApplying, setIsApplying] = useState<boolean>(false);
  const [applySuccess, setApplySuccess] = useState<boolean>(false);
  const [vaultDocs, setVaultDocs] = useState<IssuedDoc[]>(INITIAL_VAULT_DOCS);
  const [showProfileModal, setShowProfileModal] = useState<boolean>(false);

  const getServiceName = (srv: ServiceItem) => {
    switch (srv.id) {
      case 'pan-card': return t.itdName;
      case 'voter-id': return t.eciName;
      case 'uidai-aadhaar': return t.uidaiName;
      case 'morth-dl': return t.morthName;
      case 'pmjay-health': return t.pmjayName;
      case 'mea-passport': return t.meaName;
      case 'nfsa-pds': return t.pdsName;
      case 'revenue-dept': return t.revenueName;
      case 'upsc-exam': return t.upscName;
      case 'ssc-exam': return t.sscName;
      case 'nta-testing': return t.ntaName;
      case 'rrb-railway': return t.rrbName;
      case 'ibps-bank': return t.ibpsName;
      case 'cbse-board': return t.cbseName;
      case 'ugc-net': return t.ugcName;
      case 'state-psc': return t.pscName;
      case 'epfo-uan': return t.epfoName;
      case 'lic-insurance': return t.licName;
      case 'sbi-bank': return t.sbiName;
      default: return srv.name;
    }
  };

  const getServiceDoc = (srv: ServiceItem) => {
    switch (srv.id) {
      case 'pan-card': return t.itdDoc;
      case 'voter-id': return t.eciDoc;
      case 'uidai-aadhaar': return t.uidaiDoc;
      case 'morth-dl': return t.morthDoc;
      case 'pmjay-health': return t.pmjayDoc;
      case 'mea-passport': return t.meaDoc;
      case 'nfsa-pds': return t.pdsDoc;
      case 'revenue-dept': return t.revenueDoc;
      case 'upsc-exam': return t.upscDoc;
      case 'ssc-exam': return t.sscDoc;
      case 'nta-testing': return t.ntaDoc;
      case 'rrb-railway': return t.rrbDoc;
      case 'ibps-bank': return t.ibpsDoc;
      case 'cbse-board': return t.cbseDoc;
      case 'ugc-net': return t.ugcDoc;
      case 'state-psc': return t.pscDoc;
      case 'epfo-uan': return t.epfoDoc;
      case 'lic-insurance': return t.licDoc;
      case 'sbi-bank': return t.sbiDoc;
      default: return srv.documentType;
    }
  };

  const categories = [
    { id: 'all', label: t.allServices },
    { id: 'docs', label: t.govtDocs },
    { id: 'exams', label: t.govtExams },
    { id: 'vault', label: `${t.issuedVault} (${vaultDocs.length})` },
    { id: 'profile', label: t.citizenProfile },
  ];

  const filteredServices = useMemo(() => {
    return SERVICES_DATA.filter((srv) => {
      const matchCategory =
        selectedCategory === 'all' ||
        (selectedCategory === 'docs' && srv.category === 'docs') ||
        (selectedCategory === 'exams' && srv.category === 'exams');

      const sName = getServiceName(srv).toLowerCase();
      const sDoc = getServiceDoc(srv).toLowerCase();
      const sState = srv.state.toLowerCase();
      const q = searchQuery.toLowerCase();

      const matchSearch =
        sName.includes(q) ||
        srv.name.toLowerCase().includes(q) ||
        sState.includes(q) ||
        sDoc.includes(q) ||
        srv.documentType.toLowerCase().includes(q);
      return matchCategory && matchSearch;
    });
  }, [selectedCategory, searchQuery, language]);

  const govtDocsList = useMemo(() => {
    return filteredServices.filter((s) => s.section === 'govt-docs');
  }, [filteredServices]);

  const govtExamsList = useMemo(() => {
    return filteredServices.filter((s) => s.section === 'govt-exams');
  }, [filteredServices]);

  const financeList = useMemo(() => {
    return filteredServices.filter((s) => s.section === 'finance-welfare');
  }, [filteredServices]);

  const handleSignOut = async () => {
    await signOut();
    router.push('/');
  };

  const handleCardClick = (service: ServiceItem) => {
    setActiveModalService(service);
    setApplySuccess(false);
  };

  const handleConfirmFetch = () => {
    if (!activeModalService) return;
    setIsApplying(true);
    setTimeout(() => {
      setIsApplying(false);
      setApplySuccess(true);
      // Add to vault
      const newDoc: IssuedDoc = {
        id: `v-${Date.now()}`,
        title: getServiceDoc(activeModalService),
        issuer: getServiceName(activeModalService),
        docNumber: `DIGI-${Math.floor(100000 + Math.random() * 900000)}`,
        issueDate: 'Issued Just Now',
        verified: true,
        type: activeModalService.logoType,
      };
      setVaultDocs((prev) => [newDoc, ...prev]);
    }, 850);
  };

  const renderCardGrid = (items: ServiceItem[]) => {
    if (items.length === 0) return null;
    return (
      <div className="doc-portal-grid">
        {items.map((srv) => (
          <div
            key={srv.id}
            onClick={() => handleCardClick(srv)}
            className="doc-portal-card"
          >
            {/* Top Right Direct External Portal Button */}
            <a
              href={srv.portalUrl}
              target="_blank"
              rel="noopener noreferrer"
              onClick={(e) => e.stopPropagation()}
              className="doc-portal-card-ext-btn"
              title={`Open official portal: ${srv.portalDomain}`}
            >
              <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
                <path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6" />
                <polyline points="15 3 21 3 21 9" />
                <line x1="10" y1="14" x2="21" y2="3" />
              </svg>
            </a>

            {/* Top Centered Logo */}
            <div className="doc-portal-card-logo-wrap">
              <OrgLogo type={srv.logoType} />
            </div>

            {/* Bottom Authority Name, Region Subtitle & Portal Link */}
            <div>
              <div style={{ display: 'flex', alignItems: 'center', gap: '4px', marginBottom: '3px' }}>
                <span
                  style={{
                    fontSize: '9.5px',
                    fontWeight: 700,
                    color: '#0d9488',
                    backgroundColor: '#f0fdfa',
                    padding: '1px 6px',
                    borderRadius: '4px',
                    border: '1px solid #ccfbf1',
                    overflow: 'hidden',
                    textOverflow: 'ellipsis',
                    whiteSpace: 'nowrap',
                    maxWidth: '100%',
                  }}
                  title={translateServiceState(srv.state, language)}
                >
                  {translateServiceState(srv.state, language)}
                </span>
              </div>

              <h3 className="doc-portal-card-title" title={getServiceName(srv)}>
                {getServiceName(srv)}
              </h3>

              <p className="doc-portal-card-subtitle" title={getServiceDoc(srv)}>
                {getServiceDoc(srv)}
              </p>

              <a
                href={srv.portalUrl}
                target="_blank"
                rel="noopener noreferrer"
                onClick={(e) => e.stopPropagation()}
                className="doc-portal-link-badge"
                title={`Visit official website: ${srv.portalDomain}`}
              >
                <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2">
                  <circle cx="12" cy="12" r="10" />
                  <line x1="2" y1="12" x2="22" y2="12" />
                  <path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z" />
                </svg>
                <span>{srv.portalDomain}</span>
                <span style={{ fontSize: '10px' }}>↗</span>
              </a>
            </div>
          </div>
        ))}
      </div>
    );
  };

  return (
    <div style={{ minHeight: '100vh', backgroundColor: '#f8fafc', color: '#0f172a' }}>
      {/* Clean Premium Web Header */}
      <header
        style={{
          position: 'sticky',
          top: 0,
          zIndex: 100,
          backgroundColor: '#ffffff',
          borderBottom: '1px solid #e2e8f0',
          boxShadow: '0 1px 3px rgba(0, 0, 0, 0.03)',
        }}
      >
        <div className="dashboard-header-container">
          {/* Top Row for Mobile (Logo + Profile) */}
          <div className="dashboard-header-top-row">
            {/* Brand Logo */}
            <div style={{ display: 'flex', alignItems: 'center', gap: '10px', cursor: 'pointer' }} onClick={() => setSelectedCategory('all')}>
              <div
                style={{
                  width: '36px',
                  height: '36px',
                  borderRadius: '10px',
                  background: 'linear-gradient(135deg, #0d9488, #0f766e)',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  color: '#fff',
                  boxShadow: '0 4px 10px rgba(13, 148, 136, 0.28)',
                }}
              >
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
                  <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                  <polyline points="14 2 14 8 20 8" />
                </svg>
              </div>
              <div>
                <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                  <span style={{ fontSize: '18px', fontWeight: 800, color: '#0d9488', letterSpacing: '-0.03em' }}>
                    DocuSewa
                  </span>
                  <span style={{ fontSize: '9.5px', fontWeight: 700, backgroundColor: '#ccfbf1', color: '#0f766e', padding: '1px 5px', borderRadius: '4px' }}>
                    {t.govBadge}
                  </span>
                </div>
                <p style={{ margin: 0, fontSize: '10px', fontWeight: 600, color: '#64748b' }}>
                  {t.brandTagline}
                </p>
              </div>
            </div>

            {/* Language Switcher & Profile Avatar */}
            <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
              {/* Language Switcher Pill */}
              <div
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  backgroundColor: '#f1f5f9',
                  borderRadius: '12px',
                  padding: '2px',
                  border: '1.5px solid #e2e8f0',
                }}
              >
                {(['en', 'hi', 'pa'] as Language[]).map((lang) => (
                  <button
                    key={lang}
                    onClick={() => setLanguage(lang)}
                    className="btn-interactive"
                    style={{
                      border: 'none',
                      backgroundColor: language === lang ? '#0d9488' : 'transparent',
                      color: language === lang ? '#ffffff' : '#475569',
                      padding: '4px 8px',
                      borderRadius: '8px',
                      fontSize: '11px',
                      fontWeight: 800,
                      cursor: 'pointer',
                      transition: 'all 0.2s ease',
                    }}
                  >
                    {lang === 'en' ? 'EN' : lang === 'hi' ? 'हिन्दी' : 'ਪੰਜਾਬੀ'}
                  </button>
                ))}
              </div>

              {/* Profile Avatar Pill */}
              <div
                onClick={() => setSelectedCategory('profile')}
                className="btn-interactive"
                title={t.citizenProfile}
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '8px',
                  padding: '4px 10px 4px 6px',
                  borderRadius: '20px',
                  backgroundColor: '#ffffff',
                  border: '1.5px solid #e2e8f0',
                  cursor: 'pointer',
                  boxShadow: '0 1px 3px rgba(0,0,0,0.04)',
                }}
              >
                <div
                  style={{
                    width: '28px',
                    height: '28px',
                    borderRadius: '50%',
                    backgroundColor: '#0d9488',
                    color: '#ffffff',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    fontWeight: 800,
                    fontSize: '11.5px',
                  }}
                >
                  DK
                </div>
                <div style={{ textAlign: 'left' }}>
                  <div style={{ fontSize: '12px', fontWeight: 800, color: '#0f172a', lineHeight: 1.1 }}>
                    Dilkhush
                  </div>
                  <div style={{ fontSize: '9.5px', fontWeight: 700, color: '#0d9488' }}>
                    {t.verifiedCitizen}
                  </div>
                </div>
              </div>
            </div>
          </div>

          {/* Search Input Box */}
          <div className="dashboard-header-search-wrap">
            <input
              type="text"
              placeholder={t.searchPlaceholder}
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              style={{
                width: '100%',
                height: '40px',
                padding: '0 16px 0 40px',
                borderRadius: '12px',
                border: '1.5px solid #e2e8f0',
                backgroundColor: '#f8fafc',
                fontSize: '13px',
                color: '#0f172a',
                outline: 'none',
                transition: 'all 0.2s ease',
              }}
            />
            <svg
              width="16"
              height="16"
              viewBox="0 0 24 24"
              fill="none"
              stroke="#64748b"
              strokeWidth="2.2"
              style={{ position: 'absolute', left: '14px', top: '12px' }}
            >
              <circle cx="11" cy="11" r="8" />
              <line x1="21" y1="21" x2="16.65" y2="16.65" />
            </svg>
          </div>
        </div>
      </header>

      {/* Main Content Area */}
      <main className="dashboard-main-container">
        {/* Category Pills */}
        <div
          className="no-scrollbar"
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: '8px',
            overflowX: 'auto',
            paddingBottom: '8px',
            marginBottom: '24px',
            WebkitOverflowScrolling: 'touch',
          }}
        >
          {categories.map((cat) => {
            const isActive = selectedCategory === cat.id;
            return (
              <button
                key={cat.id}
                onClick={() => setSelectedCategory(cat.id as any)}
                className="btn-interactive"
                style={{
                  padding: '8px 16px',
                  borderRadius: '12px',
                  border: isActive ? '1.5px solid #0d9488' : '1px solid #e2e8f0',
                  backgroundColor: isActive ? '#0d9488' : '#ffffff',
                  color: isActive ? '#ffffff' : '#475569',
                  fontSize: '13px',
                  fontWeight: isActive ? 800 : 600,
                  cursor: 'pointer',
                  whiteSpace: 'nowrap',
                  boxShadow: isActive ? '0 4px 12px rgba(13, 148, 136, 0.25)' : 'none',
                  flexShrink: 0,
                  transition: 'all 0.2s ease',
                }}
              >
                {cat.label}
              </button>
            );
          })}
        </div>

        {/* CITIZEN PROFILE VIEW */}
        {selectedCategory === 'profile' ? (
          <ProfileSection
            vaultCount={vaultDocs.length}
            language={language}
            onLanguageChange={setLanguage}
            onNavigateToVault={() => setSelectedCategory('vault')}
          />
        ) : selectedCategory === 'vault' ? (
          <div>
            <div style={{ marginBottom: '20px' }}>
              <h2 style={{ fontSize: '18px', fontWeight: 800, color: '#0f172a', margin: '0 0 4px' }}>
                {t.vaultTitle}
              </h2>
              <p style={{ fontSize: '12.5px', color: '#64748b', margin: 0 }}>
                {t.vaultSubtitle}
              </p>
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(280px, 1fr))', gap: '14px' }}>
              {vaultDocs.map((doc) => {
                const vDoc = translateVaultDoc(doc, language);
                return (
                  <div
                    key={doc.id}
                    style={{
                      backgroundColor: '#ffffff',
                      borderRadius: '16px',
                      border: '1.5px solid #e2e8f0',
                      padding: '16px',
                      display: 'flex',
                      flexDirection: 'column',
                      justifyContent: 'space-between',
                      boxShadow: '0 2px 8px rgba(0, 0, 0, 0.04)',
                    }}
                  >
                    <div style={{ display: 'flex', alignItems: 'flex-start', gap: '12px', marginBottom: '12px' }}>
                      <div
                        style={{
                          width: '42px',
                          height: '42px',
                          minWidth: '42px',
                          borderRadius: '10px',
                          backgroundColor: '#f0fdfa',
                          border: '1px solid #ccfbf1',
                          display: 'flex',
                          alignItems: 'center',
                          justifyContent: 'center',
                          color: '#0d9488',
                        }}
                      >
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                          <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
                        </svg>
                      </div>

                      <div style={{ flex: 1, minWidth: 0 }}>
                        <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                          <h3 style={{ fontSize: '14px', fontWeight: 800, color: '#0f172a', margin: 0, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                            {vDoc.title}
                          </h3>
                          <span style={{ fontSize: '10px', color: '#16a34a', fontWeight: 700, flexShrink: 0 }}>{t.verifiedBadge}</span>
                        </div>
                        <p style={{ fontSize: '11.5px', color: '#64748b', margin: '2px 0 0', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                          {vDoc.issuer}
                        </p>
                      </div>
                    </div>

                    <div
                      style={{
                        backgroundColor: '#f8fafc',
                        borderRadius: '10px',
                        padding: '8px 12px',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'space-between',
                        marginBottom: '12px',
                      }}
                    >
                      <div>
                        <div style={{ fontSize: '9.5px', color: '#94a3b8', fontWeight: 600 }}>{t.docNumber}</div>
                        <div style={{ fontSize: '12px', fontWeight: 700, color: '#0f172a' }}>{doc.docNumber}</div>
                      </div>
                      <div style={{ textAlign: 'right' }}>
                        <div style={{ fontSize: '9.5px', color: '#94a3b8', fontWeight: 600 }}>{t.docStatus}</div>
                        <div style={{ fontSize: '11px', fontWeight: 600, color: '#475569' }}>{vDoc.issueDate}</div>
                      </div>
                    </div>

                    <div style={{ display: 'flex', gap: '8px' }}>
                      <button
                        onClick={() => alert(`Viewing verified ${vDoc.title}`)}
                        style={{
                          flex: 1,
                          height: '34px',
                          borderRadius: '8px',
                          border: '1px solid #e2e8f0',
                          backgroundColor: '#ffffff',
                          color: '#0f172a',
                          fontWeight: 600,
                          fontSize: '12px',
                          cursor: 'pointer',
                        }}
                      >
                        {t.viewDoc}
                      </button>
                      <button
                        onClick={() => alert(`Downloaded authenticated PDF for ${vDoc.title}`)}
                        style={{
                          flex: 1,
                          height: '34px',
                          borderRadius: '8px',
                          border: 'none',
                          backgroundColor: '#0d9488',
                          color: '#ffffff',
                          fontWeight: 700,
                          fontSize: '12px',
                          cursor: 'pointer',
                        }}
                      >
                        {t.downloadDoc}
                      </button>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        ) : (
          <div>
            {/* SECTION 1: GOVT DOCUMENTS */}
            {(selectedCategory === 'all' || selectedCategory === 'docs') && govtDocsList.length > 0 && (
              <section style={{ marginBottom: '36px' }}>
                <div
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'space-between',
                    marginBottom: '16px',
                    paddingBottom: '10px',
                    borderBottom: '1px solid #f1f5f9',
                  }}
                >
                  <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                    <div
                      style={{
                        width: '34px',
                        height: '34px',
                        borderRadius: '10px',
                        background: 'linear-gradient(135deg, #0d9488, #0f766e)',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        color: '#ffffff',
                        boxShadow: '0 3px 10px rgba(13, 148, 136, 0.28)',
                        flexShrink: 0,
                      }}
                    >
                      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.3">
                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                        <polyline points="14 2 14 8 20 8" />
                        <line x1="16" y1="13" x2="8" y2="13" />
                        <line x1="16" y1="17" x2="8" y2="17" />
                      </svg>
                    </div>
                    <div>
                      <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                        <h2 style={{ fontSize: '17px', fontWeight: 800, color: '#0f172a', letterSpacing: '-0.02em', margin: 0 }}>
                          {t.identityDocsTitle}
                        </h2>
                        <span
                          style={{
                            fontSize: '11px',
                            fontWeight: 700,
                            backgroundColor: '#f0fdfa',
                            color: '#0d9488',
                            border: '1px solid #ccfbf1',
                            padding: '2px 8px',
                            borderRadius: '12px',
                          }}
                        >
                          {govtDocsList.length} {t.identityDocsBadge}
                        </span>
                      </div>
                    </div>
                  </div>

                  <div style={{ display: 'flex', alignItems: 'center', gap: '6px', fontSize: '11.5px', fontWeight: 600, color: '#0d9488' }}>
                    <span style={{ display: 'inline-block', width: '6px', height: '6px', borderRadius: '50%', backgroundColor: '#10b981' }}></span>
                    <span className="hidden sm:inline">{t.directPortals}</span>
                  </div>
                </div>
                {renderCardGrid(govtDocsList)}
              </section>
            )}

            {/* SECTION 2: GOVT EXAMS & EDUCATION */}
            {(selectedCategory === 'all' || selectedCategory === 'exams') && govtExamsList.length > 0 && (
              <section style={{ marginBottom: '36px' }}>
                <div
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'space-between',
                    marginBottom: '16px',
                    paddingBottom: '10px',
                    borderBottom: '1px solid #f1f5f9',
                  }}
                >
                  <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                    <div
                      style={{
                        width: '34px',
                        height: '34px',
                        borderRadius: '10px',
                        background: 'linear-gradient(135deg, #3b82f6, #1d4ed8)',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        color: '#ffffff',
                        boxShadow: '0 3px 10px rgba(37, 99, 235, 0.28)',
                        flexShrink: 0,
                      }}
                    >
                      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.3">
                        <path d="M22 10v6M2 10l10-5 10 5-10 5z" />
                        <path d="M6 12v5c3 3 9 3 12 0v-5" />
                      </svg>
                    </div>
                    <div>
                      <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                        <h2 style={{ fontSize: '17px', fontWeight: 800, color: '#0f172a', letterSpacing: '-0.02em', margin: 0 }}>
                          {t.examsTitle}
                        </h2>
                        <span
                          style={{
                            fontSize: '11px',
                            fontWeight: 700,
                            backgroundColor: '#eff6ff',
                            color: '#2563eb',
                            border: '1px solid #dbeafe',
                            padding: '2px 8px',
                            borderRadius: '12px',
                          }}
                        >
                          {govtExamsList.length} {t.examsBadge}
                        </span>
                      </div>
                    </div>
                  </div>

                  <div style={{ display: 'flex', alignItems: 'center', gap: '6px', fontSize: '11.5px', fontWeight: 600, color: '#2563eb' }}>
                    <span style={{ display: 'inline-block', width: '6px', height: '6px', borderRadius: '50%', backgroundColor: '#3b82f6' }}></span>
                    <span className="hidden sm:inline">{t.admitCardsBadge}</span>
                  </div>
                </div>
                {renderCardGrid(govtExamsList)}
              </section>
            )}

            {/* SECTION 3: FINANCIAL & WELFARE */}
            {selectedCategory === 'all' && financeList.length > 0 && (
              <section style={{ marginBottom: '36px' }}>
                <div
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'space-between',
                    marginBottom: '16px',
                    paddingBottom: '10px',
                    borderBottom: '1px solid #f1f5f9',
                  }}
                >
                  <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                    <div
                      style={{
                        width: '34px',
                        height: '34px',
                        borderRadius: '10px',
                        background: 'linear-gradient(135deg, #f59e0b, #d97706)',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        color: '#ffffff',
                        boxShadow: '0 3px 10px rgba(217, 119, 6, 0.28)',
                        flexShrink: 0,
                      }}
                    >
                      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.3">
                        <rect x="2" y="7" width="20" height="14" rx="2" ry="2" />
                        <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16" />
                      </svg>
                    </div>
                    <div>
                      <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                        <h2 style={{ fontSize: '17px', fontWeight: 800, color: '#0f172a', letterSpacing: '-0.02em', margin: 0 }}>
                          {t.financeTitle}
                        </h2>
                        <span
                          style={{
                            fontSize: '11px',
                            fontWeight: 700,
                            backgroundColor: '#fffbeb',
                            color: '#b45309',
                            border: '1px solid #fef3c7',
                            padding: '2px 8px',
                            borderRadius: '12px',
                          }}
                        >
                          {financeList.length} {t.financeBadge}
                        </span>
                      </div>
                    </div>
                  </div>

                  <div style={{ display: 'flex', alignItems: 'center', gap: '6px', fontSize: '11.5px', fontWeight: 600, color: '#b45309' }}>
                    <span style={{ display: 'inline-block', width: '6px', height: '6px', borderRadius: '50%', backgroundColor: '#f59e0b' }}></span>
                    <span className="hidden sm:inline">{t.bankingBadge}</span>
                  </div>
                </div>
                {renderCardGrid(financeList)}
              </section>
            )}
          </div>
        )}

        {/* Private Platform Disclaimer */}
        <footer
          style={{
            marginTop: '36px',
            padding: '16px 20px',
            backgroundColor: '#ffffff',
            borderRadius: '16px',
            border: '1px solid #e2e8f0',
            display: 'flex',
            alignItems: 'center',
            gap: '12px',
            color: '#64748b',
            fontSize: '12px',
            lineHeight: 1.5,
          }}
        >
          <div
            style={{
              width: '28px',
              height: '28px',
              minWidth: '28px',
              borderRadius: '8px',
              backgroundColor: '#f1f5f9',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              color: '#0d9488',
              fontWeight: 800,
              fontSize: '12px',
            }}
          >
            ℹ️
          </div>
          <div>
            <strong style={{ color: '#0f172a' }}>
              {language === 'hi'
                ? 'निजी नागरिक सुविधा मंच:'
                : language === 'pa'
                ? 'ਨਿੱਜੀ ਨਾਗਰਿਕ ਸੁਵਿਧਾ ਪਲੇਟਫਾਰਮ:'
                : 'Private Citizen Utility Platform:'}
            </strong>{' '}
            {language === 'hi'
              ? 'DocuSewa एक स्वतंत्र निजी पोर्टल है जो आधिकारिक सार्वजनिक सेवाओं और पोर्टलों तक सीधी पहुंच एवं नेविगेशन को सरल बनाता है। हम किसी भी सरकारी एजेंसी से संबद्ध नहीं हैं।'
              : language === 'pa'
              ? 'DocuSewa ਇੱਕ ਸੁਤੰਤਰ ਨਿੱਜੀ ਪਲੇਟਫਾਰਮ ਹੈ ਜੋ ਅਧਿਕਾਰਤ ਪਬਲਿਕ ਪੋਰਟਲਾਂ ਤੱਕ ਸਿੱਧੀ ਪਹੁੰਚ ਨੂੰ ਆਸਾਨ ਬਣਾਉਂਦਾ ਹੈ। ਅਸੀਂ ਕਿਸੇ ਵੀ ਸਰਕਾਰੀ ਸੰਸਥਾ ਨਾਲ ਸੰਬੰਧਿਤ ਨਹੀਂ ਹਾਂ।'
              : 'DocuSewa is an independent private citizen utility platform designed to simplify access and direct navigation to official public services and registries. We are not affiliated with or endorsed by any government entity.'}
          </div>
        </footer>
      </main>

      {/* Premium Citizen Profile Modal */}
      {showProfileModal && (
        <div
          style={{
            position: 'fixed',
            inset: 0,
            backgroundColor: 'rgba(15, 23, 42, 0.65)',
            backdropFilter: 'blur(8px)',
            WebkitBackdropFilter: 'blur(8px)',
            zIndex: 1000,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            padding: '16px',
            animation: 'overlayFadeIn 0.2s ease both',
          }}
          onClick={() => setShowProfileModal(false)}
        >
          <div
            onClick={(e) => e.stopPropagation()}
            style={{
              position: 'relative',
              width: '100%',
              maxWidth: '820px',
              maxHeight: '90vh',
              overflowY: 'auto',
              borderRadius: '24px',
              boxShadow: '0 25px 50px -12px rgba(15, 23, 42, 0.25)',
              animation: 'modalSmoothIn 0.25s cubic-bezier(0.16, 1, 0.3, 1) both',
            }}
          >
            <ProfileSection
              isModalMode={true}
              vaultCount={vaultDocs.length}
              language={language}
              onLanguageChange={setLanguage}
              onClose={() => setShowProfileModal(false)}
              onNavigateToVault={() => {
                setShowProfileModal(false);
                setSelectedCategory('vault');
              }}
            />
          </div>
        </div>
      )}

      {/* Detail & Fetch Modal */}
      {activeModalService && (
        <div
          style={{
            position: 'fixed',
            inset: 0,
            backgroundColor: 'rgba(15, 23, 42, 0.5)',
            backdropFilter: 'blur(6px)',
            WebkitBackdropFilter: 'blur(6px)',
            zIndex: 1000,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            padding: '16px',
            animation: 'overlayFadeIn 0.2s ease both',
          }}
        >
          <div
            style={{
              position: 'relative',
              backgroundColor: '#ffffff',
              borderRadius: '20px',
              border: '1px solid #e2e8f0',
              padding: '24px',
              width: '100%',
              maxWidth: '440px',
              boxShadow: '0 20px 35px -5px rgba(15, 23, 42, 0.15)',
              animation: 'modalSmoothIn 0.25s cubic-bezier(0.16, 1, 0.3, 1) both',
            }}
          >
            {/* Close Button */}
            <button
              onClick={() => setActiveModalService(null)}
              style={{
                position: 'absolute',
                top: '16px',
                right: '16px',
                width: '32px',
                height: '32px',
                borderRadius: '50%',
                backgroundColor: '#f1f5f9',
                border: 'none',
                color: '#64748b',
                cursor: 'pointer',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
              }}
            >
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
                <line x1="18" y1="6" x2="6" y2="18" />
                <line x1="6" y1="6" x2="18" y2="18" />
              </svg>
            </button>

            {applySuccess ? (
              <div style={{ textAlign: 'center', padding: '10px 0' }}>
                <div
                  style={{
                    width: '52px',
                    height: '52px',
                    borderRadius: '50%',
                    backgroundColor: '#dcfce7',
                    color: '#16a34a',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    margin: '0 auto 12px',
                  }}
                >
                  <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3">
                    <polyline points="20 6 9 17 4 12" />
                  </svg>
                </div>
                <h3 style={{ fontSize: '18px', fontWeight: 800, color: '#0f172a', margin: '0 0 6px' }}>
                  {t.docIssuedSuccess}
                </h3>
                <p style={{ fontSize: '12.5px', color: '#64748b', lineHeight: 1.5, margin: '0 0 18px' }}>
                  {t.docIssuedDesc}
                </p>
                <div style={{ display: 'flex', gap: '8px' }}>
                  <button
                    onClick={() => {
                      setActiveModalService(null);
                      setSelectedCategory('vault');
                    }}
                    className="btn-interactive"
                    style={{
                      flex: 1,
                      height: '40px',
                      borderRadius: '10px',
                      border: 'none',
                      backgroundColor: '#0d9488',
                      color: '#ffffff',
                      fontWeight: 700,
                      cursor: 'pointer',
                    }}
                  >
                    {t.viewInVault}
                  </button>
                  <button
                    onClick={() => setActiveModalService(null)}
                    style={{
                      height: '40px',
                      padding: '0 16px',
                      borderRadius: '10px',
                      border: '1px solid #e2e8f0',
                      backgroundColor: '#ffffff',
                      color: '#475569',
                      fontWeight: 600,
                      cursor: 'pointer',
                    }}
                  >
                    {t.close}
                  </button>
                </div>
              </div>
            ) : (
              <div>
                {/* Header preview in modal */}
                <div
                  style={{
                    backgroundColor: '#f8fafc',
                    borderRadius: '14px',
                    border: '1px solid #e2e8f0',
                    padding: '14px',
                    display: 'flex',
                    alignItems: 'center',
                    gap: '12px',
                    marginBottom: '16px',
                  }}
                >
                  <OrgLogo type={activeModalService.logoType} />
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <h3 style={{ fontSize: '14px', fontWeight: 800, color: '#0f172a', margin: '0 0 2px', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                      {getServiceName(activeModalService)}
                    </h3>
                    <p style={{ fontSize: '11.5px', color: '#0d9488', fontWeight: 600, margin: 0, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                      {getServiceDoc(activeModalService)}
                    </p>
                  </div>
                </div>

                {/* Official Government Website Portal Card */}
                <div
                  style={{
                    backgroundColor: '#f0fdfa',
                    borderRadius: '12px',
                    padding: '12px 14px',
                    marginBottom: '16px',
                    border: '1px solid #ccfbf1',
                  }}
                >
                  <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '4px' }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '6px', fontSize: '11px', fontWeight: 700, color: '#0f766e' }}>
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
                      </svg>
                      <span>{t.officialPortal}</span>
                    </div>
                    <span style={{ fontSize: '10.5px', fontWeight: 600, color: '#0d9488', backgroundColor: '#e6fffa', padding: '1px 6px', borderRadius: '4px' }}>
                      {activeModalService.portalDomain}
                    </span>
                  </div>

                  <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: '8px' }}>
                    <a
                      href={activeModalService.portalUrl}
                      target="_blank"
                      rel="noopener noreferrer"
                      style={{
                        fontSize: '12px',
                        fontWeight: 600,
                        color: '#0d9488',
                        textDecoration: 'underline',
                        overflow: 'hidden',
                        textOverflow: 'ellipsis',
                        whiteSpace: 'nowrap',
                        flex: 1,
                      }}
                      title={activeModalService.portalUrl}
                    >
                      {activeModalService.portalUrl}
                    </a>

                    <a
                      href={activeModalService.portalUrl}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="btn-interactive"
                      style={{
                        display: 'inline-flex',
                        alignItems: 'center',
                        gap: '4px',
                        padding: '5px 10px',
                        backgroundColor: '#0d9488',
                        color: '#ffffff',
                        borderRadius: '6px',
                        fontSize: '11px',
                        fontWeight: 700,
                        textDecoration: 'none',
                        flexShrink: 0,
                      }}
                    >
                      <span>{t.visitSite}</span>
                      <span style={{ fontSize: '11px' }}>↗</span>
                    </a>
                  </div>
                </div>

                {/* Required Verification Fields */}
                <div
                  style={{
                    backgroundColor: '#f8fafc',
                    borderRadius: '10px',
                    padding: '12px',
                    marginBottom: '18px',
                    border: '1px solid #e2e8f0',
                  }}
                >
                  <div style={{ fontSize: '12px', fontWeight: 700, color: '#0f172a', marginBottom: '8px' }}>
                    {t.requiredDetails}
                  </div>
                  <div style={{ display: 'flex', flexDirection: 'column', gap: '6px' }}>
                    {activeModalService.requiredDocs.map((doc, idx) => (
                      <div key={idx} style={{ display: 'flex', alignItems: 'center', gap: '6px', fontSize: '11.5px', color: '#334155' }}>
                        <span style={{ color: '#0d9488', fontWeight: 800 }}>✓</span>
                        <span>{translateRequiredDoc(doc, language)}</span>
                      </div>
                    ))}
                  </div>
                </div>

                {/* Modal Actions */}
                <div style={{ display: 'flex', gap: '8px' }}>
                  <button
                    onClick={() => setActiveModalService(null)}
                    style={{
                      flex: 1,
                      height: '40px',
                      borderRadius: '10px',
                      border: '1px solid #e2e8f0',
                      backgroundColor: '#ffffff',
                      color: '#475569',
                      fontWeight: 600,
                      cursor: 'pointer',
                    }}
                  >
                    {t.cancel}
                  </button>

                  <button
                    onClick={handleConfirmFetch}
                    disabled={isApplying}
                    className="btn-interactive"
                    style={{
                      flex: 2,
                      height: '40px',
                      borderRadius: '10px',
                      border: 'none',
                      backgroundColor: '#0d9488',
                      color: '#ffffff',
                      fontWeight: 700,
                      cursor: isApplying ? 'wait' : 'pointer',
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      gap: '8px',
                    }}
                  >
                    {isApplying ? <span>{t.pullingDoc}</span> : <span>{t.fetchDocument}</span>}
                  </button>
                </div>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
}
