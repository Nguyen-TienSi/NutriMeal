import React, { useState, useRef, useEffect } from 'react';
import { Facebook, Twitter, Link2, MessageCircle } from 'lucide-react';

const ShareMenu = ({ postId, isOpen, onClose }) => {
  const [copied, setCopied] = useState(false);
  const menuRef = useRef();

  // Generate share URLs
  const postUrl = `${window.location.origin}/post/${postId}`;
  const shareUrls = {
    facebook: `https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(postUrl)}`,
    twitter: `https://twitter.com/intent/tweet?url=${encodeURIComponent(postUrl)}`,
    zalo: `https://zalo.me/share?u=${encodeURIComponent(postUrl)}&t=${encodeURIComponent('Check out this post')}`
  };

  // Handle click outside to close menu
  useEffect(() => {
    const handleClickOutside = (event) => {
      if (menuRef.current && !menuRef.current.contains(event.target)) {
        onClose();
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, [onClose]);

  // Copy link handler
  const handleCopyLink = async () => {
    try {
      await navigator.clipboard.writeText(postUrl);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    } catch (error) {
      console.error('Failed to copy:', error);
    }
  };

  // Share handlers
  const handleShare = (platform) => {
    window.open(shareUrls[platform], '_blank', 'width=600,height=400');
    onClose();
  };

  if (!isOpen) return null;

  return (
    <div 
      ref={menuRef}
      className="absolute bottom-full right-0 mb-2 bg-base-100 rounded-lg shadow-lg p-2 min-w-[200px] z-50"
    >
      <div className="flex flex-col gap-2">
        <button 
          onClick={() => handleShare('facebook')} 
          className="btn btn-ghost btn-sm justify-start gap-2"
        >
          <Facebook size={18} />
          Share on Facebook
        </button>
        <button 
          onClick={() => handleShare('twitter')} 
          className="btn btn-ghost btn-sm justify-start gap-2"
        >
          <Twitter size={18} />
          Share on Twitter
        </button>
        <button 
          onClick={() => handleShare('zalo')} 
          className="btn btn-ghost btn-sm justify-start gap-2"
        >
          <MessageCircle size={18} />
          Share on Zalo
        </button>
        <button 
          onClick={handleCopyLink} 
          className="btn btn-ghost btn-sm justify-start gap-2"
        >
          <Link2 size={18} />
          {copied ? 'Copied!' : 'Copy link'}
        </button>
      </div>
    </div>
  );
};

export default ShareMenu;