'use client';

import React, { useState } from 'react';
import { signOut } from '@/services/auth.service';
import { useRouter } from 'next/navigation';
import { Language, translations } from '@/lib/translations';

interface ProfileData {
  fullName: string;
  displayName: string;
  phone: string;
  email: string;
  dob: string;
  gender: string;
  bloodGroup: string;
  fatherName: string;
  address: string;
  state: string;
  pincode: string;
  citizenId: string;
  aadhaarLast4: string;
  panNumber: string;
  abhaId: string;
  uanNumber: string;
  kycLevel: string;
  joinedDate: string;
}

interface LinkedGovAccount {
  id: string;
  name: string;
  dept: string;
  identifier: string;
  status: 'connected' | 'action_required' | 'syncing';
  lastSynced: string;
  badgeColor: string;
  logo: string;
}

interface ConsentLogItem {
  id: string;
  portal: string;
  purpose: string;
  docsShared: string[];
  date: string;
  status: 'active' | 'revoked';
}

const INITIAL_PROFILE: ProfileData = {
  fullName: 'Dilkhush Kumar',
  displayName: 'Dilkhush',
  phone: '+91 98765 43210',
  email: 'dilkhush.citizen@docusewa.gov.in',
  dob: '15 Aug 1998',
  gender: 'Male',
  bloodGroup: 'O+ Positive',
  fatherName: 'Rajendra Kumar',
  address: 'H-42, Sector 62, Electronic City, Noida',
  state: 'Uttar Pradesh',
  pincode: '201301',
  citizenId: 'DS-IN-2026-89210',
  aadhaarLast4: '8921',
  panNumber: 'ABCDE1234F',
  abhaId: '91-8921-4412-3320',
  uanNumber: '101293849120',
  kycLevel: 'Tier 3 (DigiLocker + Biometric Verified)',
  joinedDate: 'January 2024',
};

const INITIAL_ACCOUNTS: LinkedGovAccount[] = [
  {
    id: 'uidai',
    name: 'UIDAI Aadhaar System',
    dept: 'Unique Identification Authority of India',
    identifier: 'XXXXXXXX8921',
    status: 'connected',
    lastSynced: '2 mins ago',
    badgeColor: '#ea580c',
    logo: 'uidai',
  },
  {
    id: 'itd',
    name: 'e-Filing PAN Database',
    dept: 'Income Tax Department, Ministry of Finance',
    identifier: 'ABCDE1234F',
    status: 'connected',
    lastSynced: 'Yesterday, 18:30',
    badgeColor: '#0d9488',
    logo: 'itd',
  },
  {
    id: 'digilocker',
    name: 'DigiLocker Central Vault Gateway',
    dept: 'National e-Governance Division (MeitY)',
    identifier: 'DL-IN-987654',
    status: 'connected',
    lastSynced: 'Live Sync Active',
    badgeColor: '#2563eb',
    logo: 'digi',
  },
  {
    id: 'morth',
    name: 'Parivahan Sarathi / Vahan',
    dept: 'Ministry of Road Transport & Highways',
    identifier: 'DL-04202100892',
    status: 'connected',
    lastSynced: '12 Feb 2026',
    badgeColor: '#16a34a',
    logo: 'morth',
  },
  {
    id: 'nha',
    name: 'Ayushman Bharat ABHA Health ID',
    dept: 'National Health Authority',
    identifier: '91-8921-4412-3320',
    status: 'connected',
    lastSynced: '04 Jan 2026',
    badgeColor: '#9333ea',
    logo: 'nha',
  },
  {
    id: 'epfo',
    name: 'EPFO Member Unified Portal',
    dept: 'Employees’ Provident Fund Organisation',
    identifier: 'UAN 101293849120',
    status: 'connected',
    lastSynced: '28 Jan 2026',
    badgeColor: '#b45309',
    logo: 'epfo',
  },
];

const INITIAL_CONSENT_LOGS: ConsentLogItem[] = [
  {
    id: 'c-1',
    portal: 'State Bank of India (KYC Verification)',
    purpose: 'Instant Account Opening & CIBIL Check',
    docsShared: ['Aadhaar e-KYC', 'PAN Verification'],
    date: '22 Feb 2026, 11:20 AM',
    status: 'active',
  },
  {
    id: 'c-2',
    portal: 'Union Public Service Commission (UPSC OTR)',
    purpose: 'Candidate Age & Domicile Verification',
    docsShared: ['Class X Marksheet', 'Aadhaar ID'],
    date: '10 Feb 2026, 04:15 PM',
    status: 'active',
  },
  {
    id: 'c-3',
    portal: 'National Testing Agency (NTA Exam Portal)',
    purpose: 'Exam Center Biometric Match & Hall Ticket',
    docsShared: ['Aadhaar ID', 'Passport Photo'],
    date: '15 Jan 2026, 09:30 AM',
    status: 'active',
  },
];

interface ProfileSectionProps {
  vaultCount?: number;
  onNavigateToVault?: () => void;
  onClose?: () => void;
  isModalMode?: boolean;
  language?: Language;
  onLanguageChange?: (lang: Language) => void;
}

