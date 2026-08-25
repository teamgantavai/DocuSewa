'use client';

import React, { useState, useRef, useEffect, useCallback } from 'react';

interface PhotoCropModalProps {
  isOpen: boolean;
  imageSrc: string | null;
  onClose: () => void;
  onApplyCrop: (croppedDataUrl: string) => void;
}

export default function PhotoCropModal({
  isOpen,
  imageSrc,
  onClose,
  onApplyCrop,
}: PhotoCropModalProps) {
  const [zoom, setZoom] = useState<number>(1);
  const [rotation, setRotation] = useState<number>(0);
  const [position, setPosition] = useState<{ x: number; y: number }>({ x: 0, y: 0 });
  const [isDragging, setIsDragging] = useState<boolean>(false);
  const [dragStart, setDragStart] = useState<{ x: number; y: number }>({ x: 0, y: 0 });

  const containerRef = useRef<HTMLDivElement | null>(null);
  const imgRef = useRef<HTMLImageElement | null>(null);

  // Reset state when a new image is loaded
  useEffect(() => {
    if (isOpen) {
      setZoom(1);
      setRotation(0);
      setPosition({ x: 0, y: 0 });
    }
  }, [isOpen, imageSrc]);

  // Handle Mouse / Touch Dragging
  const handleMouseDown = (e: React.MouseEvent) => {
    e.preventDefault();
    setIsDragging(true);
    setDragStart({ x: e.clientX - position.x, y: e.clientY - position.y });
  };

  const handleMouseMove = useCallback(
    (e: React.MouseEvent) => {
      if (!isDragging) return;
      setPosition({
        x: e.clientX - dragStart.x,
        y: e.clientY - dragStart.y,
      });
    },
    [isDragging, dragStart]
  );

  const handleMouseUp = () => {
    setIsDragging(false);
  };

  // Touch Handlers for Mobile Web
  const handleTouchStart = (e: React.TouchEvent) => {
    if (e.touches.length === 1) {
      const touch = e.touches[0];
      setIsDragging(true);
      setDragStart({ x: touch.clientX - position.x, y: touch.clientY - position.y });
    }
  };

  const handleTouchMove = useCallback(
    (e: React.TouchEvent) => {
      if (!isDragging || e.touches.length !== 1) return;
      const touch = e.touches[0];
      setPosition({
        x: touch.clientX - dragStart.x,
        y: touch.clientY - dragStart.y,
      });
    },
    [isDragging, dragStart]
  );

  const handleTouchEnd = () => {
    setIsDragging(false);
  };

  // Perform canvas crop
  const handleCropAndApply = () => {
    if (!imgRef.current) return;

    const canvas = document.createElement('canvas');
    const cropSize = 320; // High-res avatar crop size
    canvas.width = cropSize;
    canvas.height = cropSize;
    const ctx = canvas.getContext('2d');

    if (!ctx) return;

    // Background circle clip
    ctx.beginPath();
    ctx.arc(cropSize / 2, cropSize / 2, cropSize / 2, 0, Math.PI * 2);
    ctx.closePath();
    ctx.clip();

    ctx.save();
    // Center of canvas
    ctx.translate(cropSize / 2, cropSize / 2);
    ctx.rotate((rotation * Math.PI) / 180);

    // Scaling factor between preview display box (220px) and canvas size (320px)
    const previewBoxSize = 220;
    const scaleFactor = cropSize / previewBoxSize;

    // Apply pan and zoom
    const drawX = position.x * scaleFactor;
    const drawY = position.y * scaleFactor;

    const img = imgRef.current;
    const aspect = img.naturalWidth / img.naturalHeight;

    let baseWidth = cropSize;
    let baseHeight = cropSize;

    if (aspect >= 1) {
      baseHeight = cropSize;
      baseWidth = cropSize * aspect;
    } else {
      baseWidth = cropSize;
      baseHeight = cropSize / aspect;
    }

    const scaledWidth = baseWidth * zoom;
    const scaledHeight = baseHeight * zoom;

    ctx.drawImage(
      img,
      drawX - scaledWidth / 2,
      drawY - scaledHeight / 2,
      scaledWidth,
      scaledHeight
    );

    ctx.restore();

    const croppedDataUrl = canvas.toDataURL('image/jpeg', 0.92);
    onApplyCrop(croppedDataUrl);
    onClose();
  };

  if (!isOpen || !imageSrc) return null;

  return (
    <div
      style={{
        position: 'fixed',
        inset: 0,
        backgroundColor: 'rgba(15, 23, 42, 0.75)',
        backdropFilter: 'blur(8px)',
        WebkitBackdropFilter: 'blur(8px)',
        zIndex: 999999,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        padding: '16px',
        animation: 'overlayFadeIn 0.2s ease both',
      }}
      onClick={onClose}
    >
      <div
        onClick={(e) => e.stopPropagation()}
        style={{
          backgroundColor: '#ffffff',
          borderRadius: '24px',
          width: '100%',
          maxWidth: '420px',
          overflow: 'hidden',
          boxShadow: '0 25px 50px -12px rgba(15, 23, 42, 0.3)',
          border: '1px solid #e2e8f0',
          animation: 'modalSmoothIn 0.25s cubic-bezier(0.16, 1, 0.3, 1) both',
        }}
      >
        {/* Header */}
        <div
          style={{
            padding: '16px 20px',
            borderBottom: '1px solid #e2e8f0',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between',
            backgroundColor: '#f8fafc',
          }}
        >
          <div>
            <h3 style={{ margin: 0, fontSize: '16px', fontWeight: 800, color: '#0f172a' }}>
              Crop Profile Photo
            </h3>
            <p style={{ margin: '2px 0 0', fontSize: '11.5px', color: '#64748b' }}>
              Drag to position & adjust zoom for circular ID photo
            </p>
          </div>
          <button
            onClick={onClose}
            style={{
              width: '30px',
              height: '30px',
              borderRadius: '50%',
              backgroundColor: '#ffffff',
              border: '1px solid #e2e8f0',
              color: '#64748b',
              cursor: 'pointer',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
            }}
          >
            ✕
          </button>
        </div>

        {/* Crop Viewport Area */}
        <div
          style={{
            padding: '24px',
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            backgroundColor: '#0f172a',
            userSelect: 'none',
          }}
        >
          <div
            ref={containerRef}
            onMouseDown={handleMouseDown}
            onMouseMove={handleMouseMove}
            onMouseUp={handleMouseUp}
            onTouchStart={handleTouchStart}
            onTouchMove={handleTouchMove}
            onTouchEnd={handleTouchEnd}
            style={{
              position: 'relative',
              width: '220px',
              height: '220px',
              borderRadius: '50%',
              overflow: 'hidden',
              cursor: isDragging ? 'grabbing' : 'grab',
              border: '3px solid #0d9488',
              boxShadow: '0 0 0 9999px rgba(15, 23, 42, 0.7)',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              backgroundColor: '#1e293b',
            }}
          >
            {/* Target Image */}
            <img
              ref={imgRef}
              src={imageSrc}
              alt="Crop target"
              draggable={false}
              style={{
                position: 'absolute',
                transform: `translate(${position.x}px, ${position.y}px) scale(${zoom}) rotate(${rotation}deg)`,
                transformOrigin: 'center center',
                maxWidth: 'none',
                height: '100%',
                objectFit: 'cover',
                pointerEvents: 'none',
                transition: isDragging ? 'none' : 'transform 0.05s ease-out',
              }}
            />

            {/* Circular Guide Grid */}
            <div
              style={{
                position: 'absolute',
                inset: 0,
                borderRadius: '50%',
                border: '1px dashed rgba(255, 255, 255, 0.4)',
                pointerEvents: 'none',
              }}
            />
          </div>

          <p style={{ color: '#94a3b8', fontSize: '11px', marginTop: '14px', marginBottom: 0 }}>
            💡 Pinch or use slider below to zoom & rotate
          </p>
        </div>

        {/* Controls */}
        <div style={{ padding: '18px 20px', backgroundColor: '#ffffff' }}>
          {/* Zoom Slider */}
          <div style={{ marginBottom: '14px' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '12px', fontWeight: 700, color: '#475569', marginBottom: '6px' }}>
              <span>Zoom</span>
              <span>{Math.round(zoom * 100)}%</span>
            </div>
            <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
              <button
                type="button"
                onClick={() => setZoom((z) => Math.max(1, +(z - 0.15).toFixed(2)))}
                style={{
                  width: '28px',
                  height: '28px',
                  borderRadius: '6px',
                  border: '1px solid #e2e8f0',
                  backgroundColor: '#f8fafc',
                  cursor: 'pointer',
                  fontWeight: 800,
                  fontSize: '14px',
                  color: '#0f172a',
                }}
              >
                -
              </button>
              <input
                type="range"
                min="1"
                max="3"
                step="0.05"
                value={zoom}
                onChange={(e) => setZoom(parseFloat(e.target.value))}
                style={{
                  flex: 1,
                  accentColor: '#0d9488',
                  height: '6px',
                  borderRadius: '3px',
                  cursor: 'pointer',
                }}
              />
              <button
                type="button"
                onClick={() => setZoom((z) => Math.min(3, +(z + 0.15).toFixed(2)))}
                style={{
                  width: '28px',
                  height: '28px',
                  borderRadius: '6px',
                  border: '1px solid #e2e8f0',
                  backgroundColor: '#f8fafc',
                  cursor: 'pointer',
                  fontWeight: 800,
                  fontSize: '14px',
                  color: '#0f172a',
                }}
              >
                +
              </button>
            </div>
          </div>

          {/* Quick Actions (Rotate & Reset) */}
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '18px' }}>
            <button
              type="button"
              onClick={() => setRotation((r) => (r + 90) % 360)}
              className="btn-interactive"
              style={{
                flex: 1,
                padding: '7px 12px',
                borderRadius: '8px',
                border: '1px solid #e2e8f0',
                backgroundColor: '#f8fafc',
                color: '#0f172a',
                fontSize: '11.5px',
                fontWeight: 700,
                cursor: 'pointer',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                gap: '5px',
              }}
            >
              <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
                <path d="M21.5 2v6h-6M21.34 15.57a10 10 0 1 1-.57-8.38l5.67-5.67" />
              </svg>
              <span>Rotate 90°</span>
            </button>

            <button
              type="button"
              onClick={() => {
                setZoom(1);
                setRotation(0);
                setPosition({ x: 0, y: 0 });
              }}
              className="btn-interactive"
              style={{
                flex: 1,
                padding: '7px 12px',
                borderRadius: '8px',
                border: '1px solid #e2e8f0',
                backgroundColor: '#f8fafc',
                color: '#64748b',
                fontSize: '11.5px',
                fontWeight: 700,
                cursor: 'pointer',
              }}
            >
              Reset
            </button>
          </div>

          {/* Dialog Action Buttons */}
          <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
            <button
              type="button"
              onClick={onClose}
              style={{
                flex: 1,
                height: '42px',
                borderRadius: '10px',
                border: '1px solid #e2e8f0',
                backgroundColor: '#ffffff',
                color: '#64748b',
                fontWeight: 700,
                fontSize: '13px',
                cursor: 'pointer',
              }}
            >
              Cancel
            </button>

            <button
              type="button"
              onClick={handleCropAndApply}
              className="btn-interactive"
              style={{
                flex: 2,
                height: '42px',
                borderRadius: '10px',
                border: 'none',
                backgroundColor: '#0d9488',
                color: '#ffffff',
                fontWeight: 800,
                fontSize: '13px',
                cursor: 'pointer',
                boxShadow: '0 4px 12px rgba(13, 148, 136, 0.28)',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                gap: '6px',
              }}
            >
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
                <path d="M20 6L9 17l-5-5" />
              </svg>
              <span>Apply & Save Photo</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
