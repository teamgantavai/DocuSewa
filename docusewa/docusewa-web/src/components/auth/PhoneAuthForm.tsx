'use client';

import React, { useCallback, useEffect, useRef, useState } from 'react';
import { sendOtp, sendEmailOtp, signInWithGoogle, DEMO_PHONE, DEMO_EMAIL } from '@/services/auth.service';

interface PhoneAuthFormProps {
  onOtpSent: (target: string, type: 'phone' | 'email') => void;
  onQrLoginClick?: () => void;
}

const VALID_PHONE_RE = /^[6-9]\d{9}$/;
const VALID_EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

export function PhoneAuthForm({ onOtpSent, onQrLoginClick }: PhoneAuthFormProps) {
  const [authMethod, setAuthMethod] = useState<'phone' | 'email'>('phone');
  const [phone, setPhone] = useState('');
  const [email, setEmail] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [isGoogleLoading, setIsGoogleLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [isFocused, setIsFocused] = useState(false);

  const phoneInputRef = useRef<HTMLInputElement>(null);
  const emailInputRef = useRef<HTMLInputElement>(null);

  const isPhoneValid = VALID_PHONE_RE.test(phone);
  const isEmailValid = VALID_EMAIL_RE.test(email);
  const isValid = authMethod === 'phone' ? isPhoneValid : isEmailValid;

  const handlePhoneChange = useCallback(
    (e: React.ChangeEvent<HTMLInputElement>) => {
      const digits = e.target.value.replace(/\D/g, '').slice(0, 10);
      setPhone(digits);
      if (error) setError(null);
    },
    [error]
  );

  const handleEmailChange = useCallback(
    (e: React.ChangeEvent<HTMLInputElement>) => {
      setEmail(e.target.value);
      if (error) setError(null);
    },
    [error]
  );

  const fillDemo = () => {
    if (authMethod === 'phone') {
      setPhone(DEMO_PHONE);
    } else {
      setEmail(DEMO_EMAIL);
    }
    setError(null);
  };

  const handleSubmit = useCallback(
    async (e?: React.FormEvent) => {
      e?.preventDefault();
      if (!isValid || isSubmitting) return;

      setIsSubmitting(true);
      setError(null);

      if (authMethod === 'phone') {
        if (!VALID_PHONE_RE.test(phone)) {
          setError('Please enter a valid 10-digit Indian mobile number.');
          setIsSubmitting(false);
          return;
        }

        const result = await sendOtp(phone);
        setIsSubmitting(false);

        if (result.error) {
          setError(result.error);
          return;
        }

        onOtpSent(phone, 'phone');
      } else {
        if (!VALID_EMAIL_RE.test(email)) {
          setError('Please enter a valid email address.');
          setIsSubmitting(false);
          return;
        }

        const result = await sendEmailOtp(email);
        setIsSubmitting(false);

        if (result.error) {
          setError(result.error);
          return;
        }

        onOtpSent(email, 'email');
      }
    },
    [authMethod, phone, email, isValid, isSubmitting, onOtpSent]
  );

  const handleGoogleSignIn = useCallback(async () => {
    if (isGoogleLoading) return;
    setIsGoogleLoading(true);
    setError(null);

    const result = await signInWithGoogle();
    if (result.error) {
      setError(result.error);
      setIsGoogleLoading(false);
    }
  }, [isGoogleLoading]);

  // Submit on Enter
  useEffect(() => {
    const handler = (e: KeyboardEvent) => {
      if (e.key === 'Enter' && isValid) handleSubmit();
    };
    window.addEventListener('keydown', handler);
    return () => window.removeEventListener('keydown', handler);
  }, [isValid, handleSubmit]);

  return (
    <form onSubmit={handleSubmit} noValidate style={{ display: 'flex', flexDirection: 'column' }}>
      {/* Mode Switcher Tabs: Mobile | Email */}
      <div
        style={{
          display: 'flex',
          backgroundColor: 'var(--bg-muted)',
          borderRadius: '8px',
          padding: '3px',
          marginBottom: '16px',
          gap: '4px',
        }}
      >
        <button
          type="button"
          onClick={() => {
            setAuthMethod('phone');
            setError(null);
          }}
          style={{
            flex: 1,
            height: '34px',
            border: 'none',
            borderRadius: '6px',
            backgroundColor: authMethod === 'phone' ? 'var(--bg-card)' : 'transparent',
            color: authMethod === 'phone' ? 'var(--primary)' : 'var(--text-muted)',
            fontWeight: authMethod === 'phone' ? 600 : 500,
            fontSize: '13.5px',
            cursor: 'pointer',
            boxShadow: authMethod === 'phone' ? 'var(--shadow-sm)' : 'none',
            transition: 'all 0.15s ease',
            fontFamily: 'inherit',
          }}
        >
          Mobile
        </button>

        <button
          type="button"
          onClick={() => {
            setAuthMethod('email');
            setError(null);
          }}
          style={{
            flex: 1,
            height: '34px',
            border: 'none',
            borderRadius: '6px',
            backgroundColor: authMethod === 'email' ? 'var(--bg-card)' : 'transparent',
            color: authMethod === 'email' ? 'var(--primary)' : 'var(--text-muted)',
            fontWeight: authMethod === 'email' ? 600 : 500,
            fontSize: '13.5px',
            cursor: 'pointer',
            boxShadow: authMethod === 'email' ? 'var(--shadow-sm)' : 'none',
            transition: 'all 0.15s ease',
            fontFamily: 'inherit',
          }}
        >
          Email
        </button>
      </div>

      {/* Input Field (Phone or Email) */}
      <div
        key={authMethod}
        style={{
          display: 'flex',
          alignItems: 'center',
          border: isFocused ? '2px solid var(--border-active)' : '1.5px solid var(--border-focus)',
          borderRadius: '10px',
          backgroundColor: 'var(--bg-input)',
          transition: 'all 0.15s ease',
          padding: '2px 4px',
          boxShadow: isFocused ? 'var(--ring-primary)' : 'none',
          animation: 'tabSwitchFade 0.2s cubic-bezier(0.16, 1, 0.3, 1) both',
        }}
      >
        {authMethod === 'phone' ? (
          <>
            <div
              style={{
                padding: '12px 14px',
                fontSize: '15px',
                fontWeight: 500,
                color: 'var(--text-body)',
                borderRight: '1px solid var(--border-muted)',
                userSelect: 'none',
              }}
            >
              +91
            </div>
            <input
              id="phone-input"
              ref={phoneInputRef}
              type="tel"
              inputMode="numeric"
              pattern="[0-9]*"
              value={phone}
              onChange={handlePhoneChange}
              onFocus={() => setIsFocused(true)}
              onBlur={() => setIsFocused(false)}
              placeholder="Mobile number (Demo: 9876543210)"
              autoComplete="tel"
              aria-label="10-digit mobile number"
              style={{
                flex: 1,
                border: 'none',
                outline: 'none',
                backgroundColor: 'transparent',
                fontSize: '15px',
                fontWeight: 400,
                color: 'var(--text-main)',
                padding: '12px 14px',
                fontFamily: 'inherit',
              }}
            />
          </>
        ) : (
          <input
            id="email-input"
            ref={emailInputRef}
            type="email"
            value={email}
            onChange={handleEmailChange}
            onFocus={() => setIsFocused(true)}
            onBlur={() => setIsFocused(false)}
            placeholder="Enter email (Demo: demo@docusewa.in)"
            autoComplete="email"
            aria-label="Email address"
            style={{
              flex: 1,
              border: 'none',
              outline: 'none',
              backgroundColor: 'transparent',
              fontSize: '15px',
              fontWeight: 400,
              color: 'var(--text-main)',
              padding: '12px 14px',
              fontFamily: 'inherit',
            }}
          />
        )}
      </div>

      {/* Demo Credentials Quick Fill Chip */}
      <div style={{ marginTop: '8px', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <button
          type="button"
          onClick={fillDemo}
          style={{
            background: 'var(--primary-subtle)',
            border: '1px solid var(--border-focus)',
            borderRadius: '6px',
            padding: '3px 8px',
            fontSize: '11.5px',
            fontWeight: 600,
            color: 'var(--primary-dark)',
            cursor: 'pointer',
            fontFamily: 'inherit',
          }}
        >
          ⚡ Auto-fill Demo: {authMethod === 'phone' ? '9876543210' : 'demo@docusewa.gov.in'}
        </button>

        <span style={{ fontSize: '11px', color: 'var(--text-muted)' }}>
          Demo OTP: <strong>123456</strong>
        </span>
      </div>

      {/* Inline Error Message */}
      {error && (
        <p
          role="alert"
          style={{
            margin: '8px 0 0',
            fontSize: '12.5px',
            color: 'var(--error-dark)',
            fontWeight: 500,
          }}
        >
          {error}
        </p>
      )}

      {/* Continue Button */}
      <button
        type="submit"
        disabled={!isValid || isSubmitting}
        style={{
          marginTop: '16px',
          width: '100%',
          height: '46px',
          border: 'none',
          borderRadius: '10px',
          backgroundColor: isValid && !isSubmitting ? 'var(--primary)' : 'var(--primary-light)',
          color: isValid && !isSubmitting ? 'var(--text-inverse)' : 'var(--primary-hover)',
          fontSize: '15px',
          fontWeight: 600,
          fontFamily: 'inherit',
          cursor: isValid && !isSubmitting ? 'pointer' : 'not-allowed',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          gap: '8px',
          transition: 'background-color 0.2s ease',
        }}
      >
        {isSubmitting ? (
          <>
            <span
              style={{
                width: '16px',
                height: '16px',
                border: '2px solid rgba(255, 255, 255, 0.4)',
                borderTopColor: 'var(--text-inverse)',
                borderRadius: '50%',
                animation: 'spin 0.7s linear infinite',
              }}
            />
            <span>Sending OTP…</span>
          </>
        ) : (
          'Continue'
        )}
      </button>

      {/* Terms of Service Link */}
      <p
        style={{
          marginTop: '14px',
          fontSize: '12px',
          color: 'var(--text-muted)',
          textAlign: 'center',
          lineHeight: 1.4,
        }}
      >
        By continuing, I agree to the{' '}
        <a
          href="/terms"
          style={{
            color: 'var(--primary)',
            textDecoration: 'none',
            fontWeight: 600,
          }}
        >
          Terms of Service
        </a>
      </p>

      {/* "or" Divider */}
      <div
        style={{
          margin: '20px 0',
          display: 'flex',
          alignItems: 'center',
          position: 'relative',
        }}
      >
        <div style={{ flex: 1, height: '1px', backgroundColor: 'var(--border-default)' }} />
        <span
          style={{
            padding: '0 12px',
            fontSize: '12.5px',
            color: 'var(--text-placeholder)',
            backgroundColor: 'var(--bg-card)',
          }}
        >
          or
        </span>
        <div style={{ flex: 1, height: '1px', backgroundColor: 'var(--border-default)' }} />
      </div>

      {/* Continue with Google Button */}
      <button
        type="button"
        onClick={handleGoogleSignIn}
        disabled={isGoogleLoading}
        style={{
          width: '100%',
          height: '46px',
          borderRadius: '10px',
          border: '1px solid var(--border-default)',
          backgroundColor: 'var(--bg-card)',
          color: 'var(--text-main)',
          fontSize: '14.5px',
          fontWeight: 600,
          cursor: isGoogleLoading ? 'wait' : 'pointer',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          gap: '12px',
          marginBottom: '12px',
          transition: 'all 0.15s ease',
          boxShadow: 'var(--shadow-sm)',
        }}
        onMouseEnter={(e) => {
          e.currentTarget.style.backgroundColor = 'var(--bg-hover)';
          e.currentTarget.style.borderColor = 'var(--border-muted)';
        }}
        onMouseLeave={(e) => {
          e.currentTarget.style.backgroundColor = 'var(--bg-card)';
          e.currentTarget.style.borderColor = 'var(--border-default)';
        }}
      >
        {isGoogleLoading ? (
          <>
            <span
              style={{
                width: '16px',
                height: '16px',
                border: '2px solid rgba(13, 148, 136, 0.3)',
                borderTopColor: 'var(--primary)',
                borderRadius: '50%',
                animation: 'spin 0.7s linear infinite',
              }}
            />
            <span>Connecting to Google…</span>
          </>
        ) : (
          <>
            <svg width="18" height="18" viewBox="0 0 24 24">
              <path
                fill="#4285F4"
                d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"
              />
              <path
                fill="#34A853"
                d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
              />
              <path
                fill="#FBBC05"
                d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.06H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.94l2.85-2.22.81-.63z"
              />
              <path
                fill="#EA4335"
                d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.06l3.66 2.84c.87-2.6 3.3-4.52 6.16-4.52z"
              />
            </svg>
            <span>Continue with Google</span>
          </>
        )}
      </button>

      {/* Login using QR Code Card */}
      <div
        onClick={onQrLoginClick}
        style={{
          border: '1px solid var(--border-default)',
          borderRadius: '10px',
          padding: '12px 14px',
          display: 'flex',
          alignItems: 'center',
          gap: '12px',
          cursor: 'pointer',
          backgroundColor: 'var(--bg-card)',
          transition: 'all 0.15s ease',
        }}
        onMouseEnter={(e) => {
          e.currentTarget.style.borderColor = 'var(--primary-light)';
          e.currentTarget.style.backgroundColor = 'var(--primary-surface)';
        }}
        onMouseLeave={(e) => {
          e.currentTarget.style.borderColor = 'var(--border-default)';
          e.currentTarget.style.backgroundColor = 'var(--bg-card)';
        }}
      >
        <div
          style={{
            width: '32px',
            height: '32px',
            borderRadius: '8px',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            color: 'var(--primary)',
            flexShrink: 0,
          }}
        >
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <rect x="3" y="3" width="7" height="7" rx="1.5" />
            <rect x="14" y="3" width="7" height="7" rx="1.5" />
            <rect x="14" y="14" width="7" height="7" rx="1.5" />
            <rect x="3" y="14" width="7" height="7" rx="1.5" />
            <line x1="7" y1="7" x2="7.01" y2="7" />
            <line x1="17" y1="7" x2="17.01" y2="7" />
            <line x1="7" y1="17" x2="7.01" y2="7" />
            <line x1="17" y1="17" x2="17.01" y2="7" />
          </svg>
        </div>

        <div>
          <p
            style={{
              margin: 0,
              fontSize: '14px',
              fontWeight: 700,
              color: 'var(--text-main)',
            }}
          >
            Login using QR Code
          </p>
          <p
            style={{
              margin: '2px 0 0',
              fontSize: '12px',
              color: 'var(--text-muted)',
            }}
          >
            Scan using{' '}
            <span style={{ color: 'var(--primary)', fontWeight: 600 }}>
              DocuSewa Mobile App
            </span>
          </p>
        </div>
      </div>
    </form>
  );
}
