'use client';

import React from 'react';

interface TrustItem {
  icon: React.ReactNode;
  badge: string;
  title: string;
  subtitle: string;
}

const TRUST_ITEMS: TrustItem[] = [
  {
    icon: (
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
        <path d="m9 12 2 2 4-4" />
      </svg>
    ),
    badge: 'AES-256 GCM',
    title: 'Bank-Grade Security',
    subtitle: 'Zero-knowledge encryption protects your documents & identities',
  },
  {
    icon: (
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
        <path d="M7 11V7a5 5 0 0 1 10 0v4" />
      </svg>
    ),
    badge: 'Gov & UIDAI Ready',
    title: 'Verified Partner Network',
    subtitle: 'Services routed only to certified CSPs and verified operators',
  },
  {
    icon: (
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <path d="M13 2L3 14h9l-1 8 10-12h-9l1-8z" />
      </svg>
    ),
    badge: 'Real-time Tracking',
    title: 'Transparent SLA & Timeline',
    subtitle: 'Instant SMS & WhatsApp updates at every stage of your request',
  },
];

interface TrustIndicatorsProps {
  /** light = for dark hero panel with glass effect, dark = for white card */
  variant?: 'light' | 'dark';
}

export function TrustIndicators({ variant = 'light' }: TrustIndicatorsProps) {
  const isLight = variant === 'light';

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '14px' }}>
      {TRUST_ITEMS.map((item) => (
        <div
          key={item.title}
          style={{
            display: 'flex',
            alignItems: 'flex-start',
            gap: '14px',
            padding: isLight ? '14px 16px' : '12px 14px',
            borderRadius: '16px',
            backgroundColor: isLight
              ? 'rgba(255, 255, 255, 0.05)'
              : 'rgba(241, 245, 249, 0.7)',
            border: isLight
              ? '1px solid rgba(255, 255, 255, 0.09)'
              : '1px solid #e2e8f0',
            backdropFilter: isLight ? 'blur(10px)' : 'none',
            transition: 'transform 0.2s ease, background-color 0.2s ease',
          }}
        >
          {/* Icon Box */}
          <div
            style={{
              width: 38,
              height: 38,
              borderRadius: 12,
              backgroundColor: isLight
                ? 'rgba(59, 130, 246, 0.18)'
                : 'rgba(37, 99, 235, 0.1)',
              color: isLight ? '#60a5fa' : '#2563eb',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              flexShrink: 0,
              boxShadow: isLight
                ? '0 0 16px rgba(59, 130, 246, 0.25)'
                : 'none',
            }}
          >
            {item.icon}
          </div>

          {/* Text Content */}
          <div style={{ flex: 1, minWidth: 0 }}>
            <div
              style={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'space-between',
                gap: 8,
                marginBottom: 3,
              }}
            >
              <h4
                style={{
                  margin: 0,
                  fontSize: 13.5,
                  fontWeight: 700,
                  color: isLight ? '#ffffff' : '#0f172a',
                  letterSpacing: '-0.01em',
                }}
              >
                {item.title}
              </h4>
              <span
                style={{
                  fontSize: 10,
                  fontWeight: 600,
                  padding: '2px 7px',
                  borderRadius: 9999,
                  backgroundColor: isLight
                    ? 'rgba(96, 165, 250, 0.15)'
                    : 'rgba(37, 99, 235, 0.08)',
                  color: isLight ? '#93c5fd' : '#2563eb',
                  border: isLight
                    ? '1px solid rgba(96, 165, 250, 0.25)'
                    : '1px solid rgba(37, 99, 235, 0.15)',
                  whiteSpace: 'nowrap',
                  letterSpacing: '0.02em',
                }}
              >
                {item.badge}
              </span>
            </div>
            <p
              style={{
                margin: 0,
                fontSize: 12,
                color: isLight ? 'rgba(226, 232, 240, 0.72)' : '#64748b',
                lineHeight: 1.45,
              }}
            >
              {item.subtitle}
            </p>
          </div>
        </div>
      ))}
    </div>
  );
}
