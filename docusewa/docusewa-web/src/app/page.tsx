'use client';

import React, { useCallback, useEffect, useMemo, useState } from 'react';
import { useRouter } from 'next/navigation';
import { PhoneAuthForm } from '@/components/auth/PhoneAuthForm';
import { OtpModal } from '@/components/auth/OtpModal';
import { sendOtp, sendEmailOtp, getCurrentUser, signInWithDemo } from '@/services/auth.service';
import { Language, translations } from '@/lib/translations';

interface PortalService {
  id: string;
  name: string;
  category: 'docs' | 'exams' | 'finance';
  docType: string;
  tag: string;
  url: string;
  color: string;
  icon: string;
}

const FEATURED_PORTALS: PortalService[] = [
  {
    id: 'pan-card',
    name: 'Income Tax Department (ITD)',
    category: 'docs',
    docType: 'e-PAN Card Verification',
    tag: 'Identity',
    url: 'https://eportal.incometax.gov.in',
    color: '#0d9488',
    icon: '💳',
  },
  {
    id: 'uidai-aadhaar',
    name: 'UIDAI (Aadhaar Portal)',
    category: 'docs',
    docType: 'Digital Aadhaar Copy',
    tag: 'Identity',
    url: 'https://myaadhaar.uidai.gov.in',
    color: '#0284c7',
    icon: '🆔',
  },
  {
    id: 'voter-id',
    name: 'Election Commission of India (ECI)',
    category: 'docs',
    docType: 'e-EPIC Voter Card',
    tag: 'Identity',
    url: 'https://voters.eci.gov.in',
    color: '#7c3aed',
    icon: '🗳️',
  },
  {
    id: 'morth-dl',
    name: 'Ministry of Road Transport (Parivahan)',
    category: 'docs',
    docType: 'Driving Licence & RC',
    tag: 'Transport',
    url: 'https://parivahan.gov.in',
    color: '#059669',
    icon: '🚗',
  },
  {
    id: 'upsc-exams',
    name: 'Union Public Service Commission (UPSC)',
    category: 'exams',
    docType: 'e-Admit Card & Results',
    tag: 'Civil Services',
    url: 'https://upsconline.nic.in',
    color: '#2563eb',
    icon: '🎓',
  },
  {
    id: 'ssc-exams',
    name: 'Staff Selection Commission (SSC)',
    category: 'exams',
    docType: 'Hall Ticket & Scorecard',
    tag: 'Central Exams',
    url: 'https://ssc.gov.in',
    color: '#ea580c',
    icon: '📋',
  },
  {
    id: 'nta-exams',
    name: 'National Testing Agency (NTA)',
    category: 'exams',
    docType: 'JEE / NEET / CUET Admit Card',
    tag: 'Entrance Exams',
    url: 'https://nta.ac.in',
    color: '#db2777',
    icon: '🔬',
  },
  {
    id: 'cbse-boards',
    name: 'Central Board of Sec. Education (CBSE)',
    category: 'exams',
    docType: '10th & 12th Marksheets',
    tag: 'Board Results',
    url: 'https://cbse.gov.in',
    color: '#4f46e5',
    icon: '📚',
  },
  {
    id: 'pmjay-health',
    name: 'National Health Authority (NHA)',
    category: 'docs',
    docType: 'Ayushman Bharat ABHA Card',
    tag: 'Health Insurance',
    url: 'https://abdm.gov.in',
    color: '#16a34a',
    icon: '🏥',
  },
  {
    id: 'epfo-uan',
    name: 'Employees Provident Fund (EPFO)',
    category: 'finance',
    docType: 'UAN Card & Member Passbook',
    tag: 'Pensions',
    url: 'https://unifiedportal-mem.epfindia.gov.in',
    color: '#d97706',
    icon: '🏦',
  },
  {
    id: 'lic-policy',
    name: 'Life Insurance Corp. (LIC)',
    category: 'finance',
    docType: 'Policy Bonds & Premium Status',
    tag: 'Insurance',
    url: 'https://licindia.in',
    color: '#dc2626',
    icon: '🛡️',
  },
  {
    id: 'sbi-bank',
    name: 'State Bank of India (SBI)',
    category: 'finance',
    docType: 'Account Statement & Passbook',
    tag: 'Banking',
    url: 'https://onlinesbi.sbi',
    color: '#0284c7',
    icon: '🏛️',
  },
];

const FAQS = [
  {
    q: 'Is DocuSewa an official government entity or website?',
    a: 'No. DocuSewa is an independent, private citizen utility platform designed to aggregate, organize, and provide direct seamless access to 19+ official public registries, exam portals, and encrypted document storage.',
  },
  {
    q: 'How does the Document Vault and Citizen Pass work?',
    a: 'DocuSewa allows verified citizens to generate a personalized Digital Citizen Pass and maintain an encrypted vault of certificates pulled or verified from official portal services with complete privacy.',
  },
  {
    q: 'Which languages are supported on DocuSewa?',
    a: 'DocuSewa fully supports three regional languages: English, Hindi (हिंदी), and Punjabi (ਪੰਜਾਬੀ). All service names, departments, modals, and profile sections adapt seamlessly.',
  },
  {
    q: 'Is my personal information and document data safe?',
    a: 'Yes. DocuSewa uses 256-bit client-side AES encryption principles. We do not sell or monetize citizen data, and all redirections go directly to official authority portals.',
  },
];