export default function ProfileSection({
  vaultCount = 3,
  onNavigateToVault,
  onClose,
  isModalMode = false,
  language = 'en',
  onLanguageChange,
}: ProfileSectionProps) {
  const router = useRouter();
  const t = translations[language] || translations.en;

  const [activeTab, setActiveTab] = useState<'card' | 'details' | 'accounts' | 'security' | 'preferences'>('card');
  const [profile, setProfile] = useState<ProfileData>(INITIAL_PROFILE);
  const [isEditing, setIsEditing] = useState<boolean>(false);
  const [formData, setFormData] = useState<ProfileData>(INITIAL_PROFILE);
  const [toastMessage, setToastMessage] = useState<string | null>(null);
  const [copiedField, setCopiedField] = useState<string | null>(null);
  const [accounts, setAccounts] = useState<LinkedGovAccount[]>(INITIAL_ACCOUNTS);
  const [consentLogs, setConsentLogs] = useState<ConsentLogItem[]>(INITIAL_CONSENT_LOGS);
  const [twoFactorEnabled, setTwoFactorEnabled] = useState<boolean>(true);
  const [biometricLockEnabled, setBiometricLockEnabled] = useState<boolean>(true);
  const [whatsappAlerts, setWhatsappAlerts] = useState<boolean>(true);
  const [smsAlerts, setSmsAlerts] = useState<boolean>(true);
  const [isSyncingAll, setIsSyncingAll] = useState<boolean>(false);

  const showToast = (msg: string) => {
    setToastMessage(msg);
    setTimeout(() => {
      setToastMessage(null);
    }, 3500);
  };

  const handleCopy = (text: string, label: string) => {
    navigator.clipboard.writeText(text);
    setCopiedField(label);
    showToast(t.copied);
    setTimeout(() => setCopiedField(null), 2000);
  };

  const handleSaveProfile = (e: React.FormEvent) => {
    e.preventDefault();
    setProfile(formData);
    setIsEditing(false);
    showToast(t.saveChanges + ' ✓');
  };

  const handleCancelEdit = () => {
    setFormData(profile);
    setIsEditing(false);
  };

  const handleSyncAllAccounts = () => {
    setIsSyncingAll(true);
    setTimeout(() => {
      setIsSyncingAll(false);
      setAccounts((prev) =>
        prev.map((acc) => ({
          ...acc,
          lastSynced: 'Just now (Verified)',
        }))
      );
      showToast('All 6 Government Portals synchronized!');
    }, 1200);
  };

  const handleRevokeConsent = (id: string) => {
    setConsentLogs((prev) =>
      prev.map((item) => (item.id === id ? { ...item, status: 'revoked' } : item))
    );
    showToast('Permission revoked.');
  };

  const handleSignOut = async () => {
    await signOut();
    router.push('/');
  };

  return (
    <div
      style={{
        backgroundColor: '#ffffff',
        borderRadius: '24px',
        border: '1.5px solid #e2e8f0',
        boxShadow: '0 4px 20px rgba(0, 0, 0, 0.04)',
        overflow: 'hidden',
        animation: 'cardPopIn 0.3s cubic-bezier(0.16, 1, 0.3, 1) both',
      }}
    >
      {/* Toast Notification Banner */}
      {toastMessage && (
        <div
          style={{
            position: 'fixed',
            bottom: '24px',
            right: '24px',
            zIndex: 9999,
            backgroundColor: '#0f172a',
            color: '#ffffff',
            padding: '12px 20px',
            borderRadius: '12px',
            boxShadow: '0 10px 25px rgba(0, 0, 0, 0.25)',
            display: 'flex',
            alignItems: 'center',
            gap: '10px',
            fontSize: '13px',
            fontWeight: 600,
            animation: 'fadeInScale 0.2s ease both',
            border: '1px solid #334155',
          }}
        >
          <span style={{ color: '#10b981', fontSize: '16px' }}>✓</span>
          <span>{toastMessage}</span>
        </div>
      )}

      {/* Top Banner with Indian Tri-Color / Ashoka Accent */}
      <div
        style={{
          background: 'linear-gradient(135deg, #042f2e 0%, #0f766e 50%, #0d9488 100%)',
          color: '#ffffff',
          padding: isModalMode ? '24px 20px 20px' : '32px 28px 24px',
          position: 'relative',
          overflow: 'hidden',
        }}
      >
        {/* Subtle Decorative Backdrop */}
        <div
          style={{
            position: 'absolute',
            top: '-40px',
            right: '-40px',
            width: '200px',
            height: '200px',
            borderRadius: '50%',
            background: 'radial-gradient(circle, rgba(204, 251, 241, 0.15) 0%, rgba(204, 251, 241, 0) 70%)',
            pointerEvents: 'none',
          }}
        />

        {/* Modal Close Button if in modal */}
        {isModalMode && onClose && (
          <button
            onClick={onClose}
            style={{
              position: 'absolute',
              top: '16px',
              right: '16px',
              width: '32px',
              height: '32px',
              borderRadius: '50%',
              backgroundColor: 'rgba(255, 255, 255, 0.15)',
              border: 'none',
              color: '#ffffff',
              cursor: 'pointer',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              backdropFilter: 'blur(4px)',
            }}
          >
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
              <line x1="18" y1="6" x2="6" y2="18" />
              <line x1="6" y1="6" x2="18" y2="18" />
            </svg>
          </button>
        )}

        <div
          style={{
            display: 'flex',
            flexWrap: 'wrap',
            alignItems: 'center',
            justifyContent: 'space-between',
            gap: '20px',
          }}
        >
          {/* Avatar + Main Identity Info */}
          <div style={{ display: 'flex', alignItems: 'center', gap: '18px' }}>
            <div
              style={{
                position: 'relative',
                width: '74px',
                height: '74px',
                borderRadius: '22px',
                background: 'linear-gradient(135deg, #14b8a6, #0f766e)',
                border: '3px solid rgba(255, 255, 255, 0.9)',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                boxShadow: '0 8px 20px rgba(0, 0, 0, 0.25)',
                color: '#ffffff',
                fontSize: '26px',
                fontWeight: 900,
                letterSpacing: '-0.02em',
                flexShrink: 0,
              }}
            >
              DK
              <span
                title="Verified Citizen"
                style={{
                  position: 'absolute',
                  bottom: '-4px',
                  right: '-4px',
                  backgroundColor: '#10b981',
                  color: '#ffffff',
                  width: '22px',
                  height: '22px',
                  borderRadius: '50%',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  fontSize: '12px',
                  fontWeight: 900,
                  border: '2.5px solid #0f766e',
                }}
              >
                ✓
              </span>
            </div>

            <div>
              <div style={{ display: 'flex', alignItems: 'center', gap: '8px', flexWrap: 'wrap' }}>
                <h1 style={{ fontSize: isModalMode ? '20px' : '24px', fontWeight: 800, margin: 0, letterSpacing: '-0.02em' }}>
                  {profile.fullName}
                </h1>
                <span
                  style={{
                    fontSize: '11px',
                    fontWeight: 700,
                    backgroundColor: 'rgba(255, 255, 255, 0.18)',
                    color: '#ccfbf1',
                    padding: '2px 8px',
                    borderRadius: '8px',
                    border: '1px solid rgba(255, 255, 255, 0.25)',
                    backdropFilter: 'blur(4px)',
                  }}
                >
                  {t.citizenOfIndia}
                </span>
              </div>

              <p style={{ margin: '4px 0 0', fontSize: '13px', color: '#ccfbf1', opacity: 0.9, display: 'flex', alignItems: 'center', gap: '6px' }}>
                <span>ID: <strong>{profile.citizenId}</strong></span>
                <span style={{ opacity: 0.5 }}>•</span>
                <span>{t.kycTier}</span>
              </p>
            </div>
          </div>

          {/* Header Quick Actions */}
          <div style={{ display: 'flex', alignItems: 'center', gap: '10px', flexWrap: 'wrap' }}>
            {/* Quick Language Toggle in Profile Header */}
            <div
              style={{
                display: 'flex',
                alignItems: 'center',
                backgroundColor: 'rgba(255, 255, 255, 0.15)',
                borderRadius: '10px',
                padding: '2px',
                border: '1px solid rgba(255, 255, 255, 0.3)',
              }}
            >
              {(['en', 'hi', 'pa'] as Language[]).map((lang) => (
                <button
                  key={lang}
                  onClick={() => onLanguageChange?.(lang)}
                  style={{
                    border: 'none',
                    backgroundColor: language === lang ? '#ffffff' : 'transparent',
                    color: language === lang ? '#0f766e' : '#ffffff',
                    padding: '4px 10px',
                    borderRadius: '8px',
                    fontSize: '11.5px',
                    fontWeight: 800,
                    cursor: 'pointer',
                    transition: 'all 0.2s ease',
                  }}
                >
                  {lang === 'en' ? 'EN' : lang === 'hi' ? 'हिन्दी' : 'ਪੰਜਾਬੀ'}
                </button>
              ))}
            </div>

            <button
              onClick={handleSyncAllAccounts}
              disabled={isSyncingAll}
              className="btn-interactive"
              style={{
                display: 'inline-flex',
                alignItems: 'center',
                gap: '6px',
                backgroundColor: 'rgba(255, 255, 255, 0.15)',
                color: '#ffffff',
                border: '1px solid rgba(255, 255, 255, 0.3)',
                padding: '8px 14px',
                borderRadius: '12px',
                fontSize: '12.5px',
                fontWeight: 700,
                cursor: isSyncingAll ? 'wait' : 'pointer',
                backdropFilter: 'blur(6px)',
              }}
            >
              <svg
                width="14"
                height="14"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeWidth="2.5"
                style={{ animation: isSyncingAll ? 'spin 1s linear infinite' : 'none' }}
              >
                <path d="M21.5 2v6h-6M2.5 22v-6h6M2 11.5a10 10 0 0 1 18.8-4.3M22 12.5a10 10 0 0 1-18.8 4.2" />
              </svg>
              <span>{isSyncingAll ? t.syncing : t.syncGateway}</span>
            </button>

            <button
              onClick={handleSignOut}
              className="btn-interactive"
              style={{
                display: 'inline-flex',
                alignItems: 'center',
                gap: '6px',
                backgroundColor: '#fff1f2',
                color: '#e11d48',
                border: '1px solid #fecdd3',
                padding: '8px 14px',
                borderRadius: '12px',
                fontSize: '12.5px',
                fontWeight: 700,
                cursor: 'pointer',
              }}
            >
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
                <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
                <polyline points="16 17 21 12 16 7" />
                <line x1="21" y1="12" x2="9" y2="12" />
              </svg>
              <span>{t.signOut.split(' ')[0]}</span>
            </button>
          </div>
        </div>

        {/* Quick Highlights Strip */}
        <div
          style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(auto-fit, minmax(130px, 1fr))',
            gap: '12px',
            marginTop: '24px',
            paddingTop: '16px',
            borderTop: '1px solid rgba(255, 255, 255, 0.15)',
          }}
        >
          <div style={{ backgroundColor: 'rgba(0, 0, 0, 0.18)', padding: '8px 12px', borderRadius: '10px' }}>
            <div style={{ fontSize: '10px', color: '#99f6e4', fontWeight: 700 }}>{t.aadhaarSeeded}</div>
            <div style={{ fontSize: '13px', fontWeight: 800, color: '#ffffff' }}>•••• {profile.aadhaarLast4}</div>
          </div>
          <div style={{ backgroundColor: 'rgba(0, 0, 0, 0.18)', padding: '8px 12px', borderRadius: '10px' }}>
            <div style={{ fontSize: '10px', color: '#99f6e4', fontWeight: 700 }}>{t.panNumber}</div>
            <div style={{ fontSize: '13px', fontWeight: 800, color: '#ffffff' }}>{profile.panNumber}</div>
          </div>
          <div style={{ backgroundColor: 'rgba(0, 0, 0, 0.18)', padding: '8px 12px', borderRadius: '10px' }}>
            <div style={{ fontSize: '10px', color: '#99f6e4', fontWeight: 700 }}>{t.vaultRecords}</div>
            <div style={{ fontSize: '13px', fontWeight: 800, color: '#ffffff' }}>{vaultCount} Docs</div>
          </div>
          <div style={{ backgroundColor: 'rgba(0, 0, 0, 0.18)', padding: '8px 12px', borderRadius: '10px' }}>
            <div style={{ fontSize: '10px', color: '#99f6e4', fontWeight: 700 }}>{t.securityStatus}</div>
            <div style={{ fontSize: '13px', fontWeight: 800, color: '#4ade80' }}>{t.secHigh}</div>
          </div>
        </div>
      </div>

      {/* Sub-Navigation Tabs */}
      <div
        className="no-scrollbar"
        style={{
          display: 'flex',
          alignItems: 'center',
          gap: '4px',
          padding: '12px 20px',
          borderBottom: '1px solid #e2e8f0',
          backgroundColor: '#f8fafc',
          overflowX: 'auto',
          WebkitOverflowScrolling: 'touch',
        }}
      >
        {[
          { id: 'card', label: t.tabDigitalPass },
          { id: 'details', label: t.tabPersonalKYC },
          { id: 'accounts', label: `${t.tabLinkedPortals} (${accounts.length})` },
          { id: 'security', label: t.tabSecurity },
          { id: 'preferences', label: t.tabPreferences },
        ].map((tab) => {
          const isActive = activeTab === tab.id;
          return (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id as any)}
              className="btn-interactive"
              style={{
                padding: '8px 16px',
                borderRadius: '10px',
                border: 'none',
                backgroundColor: isActive ? '#ffffff' : 'transparent',
                color: isActive ? '#0d9488' : '#64748b',
                fontSize: '13px',
                fontWeight: isActive ? 800 : 600,
                cursor: 'pointer',
                whiteSpace: 'nowrap',
                boxShadow: isActive ? '0 2px 6px rgba(0, 0, 0, 0.06)' : 'none',
                flexShrink: 0,
                transition: 'all 0.2s ease',
              }}
            >
              {tab.label}
            </button>
          );
        })}
      </div>

      {/* TAB CONTENT */}
      <div style={{ padding: isModalMode ? '20px' : '28px', backgroundColor: '#ffffff' }}>
        {/* ========================================================================= */}
        {/* TAB 1: DIGITAL CARD */}
        {/* ========================================================================= */}
        {activeTab === 'card' && (
          <div style={{ animation: 'tabSwitchFade 0.2s ease both' }}>
            <div
              style={{
                display: 'grid',
                gridTemplateColumns: 'repeat(auto-fit, minmax(320px, 1fr))',
                gap: '24px',
                alignItems: 'start',
              }}
            >
              {/* National Digital Identity Card Preview */}
              <div
                style={{
                  background: 'linear-gradient(135deg, #092e2b 0%, #0d5952 50%, #0a423d 100%)',
                  borderRadius: '20px',
                  padding: '24px',
                  color: '#ffffff',
                  boxShadow: '0 12px 30px rgba(13, 148, 136, 0.25)',
                  position: 'relative',
                  overflow: 'hidden',
                  border: '1.5px solid rgba(204, 251, 241, 0.3)',
                }}
              >
                {/* Header */}
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '18px' }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                    <div
                      style={{
                        width: '32px',
                        height: '32px',
                        borderRadius: '8px',
                        backgroundColor: 'rgba(255, 255, 255, 0.18)',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        fontSize: '16px',
                      }}
                    >
                      🇮🇳
                    </div>
                    <div>
                      <div style={{ fontSize: '10px', fontWeight: 800, letterSpacing: '0.06em', color: '#5eead4', textTransform: 'uppercase' }}>
                        {t.govtOfIndia}
                      </div>
                      <div style={{ fontSize: '14px', fontWeight: 900, color: '#ffffff' }}>
                        {t.citizenPass}
                      </div>
                    </div>
                  </div>

                  <div
                    style={{
                      fontSize: '10px',
                      fontWeight: 800,
                      backgroundColor: '#134e4a',
                      color: '#5eead4',
                      padding: '3px 8px',
                      borderRadius: '6px',
                      border: '1px solid #2dd4bf',
                    }}
                  >
                    {t.digilockerVerified}
                  </div>
                </div>

                {/* Body */}
                <div style={{ display: 'flex', gap: '16px', alignItems: 'center', marginBottom: '20px' }}>
                  <div
                    style={{
                      width: '76px',
                      height: '92px',
                      borderRadius: '12px',
                      background: 'linear-gradient(180deg, #14b8a6 0%, #0f766e 100%)',
                      border: '2px solid rgba(255, 255, 255, 0.8)',
                      display: 'flex',
                      flexDirection: 'column',
                      alignItems: 'center',
                      justifyContent: 'center',
                      color: '#ffffff',
                      flexShrink: 0,
                      boxShadow: '0 4px 12px rgba(0,0,0,0.2)',
                    }}
                  >
                    <span style={{ fontSize: '24px', fontWeight: 900 }}>DK</span>
                    <span style={{ fontSize: '9px', fontWeight: 700, backgroundColor: 'rgba(0,0,0,0.3)', padding: '1px 6px', borderRadius: '4px', marginTop: '4px' }}>
                      CITIZEN
                    </span>
                  </div>

                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div style={{ fontSize: '10px', color: '#99f6e4', fontWeight: 600 }}>{t.cardName}</div>
                    <div style={{ fontSize: '16px', fontWeight: 800, color: '#ffffff', lineHeight: 1.2, marginBottom: '8px' }}>
                      {profile.fullName}
                    </div>

                    <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '6px' }}>
                      <div>
                        <div style={{ fontSize: '9.5px', color: '#99f6e4', fontWeight: 600 }}>{t.cardDob}</div>
                        <div style={{ fontSize: '12px', fontWeight: 700, color: '#ffffff' }}>{profile.dob}</div>
                      </div>
                      <div>
                        <div style={{ fontSize: '9.5px', color: '#99f6e4', fontWeight: 600 }}>{t.cardGender}</div>
                        <div style={{ fontSize: '12px', fontWeight: 700, color: '#ffffff' }}>{profile.gender}</div>
                      </div>
                    </div>
                  </div>
                </div>

                {/* Footer */}
                <div
                  style={{
                    backgroundColor: 'rgba(0, 0, 0, 0.25)',
                    borderRadius: '10px',
                    padding: '10px 14px',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'space-between',
                  }}
                >
                  <div>
                    <div style={{ fontSize: '9px', color: '#99f6e4', fontWeight: 700, letterSpacing: '0.05em' }}>
                      {t.cardCitizenId}
                    </div>
                    <div style={{ fontSize: '13.5px', fontWeight: 800, color: '#ffffff', letterSpacing: '0.04em' }}>
                      {profile.citizenId}
                    </div>
                  </div>

                  <div
                    style={{
                      width: '38px',
                      height: '38px',
                      backgroundColor: '#ffffff',
                      borderRadius: '6px',
                      padding: '3px',
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                    }}
                  >
                    <svg width="32" height="32" viewBox="0 0 24 24" fill="#0f172a">
                      <path d="M3 3h6v6H3V3zm2 2v2h2V5H5zm8-2h6v6h-6V3zm2 2v2h2V5h-2zM3 13h6v6H3v-6zm2 2v2h2v-2H5zm13-2h3v2h-3v-2zm-5 0h3v3h-3v-3zm2 3h3v3h-3v-3zm3 0h3v3h-3v-3z" />
                    </svg>
                  </div>
                </div>
              </div>

              {/* Actions & Verification Badges */}
              <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
                <div
                  style={{
                    backgroundColor: '#f8fafc',
                    borderRadius: '16px',
                    border: '1.5px solid #e2e8f0',
                    padding: '18px',
                  }}
                >
                  <h3 style={{ fontSize: '15px', fontWeight: 800, color: '#0f172a', margin: '0 0 12px' }}>
                    {t.trustBadgesTitle}
                  </h3>

                  <div style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '10px', fontSize: '13px' }}>
                      <span style={{ color: '#16a34a', fontWeight: 900 }}>✓</span>
                      <div>
                        <div style={{ fontWeight: 700, color: '#0f172a' }}>{t.trustDigiLocker}</div>
                        <div style={{ fontSize: '11.5px', color: '#64748b' }}>{t.trustDigiLockerDesc}</div>
                      </div>
                    </div>

                    <div style={{ display: 'flex', alignItems: 'center', gap: '10px', fontSize: '13px' }}>
                      <span style={{ color: '#16a34a', fontWeight: 900 }}>✓</span>
                      <div>
                        <div style={{ fontWeight: 700, color: '#0f172a' }}>{t.trustAadhaar}</div>
                        <div style={{ fontSize: '11.5px', color: '#64748b' }}>{t.trustAadhaarDesc}</div>
                      </div>
                    </div>

                    <div style={{ display: 'flex', alignItems: 'center', gap: '10px', fontSize: '13px' }}>
                      <span style={{ color: '#16a34a', fontWeight: 900 }}>✓</span>
                      <div>
                        <div style={{ fontWeight: 700, color: '#0f172a' }}>{t.trustGovt}</div>
                        <div style={{ fontSize: '11.5px', color: '#64748b' }}>{t.trustGovtDesc}</div>
                      </div>
                    </div>
                  </div>
                </div>

                {/* Actions */}
                <div style={{ display: 'flex', gap: '10px' }}>
                  <button
                    onClick={() => handleCopy(profile.citizenId, 'Citizen ID')}
                    className="btn-interactive"
                    style={{
                      flex: 1,
                      height: '42px',
                      borderRadius: '12px',
                      border: '1.5px solid #e2e8f0',
                      backgroundColor: '#ffffff',
                      color: '#0f172a',
                      fontWeight: 700,
                      fontSize: '13px',
                      cursor: 'pointer',
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      gap: '8px',
                    }}
                  >
                    <span>{copiedField ? t.copied : t.copyId}</span>
                  </button>

                  <button
                    onClick={() => showToast('Citizen Card downloaded!')}
                    className="btn-interactive"
                    style={{
                      flex: 1,
                      height: '42px',
                      borderRadius: '12px',
                      border: 'none',
                      backgroundColor: '#0d9488',
                      color: '#ffffff',
                      fontWeight: 700,
                      fontSize: '13px',
                      cursor: 'pointer',
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      gap: '8px',
                      boxShadow: '0 4px 12px rgba(13, 148, 136, 0.25)',
                    }}
                  >
                    <span>{t.downloadPass}</span>
                  </button>
                </div>
              </div>
            </div>
          </div>
        )}

        {/* ========================================================================= */}
        {/* TAB 2: PERSONAL DETAILS */}
        {/* ========================================================================= */}
        {activeTab === 'details' && (
          <div style={{ animation: 'tabSwitchFade 0.2s ease both' }}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '20px' }}>
              <div>
                <h3 style={{ fontSize: '17px', fontWeight: 800, color: '#0f172a', margin: '0 0 4px' }}>
                  {t.personalTitle}
                </h3>
                <p style={{ fontSize: '12.5px', color: '#64748b', margin: 0 }}>
                  {t.personalSubtitle}
                </p>
              </div>

              {!isEditing ? (
                <button
                  onClick={() => setIsEditing(true)}
                  className="btn-interactive"
                  style={{
                    padding: '8px 16px',
                    borderRadius: '10px',
                    border: '1.5px solid #ccfbf1',
                    backgroundColor: '#f0fdfa',
                    color: '#0d9488',
                    fontSize: '12.5px',
                    fontWeight: 700,
                    cursor: 'pointer',
                    display: 'flex',
                    alignItems: 'center',
                    gap: '6px',
                  }}
                >
                  <span>{t.editProfile}</span>
                </button>
              ) : (
                <button
                  onClick={handleCancelEdit}
                  style={{
                    padding: '7px 14px',
                    borderRadius: '8px',
                    border: '1px solid #e2e8f0',
                    backgroundColor: '#ffffff',
                    color: '#64748b',
                    fontSize: '12px',
                    fontWeight: 600,
                    cursor: 'pointer',
                  }}
                >
                  {t.cancel}
                </button>
              )}
            </div>

            <form onSubmit={handleSaveProfile}>
              <div
                style={{
                  display: 'grid',
                  gridTemplateColumns: 'repeat(auto-fit, minmax(260px, 1fr))',
                  gap: '16px',
                  marginBottom: '24px',
                }}
              >
                {/* Name */}
                <div style={{ backgroundColor: '#f8fafc', padding: '14px', borderRadius: '12px', border: '1px solid #e2e8f0' }}>
                  <label style={{ display: 'block', fontSize: '11px', fontWeight: 700, color: '#64748b', marginBottom: '6px' }}>
                    {t.lblFullName}
                  </label>
                  {isEditing ? (
                    <input
                      type="text"
                      value={formData.fullName}
                      onChange={(e) => setFormData({ ...formData, fullName: e.target.value })}
                      style={{ width: '100%', padding: '8px 10px', borderRadius: '8px', border: '1.5px solid #0d9488', fontSize: '13px', fontWeight: 600 }}
                      required
                    />
                  ) : (
                    <div style={{ fontSize: '14px', fontWeight: 800, color: '#0f172a' }}>{profile.fullName}</div>
                  )}
                </div>

                {/* Mobile */}
                <div style={{ backgroundColor: '#f8fafc', padding: '14px', borderRadius: '12px', border: '1px solid #e2e8f0' }}>
                  <label style={{ display: 'block', fontSize: '11px', fontWeight: 700, color: '#64748b', marginBottom: '6px' }}>
                    {t.lblPhone}
                  </label>
                  {isEditing ? (
                    <input
                      type="text"
                      value={formData.phone}
                      onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                      style={{ width: '100%', padding: '8px 10px', borderRadius: '8px', border: '1.5px solid #0d9488', fontSize: '13px', fontWeight: 600 }}
                      required
                    />
                  ) : (
                    <div style={{ fontSize: '14px', fontWeight: 800, color: '#0f172a' }}>{profile.phone}</div>
                  )}
                </div>

                {/* Email */}
                <div style={{ backgroundColor: '#f8fafc', padding: '14px', borderRadius: '12px', border: '1px solid #e2e8f0' }}>
                  <label style={{ display: 'block', fontSize: '11px', fontWeight: 700, color: '#64748b', marginBottom: '6px' }}>
                    {t.lblEmail}
                  </label>
                  {isEditing ? (
                    <input
                      type="email"
                      value={formData.email}
                      onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                      style={{ width: '100%', padding: '8px 10px', borderRadius: '8px', border: '1.5px solid #0d9488', fontSize: '13px', fontWeight: 600 }}
                      required
                    />
                  ) : (
                    <div style={{ fontSize: '14px', fontWeight: 800, color: '#0f172a' }}>{profile.email}</div>
                  )}
                </div>

                {/* DOB & Gender */}
                <div style={{ backgroundColor: '#f8fafc', padding: '14px', borderRadius: '12px', border: '1px solid #e2e8f0' }}>
                  <label style={{ display: 'block', fontSize: '11px', fontWeight: 700, color: '#64748b', marginBottom: '6px' }}>
                    {t.lblDobGender}
                  </label>
                  <div style={{ fontSize: '14px', fontWeight: 800, color: '#0f172a' }}>
                    {profile.dob} • {profile.gender}
                  </div>
                </div>

                {/* Blood Group */}
                <div style={{ backgroundColor: '#f8fafc', padding: '14px', borderRadius: '12px', border: '1px solid #e2e8f0' }}>
                  <label style={{ display: 'block', fontSize: '11px', fontWeight: 700, color: '#64748b', marginBottom: '6px' }}>
                    {t.lblBloodGroup}
                  </label>
                  <div style={{ fontSize: '14px', fontWeight: 800, color: '#0f172a' }}>{profile.bloodGroup}</div>
                </div>

                {/* Father's Name */}
                <div style={{ backgroundColor: '#f8fafc', padding: '14px', borderRadius: '12px', border: '1px solid #e2e8f0' }}>
                  <label style={{ display: 'block', fontSize: '11px', fontWeight: 700, color: '#64748b', marginBottom: '6px' }}>
                    {t.lblFather}
                  </label>
                  <div style={{ fontSize: '14px', fontWeight: 800, color: '#0f172a' }}>{profile.fatherName}</div>
                </div>

                {/* Address */}
                <div style={{ backgroundColor: '#f8fafc', padding: '14px', borderRadius: '12px', border: '1px solid #e2e8f0', gridColumn: '1 / -1' }}>
                  <label style={{ display: 'block', fontSize: '11px', fontWeight: 700, color: '#64748b', marginBottom: '6px' }}>
                    {t.lblAddress}
                  </label>
                  {isEditing ? (
                    <input
                      type="text"
                      value={formData.address}
                      onChange={(e) => setFormData({ ...formData, address: e.target.value })}
                      style={{ width: '100%', padding: '8px 10px', borderRadius: '8px', border: '1.5px solid #0d9488', fontSize: '13px', fontWeight: 600 }}
                    />
                  ) : (
                    <div style={{ fontSize: '14px', fontWeight: 700, color: '#0f172a' }}>
                      {profile.address}, {profile.state} — {profile.pincode}
                    </div>
                  )}
                </div>
              </div>

              {isEditing && (
                <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '10px' }}>
                  <button
                    type="submit"
                    className="btn-interactive"
                    style={{
                      padding: '10px 24px',
                      borderRadius: '10px',
                      border: 'none',
                      backgroundColor: '#0d9488',
                      color: '#ffffff',
                      fontWeight: 700,
                      cursor: 'pointer',
                    }}
                  >
                    {t.saveChanges}
                  </button>
                </div>
              )}
            </form>
          </div>
        )}

        {/* ========================================================================= */}
        {/* TAB 3: LINKED ACCOUNTS */}
        {/* ========================================================================= */}
        {activeTab === 'accounts' && (
          <div style={{ animation: 'tabSwitchFade 0.2s ease both' }}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '18px' }}>
              <div>
                <h3 style={{ fontSize: '17px', fontWeight: 800, color: '#0f172a', margin: '0 0 4px' }}>
                  {t.linkedTitle}
                </h3>
                <p style={{ fontSize: '12.5px', color: '#64748b', margin: 0 }}>
                  {t.linkedSubtitle}
                </p>
              </div>

              <button
                onClick={handleSyncAllAccounts}
                disabled={isSyncingAll}
                className="btn-interactive"
                style={{
                  padding: '7px 14px',
                  borderRadius: '10px',
                  border: '1px solid #ccfbf1',
                  backgroundColor: '#f0fdfa',
                  color: '#0d9488',
                  fontSize: '12px',
                  fontWeight: 700,
                  cursor: isSyncingAll ? 'wait' : 'pointer',
                  display: 'flex',
                  alignItems: 'center',
                  gap: '6px',
                }}
              >
                <span>{isSyncingAll ? t.syncing : t.syncAllPortals}</span>
              </button>
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))', gap: '14px' }}>
              {accounts.map((acc) => (
                <div
                  key={acc.id}
                  style={{
                    backgroundColor: '#ffffff',
                    borderRadius: '16px',
                    border: '1.5px solid #e2e8f0',
                    padding: '16px',
                    display: 'flex',
                    flexDirection: 'column',
                    justifyContent: 'space-between',
                  }}
                >
                  <div style={{ display: 'flex', alignItems: 'flex-start', gap: '12px', marginBottom: '12px' }}>
                    <div
                      style={{
                        width: '40px',
                        height: '40px',
                        borderRadius: '10px',
                        backgroundColor: '#f8fafc',
                        border: '1.5px solid #e2e8f0',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        fontSize: '18px',
                      }}
                    >
                      🏛️
                    </div>

                    <div style={{ flex: 1, minWidth: 0 }}>
                      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                        <h4 style={{ fontSize: '13.5px', fontWeight: 800, color: '#0f172a', margin: 0 }}>
                          {acc.name}
                        </h4>
                        <span style={{ fontSize: '10px', fontWeight: 700, color: '#16a34a', backgroundColor: '#dcfce7', padding: '2px 6px', borderRadius: '4px' }}>
                          {t.lblLinked}
                        </span>
                      </div>
                      <p style={{ fontSize: '11px', color: '#64748b', margin: '2px 0 0' }}>{acc.dept}</p>
                    </div>
                  </div>

                  <div style={{ backgroundColor: '#f8fafc', borderRadius: '10px', padding: '8px 12px', display: 'flex', justifyContent: 'space-between', fontSize: '11.5px' }}>
                    <strong style={{ color: '#0f172a' }}>{acc.identifier}</strong>
                    <span style={{ color: '#0d9488', fontWeight: 700 }}>{acc.lastSynced}</span>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* ========================================================================= */}
        {/* TAB 4: SECURITY */}
        {/* ========================================================================= */}
        {activeTab === 'security' && (
          <div style={{ animation: 'tabSwitchFade 0.2s ease both' }}>
            <div style={{ marginBottom: '20px' }}>
              <h3 style={{ fontSize: '17px', fontWeight: 800, color: '#0f172a', margin: '0 0 4px' }}>
                {t.securityTitle}
              </h3>
              <p style={{ fontSize: '12.5px', color: '#64748b', margin: 0 }}>
                {t.securitySubtitle}
              </p>
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', gap: '16px', marginBottom: '24px' }}>
              <div style={{ backgroundColor: '#f8fafc', padding: '16px', borderRadius: '14px', border: '1.5px solid #e2e8f0', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                <div>
                  <div style={{ fontSize: '13.5px', fontWeight: 800, color: '#0f172a' }}>{t.twoFactorTitle}</div>
                  <div style={{ fontSize: '11.5px', color: '#64748b', marginTop: '2px' }}>{t.twoFactorDesc}</div>
                </div>
                <button
                  onClick={() => setTwoFactorEnabled(!twoFactorEnabled)}
                  style={{ width: '46px', height: '26px', borderRadius: '13px', backgroundColor: twoFactorEnabled ? '#0d9488' : '#cbd5e1', border: 'none', position: 'relative', cursor: 'pointer' }}
                >
                  <span style={{ position: 'absolute', top: '3px', left: twoFactorEnabled ? '23px' : '3px', width: '20px', height: '20px', borderRadius: '50%', backgroundColor: '#ffffff' }} />
                </button>
              </div>

              <div style={{ backgroundColor: '#f8fafc', padding: '16px', borderRadius: '14px', border: '1.5px solid #e2e8f0', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                <div>
                  <div style={{ fontSize: '13.5px', fontWeight: 800, color: '#0f172a' }}>{t.bioLockTitle}</div>
                  <div style={{ fontSize: '11.5px', color: '#64748b', marginTop: '2px' }}>{t.bioLockDesc}</div>
                </div>
                <button
                  onClick={() => setBiometricLockEnabled(!biometricLockEnabled)}
                  style={{ width: '46px', height: '26px', borderRadius: '13px', backgroundColor: biometricLockEnabled ? '#0d9488' : '#cbd5e1', border: 'none', position: 'relative', cursor: 'pointer' }}
                >
                  <span style={{ position: 'absolute', top: '3px', left: biometricLockEnabled ? '23px' : '3px', width: '20px', height: '20px', borderRadius: '50%', backgroundColor: '#ffffff' }} />
                </button>
              </div>
            </div>

            <div>
              <h4 style={{ fontSize: '14px', fontWeight: 800, color: '#0f172a', margin: '0 0 12px' }}>
                {t.consentTitle}
              </h4>
              <div style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
                {consentLogs.map((log) => (
                  <div key={log.id} style={{ backgroundColor: '#ffffff', borderRadius: '14px', border: '1px solid #e2e8f0', padding: '14px 16px', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                    <div>
                      <div style={{ fontSize: '13px', fontWeight: 800, color: '#0f172a' }}>{log.portal}</div>
                      <div style={{ fontSize: '11.5px', color: '#64748b' }}>{log.purpose}</div>
                    </div>
                    {log.status === 'active' && (
                      <button
                        onClick={() => handleRevokeConsent(log.id)}
                        style={{ padding: '6px 12px', borderRadius: '8px', border: '1px solid #fecdd3', backgroundColor: '#fff1f2', color: '#e11d48', fontSize: '11.5px', fontWeight: 700, cursor: 'pointer' }}
                      >
                        {t.revokeAccess}
                      </button>
                    )}
                  </div>
                ))}
              </div>
            </div>
          </div>
        )}

        {/* ========================================================================= */}
        {/* TAB 5: PREFERENCES */}
        {/* ========================================================================= */}
        {activeTab === 'preferences' && (
          <div style={{ animation: 'tabSwitchFade 0.2s ease both' }}>
            <div style={{ marginBottom: '20px' }}>
              <h3 style={{ fontSize: '17px', fontWeight: 800, color: '#0f172a', margin: '0 0 4px' }}>
                {t.preferencesTitle}
              </h3>
              <p style={{ fontSize: '12.5px', color: '#64748b', margin: 0 }}>
                {t.preferencesSubtitle}
              </p>
            </div>

            <div style={{ display: 'flex', flexDirection: 'column', gap: '16px', maxWidth: '600px' }}>
              {/* Language Selection */}
              <div style={{ backgroundColor: '#f8fafc', padding: '16px', borderRadius: '14px', border: '1px solid #e2e8f0' }}>
                <label style={{ display: 'block', fontSize: '12.5px', fontWeight: 800, color: '#0f172a', marginBottom: '8px' }}>
                  {t.portalLanguage}
                </label>
                <div style={{ display: 'flex', gap: '10px' }}>
                  {[
                    { code: 'en', label: 'English (Default)' },
                    { code: 'hi', label: 'हिंदी (Hindi)' },
                    { code: 'pa', label: 'ਪੰਜਾਬੀ (Punjabi)' },
                  ].map((item) => (
                    <button
                      key={item.code}
                      type="button"
                      onClick={() => onLanguageChange?.(item.code as Language)}
                      className="btn-interactive"
                      style={{
                        flex: 1,
                        padding: '10px',
                        borderRadius: '10px',
                        border: language === item.code ? '2px solid #0d9488' : '1px solid #e2e8f0',
                        backgroundColor: language === item.code ? '#f0fdfa' : '#ffffff',
                        color: language === item.code ? '#0d9488' : '#334155',
                        fontWeight: language === item.code ? 800 : 600,
                        fontSize: '12.5px',
                        cursor: 'pointer',
                      }}
                    >
                      {item.label}
                    </button>
                  ))}
                </div>
              </div>

              {/* Notifications */}
              <div style={{ backgroundColor: '#f8fafc', padding: '16px', borderRadius: '14px', border: '1px solid #e2e8f0' }}>
                <div style={{ fontSize: '12.5px', fontWeight: 800, color: '#0f172a', marginBottom: '12px' }}>
                  {t.alertsTitle}
                </div>
                <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
                  <label style={{ display: 'flex', alignItems: 'center', gap: '10px', fontSize: '13px', cursor: 'pointer' }}>
                    <input
                      type="checkbox"
                      checked={whatsappAlerts}
                      onChange={(e) => setWhatsappAlerts(e.target.checked)}
                      style={{ accentColor: '#0d9488', width: '16px', height: '16px' }}
                    />
                    <span style={{ fontWeight: 600, color: '#0f172a' }}>{t.whatsappAlerts}</span>
                  </label>

                  <label style={{ display: 'flex', alignItems: 'center', gap: '10px', fontSize: '13px', cursor: 'pointer' }}>
                    <input
                      type="checkbox"
                      checked={smsAlerts}
                      onChange={(e) => setSmsAlerts(e.target.checked)}
                      style={{ accentColor: '#0d9488', width: '16px', height: '16px' }}
                    />
                    <span style={{ fontWeight: 600, color: '#0f172a' }}>{t.smsAlerts}</span>
                  </label>
                </div>
              </div>

              {/* Data Export */}
              <div style={{ backgroundColor: '#f8fafc', padding: '16px', borderRadius: '14px', border: '1px solid #e2e8f0' }}>
                <div style={{ fontSize: '12.5px', fontWeight: 800, color: '#0f172a', marginBottom: '4px' }}>
                  {t.dataPortability}
                </div>
                <div style={{ fontSize: '11.5px', color: '#64748b', marginBottom: '12px' }}>
                  {t.dataPortabilityDesc}
                </div>
                <button
                  onClick={() => showToast('Citizen data archive exported!')}
                  className="btn-interactive"
                  style={{
                    padding: '8px 16px',
                    borderRadius: '10px',
                    border: '1px solid #e2e8f0',
                    backgroundColor: '#ffffff',
                    color: '#0f172a',
                    fontSize: '12.5px',
                    fontWeight: 700,
                    cursor: 'pointer',
                  }}
                >
                  {t.exportData}
                </button>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
