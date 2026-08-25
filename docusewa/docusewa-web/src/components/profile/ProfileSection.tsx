'use client';

import React, { useState, useRef, useEffect } from 'react';
import { signOut } from '@/services/auth.service';
import { useRouter } from 'next/navigation';
import { Language, translations } from '@/lib/translations';
import PhotoCropModal from './PhotoCropModal';

const DEFAULT_AVATAR = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80';

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
  photoUrl?: string;
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
  kycLevel: 'Tier 3 (DigiLocker + Biometric)',
  joinedDate: 'January 2024',
  photoUrl: DEFAULT_AVATAR,
};

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
  const fileInputRef = useRef<HTMLInputElement | null>(null);

  // 2 Clean Tabs without icons: 'details' (Personal & KYC), 'settings' (Settings)
  const [activeTab, setActiveTab] = useState<'details' | 'settings'>('details');
  const [profile, setProfile] = useState<ProfileData>(INITIAL_PROFILE);
  const [isEditing, setIsEditing] = useState<boolean>(false);
  const [formData, setFormData] = useState<ProfileData>(INITIAL_PROFILE);
  const [toastMessage, setToastMessage] = useState<string | null>(null);
  const [copiedField, setCopiedField] = useState<string | null>(null);
  const [twoFactorEnabled, setTwoFactorEnabled] = useState<boolean>(true);
  const [biometricLockEnabled, setBiometricLockEnabled] = useState<boolean>(true);
  const [whatsappAlerts, setWhatsappAlerts] = useState<boolean>(true);
  const [smsAlerts, setSmsAlerts] = useState<boolean>(true);
  const [showQrModal, setShowQrModal] = useState<boolean>(false);
  const [isUploadingPhoto, setIsUploadingPhoto] = useState<boolean>(false);
  const [isCropModalOpen, setIsCropModalOpen] = useState<boolean>(false);
  const [rawCropImage, setRawCropImage] = useState<string | null>(null);

  // Load saved profile data and avatar from localStorage if available
  useEffect(() => {
    try {
      const savedAvatar = localStorage.getItem('janseva_citizen_avatar');
      const savedProfileStr = localStorage.getItem('janseva_citizen_profile');
      let mergedProfile = { ...INITIAL_PROFILE };

      if (savedProfileStr) {
        const parsed = JSON.parse(savedProfileStr);
        mergedProfile = { ...mergedProfile, ...parsed };
      }

      if (savedAvatar) {
        mergedProfile.photoUrl = savedAvatar;
      }

      setProfile(mergedProfile);
      setFormData(mergedProfile);
    } catch {
      // Fallback gracefully to default
    }
  }, []);

  const showToast = (msg: string) => {
    setToastMessage(msg);
    setTimeout(() => {
      setToastMessage(null);
    }, 2800);
  };

  const handleCopy = (text: string, label: string) => {
    navigator.clipboard.writeText(text);
    setCopiedField(label);
    showToast(`${label} copied to clipboard!`);
    setTimeout(() => setCopiedField(null), 2000);
  };

  const handlePhotoFile = (file: File) => {
    if (!file.type.startsWith('image/')) {
      showToast(t.photoFormatError);
      return;
    }

    // 5MB Limit
    if (file.size > 5 * 1024 * 1024) {
      showToast(t.photoSizeLimitError);
      return;
    }

    setIsUploadingPhoto(true);
    const reader = new FileReader();
    reader.onload = (event) => {
      const base64 = event.target?.result as string;
      if (base64) {
        setRawCropImage(base64);
        setIsCropModalOpen(true);
      }
      setIsUploadingPhoto(false);
    };

    reader.onerror = () => {
      setIsUploadingPhoto(false);
      showToast('Error reading image file.');
    };

    reader.readAsDataURL(file);
  };

  const handleApplyCroppedPhoto = (croppedBase64: string) => {
    const updated = { ...profile, photoUrl: croppedBase64 };
    setProfile(updated);
    setFormData((prev) => ({ ...prev, photoUrl: croppedBase64 }));
    try {
      localStorage.setItem('janseva_citizen_avatar', croppedBase64);
      localStorage.setItem('janseva_citizen_profile', JSON.stringify(updated));
      window.dispatchEvent(
        new CustomEvent('janseva_avatar_updated', {
          detail: { avatarUrl: croppedBase64, fullName: updated.fullName },
        })
      );
    } catch {
      // localStorage full or restricted
    }
    showToast(t.photoUpdated);
  };

  const handlePhotoInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = e.target.files;
    if (files && files.length > 0) {
      handlePhotoFile(files[0]);
    }
    // Reset value so user can re-upload the same file if desired
    if (e.target) e.target.value = '';
  };

  const handleRemovePhoto = () => {
    const updated = { ...profile, photoUrl: DEFAULT_AVATAR };
    setProfile(updated);
    setFormData((prev) => ({ ...prev, photoUrl: DEFAULT_AVATAR }));
    try {
      localStorage.removeItem('janseva_citizen_avatar');
      localStorage.setItem('janseva_citizen_profile', JSON.stringify(updated));
      window.dispatchEvent(
        new CustomEvent('janseva_avatar_updated', {
          detail: { avatarUrl: DEFAULT_AVATAR, fullName: updated.fullName },
        })
      );
    } catch {
      // Ignore
    }
    showToast(t.photoRemoved);
  };

  const handleSaveProfile = (e: React.FormEvent) => {
    e.preventDefault();
    setProfile(formData);
    try {
      localStorage.setItem('janseva_citizen_profile', JSON.stringify(formData));
      if (formData.photoUrl) {
        localStorage.setItem('janseva_citizen_avatar', formData.photoUrl);
        window.dispatchEvent(
          new CustomEvent('janseva_avatar_updated', {
            detail: { avatarUrl: formData.photoUrl, fullName: formData.fullName },
          })
        );
      }
    } catch {
      // Ignore
    }
    setIsEditing(false);
    showToast('Citizen profile updated successfully! ✓');
  };

  const handleCancelEdit = () => {
    setFormData(profile);
    setIsEditing(false);
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
        boxShadow: '0 10px 30px rgba(15, 23, 42, 0.05)',
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
            zIndex: 99999,
            backgroundColor: '#0f172a',
            color: '#ffffff',
            padding: '12px 20px',
            borderRadius: '14px',
            boxShadow: '0 12px 30px rgba(0, 0, 0, 0.28)',
            display: 'flex',
            alignItems: 'center',
            gap: '10px',
            fontSize: '13px',
            fontWeight: 700,
            border: '1px solid #334155',
            animation: 'fadeInScale 0.2s ease both',
          }}
        >
          <span style={{ color: '#10b981', fontSize: '15px' }}>✓</span>
          <span>{toastMessage}</span>
        </div>
      )}

      {/* Photo Crop Modal */}
      <PhotoCropModal
        isOpen={isCropModalOpen}
        imageSrc={rawCropImage}
        onClose={() => setIsCropModalOpen(false)}
        onApplyCrop={handleApplyCroppedPhoto}
      />

      {/* QR Code Pass Modal */}
      {showQrModal && (
        <div
          style={{
            position: 'fixed',
            inset: 0,
            backgroundColor: 'rgba(15, 23, 42, 0.65)',
            backdropFilter: 'blur(8px)',
            WebkitBackdropFilter: 'blur(8px)',
            zIndex: 99999,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            padding: '16px',
          }}
          onClick={() => setShowQrModal(false)}
        >
          <div
            onClick={(e) => e.stopPropagation()}
            style={{
              backgroundColor: '#ffffff',
              borderRadius: '24px',
              padding: '28px',
              maxWidth: '360px',
              width: '100%',
              textAlign: 'center',
              boxShadow: '0 20px 40px rgba(0,0,0,0.25)',
              border: '1px solid #e2e8f0',
              animation: 'modalSmoothIn 0.25s cubic-bezier(0.16, 1, 0.3, 1) both',
            }}
          >
            <div style={{ fontSize: '28px', marginBottom: '8px' }}>🇮🇳</div>
            <h3 style={{ fontSize: '18px', fontWeight: 800, color: '#0f172a', margin: '0 0 4px' }}>
              Citizen Digital Pass QR
            </h3>
            <p style={{ fontSize: '12px', color: '#64748b', margin: '0 0 18px' }}>
              Scan at authorized Govt Touchpoints & DigiYatra
            </p>

            <div
              style={{
                backgroundColor: '#f8fafc',
                padding: '20px',
                borderRadius: '16px',
                border: '1.5px dashed #cbd5e1',
                display: 'inline-flex',
                alignItems: 'center',
                justifyContent: 'center',
                marginBottom: '16px',
              }}
            >
              <svg width="180" height="180" viewBox="0 0 24 24" fill="#0f172a">
                <path d="M3 3h6v6H3V3zm2 2v2h2V5H5zm8-2h6v6h-6V3zm2 2v2h2V5h-2zM3 13h6v6H3v-6zm2 2v2h2v-2H5zm13-2h3v2h-3v-2zm-5 0h3v3h-3v-3zm2 3h3v3h-3v-3zm3 0h3v3h-3v-3z" />
              </svg>
            </div>

            <div style={{ fontSize: '13.5px', fontWeight: 800, color: '#0d9488', letterSpacing: '0.04em', marginBottom: '20px' }}>
              {profile.citizenId}
            </div>

            <button
              onClick={() => setShowQrModal(false)}
              className="btn-interactive"
              style={{
                width: '100%',
                padding: '12px',
                borderRadius: '12px',
                border: 'none',
                backgroundColor: '#0f172a',
                color: '#ffffff',
                fontWeight: 700,
                fontSize: '13px',
                cursor: 'pointer',
              }}
            >
              {t.close}
            </button>
          </div>
        </div>
      )}

      {/* ========================================================================= */}
      {/* 1. HERO HEADER: CLEAN & PROFESSIONAL CITIZEN CARD */}
      {/* ========================================================================= */}
      <div
        style={{
          backgroundColor: '#ffffff',
          color: '#0f172a',
          padding: isModalMode ? '20px 18px 16px' : '24px 24px 18px',
          position: 'relative',
          borderBottom: '1px solid #e2e8f0',
        }}
      >
        {/* Modal Close Button */}
        {isModalMode && onClose && (
          <button
            onClick={onClose}
            aria-label="Close"
            style={{
              position: 'absolute',
              top: '16px',
              right: '16px',
              width: '32px',
              height: '32px',
              borderRadius: '50%',
              backgroundColor: '#f1f5f9',
              border: '1px solid #e2e8f0',
              color: '#475569',
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
        )}

        {/* Identity & Header Row */}
        <div
          style={{
            display: 'flex',
            flexWrap: 'wrap',
            alignItems: 'center',
            justifyContent: 'space-between',
            gap: '16px',
          }}
        >
          {/* Avatar + Main Citizen Identity */}
          <div style={{ display: 'flex', alignItems: 'center', gap: '16px', minWidth: 0 }}>
            <input
              type="file"
              ref={fileInputRef}
              accept="image/png, image/jpeg, image/jpg, image/webp"
              onChange={handlePhotoInputChange}
              style={{ display: 'none' }}
              aria-label="Upload citizen profile photo"
            />
            <div
              onClick={() => fileInputRef.current?.click()}
              title={t.photoUploadPrompt}
              className="btn-interactive"
              style={{
                position: 'relative',
                width: '68px',
                height: '68px',
                borderRadius: '50%',
                border: '2.5px solid #0d9488',
                boxShadow: '0 4px 14px rgba(13, 148, 136, 0.2)',
                flexShrink: 0,
                cursor: 'pointer',
              }}
            >
              <img
                src={profile.photoUrl || DEFAULT_AVATAR}
                alt={profile.fullName}
                style={{ width: '100%', height: '100%', borderRadius: '50%', objectFit: 'cover' }}
              />

              {/* Camera Icon Overlay Badge */}
              <div
                title={t.changePhoto}
                style={{
                  position: 'absolute',
                  bottom: '-2px',
                  right: '-2px',
                  backgroundColor: '#0d9488',
                  color: '#ffffff',
                  width: '24px',
                  height: '24px',
                  borderRadius: '50%',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  border: '2px solid #ffffff',
                  boxShadow: '0 2px 6px rgba(0,0,0,0.2)',
                  transition: 'transform 0.2s ease',
                }}
              >
                {isUploadingPhoto ? (
                  <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3" className="animate-spin">
                    <path d="M12 2v4M12 18v4M4.93 4.93l2.83 2.83M16.24 16.24l2.83 2.83M2 12h4M18 12h4M4.93 19.07l2.83-2.83M16.24 7.76l2.83-2.83" />
                  </svg>
                ) : (
                  <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
                    <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z" />
                    <circle cx="12" cy="13" r="4" />
                  </svg>
                )}
              </div>
            </div>

            <div style={{ minWidth: 0 }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: '8px', flexWrap: 'wrap' }}>
                <h1
                  style={{
                    fontSize: isModalMode ? '19px' : '21px',
                    fontWeight: 800,
                    margin: 0,
                    letterSpacing: '-0.02em',
                    lineHeight: 1.2,
                    color: '#0f172a',
                  }}
                >
                  {profile.fullName}
                </h1>
                <span
                  style={{
                    fontSize: '11px',
                    fontWeight: 700,
                    backgroundColor: '#f1f5f9',
                    color: '#0d9488',
                    padding: '2px 8px',
                    borderRadius: '6px',
                    border: '1px solid #e2e8f0',
                    display: 'inline-flex',
                    alignItems: 'center',
                    gap: '4px',
                  }}
                >
                  <span>🇮🇳</span>
                  <span>{t.citizenOfIndia}</span>
                </span>
              </div>

              {/* Location, Citizen ID & Photo Actions */}
              <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginTop: '6px', flexWrap: 'wrap' }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: '4px', fontSize: '12px', color: '#64748b', fontWeight: 500 }}>
                  <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="#0d9488" strokeWidth="2.5">
                    <path d="M12 2a8 8 0 0 0-8 8c0 5.25 8 12 8 12s8-6.75 8-12a8 8 0 0 0-8-8z" />
                    <circle cx="12" cy="10" r="3" />
                  </svg>
                  <span>{profile.address}, {profile.state}</span>
                </div>

                <button
                  onClick={() => handleCopy(profile.citizenId, 'Citizen ID')}
                  title="Click to copy Citizen ID"
                  className="btn-interactive"
                  style={{
                    display: 'inline-flex',
                    alignItems: 'center',
                    gap: '5px',
                    backgroundColor: '#f8fafc',
                    border: '1px solid #cbd5e1',
                    borderRadius: '6px',
                    padding: '2px 8px',
                    color: '#0f172a',
                    fontSize: '11px',
                    fontWeight: 700,
                    cursor: 'pointer',
                  }}
                >
                  <span>ID: {profile.citizenId}</span>
                  <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#64748b" strokeWidth="2.5">
                    <rect x="9" y="9" width="13" height="13" rx="2" ry="2" />
                    <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1" />
                  </svg>
                </button>

                {/* Change Photo Button */}
                <button
                  onClick={() => fileInputRef.current?.click()}
                  title={t.uploadPhoto}
                  className="btn-interactive"
                  style={{
                    display: 'inline-flex',
                    alignItems: 'center',
                    gap: '4px',
                    backgroundColor: '#f0fdfa',
                    border: '1px solid #ccfbf1',
                    borderRadius: '6px',
                    padding: '2px 8px',
                    color: '#0d9488',
                    fontSize: '11px',
                    fontWeight: 700,
                    cursor: 'pointer',
                  }}
                >
                  <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
                    <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z" />
                    <circle cx="12" cy="13" r="4" />
                  </svg>
                  <span>{t.changePhoto}</span>
                </button>

                {/* Remove Photo if customized */}
                {profile.photoUrl && profile.photoUrl !== DEFAULT_AVATAR && (
                  <button
                    onClick={handleRemovePhoto}
                    title={t.removePhoto}
                    className="btn-interactive"
                    style={{
                      display: 'inline-flex',
                      alignItems: 'center',
                      gap: '4px',
                      backgroundColor: '#fff1f2',
                      border: '1px solid #fecdd3',
                      borderRadius: '6px',
                      padding: '2px 8px',
                      color: '#e11d48',
                      fontSize: '11px',
                      fontWeight: 700,
                      cursor: 'pointer',
                    }}
                  >
                    <span>×</span>
                    <span>{t.removePhoto}</span>
                  </button>
                )}
              </div>
            </div>
          </div>
        </div>

        {/* 3 Clean Status Chips */}
        <div
          style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(3, 1fr)',
            gap: '8px',
            marginTop: '16px',
            paddingTop: '12px',
            borderTop: '1px solid #f1f5f9',
          }}
        >
          <div
            style={{
              backgroundColor: '#f8fafc',
              padding: '8px 12px',
              borderRadius: '10px',
              border: '1px solid #e2e8f0',
            }}
          >
            <div style={{ fontSize: '9.5px', color: '#64748b', fontWeight: 700, letterSpacing: '0.3px' }}>KYC STATUS</div>
            <div style={{ fontSize: '12.5px', fontWeight: 800, color: '#0d9488' }}>Tier 3 Verified</div>
          </div>

          <div
            style={{
              backgroundColor: '#f8fafc',
              padding: '8px 12px',
              borderRadius: '10px',
              border: '1px solid #e2e8f0',
            }}
          >
            <div style={{ fontSize: '9.5px', color: '#64748b', fontWeight: 700, letterSpacing: '0.3px' }}>DIGILOCKER</div>
            <div style={{ fontSize: '12.5px', fontWeight: 800, color: '#10b981' }}>● Linked Active</div>
          </div>

          <div
            onClick={onNavigateToVault}
            style={{
              backgroundColor: '#f8fafc',
              padding: '8px 12px',
              borderRadius: '10px',
              border: '1px solid #e2e8f0',
              cursor: onNavigateToVault ? 'pointer' : 'default',
            }}
          >
            <div style={{ fontSize: '9.5px', color: '#64748b', fontWeight: 700, letterSpacing: '0.3px' }}>VAULT DOCS</div>
            <div style={{ fontSize: '12.5px', fontWeight: 800, color: '#0f172a' }}>{vaultCount} Certs →</div>
          </div>
        </div>
      </div>

      {/* ========================================================================= */}
      {/* 2. SEGMENTED TABS (2 CLEAN TABS: PERSONAL & KYC, SETTINGS) */}
      {/* ========================================================================= */}
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          gap: '6px',
          padding: '8px 16px',
          borderBottom: '1px solid #e2e8f0',
          backgroundColor: '#f8fafc',
        }}
      >
        {[
          { id: 'details', label: t.tabPersonalKYC },
          { id: 'settings', label: t.tabPreferences },
        ].map((tab) => {
          const isActive = activeTab === tab.id;
          return (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id as any)}
              className="btn-interactive"
              style={{
                flex: 1,
                padding: '9px 12px',
                borderRadius: '10px',
                border: '1px solid',
                borderColor: isActive ? '#0d9488' : '#e2e8f0',
                backgroundColor: isActive ? '#0d9488' : '#ffffff',
                color: isActive ? '#ffffff' : '#475569',
                fontSize: '12.5px',
                fontWeight: isActive ? 800 : 600,
                cursor: 'pointer',
                textAlign: 'center',
                boxShadow: isActive ? '0 2px 8px rgba(13, 148, 136, 0.2)' : 'none',
                transition: 'all 0.2s ease',
                whiteSpace: 'nowrap',
              }}
            >
              {tab.label}
            </button>
          );
        })}
      </div>

      {/* ========================================================================= */}
      {/* 3. TAB CONTENT */}
      {/* ========================================================================= */}
      <div style={{ padding: isModalMode ? '16px' : '22px', backgroundColor: '#ffffff' }}>
        {/* ======================================================================= */}
        {/* TAB 1: PERSONAL & KYC INFORMATION */}
        {/* ======================================================================= */}
        {activeTab === 'details' && (
          <div style={{ animation: 'tabSwitchFade 0.2s ease both' }}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '14px' }}>
              <div>
                <h3 style={{ fontSize: '15px', fontWeight: 800, color: '#0f172a', margin: '0 0 2px' }}>
                  {t.personalTitle}
                </h3>
                <p style={{ fontSize: '11.5px', color: '#64748b', margin: 0 }}>
                  {t.personalSubtitle}
                </p>
              </div>

              {!isEditing ? (
                <button
                  onClick={() => setIsEditing(true)}
                  className="btn-interactive"
                  style={{
                    padding: '6px 12px',
                    borderRadius: '8px',
                    border: '1.5px solid #ccfbf1',
                    backgroundColor: '#f0fdfa',
                    color: '#0d9488',
                    fontSize: '11.5px',
                    fontWeight: 700,
                    cursor: 'pointer',
                    display: 'flex',
                    alignItems: 'center',
                    gap: '4px',
                  }}
                >
                  <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
                    <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                    <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                  </svg>
                  <span>{t.editProfile}</span>
                </button>
              ) : (
                <button
                  onClick={handleCancelEdit}
                  style={{
                    padding: '6px 12px',
                    borderRadius: '8px',
                    border: '1px solid #e2e8f0',
                    backgroundColor: '#ffffff',
                    color: '#64748b',
                    fontSize: '11.5px',
                    fontWeight: 700,
                    cursor: 'pointer',
                  }}
                >
                  {t.cancel}
                </button>
              )}
            </div>

            {isEditing ? (
              <form onSubmit={handleSaveProfile}>
                {/* Photo Upload & Preview Card in Edit Form */}
                <div
                  style={{
                    backgroundColor: '#f8fafc',
                    padding: '16px',
                    borderRadius: '14px',
                    border: '1.5px dashed #cbd5e1',
                    marginBottom: '16px',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'space-between',
                    gap: '16px',
                    flexWrap: 'wrap',
                  }}
                >
                  <div style={{ display: 'flex', alignItems: 'center', gap: '14px' }}>
                    <div
                      style={{
                        position: 'relative',
                        width: '56px',
                        height: '56px',
                        borderRadius: '50%',
                        border: '2px solid #0d9488',
                        overflow: 'hidden',
                        flexShrink: 0,
                        backgroundColor: '#ffffff',
                      }}
                    >
                      <img
                        src={formData.photoUrl || DEFAULT_AVATAR}
                        alt="Profile Preview"
                        style={{ width: '100%', height: '100%', objectFit: 'cover' }}
                      />
                    </div>
                    <div>
                      <div style={{ fontSize: '13px', fontWeight: 800, color: '#0f172a' }}>
                        {t.uploadPhoto}
                      </div>
                      <div style={{ fontSize: '11px', color: '#64748b', marginTop: '2px' }}>
                        PNG, JPG, WEBP • Max 5MB
                      </div>
                    </div>
                  </div>

                  <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                    <button
                      type="button"
                      onClick={() => fileInputRef.current?.click()}
                      className="btn-interactive"
                      style={{
                        padding: '7px 14px',
                        borderRadius: '8px',
                        border: '1px solid #0d9488',
                        backgroundColor: '#0d9488',
                        color: '#ffffff',
                        fontSize: '12px',
                        fontWeight: 700,
                        cursor: 'pointer',
                        display: 'inline-flex',
                        alignItems: 'center',
                        gap: '6px',
                      }}
                    >
                      <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
                        <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z" />
                        <circle cx="12" cy="13" r="4" />
                      </svg>
                      <span>{t.changePhoto}</span>
                    </button>

                    {formData.photoUrl && formData.photoUrl !== DEFAULT_AVATAR && (
                      <button
                        type="button"
                        onClick={handleRemovePhoto}
                        className="btn-interactive"
                        style={{
                          padding: '7px 12px',
                          borderRadius: '8px',
                          border: '1px solid #fecdd3',
                          backgroundColor: '#fff1f2',
                          color: '#e11d48',
                          fontSize: '12px',
                          fontWeight: 700,
                          cursor: 'pointer',
                        }}
                      >
                        {t.removePhoto}
                      </button>
                    )}
                  </div>
                </div>

                <div
                  style={{
                    display: 'grid',
                    gridTemplateColumns: 'repeat(auto-fit, minmax(240px, 1fr))',
                    gap: '12px',
                    marginBottom: '18px',
                  }}
                >
                  <div style={{ backgroundColor: '#f8fafc', padding: '12px', borderRadius: '12px', border: '1px solid #e2e8f0' }}>
                    <label style={{ display: 'block', fontSize: '11px', fontWeight: 700, color: '#64748b', marginBottom: '4px' }}>
                      {t.lblFullName}
                    </label>
                    <input
                      type="text"
                      value={formData.fullName}
                      onChange={(e) => setFormData({ ...formData, fullName: e.target.value })}
                      style={{ width: '100%', padding: '7px 10px', borderRadius: '8px', border: '1.5px solid #0d9488', fontSize: '13px', fontWeight: 600 }}
                      required
                    />
                  </div>

                  <div style={{ backgroundColor: '#f8fafc', padding: '12px', borderRadius: '12px', border: '1px solid #e2e8f0' }}>
                    <label style={{ display: 'block', fontSize: '11px', fontWeight: 700, color: '#64748b', marginBottom: '4px' }}>
                      {t.lblPhone}
                    </label>
                    <input
                      type="text"
                      value={formData.phone}
                      onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                      style={{ width: '100%', padding: '7px 10px', borderRadius: '8px', border: '1.5px solid #0d9488', fontSize: '13px', fontWeight: 600 }}
                      required
                    />
                  </div>

                  <div style={{ backgroundColor: '#f8fafc', padding: '12px', borderRadius: '12px', border: '1px solid #e2e8f0' }}>
                    <label style={{ display: 'block', fontSize: '11px', fontWeight: 700, color: '#64748b', marginBottom: '4px' }}>
                      {t.lblEmail}
                    </label>
                    <input
                      type="email"
                      value={formData.email}
                      onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                      style={{ width: '100%', padding: '7px 10px', borderRadius: '8px', border: '1.5px solid #0d9488', fontSize: '13px', fontWeight: 600 }}
                      required
                    />
                  </div>

                  <div style={{ backgroundColor: '#f8fafc', padding: '12px', borderRadius: '12px', border: '1px solid #e2e8f0' }}>
                    <label style={{ display: 'block', fontSize: '11px', fontWeight: 700, color: '#64748b', marginBottom: '4px' }}>
                      {t.lblFather}
                    </label>
                    <input
                      type="text"
                      value={formData.fatherName}
                      onChange={(e) => setFormData({ ...formData, fatherName: e.target.value })}
                      style={{ width: '100%', padding: '7px 10px', borderRadius: '8px', border: '1.5px solid #0d9488', fontSize: '13px', fontWeight: 600 }}
                    />
                  </div>

                  <div style={{ backgroundColor: '#f8fafc', padding: '12px', borderRadius: '12px', border: '1px solid #e2e8f0', gridColumn: '1 / -1' }}>
                    <label style={{ display: 'block', fontSize: '11px', fontWeight: 700, color: '#64748b', marginBottom: '4px' }}>
                      {t.lblAddress}
                    </label>
                    <input
                      type="text"
                      value={formData.address}
                      onChange={(e) => setFormData({ ...formData, address: e.target.value })}
                      style={{ width: '100%', padding: '7px 10px', borderRadius: '8px', border: '1.5px solid #0d9488', fontSize: '13px', fontWeight: 600 }}
                    />
                  </div>
                </div>

                <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '8px' }}>
                  <button
                    type="submit"
                    className="btn-interactive"
                    style={{
                      padding: '8px 20px',
                      borderRadius: '10px',
                      border: 'none',
                      backgroundColor: '#0d9488',
                      color: '#ffffff',
                      fontWeight: 700,
                      fontSize: '12.5px',
                      cursor: 'pointer',
                    }}
                  >
                    {t.saveChanges}
                  </button>
                </div>
              </form>
            ) : (
              <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
                {/* 1. Official Government Credentials */}
                <div
                  style={{
                    backgroundColor: '#f8fafc',
                    borderRadius: '14px',
                    border: '1px solid #e2e8f0',
                    padding: '14px',
                  }}
                >
                  <div style={{ fontSize: '11px', fontWeight: 800, color: '#0d9488', letterSpacing: '0.05em', textTransform: 'uppercase', marginBottom: '10px' }}>
                    Official Government Credentials
                  </div>

                  <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))', gap: '10px' }}>
                    <div style={{ backgroundColor: '#ffffff', padding: '8px 12px', borderRadius: '10px', border: '1px solid #e2e8f0' }}>
                      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                        <span style={{ fontSize: '10.5px', color: '#64748b', fontWeight: 600 }}>Aadhaar</span>
                        <span style={{ fontSize: '9.5px', color: '#16a34a', fontWeight: 700, backgroundColor: '#dcfce7', padding: '1px 5px', borderRadius: '4px' }}>Verified</span>
                      </div>
                      <div style={{ fontSize: '13px', fontWeight: 800, color: '#0f172a', marginTop: '2px' }}>•••• {profile.aadhaarLast4}</div>
                    </div>

                    <div style={{ backgroundColor: '#ffffff', padding: '8px 12px', borderRadius: '10px', border: '1px solid #e2e8f0' }}>
                      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                        <span style={{ fontSize: '10.5px', color: '#64748b', fontWeight: 600 }}>PAN Number</span>
                        <span style={{ fontSize: '9.5px', color: '#16a34a', fontWeight: 700, backgroundColor: '#dcfce7', padding: '1px 5px', borderRadius: '4px' }}>Verified</span>
                      </div>
                      <div style={{ fontSize: '13px', fontWeight: 800, color: '#0f172a', marginTop: '2px' }}>{profile.panNumber}</div>
                    </div>

                    <div style={{ backgroundColor: '#ffffff', padding: '8px 12px', borderRadius: '10px', border: '1px solid #e2e8f0' }}>
                      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                        <span style={{ fontSize: '10.5px', color: '#64748b', fontWeight: 600 }}>ABHA Health ID</span>
                        <span style={{ fontSize: '9.5px', color: '#16a34a', fontWeight: 700, backgroundColor: '#dcfce7', padding: '1px 5px', borderRadius: '4px' }}>Active</span>
                      </div>
                      <div style={{ fontSize: '13px', fontWeight: 800, color: '#0f172a', marginTop: '2px' }}>{profile.abhaId}</div>
                    </div>

                    <div style={{ backgroundColor: '#ffffff', padding: '8px 12px', borderRadius: '10px', border: '1px solid #e2e8f0' }}>
                      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                        <span style={{ fontSize: '10.5px', color: '#64748b', fontWeight: 600 }}>EPFO UAN</span>
                        <span style={{ fontSize: '9.5px', color: '#16a34a', fontWeight: 700, backgroundColor: '#dcfce7', padding: '1px 5px', borderRadius: '4px' }}>Active</span>
                      </div>
                      <div style={{ fontSize: '13px', fontWeight: 800, color: '#0f172a', marginTop: '2px' }}>{profile.uanNumber}</div>
                    </div>
                  </div>
                </div>

                {/* 2. Demographics & Contact */}
                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(260px, 1fr))', gap: '12px' }}>
                  {/* Contact */}
                  <div style={{ backgroundColor: '#f8fafc', padding: '14px', borderRadius: '14px', border: '1px solid #e2e8f0' }}>
                    <div style={{ fontSize: '11px', fontWeight: 800, color: '#0d9488', letterSpacing: '0.05em', textTransform: 'uppercase', marginBottom: '10px' }}>
                      Contact Records
                    </div>
                    <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
                      <div>
                        <div style={{ fontSize: '10.5px', color: '#64748b', fontWeight: 600 }}>{t.lblPhone}</div>
                        <div style={{ fontSize: '13px', fontWeight: 800, color: '#0f172a' }}>{profile.phone}</div>
                      </div>
                      <div>
                        <div style={{ fontSize: '10.5px', color: '#64748b', fontWeight: 600 }}>{t.lblEmail}</div>
                        <div style={{ fontSize: '13px', fontWeight: 800, color: '#0f172a' }}>{profile.email}</div>
                      </div>
                    </div>
                  </div>

                  {/* Demographics */}
                  <div style={{ backgroundColor: '#f8fafc', padding: '14px', borderRadius: '14px', border: '1px solid #e2e8f0' }}>
                    <div style={{ fontSize: '11px', fontWeight: 800, color: '#0d9488', letterSpacing: '0.05em', textTransform: 'uppercase', marginBottom: '10px' }}>
                      Personal Demographics
                    </div>
                    <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
                      <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                        <div>
                          <div style={{ fontSize: '10.5px', color: '#64748b', fontWeight: 600 }}>DOB & Gender</div>
                          <div style={{ fontSize: '12.5px', fontWeight: 800, color: '#0f172a' }}>{profile.dob} • {profile.gender}</div>
                        </div>
                        <div>
                          <div style={{ fontSize: '10.5px', color: '#64748b', fontWeight: 600 }}>Blood Group</div>
                          <div style={{ fontSize: '12.5px', fontWeight: 800, color: '#0f172a' }}>{profile.bloodGroup}</div>
                        </div>
                      </div>
                      <div>
                        <div style={{ fontSize: '10.5px', color: '#64748b', fontWeight: 600 }}>{t.lblAddress}</div>
                        <div style={{ fontSize: '12px', fontWeight: 700, color: '#0f172a' }}>
                          {profile.address}, {profile.state} — {profile.pincode}
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            )}
          </div>
        )}

        {/* ======================================================================= */}
        {/* TAB 3: SETTINGS (CLEAN, SINGLE-LINE ALIGNED) */}
        {/* ======================================================================= */}
        {activeTab === 'settings' && (
          <div style={{ animation: 'tabSwitchFade 0.2s ease both' }}>
            {/* Security Toggles Grid */}
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(260px, 1fr))', gap: '10px', marginBottom: '14px' }}>
              <div style={{ backgroundColor: '#f8fafc', padding: '12px 14px', borderRadius: '12px', border: '1.5px solid #e2e8f0', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                <div>
                  <div style={{ fontSize: '12.5px', fontWeight: 800, color: '#0f172a' }}>{t.twoFactorTitle}</div>
                  <div style={{ fontSize: '11px', color: '#64748b', marginTop: '2px' }}>{t.twoFactorDesc}</div>
                </div>
                <button
                  onClick={() => {
                    setTwoFactorEnabled(!twoFactorEnabled);
                    showToast(`2FA Authentication ${!twoFactorEnabled ? 'Enabled' : 'Disabled'}`);
                  }}
                  style={{ width: '40px', height: '22px', borderRadius: '11px', backgroundColor: twoFactorEnabled ? '#0d9488' : '#cbd5e1', border: 'none', position: 'relative', cursor: 'pointer' }}
                >
                  <span style={{ position: 'absolute', top: '2px', left: twoFactorEnabled ? '20px' : '2px', width: '18px', height: '18px', borderRadius: '50%', backgroundColor: '#ffffff', transition: 'all 0.2s ease' }} />
                </button>
              </div>

              <div style={{ backgroundColor: '#f8fafc', padding: '12px 14px', borderRadius: '12px', border: '1.5px solid #e2e8f0', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                <div>
                  <div style={{ fontSize: '12.5px', fontWeight: 800, color: '#0f172a' }}>{t.bioLockTitle}</div>
                  <div style={{ fontSize: '11px', color: '#64748b', marginTop: '2px' }}>{t.bioLockDesc}</div>
                </div>
                <button
                  onClick={() => {
                    setBiometricLockEnabled(!biometricLockEnabled);
                    showToast(`Biometric Security ${!biometricLockEnabled ? 'Locked' : 'Unlocked'}`);
                  }}
                  style={{ width: '40px', height: '22px', borderRadius: '11px', backgroundColor: biometricLockEnabled ? '#0d9488' : '#cbd5e1', border: 'none', position: 'relative', cursor: 'pointer' }}
                >
                  <span style={{ position: 'absolute', top: '2px', left: biometricLockEnabled ? '20px' : '2px', width: '18px', height: '18px', borderRadius: '50%', backgroundColor: '#ffffff', transition: 'all 0.2s ease' }} />
                </button>
              </div>
            </div>

            {/* Notification & Language Settings */}
            <div style={{ display: 'flex', flexDirection: 'column', gap: '12px', maxWidth: '640px' }}>
              {/* Regional Portal Language Dropdown */}
              <div style={{ backgroundColor: '#f8fafc', padding: '14px', borderRadius: '14px', border: '1px solid #e2e8f0' }}>
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '10px' }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                    <div style={{ padding: '6px', borderRadius: '8px', backgroundColor: 'rgba(13, 148, 136, 0.1)', color: '#0d9488', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                      <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
                        <circle cx="12" cy="12" r="10" />
                        <line x1="2" y1="12" x2="22" y2="12" />
                        <path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z" />
                      </svg>
                    </div>
                    <div>
                      <div style={{ fontSize: '12.5px', fontWeight: 800, color: '#0f172a' }}>{t.portalLanguage}</div>
                      <div style={{ fontSize: '11px', color: '#64748b' }}>Select preferred language across all services</div>
                    </div>
                  </div>
                  <span style={{ fontSize: '10px', fontWeight: 800, color: '#0d9488', backgroundColor: 'rgba(13, 148, 136, 0.1)', padding: '3px 8px', borderRadius: '6px' }}>
                    3 REGIONS
                  </span>
                </div>

                <select
                  value={language}
                  onChange={(e) => onLanguageChange?.(e.target.value as Language)}
                  style={{
                    width: '100%',
                    padding: '9px 12px',
                    borderRadius: '10px',
                    border: '1px solid #cbd5e1',
                    backgroundColor: '#ffffff',
                    color: '#0f172a',
                    fontSize: '13px',
                    fontWeight: 600,
                    cursor: 'pointer',
                    outline: 'none',
                  }}
                >
                  <option value="en">🇬🇧 English (Default Portal Language)</option>
                  <option value="hi">🇮🇳 हिन्दी (Hindi · राष्ट्रीय आधिकारिक भाषा)</option>
                  <option value="pa">🇮🇳 ਪੰਜਾਬੀ (Punjabi · ਖੇਤਰੀ ਭਾਸ਼ਾ)</option>
                </select>
              </div>

              {/* Expiry & Renewal Alerts */}
              <div style={{ backgroundColor: '#f8fafc', padding: '14px', borderRadius: '14px', border: '1px solid #e2e8f0' }}>
                <div style={{ fontSize: '12.5px', fontWeight: 800, color: '#0f172a', marginBottom: '10px' }}>
                  {t.alertsTitle}
                </div>
                <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
                  <label
                    style={{
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'space-between',
                      padding: '8px 12px',
                      backgroundColor: '#ffffff',
                      borderRadius: '10px',
                      border: '1px solid #e2e8f0',
                      cursor: 'pointer',
                    }}
                  >
                    <span style={{ fontSize: '12px', fontWeight: 600, color: '#0f172a', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>
                      {t.whatsappAlerts}
                    </span>
                    <input
                      type="checkbox"
                      checked={whatsappAlerts}
                      onChange={(e) => setWhatsappAlerts(e.target.checked)}
                      style={{ accentColor: '#0d9488', width: '16px', height: '16px', flexShrink: 0, marginLeft: '12px' }}
                    />
                  </label>

                  <label
                    style={{
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'space-between',
                      padding: '8px 12px',
                      backgroundColor: '#ffffff',
                      borderRadius: '10px',
                      border: '1px solid #e2e8f0',
                      cursor: 'pointer',
                    }}
                  >
                    <span style={{ fontSize: '12px', fontWeight: 600, color: '#0f172a', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>
                      {t.smsAlerts}
                    </span>
                    <input
                      type="checkbox"
                      checked={smsAlerts}
                      onChange={(e) => setSmsAlerts(e.target.checked)}
                      style={{ accentColor: '#0d9488', width: '16px', height: '16px', flexShrink: 0, marginLeft: '12px' }}
                    />
                  </label>
                </div>
              </div>

              {/* Data Portability & Sign Out (Clean Single Line) */}
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '10px', marginTop: '4px' }}>
                <button
                  onClick={() => showToast('Encrypted Citizen JSON Archive Exported! ✓')}
                  className="btn-interactive"
                  style={{
                    height: '42px',
                    borderRadius: '12px',
                    border: '1px solid #e2e8f0',
                    backgroundColor: '#f8fafc',
                    color: '#0f172a',
                    fontSize: '12.5px',
                    fontWeight: 700,
                    cursor: 'pointer',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    gap: '6px',
                    whiteSpace: 'nowrap',
                  }}
                >
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
                    <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                    <polyline points="7 10 12 15 17 10" />
                    <line x1="12" y1="15" x2="12" y2="3" />
                  </svg>
                  <span>{t.exportData}</span>
                </button>

                <button
                  onClick={handleSignOut}
                  className="btn-interactive"
                  style={{
                    height: '42px',
                    borderRadius: '12px',
                    border: '1px solid #fecdd3',
                    backgroundColor: '#fff1f2',
                    color: '#e11d48',
                    fontSize: '12.5px',
                    fontWeight: 800,
                    cursor: 'pointer',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    gap: '6px',
                    whiteSpace: 'nowrap',
                  }}
                >
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
                    <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
                    <polyline points="16 17 21 12 16 7" />
                    <line x1="21" y1="12" x2="9" y2="12" />
                  </svg>
                  <span>{t.signOut}</span>
                </button>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