export default function LandingHomePage() {
  const router = useRouter();
  const [language, setLanguage] = useState<Language>('en');
  const t = translations[language] || translations.en;

  const [otpTarget, setOtpTarget] = useState<string | null>(null);
  const [otpType, setOtpType] = useState<'phone' | 'email'>('phone');
  const [isCheckingSession, setIsCheckingSession] = useState(true);
  const [showQrModal, setShowQrModal] = useState(false);
  const [portalCategory, setPortalCategory] = useState<'all' | 'docs' | 'exams' | 'finance'>('all');
  const [openFaq, setOpenFaq] = useState<number | null>(0);
  const [isDemoLoading, setIsDemoLoading] = useState(false);

  useEffect(() => {
    getCurrentUser().then((user) => {
      if (user) router.replace('/dashboard');
      else setIsCheckingSession(false);
    });
  }, [router]);

  const handleOtpSent = useCallback((target: string, type: 'phone' | 'email') => {
    setOtpTarget(target);
    setOtpType(type);
  }, []);

  const handleVerified = useCallback(() => {
    router.replace('/dashboard');
  }, [router]);

  const handleEditNumber = useCallback(() => {
    setOtpTarget(null);
  }, []);

  const handleResend = useCallback(async () => {
    if (!otpTarget) return;
    if (otpType === 'phone') {
      await sendOtp(otpTarget);
    } else {
      await sendEmailOtp(otpTarget);
    }
  }, [otpTarget, otpType]);

  const handleInstantDemoLogin = async () => {
    setIsDemoLoading(true);
    await signInWithDemo();
    router.replace('/dashboard');
  };

  const filteredPortals = useMemo(() => {
    if (portalCategory === 'all') return FEATURED_PORTALS;
    return FEATURED_PORTALS.filter((p) => p.category === portalCategory);
  }, [portalCategory]);

  if (isCheckingSession) {
    return (
      <div
        style={{
          minHeight: '100vh',
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          justifyContent: 'center',
          backgroundColor: '#f0fdfa',
          gap: '16px',
        }}
      >
        <div
          style={{
            width: '42px',
            height: '42px',
            border: '3.5px solid #ccfbf1',
            borderTopColor: '#0d9488',
            borderRadius: '50%',
            animation: 'spin 0.8s linear infinite',
          }}
        />
        <span style={{ fontSize: '13px', fontWeight: 600, color: '#0f766e' }}>
          Loading DocuSewa Portal...
        </span>
      </div>
    );
  }

  return (
    <div style={{ minHeight: '100vh', backgroundColor: '#ffffff', color: '#0f172a', display: 'flex', flexDirection: 'column' }}>
      {/* ------------------------------------------------------------- */}
      {/* 1. FLOATING NAVIGATION BAR                                     */}
      {/* ------------------------------------------------------------- */}
      <header
        style={{
          position: 'sticky',
          top: 0,
          zIndex: 100,
          backgroundColor: 'rgba(255, 255, 255, 0.92)',
          backdropFilter: 'blur(12px)',
          WebkitBackdropFilter: 'blur(12px)',
          borderBottom: '1px solid rgba(226, 232, 240, 0.8)',
        }}
      >
        <div
          style={{
            maxWidth: '1280px',
            margin: '0 auto',
            padding: '0 24px',
            height: '70px',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between',
            gap: '16px',
          }}
        >
          {/* Logo & Platform Tag */}
          <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
            <div
              style={{
                width: '38px',
                height: '38px',
                borderRadius: '11px',
                background: 'linear-gradient(135deg, #0f766e 0%, #0d9488 100%)',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                color: '#ffffff',
                boxShadow: '0 4px 12px rgba(13, 148, 136, 0.3)',
              }}
            >
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round">
                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                <polyline points="14 2 14 8 20 8" />
                <line x1="16" y1="13" x2="8" y2="13" />
                <line x1="16" y1="17" x2="8" y2="17" />
                <polyline points="10 9 9 9 8 9" />
              </svg>
            </div>
            <div>
              <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                <span style={{ fontSize: '19px', fontWeight: 900, color: '#0f172a', letterSpacing: '-0.03em' }}>
                  Docu<span style={{ color: '#0d9488' }}>Sewa</span>
                </span>
                <span
                  style={{
                    fontSize: '9.5px',
                    fontWeight: 800,
                    backgroundColor: '#ccfbf1',
                    color: '#0f766e',
                    padding: '2px 6px',
                    borderRadius: '5px',
                    letterSpacing: '0.04em',
                  }}
                >
                  {t.govBadge}
                </span>
              </div>
              <p style={{ margin: 0, fontSize: '10px', color: '#64748b', fontWeight: 600 }}>
                {t.brandTagline}
              </p>
            </div>
          </div>

          {/* Nav Links (Desktop) */}
          <nav className="hidden md:flex" style={{ display: 'flex', alignItems: 'center', gap: '24px' }}>
            <a href="#services" style={{ fontSize: '13.5px', fontWeight: 600, color: '#475569', textDecoration: 'none', transition: 'color 0.15s' }}>
              19+ Direct Portals
            </a>
            <a href="#pass" style={{ fontSize: '13.5px', fontWeight: 600, color: '#475569', textDecoration: 'none', transition: 'color 0.15s' }}>
              Digital Citizen Pass
            </a>
            <a href="#security" style={{ fontSize: '13.5px', fontWeight: 600, color: '#475569', textDecoration: 'none', transition: 'color 0.15s' }}>
              Privacy & Security
            </a>
            <a href="#faq" style={{ fontSize: '13.5px', fontWeight: 600, color: '#475569', textDecoration: 'none', transition: 'color 0.15s' }}>
              FAQ
            </a>
          </nav>

          {/* Right Actions: Language Switcher & Quick Demo */}
          <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
            {/* Language Picker */}
            <div
              style={{
                display: 'flex',
                alignItems: 'center',
                backgroundColor: '#f1f5f9',
                borderRadius: '9px',
                padding: '3px',
                gap: '2px',
                border: '1px solid #e2e8f0',
              }}
            >
              <button
                onClick={() => setLanguage('en')}
                style={{
                  padding: '4px 8px',
                  borderRadius: '6px',
                  border: 'none',
                  fontSize: '11.5px',
                  fontWeight: language === 'en' ? 700 : 500,
                  backgroundColor: language === 'en' ? '#ffffff' : 'transparent',
                  color: language === 'en' ? '#0d9488' : '#64748b',
                  cursor: 'pointer',
                  boxShadow: language === 'en' ? '0 1px 3px rgba(0,0,0,0.06)' : 'none',
                  transition: 'all 0.15s ease',
                }}
              >
                EN
              </button>
              <button
                onClick={() => setLanguage('hi')}
                style={{
                  padding: '4px 8px',
                  borderRadius: '6px',
                  border: 'none',
                  fontSize: '11.5px',
                  fontWeight: language === 'hi' ? 700 : 500,
                  backgroundColor: language === 'hi' ? '#ffffff' : 'transparent',
                  color: language === 'hi' ? '#0d9488' : '#64748b',
                  cursor: 'pointer',
                  boxShadow: language === 'hi' ? '0 1px 3px rgba(0,0,0,0.06)' : 'none',
                  transition: 'all 0.15s ease',
                }}
              >
                हिंदी
              </button>
              <button
                onClick={() => setLanguage('pa')}
                style={{
                  padding: '4px 8px',
                  borderRadius: '6px',
                  border: 'none',
                  fontSize: '11.5px',
                  fontWeight: language === 'pa' ? 700 : 500,
                  backgroundColor: language === 'pa' ? '#ffffff' : 'transparent',
                  color: language === 'pa' ? '#0d9488' : '#64748b',
                  cursor: 'pointer',
                  boxShadow: language === 'pa' ? '0 1px 3px rgba(0,0,0,0.06)' : 'none',
                  transition: 'all 0.15s ease',
                }}
              >
                ਪੰਜਾਬੀ
              </button>
            </div>

            {/* Instant Demo Button */}
            <button
              onClick={handleInstantDemoLogin}
              disabled={isDemoLoading}
              className="btn-interactive"
              style={{
                display: 'inline-flex',
                alignItems: 'center',
                gap: '6px',
                padding: '8px 14px',
                borderRadius: '10px',
                background: 'linear-gradient(135deg, #0f766e 0%, #0d9488 100%)',
                color: '#ffffff',
                border: 'none',
                fontSize: '12.5px',
                fontWeight: 700,
                cursor: 'pointer',
                boxShadow: '0 4px 12px rgba(13, 148, 136, 0.25)',
              }}
            >
              {isDemoLoading ? (
                <span>Entering...</span>
              ) : (
                <>
                  <span>🚀 Instant Demo</span>
                </>
              )}
            </button>
          </div>
        </div>
      </header>

      {/* ------------------------------------------------------------- */}
      {/* 2. HERO SECTION                                                */}
      {/* ------------------------------------------------------------- */}
      <section className="hero-mesh-bg" style={{ padding: '48px 24px 72px' }}>
        <div
          style={{
            maxWidth: '1280px',
            margin: '0 auto',
            display: 'grid',
            gridTemplateColumns: 'repeat(auto-fit, minmax(320px, 1fr))',
            gap: '40px',
            alignItems: 'center',
          }}
        >
          {/* Left Column: Hero Copy & Value Props */}
          <div>
            {/* Pill Tag */}
            <div
              style={{
                display: 'inline-flex',
                alignItems: 'center',
                gap: '8px',
                padding: '6px 14px',
                borderRadius: '24px',
                backgroundColor: '#f0fdfa',
                border: '1px solid #99f6e4',
                color: '#0f766e',
                fontSize: '12px',
                fontWeight: 700,
                marginBottom: '20px',
                boxShadow: '0 2px 8px rgba(13, 148, 136, 0.08)',
              }}
            >
              <span style={{ display: 'inline-block', width: '7px', height: '7px', borderRadius: '50%', backgroundColor: '#14b8a6' }}></span>
              <span>⚡ Independent Citizen Utility • 100% Free & Secure</span>
            </div>

            {/* Main Headline */}
            <h1
              style={{
                fontSize: 'clamp(28px, 4vw, 46px)',
                fontWeight: 900,
                lineHeight: 1.15,
                color: '#0f172a',
                letterSpacing: '-0.03em',
                marginBottom: '18px',
              }}
            >
              Your Unified Gateway to <span className="gradient-text-teal">19+ Public Portals</span> & Citizen Vault
            </h1>

            {/* Subtitle */}
            <p
              style={{
                fontSize: '15px',
                lineHeight: 1.6,
                color: '#475569',
                marginBottom: '28px',
                maxWidth: '540px',
              }}
            >
              Instant one-click access to e-PAN, Aadhaar, Voter ID, Driving Licence, PMJAY ABHA, UPSC, SSC, NTA Exam Admit Cards, and Board Results — backed by encrypted citizen storage.
            </p>

            {/* Feature Pills */}
            <div style={{ display: 'flex', flexWrap: 'wrap', gap: '10px', marginBottom: '36px' }}>
              <div
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '6px',
                  padding: '6px 12px',
                  borderRadius: '10px',
                  backgroundColor: '#ffffff',
                  border: '1px solid #e2e8f0',
                  fontSize: '12px',
                  fontWeight: 600,
                  color: '#334155',
                  boxShadow: '0 2px 4px rgba(0,0,0,0.03)',
                }}
              >
                <span>⚡</span> Instant Direct Redirection
              </div>
              <div
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '6px',
                  padding: '6px 12px',
                  borderRadius: '10px',
                  backgroundColor: '#ffffff',
                  border: '1px solid #e2e8f0',
                  fontSize: '12px',
                  fontWeight: 600,
                  color: '#334155',
                  boxShadow: '0 2px 4px rgba(0,0,0,0.03)',
                }}
              >
                <span>📁</span> Encrypted Citizen Vault
              </div>
              <div
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '6px',
                  padding: '6px 12px',
                  borderRadius: '10px',
                  backgroundColor: '#ffffff',
                  border: '1px solid #e2e8f0',
                  fontSize: '12px',
                  fontWeight: 600,
                  color: '#334155',
                  boxShadow: '0 2px 4px rgba(0,0,0,0.03)',
                }}
              >
                <span>🌐</span> 3 Languages Supported
              </div>
            </div>

            {/* Live Stats Row */}
            <div
              style={{
                display: 'grid',
                gridTemplateColumns: 'repeat(4, 1fr)',
                gap: '12px',
                padding: '16px',
                borderRadius: '16px',
                backgroundColor: '#ffffff',
                border: '1px solid #e2e8f0',
                boxShadow: '0 4px 14px rgba(15, 23, 42, 0.04)',
                maxWidth: '540px',
              }}
            >
              <div>
                <div style={{ fontSize: '20px', fontWeight: 900, color: '#0d9488' }}>19+</div>
                <div style={{ fontSize: '10.5px', color: '#64748b', fontWeight: 600 }}>Portals & Boards</div>
              </div>
              <div>
                <div style={{ fontSize: '20px', fontWeight: 900, color: '#0284c7' }}>3</div>
                <div style={{ fontSize: '10.5px', color: '#64748b', fontWeight: 600 }}>Languages (EN/HI/PA)</div>
              </div>
              <div>
                <div style={{ fontSize: '20px', fontWeight: 900, color: '#7c3aed' }}>100%</div>
                <div style={{ fontSize: '10.5px', color: '#64748b', fontWeight: 600 }}>Free & Private</div>
              </div>
              <div>
                <div style={{ fontSize: '20px', fontWeight: 900, color: '#059669' }}>256-bit</div>
                <div style={{ fontSize: '10.5px', color: '#64748b', fontWeight: 600 }}>Encrypted Vault</div>
              </div>
            </div>
          </div>

          {/* Right Column: Premium Auth Card */}
          <div style={{ display: 'flex', justifyContent: 'center' }}>
            <div
              className="glass-card glass-card-glow"
              style={{
                width: '100%',
                maxWidth: '440px',
                borderRadius: '24px',
                padding: '30px 24px',
                boxShadow: '0 25px 50px -12px rgba(13, 148, 136, 0.15)',
              }}
            >
              {/* Auth Card Header */}
              <div style={{ marginBottom: '20px', textAlign: 'center' }}>
                <div
                  style={{
                    width: '46px',
                    height: '46px',
                    borderRadius: '14px',
                    background: 'linear-gradient(135deg, #0f766e 0%, #0d9488 100%)',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    color: '#ffffff',
                    margin: '0 auto 12px',
                    boxShadow: '0 6px 16px rgba(13, 148, 136, 0.3)',
                  }}
                >
                  <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2">
                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
                    <path d="M7 11V7a5 5 0 0 1 10 0v4" />
                  </svg>
                </div>
                <h2 style={{ margin: '0 0 4px', fontSize: '20px', fontWeight: 800, color: '#0f172a' }}>
                  Citizen Login / Sign In
                </h2>
                <p style={{ margin: 0, fontSize: '13px', color: '#64748b' }}>
                  Enter your mobile number or email for instant OTP access
                </p>
              </div>

              {/* Instant Demo Shortcut Pill */}
              <div
                onClick={handleInstantDemoLogin}
                className="btn-interactive"
                style={{
                  backgroundColor: '#f0fdfa',
                  border: '1px dashed #2dd4bf',
                  borderRadius: '12px',
                  padding: '10px 14px',
                  marginBottom: '18px',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'space-between',
                  cursor: 'pointer',
                }}
              >
                <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                  <span style={{ fontSize: '16px' }}>⚡</span>
                  <div>
                    <div style={{ fontSize: '12px', fontWeight: 700, color: '#0f766e' }}>
                      Fast Demo Mode (1-Click)
                    </div>
                    <div style={{ fontSize: '10.5px', color: '#14b8a6' }}>
                      Auto-login with pre-verified test citizen profile
                    </div>
                  </div>
                </div>
                <span style={{ fontSize: '12px', fontWeight: 800, color: '#0d9488' }}>Enter →</span>
              </div>

              {/* Main Auth Form */}
              <PhoneAuthForm
                onOtpSent={handleOtpSent}
                onQrLoginClick={() => setShowQrModal(true)}
              />

              {/* Trust Badges Footer */}
              <div
                style={{
                  marginTop: '20px',
                  paddingTop: '16px',
                  borderTop: '1px solid #e2e8f0',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  gap: '16px',
                  fontSize: '11px',
                  color: '#64748b',
                  fontWeight: 600,
                }}
              >
                <span>🔒 256-bit Encrypted</span>
                <span>•</span>
                <span>🛡️ Private Platform</span>
                <span>•</span>
                <span>🚫 Zero Spam</span>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* ------------------------------------------------------------- */}
      {/* 3. INTERACTIVE DIRECT PORTALS SHOWCASE (19+ SERVICES)          */}
      {/* ------------------------------------------------------------- */}
      <section id="services" style={{ padding: '60px 24px', backgroundColor: '#f8fafc', borderTop: '1px solid #e2e8f0' }}>
        <div style={{ maxWidth: '1280px', margin: '0 auto' }}>
          {/* Section Header */}
          <div style={{ textAlign: 'center', marginBottom: '36px' }}>
            <div
              style={{
                display: 'inline-flex',
                alignItems: 'center',
                gap: '6px',
                fontSize: '11.5px',
                fontWeight: 800,
                color: '#0d9488',
                backgroundColor: '#ccfbf1',
                padding: '3px 10px',
                borderRadius: '6px',
                marginBottom: '10px',
              }}
            >
              DIRECTORY & NAVIGATOR
            </div>
            <h2 style={{ fontSize: '28px', fontWeight: 900, color: '#0f172a', letterSpacing: '-0.02em', margin: '0 0 8px' }}>
              19+ Official Department Portals & Exam Boards
            </h2>
            <p style={{ margin: 0, fontSize: '14px', color: '#64748b', maxWidth: '600px', marginInline: 'auto' }}>
              Direct redirection and document lookups for major national identification, competitive examinations, and welfare portals.
            </p>
          </div>

          {/* Category Filter Pills */}
          <div
            style={{
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              gap: '8px',
              marginBottom: '32px',
              flexWrap: 'wrap',
            }}
          >
            {[
              { id: 'all', label: 'All Services (12 Featured)' },
              { id: 'docs', label: '📄 Identity & Documents' },
              { id: 'exams', label: '🎓 Exams & Boards' },
              { id: 'finance', label: '🏦 Finance & Welfare' },
            ].map((cat) => (
              <button
                key={cat.id}
                onClick={() => setPortalCategory(cat.id as any)}
                style={{
                  padding: '8px 16px',
                  borderRadius: '10px',
                  border: portalCategory === cat.id ? '1px solid #0d9488' : '1px solid #e2e8f0',
                  backgroundColor: portalCategory === cat.id ? '#0d9488' : '#ffffff',
                  color: portalCategory === cat.id ? '#ffffff' : '#475569',
                  fontSize: '13px',
                  fontWeight: 700,
                  cursor: 'pointer',
                  transition: 'all 0.15s ease',
                  boxShadow: portalCategory === cat.id ? '0 4px 10px rgba(13, 148, 136, 0.2)' : 'none',
                }}
              >
                {cat.label}
              </button>
            ))}
          </div>

          {/* Portals Grid */}
          <div
            style={{
              display: 'grid',
              gridTemplateColumns: 'repeat(auto-fill, minmax(260px, 1fr))',
              gap: '18px',
            }}
          >
            {filteredPortals.map((portal) => (
              <div
                key={portal.id}
                className="btn-interactive"
                style={{
                  backgroundColor: '#ffffff',
                  borderRadius: '16px',
                  border: '1px solid #e2e8f0',
                  padding: '20px',
                  display: 'flex',
                  flexDirection: 'column',
                  justifyContent: 'space-between',
                  minHeight: '160px',
                  boxShadow: '0 2px 6px rgba(0,0,0,0.02)',
                }}
              >
                <div>
                  <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '12px' }}>
                    <div
                      style={{
                        width: '38px',
                        height: '38px',
                        borderRadius: '10px',
                        backgroundColor: '#f1f5f9',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        fontSize: '18px',
                      }}
                    >
                      {portal.icon}
                    </div>
                    <span
                      style={{
                        fontSize: '10.5px',
                        fontWeight: 700,
                        backgroundColor: '#f0fdfa',
                        color: '#0f766e',
                        padding: '2px 7px',
                        borderRadius: '6px',
                        border: '1px solid #ccfbf1',
                      }}
                    >
                      {portal.tag}
                    </span>
                  </div>
                  <h3 style={{ fontSize: '14px', fontWeight: 800, color: '#0f172a', margin: '0 0 4px', lineHeight: 1.3 }}>
                    {portal.name}
                  </h3>
                  <p style={{ margin: 0, fontSize: '12px', color: '#64748b' }}>
                    {portal.docType}
                  </p>
                </div>

                <div style={{ marginTop: '16px', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                  <a
                    href={portal.url}
                    target="_blank"
                    rel="noopener noreferrer"
                    style={{
                      display: 'inline-flex',
                      alignItems: 'center',
                      gap: '4px',
                      fontSize: '11.5px',
                      fontWeight: 700,
                      color: '#0d9488',
                      textDecoration: 'none',
                    }}
                  >
                    Direct Official Portal ↗
                  </a>
                  <button
                    onClick={handleInstantDemoLogin}
                    style={{
                      padding: '4px 10px',
                      borderRadius: '6px',
                      border: '1px solid #e2e8f0',
                      backgroundColor: '#f8fafc',
                      color: '#0f172a',
                      fontSize: '11px',
                      fontWeight: 700,
                      cursor: 'pointer',
                    }}
                  >
                    Fetch
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ------------------------------------------------------------- */}
      {/* 4. DIGITAL CITIZEN PASS SHOWCASE                               */}
      {/* ------------------------------------------------------------- */}
      <section id="pass" style={{ padding: '60px 24px', backgroundColor: '#ffffff' }}>
        <div
          style={{
            maxWidth: '1280px',
            margin: '0 auto',
            display: 'grid',
            gridTemplateColumns: 'repeat(auto-fit, minmax(320px, 1fr))',
            gap: '48px',
            alignItems: 'center',
          }}
        >
          {/* Card Preview Graphic */}
          <div style={{ display: 'flex', justifyContent: 'center' }}>
            <div
              style={{
                width: '100%',
                maxWidth: '420px',
                background: 'linear-gradient(135deg, #092e2b 0%, #0d5952 50%, #0a423d 100%)',
                borderRadius: '22px',
                padding: '24px',
                color: '#ffffff',
                border: '1.5px solid rgba(94, 234, 212, 0.4)',
                boxShadow: '0 25px 50px -12px rgba(13, 148, 136, 0.3)',
              }}
            >
              {/* Card Header */}
              <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '20px' }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                  <div
                    style={{
                      padding: '6px',
                      backgroundColor: 'rgba(255, 255, 255, 0.15)',
                      borderRadius: '8px',
                      fontSize: '16px',
                    }}
                  >
                    🇮🇳
                  </div>
                  <div>
                    <div style={{ fontSize: '9px', fontWeight: 800, color: '#5eead4', letterSpacing: '0.05em' }}>
                      DOCUSEWA CITIZEN PASS
                    </div>
                    <div style={{ fontSize: '13.5px', fontWeight: 900, color: '#ffffff' }}>
                      Digital Identity Card
                    </div>
                  </div>
                </div>
                <div
                  style={{
                    fontSize: '9px',
                    fontWeight: 800,
                    backgroundColor: '#134e4a',
                    color: '#5eead4',
                    padding: '3px 8px',
                    borderRadius: '6px',
                    border: '1px solid #2dd4bf',
                  }}
                >
                  VERIFIED CITIZEN
                </div>
              </div>

              {/* Photo & Details */}
              <div style={{ display: 'flex', gap: '14px', alignItems: 'center', marginBottom: '20px' }}>
                <div
                  style={{
                    width: '64px',
                    height: '64px',
                    borderRadius: '12px',
                    backgroundColor: '#115e59',
                    border: '2px solid #5eead4',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    fontSize: '22px',
                    fontWeight: 900,
                    color: '#ffffff',
                  }}
                >
                  DK
                </div>
                <div>
                  <div style={{ fontSize: '8.5px', fontWeight: 700, color: '#99f6e4' }}>LEGAL CITIZEN NAME</div>
                  <div style={{ fontSize: '15px', fontWeight: 900, color: '#ffffff', marginBottom: '6px' }}>Dilkhush Kumar</div>
                  <div style={{ display: 'flex', gap: '16px' }}>
                    <div>
                      <div style={{ fontSize: '8px', fontWeight: 700, color: '#99f6e4' }}>DOB</div>
                      <div style={{ fontSize: '11px', fontWeight: 700, color: '#ffffff' }}>15/08/2000</div>
                    </div>
                    <div>
                      <div style={{ fontSize: '8px', fontWeight: 700, color: '#99f6e4' }}>GENDER</div>
                      <div style={{ fontSize: '11px', fontWeight: 700, color: '#ffffff' }}>MALE</div>
                    </div>
                  </div>
                </div>
              </div>

              {/* Bottom Strip */}
              <div
                style={{
                  backgroundColor: 'rgba(0, 0, 0, 0.3)',
                  borderRadius: '10px',
                  padding: '10px 14px',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'space-between',
                }}
              >
                <div>
                  <div style={{ fontSize: '8px', fontWeight: 700, color: '#99f6e4' }}>CITIZEN ID NUMBER</div>
                  <div style={{ fontSize: '13px', fontWeight: 800, color: '#ffffff', letterSpacing: '0.04em' }}>
                    DOCS-2026-IND-8849
                  </div>
                </div>
                <div
                  style={{
                    width: '32px',
                    height: '32px',
                    backgroundColor: '#ffffff',
                    borderRadius: '6px',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    color: '#0f172a',
                    fontSize: '18px',
                  }}
                >
                  ▦
                </div>
              </div>
            </div>
          </div>

          {/* Copy Explanation */}
          <div>
            <div
              style={{
                display: 'inline-flex',
                alignItems: 'center',
                gap: '6px',
                fontSize: '11.5px',
                fontWeight: 800,
                color: '#0d9488',
                backgroundColor: '#ccfbf1',
                padding: '3px 10px',
                borderRadius: '6px',
                marginBottom: '10px',
              }}
            >
              PORTABLE DIGITAL ID
            </div>
            <h2 style={{ fontSize: '28px', fontWeight: 900, color: '#0f172a', letterSpacing: '-0.02em', margin: '0 0 14px' }}>
              Your Encrypted Digital Citizen Pass
            </h2>
            <p style={{ fontSize: '15px', lineHeight: 1.6, color: '#475569', marginBottom: '24px' }}>
              A unified digital identity card mapped to your verified mobile number. Seamlessly export, download, and use across document verification counters and official portals.
            </p>

            <div style={{ display: 'grid', gap: '14px', marginBottom: '28px' }}>
              <div style={{ display: 'flex', gap: '12px', alignItems: 'flex-start' }}>
                <div style={{ width: '24px', height: '24px', borderRadius: '50%', backgroundColor: '#dcfce7', color: '#16a34a', display: 'flex', alignItems: 'center', justifyContent: 'center', fontWeight: 800, fontSize: '12px' }}>✓</div>
                <div>
                  <div style={{ fontSize: '13.5px', fontWeight: 700, color: '#0f172a' }}>Instant QR Code Verification</div>
                  <div style={{ fontSize: '12px', color: '#64748b' }}>Scan-ready cryptographic citizen hash for rapid profile checks.</div>
                </div>
              </div>
              <div style={{ display: 'flex', gap: '12px', alignItems: 'flex-start' }}>
                <div style={{ width: '24px', height: '24px', borderRadius: '50%', backgroundColor: '#dcfce7', color: '#16a34a', display: 'flex', alignItems: 'center', justifyContent: 'center', fontWeight: 800, fontSize: '12px' }}>✓</div>
                <div>
                  <div style={{ fontSize: '13.5px', fontWeight: 700, color: '#0f172a' }}>PKCS#7 Signed Digital Pass Export</div>
                  <div style={{ fontSize: '12px', color: '#64748b' }}>Download as encrypted PDF or backup archive with one click.</div>
                </div>
              </div>
            </div>

            <button
              onClick={handleInstantDemoLogin}
              className="btn-interactive"
              style={{
                padding: '12px 24px',
                borderRadius: '12px',
                backgroundColor: '#0d9488',
                color: '#ffffff',
                border: 'none',
                fontSize: '14px',
                fontWeight: 800,
                cursor: 'pointer',
                boxShadow: '0 4px 14px rgba(13, 148, 136, 0.3)',
              }}
            >
              Generate Your Pass →
            </button>
          </div>
        </div>
      </section>

      {/* ------------------------------------------------------------- */}
      {/* 5. PRIVACY & SECURITY PILLARS                                  */}
      {/* ------------------------------------------------------------- */}
      <section id="security" style={{ padding: '60px 24px', backgroundColor: '#f0fdfa', borderTop: '1px solid #ccfbf1' }}>
        <div style={{ maxWidth: '1280px', margin: '0 auto' }}>
          <div style={{ textAlign: 'center', marginBottom: '40px' }}>
            <h2 style={{ fontSize: '28px', fontWeight: 900, color: '#0f172a', margin: '0 0 8px' }}>
              Built for Citizen Privacy & Speed
            </h2>
            <p style={{ margin: 0, fontSize: '14px', color: '#64748b' }}>
              Why millions of users prefer DocuSewa as their independent portal navigator.
            </p>
          </div>

          <div
            style={{
              display: 'grid',
              gridTemplateColumns: 'repeat(auto-fit, minmax(260px, 1fr))',
              gap: '20px',
            }}
          >
            <div style={{ backgroundColor: '#ffffff', borderRadius: '18px', padding: '24px', border: '1px solid #e2e8f0', boxShadow: '0 2px 6px rgba(0,0,0,0.02)' }}>
              <div style={{ width: '42px', height: '42px', borderRadius: '12px', backgroundColor: '#f0fdfa', color: '#0d9488', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: '20px', marginBottom: '14px' }}>
                🛡️
              </div>
              <h3 style={{ fontSize: '16px', fontWeight: 800, color: '#0f172a', margin: '0 0 6px' }}>Private Platform Guarantee</h3>
              <p style={{ margin: 0, fontSize: '13px', lineHeight: 1.5, color: '#64748b' }}>
                We are an independent portal aggregator. We never store raw government passwords or sell citizen data.
              </p>
            </div>

            <div style={{ backgroundColor: '#ffffff', borderRadius: '18px', padding: '24px', border: '1px solid #e2e8f0', boxShadow: '0 2px 6px rgba(0,0,0,0.02)' }}>
              <div style={{ width: '42px', height: '42px', borderRadius: '12px', backgroundColor: '#eff6ff', color: '#0284c7', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: '20px', marginBottom: '14px' }}>
                ⚡
              </div>
              <h3 style={{ fontSize: '16px', fontWeight: 800, color: '#0f172a', margin: '0 0 6px' }}>Direct Official Redirect</h3>
              <p style={{ margin: 0, fontSize: '13px', lineHeight: 1.5, color: '#64748b' }}>
                No intermediaries. One-click routing directly to Income Tax, ECI, Parivahan, and examination boards.
              </p>
            </div>

            <div style={{ backgroundColor: '#ffffff', borderRadius: '18px', padding: '24px', border: '1px solid #e2e8f0', boxShadow: '0 2px 6px rgba(0,0,0,0.02)' }}>
              <div style={{ width: '42px', height: '42px', borderRadius: '12px', backgroundColor: '#faf5ff', color: '#7c3aed', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: '20px', marginBottom: '14px' }}>
                🌐
              </div>
              <h3 style={{ fontSize: '16px', fontWeight: 800, color: '#0f172a', margin: '0 0 6px' }}>Trilingual Accessibility</h3>
              <p style={{ margin: 0, fontSize: '13px', lineHeight: 1.5, color: '#64748b' }}>
                English, Hindi, and Punjabi interfaces allow citizens across regions to navigate services effortlessly.
              </p>
            </div>

            <div style={{ backgroundColor: '#ffffff', borderRadius: '18px', padding: '24px', border: '1px solid #e2e8f0', boxShadow: '0 2px 6px rgba(0,0,0,0.02)' }}>
              <div style={{ width: '42px', height: '42px', borderRadius: '12px', backgroundColor: '#fdf2f8', color: '#db2777', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: '20px', marginBottom: '14px' }}>
                📱
              </div>
              <h3 style={{ fontSize: '16px', fontWeight: 800, color: '#0f172a', margin: '0 0 6px' }}>Web & Mobile Sync</h3>
              <p style={{ margin: 0, fontSize: '13px', lineHeight: 1.5, color: '#64748b' }}>
                Native Flutter mobile app and ultra-fast Next.js web application stay synchronized across all devices.
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* ------------------------------------------------------------- */}
      {/* 6. FAQ ACCORDION SECTION                                       */}
      {/* ------------------------------------------------------------- */}
      <section id="faq" style={{ padding: '60px 24px', backgroundColor: '#ffffff' }}>
        <div style={{ maxWidth: '800px', margin: '0 auto' }}>
          <div style={{ textAlign: 'center', marginBottom: '36px' }}>
            <h2 style={{ fontSize: '28px', fontWeight: 900, color: '#0f172a', margin: '0 0 8px' }}>
              Frequently Asked Questions
            </h2>
            <p style={{ margin: 0, fontSize: '14px', color: '#64748b' }}>
              Clear answers regarding DocuSewa features, security, and independent platform status.
            </p>
          </div>

          <div style={{ display: 'grid', gap: '12px' }}>
            {FAQS.map((faq, idx) => {
              const isOpen = openFaq === idx;
              return (
                <div
                  key={idx}
                  style={{
                    border: '1px solid #e2e8f0',
                    borderRadius: '14px',
                    overflow: 'hidden',
                    backgroundColor: isOpen ? '#f8fafc' : '#ffffff',
                    transition: 'all 0.2s ease',
                  }}
                >
                  <button
                    onClick={() => setOpenFaq(isOpen ? null : idx)}
                    style={{
                      width: '100%',
                      padding: '16px 20px',
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'space-between',
                      border: 'none',
                      backgroundColor: 'transparent',
                      textAlign: 'left',
                      fontSize: '14.5px',
                      fontWeight: 700,
                      color: '#0f172a',
                      cursor: 'pointer',
                    }}
                  >
                    <span>{faq.q}</span>
                    <span style={{ fontSize: '16px', color: '#0d9488', fontWeight: 900, transform: isOpen ? 'rotate(180deg)' : 'none', transition: 'transform 0.2s' }}>
                      ▼
                    </span>
                  </button>
                  {isOpen && (
                    <div style={{ padding: '0 20px 18px', fontSize: '13.5px', lineHeight: 1.6, color: '#475569', borderTop: '1px solid #e2e8f0', paddingTop: '12px' }}>
                      {faq.a}
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        </div>
      </section>

      {/* ------------------------------------------------------------- */}
      {/* 7. FOOTER WITH TRANSPARENT DISCLAIMER                          */}
      {/* ------------------------------------------------------------- */}
      <footer style={{ backgroundColor: '#091e1d', color: '#94a3b8', padding: '48px 24px 32px', marginTop: 'auto' }}>
        <div style={{ maxWidth: '1280px', margin: '0 auto' }}>
          {/* Main Footer Row */}
          <div style={{ display: 'flex', justifyContent: 'space-between', flexWrap: 'wrap', gap: '32px', marginBottom: '36px' }}>
            <div style={{ maxWidth: '380px' }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: '10px', marginBottom: '12px' }}>
                <div
                  style={{
                    width: '32px',
                    height: '32px',
                    borderRadius: '8px',
                    backgroundColor: '#0d9488',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    color: '#ffffff',
                    fontWeight: 900,
                  }}
                >
                  D
                </div>
                <span style={{ fontSize: '18px', fontWeight: 900, color: '#ffffff' }}>
                  Docu<span style={{ color: '#2dd4bf' }}>Sewa</span>
                </span>
                <span style={{ fontSize: '9px', fontWeight: 800, backgroundColor: '#134e4a', color: '#5eead4', padding: '2px 6px', borderRadius: '4px' }}>
                  PORTAL
                </span>
              </div>
              <p style={{ fontSize: '13px', lineHeight: 1.5, color: '#94a3b8', margin: 0 }}>
                Independent citizen utility platform providing structured directory navigation, exam admit card pulls, and encrypted certificate vault management.
              </p>
            </div>

            {/* Quick Links */}
            <div style={{ display: 'flex', gap: '48px', flexWrap: 'wrap' }}>
              <div>
                <h4 style={{ color: '#ffffff', fontSize: '13px', fontWeight: 800, marginBottom: '12px', letterSpacing: '0.04em' }}>
                  SERVICES
                </h4>
                <ul style={{ listStyle: 'none', padding: 0, margin: 0, display: 'grid', gap: '8px', fontSize: '12.5px' }}>
                  <li><a href="#services" style={{ color: '#94a3b8', textDecoration: 'none' }}>Identity Documents</a></li>
                  <li><a href="#services" style={{ color: '#94a3b8', textDecoration: 'none' }}>Exam Admit Cards</a></li>
                  <li><a href="#services" style={{ color: '#94a3b8', textDecoration: 'none' }}>Board Results</a></li>
                  <li><a href="#services" style={{ color: '#94a3b8', textDecoration: 'none' }}>Health & Welfare</a></li>
                </ul>
              </div>

              <div>
                <h4 style={{ color: '#ffffff', fontSize: '13px', fontWeight: 800, marginBottom: '12px', letterSpacing: '0.04em' }}>
                  LANGUAGES
                </h4>
                <ul style={{ listStyle: 'none', padding: 0, margin: 0, display: 'grid', gap: '8px', fontSize: '12.5px' }}>
                  <li><button onClick={() => setLanguage('en')} style={{ background: 'none', border: 'none', color: language === 'en' ? '#2dd4bf' : '#94a3b8', cursor: 'pointer', padding: 0 }}>English (Default)</button></li>
                  <li><button onClick={() => setLanguage('hi')} style={{ background: 'none', border: 'none', color: language === 'hi' ? '#2dd4bf' : '#94a3b8', cursor: 'pointer', padding: 0 }}>हिंदी (Hindi)</button></li>
                  <li><button onClick={() => setLanguage('pa')} style={{ background: 'none', border: 'none', color: language === 'pa' ? '#2dd4bf' : '#94a3b8', cursor: 'pointer', padding: 0 }}>ਪੰਜਾਬੀ (Punjabi)</button></li>
                </ul>
              </div>
            </div>
          </div>

          {/* Transparent Private Platform Notice Banner */}
          <div
            style={{
              padding: '16px 20px',
              backgroundColor: '#042f2e',
              border: '1px solid #115e59',
              borderRadius: '14px',
              fontSize: '12px',
              lineHeight: 1.5,
              color: '#99f6e4',
              display: 'flex',
              alignItems: 'center',
              gap: '12px',
              marginBottom: '24px',
            }}
          >
            <span style={{ fontSize: '18px' }}>ℹ️</span>
            <div>
              <strong style={{ color: '#ffffff' }}>Legal Disclaimer: </strong>
              DocuSewa is an independent, private citizen utility platform. We are not an official government entity or affiliated with any government ministry. All departmental trademarks and portal links belong to their respective authorities.
            </div>
          </div>

          {/* Copyright */}
          <div style={{ textAlign: 'center', fontSize: '12px', color: '#64748b' }}>
            © {new Date().getFullYear()} DocuSewa. All rights reserved. Secure Encrypted Citizen Portal.
          </div>
        </div>
      </footer>

      {/* ------------------------------------------------------------- */}
      {/* 8. MODALS                                                      */}
      {/* ------------------------------------------------------------- */}
      {/* QR Code Login Preview Modal */}
      {showQrModal && (
        <div
          style={{
            position: 'fixed',
            inset: 0,
            backgroundColor: 'rgba(15, 23, 42, 0.65)',
            backdropFilter: 'blur(8px)',
            WebkitBackdropFilter: 'blur(8px)',
            zIndex: 200,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            padding: '16px',
          }}
          onClick={() => setShowQrModal(false)}
        >
          <div
            style={{
              backgroundColor: '#ffffff',
              borderRadius: '24px',
              padding: '32px',
              maxWidth: '380px',
              width: '100%',
              textAlign: 'center',
              boxShadow: '0 25px 50px -12px rgba(15, 23, 42, 0.25)',
            }}
            onClick={(e) => e.stopPropagation()}
          >
            <h3 style={{ margin: '0 0 8px', fontSize: '19px', fontWeight: 800, color: '#0f172a' }}>
              Scan QR Code
            </h3>
            <p style={{ margin: '0 0 20px', fontSize: '13px', color: '#64748b' }}>
              Open the DocuSewa mobile app and scan this QR code to log in instantly.
            </p>

            <div
              style={{
                width: '200px',
                height: '200px',
                margin: '0 auto 20px',
                border: '2px solid #ccfbf1',
                borderRadius: '16px',
                padding: '12px',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                backgroundColor: '#f0fdfa',
              }}
            >
              <svg width="170" height="170" viewBox="0 0 100 100" fill="#0f172a">
                <rect x="10" y="10" width="25" height="25" fill="#0f172a" />
                <rect x="15" y="15" width="15" height="15" fill="#ffffff" />
                <rect x="18" y="18" width="9" height="9" fill="#0f172a" />

                <rect x="65" y="10" width="25" height="25" fill="#0f172a" />
                <rect x="70" y="15" width="15" height="15" fill="#ffffff" />
                <rect x="73" y="18" width="9" height="9" fill="#0f172a" />

                <rect x="10" y="65" width="25" height="25" fill="#0f172a" />
                <rect x="15" y="70" width="15" height="15" fill="#ffffff" />
                <rect x="18" y="73" width="9" height="9" fill="#0f172a" />

                <rect x="42" y="12" width="6" height="6" />
                <rect x="52" y="12" width="6" height="6" />
                <rect x="42" y="24" width="6" height="6" />
                <rect x="52" y="24" width="6" height="6" />
                <rect x="45" y="45" width="10" height="10" fill="#0d9488" />
                <rect x="65" y="45" width="8" height="8" />
                <rect x="75" y="55" width="8" height="8" />
                <rect x="45" y="65" width="8" height="8" />
                <rect x="65" y="75" width="18" height="8" />
              </svg>
            </div>

            <button
              onClick={() => setShowQrModal(false)}
              style={{
                width: '100%',
                height: '44px',
                borderRadius: '12px',
                border: '1px solid #e2e8f0',
                backgroundColor: '#f1f5f9',
                color: '#0f172a',
                fontWeight: 700,
                fontSize: '14px',
                cursor: 'pointer',
              }}
            >
              Close
            </button>
          </div>
        </div>
      )}

      {/* OTP Verification Modal */}
      {otpTarget && (
        <OtpModal
          target={otpTarget}
          type={otpType}
          onVerified={handleVerified}
          onEditNumber={handleEditNumber}
          onResend={handleResend}
        />
      )}
    </div>
  );
}
