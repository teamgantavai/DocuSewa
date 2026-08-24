import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: 'DocuSewa — Government & Citizen Services Portal',
  description:
    'Securely connect with verified service providers and manage your government service requests in one unified, ultra-fast portal.',
  keywords: 'DocuSewa, citizen services, government, India, OTP, secure, Aadhaar, certificates, janseva',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <head>
        <meta charSet="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link
          rel="preconnect"
          href="https://fonts.gstatic.com"
          crossOrigin="anonymous"
        />
        <link
          href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800;900&family=Inter:wght@400;500;600;700;800;900&display=swap"
          rel="stylesheet"
        />
      </head>
      <body>{children}</body>
    </html>
  );
}
