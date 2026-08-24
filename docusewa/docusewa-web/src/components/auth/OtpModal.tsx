'use client';

import React, {
  useCallback,
  useEffect,
  useRef,
  useState,
} from 'react';
import { verifyOtp, verifyEmailOtp } from '@/services/auth.service';

const OTP_LENGTH = 6;
const RESEND_COOLDOWN = 30; // seconds

interface OtpModalProps {
  target: string;
  type?: 'phone' | 'email';
  onVerified: (isNewUser: boolean) => void;
  onEditNumber: () => void;
  onResend: () => Promise<void>;
}

export function OtpModal({
  target,
  type = 'phone',
  onVerified,
  onEditNumber,
  onResend,
}: OtpModalProps) {
  const [digits, setDigits] = useState<string[]>(Array(OTP_LENGTH).fill(''));
  const [isVerifying, setIsVerifying] = useState(false);
  const [isSuccess, setIsSuccess] = useState(false);
  const [isError, setIsError] = useState(false);
  const [isResending, setIsResending] = useState(false);
  const [errorMsg, setErrorMsg] = useState<string | null>(null);
  const [countdown, setCountdown] = useState(RESEND_COOLDOWN);
  const [shakeKey, setShakeKey] = useState(0);

  const inputRefs = useRef<(HTMLInputElement | null)[]>([]);

  // Focus first box on mount
  useEffect(() => {
    inputRefs.current[0]?.focus();
  }, []);

  // Countdown timer
  useEffect(() => {
    if (countdown <= 0) return;
    const timer = setInterval(() => setCountdown((c) => c - 1), 1000);
    return () => clearInterval(timer);
  }, [countdown]);

  const handleVerify = useCallback(
    async (otpToVerify?: string) => {
      const otp = otpToVerify || digits.join('');
      if (otp.length < OTP_LENGTH) {
        setErrorMsg('Please enter all 6 digits of the OTP.');
        return;
      }

      if (isVerifying || isSuccess) return;
      setIsVerifying(true);
      setErrorMsg(null);
      setIsError(false);

      const result =
        type === 'email'
          ? await verifyEmailOtp(target, otp)
          : await verifyOtp(target, otp);

      setIsVerifying(false);

      if (result.error) {
        setIsError(true);
        setErrorMsg(result.error);
        setShakeKey((k) => k + 1);
        setTimeout(() => {
          setDigits(Array(OTP_LENGTH).fill(''));
          setIsError(false);
          inputRefs.current[0]?.focus();
        }, 800);
        return;
      }

      setIsSuccess(true);
      setTimeout(() => {
        onVerified(result.data!.isNewUser);
      }, 600);
    },
    [digits, target, type, isVerifying, isSuccess, onVerified]
  );

  const handleDigitChange = useCallback(
    (index: number, value: string) => {
      const clean = value.replace(/\D/g, '');

      // Handle paste of full OTP
      if (clean.length === OTP_LENGTH) {
        const next = clean.split('');
        setDigits(next);
        inputRefs.current[OTP_LENGTH - 1]?.focus();
        handleVerify(clean);
        return;
      }

      if (clean.length > 1) return;

      const next = [...digits];
      next[index] = clean;
      setDigits(next);
      if (errorMsg) setErrorMsg(null);

      if (clean) {
        if (index < OTP_LENGTH - 1) {
          inputRefs.current[index + 1]?.focus();
        } else {
          // Last digit reached — trigger verification
          const otp = next.join('');
          if (otp.length === OTP_LENGTH) {
            handleVerify(otp);
          }
        }
      }
    },
    [digits, errorMsg, handleVerify]
  );

  const handleKeyDown = useCallback(
    (index: number, e: React.KeyboardEvent<HTMLInputElement>) => {
      if (e.key === 'Backspace' && !digits[index] && index > 0) {
        inputRefs.current[index - 1]?.focus();
      }
    },
    [digits]
  );

  const handleResend = useCallback(async () => {
    if (countdown > 0 || isResending) return;
    setIsResending(true);
    await onResend();
    setIsResending(false);
    setCountdown(RESEND_COOLDOWN);
    setDigits(Array(OTP_LENGTH).fill(''));
    setErrorMsg(null);
    inputRefs.current[0]?.focus();
  }, [countdown, isResending, onResend]);

  const isComplete = digits.join('').length === OTP_LENGTH;
  const displayTarget =
    type === 'phone'
      ? `+91 ${target.slice(0, 5)} ${target.slice(5)}`
      : target;

  const timerLabel = `00:${String(countdown).padStart(2, '0')}`;

  return (
    <>
      <div
        style={{
          position: 'fixed',
          inset: 0,
          backgroundColor: 'var(--bg-overlay)',
          backdropFilter: 'blur(8px)',
          WebkitBackdropFilter: 'blur(8px)',
          zIndex: 1000,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          padding: '20px',
          animation: 'overlayFadeIn 0.25s cubic-bezier(0.16, 1, 0.3, 1) both',
        }}
        role="dialog"
        aria-modal="true"
        aria-label="OTP Security Verification"
      >
        <div
          style={{
            position: 'relative',
            backgroundColor: 'var(--bg-card)',
            borderRadius: '20px',
            border: '1px solid var(--border-light)',
            padding: '32px 28px',
            width: '100%',
            maxWidth: '430px',
            boxShadow: 'var(--shadow-lg)',
            animation: 'modalSmoothIn 0.28s cubic-bezier(0.16, 1, 0.3, 1) both',
          }}
        >
          {/* Close button */}
          <button
            onClick={onEditNumber}
            style={{
              position: 'absolute',
              top: '16px',
              right: '16px',
              width: '32px',
              height: '32px',
              borderRadius: '50%',
              backgroundColor: 'var(--primary-surface)',
              border: 'none',
              color: 'var(--text-muted)',
              cursor: 'pointer',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              transition: 'background-color 0.15s ease',
            }}
            aria-label="Close"
          >
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
              <line x1="18" y1="6" x2="6" y2="18" />
              <line x1="6" y1="6" x2="18" y2="18" />
            </svg>
          </button>

          {/* Clean Executive Header */}
          <div style={{ textAlign: 'center', marginBottom: '22px' }}>
            <h3
              style={{
                margin: '0 0 6px',
                fontSize: '21px',
                fontWeight: 800,
                color: 'var(--text-main)',
                letterSpacing: '-0.025em',
              }}
            >
              Enter Verification Code
            </h3>
            <p
              style={{
                margin: '0 0 10px',
                fontSize: '13.5px',
                color: 'var(--text-muted)',
              }}
            >
              We sent a 6-digit verification code to
            </p>
            <div
              style={{
                display: 'inline-flex',
                alignItems: 'center',
                gap: '8px',
                padding: '4px 12px',
                borderRadius: '9999px',
                backgroundColor: 'var(--primary-surface)',
                border: '1px solid var(--border-light)',
              }}
            >
              <span style={{ fontSize: '13px', fontWeight: 700, color: 'var(--text-main)' }}>
                {displayTarget}
              </span>
              <button
                onClick={onEditNumber}
                style={{
                  background: 'none',
                  border: 'none',
                  color: 'var(--primary)',
                  fontSize: '12px',
                  fontWeight: 600,
                  cursor: 'pointer',
                  padding: 0,
                  textDecoration: 'underline',
                }}
              >
                Change
              </button>
            </div>
          </div>

          {/* Digits Input */}
          <div
            key={shakeKey}
            style={{
              display: 'flex',
              justifyContent: 'center',
              gap: '8px',
              marginBottom: '18px',
              animation: isError ? 'shake 0.45s ease' : 'none',
            }}
            role="group"
            aria-label="Enter 6-digit OTP"
          >
            {digits.map((digit, i) => {
              const isFilled = digit !== '';
              return (
                <input
                  key={i}
                  ref={(el) => {
                    inputRefs.current[i] = el;
                  }}
                  type="text"
                  inputMode="numeric"
                  pattern="[0-9]*"
                  maxLength={6}
                  value={digit}
                  disabled={isVerifying || isSuccess}
                  onChange={(e) => handleDigitChange(i, e.target.value)}
                  onKeyDown={(e) => handleKeyDown(i, e)}
                  aria-label={`Digit ${i + 1}`}
                  style={{
                    width: '46px',
                    height: '52px',
                    textAlign: 'center',
                    fontSize: '21px',
                    fontWeight: 700,
                    fontFamily: 'inherit',
                    borderRadius: '10px',
                    border: isError
                      ? '2px solid var(--error)'
                      : isSuccess
                      ? '2px solid var(--success)'
                      : isFilled
                      ? '2px solid var(--border-active)'
                      : '1.5px solid var(--border-default)',
                    backgroundColor: isError
                      ? 'var(--error-bg)'
                      : isSuccess
                      ? 'var(--success-light)'
                      : isFilled
                      ? 'var(--primary-surface)'
                      : 'var(--bg-hover)',
                    color: isSuccess ? 'var(--success)' : 'var(--text-main)',
                    outline: 'none',
                    boxShadow: isFilled && !isError && !isSuccess
                      ? 'var(--ring-primary)'
                      : 'none',
                    transition: 'all 0.16s ease',
                    caretColor: 'var(--primary)',
                  }}
                />
              );
            })}
          </div>

          {/* Feedback error */}
          {errorMsg && (
            <div
              role="alert"
              style={{
                margin: '0 0 14px',
                padding: '8px 12px',
                borderRadius: '8px',
                backgroundColor: 'var(--error-bg)',
                border: '1px solid var(--error-light)',
                fontSize: '12.5px',
                fontWeight: 600,
                color: 'var(--error-dark)',
                textAlign: 'center',
              }}
            >
              {errorMsg}
            </div>
          )}

          {/* Primary Action Button: Verify & Proceed */}
          <button
            type="button"
            onClick={() => handleVerify()}
            disabled={!isComplete || isVerifying || isSuccess}
            style={{
              width: '100%',
              height: '46px',
              borderRadius: '10px',
              border: 'none',
              backgroundColor: isSuccess
                ? 'var(--success)'
                : isComplete && !isVerifying
                ? 'var(--primary)'
                : 'var(--primary-light)',
              color: isComplete && !isVerifying
                ? 'var(--text-inverse)'
                : 'var(--primary-hover)',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              fontSize: '14.5px',
              fontWeight: 600,
              fontFamily: 'inherit',
              cursor: isComplete && !isVerifying && !isSuccess ? 'pointer' : 'not-allowed',
              marginBottom: '16px',
              boxShadow: isSuccess
                ? 'var(--shadow-success)'
                : isComplete
                ? 'var(--shadow-primary)'
                : 'none',
              transition: 'all 0.2s ease',
            }}
          >
            {isVerifying ? (
              <span style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
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
                Verifying…
              </span>
            ) : isSuccess ? (
              '✓ Verified'
            ) : (
              'Verify & Proceed'
            )}
          </button>

          {/* Resend Footer */}
          <div
            style={{
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-between',
              padding: '10px 14px',
              borderRadius: '10px',
              backgroundColor: 'var(--bg-hover)',
              border: '1px solid var(--border-default)',
            }}
          >
            <span style={{ fontSize: '12.5px', color: 'var(--text-muted)' }}>
              Didn&apos;t receive code?
            </span>
            {countdown > 0 ? (
              <span
                style={{
                  fontSize: '12.5px',
                  fontWeight: 600,
                  color: 'var(--primary)',
                }}
              >
                Resend in {timerLabel}
              </span>
            ) : (
              <button
                onClick={handleResend}
                disabled={isResending}
                style={{
                  background: 'none',
                  border: 'none',
                  color: 'var(--primary)',
                  fontSize: '12.5px',
                  fontWeight: 700,
                  cursor: isResending ? 'wait' : 'pointer',
                  textDecoration: 'underline',
                  padding: 0,
                }}
              >
                {isResending ? 'Sending…' : 'Resend OTP'}
              </button>
            )}
          </div>
        </div>
      </div>
    </>
  );
}
