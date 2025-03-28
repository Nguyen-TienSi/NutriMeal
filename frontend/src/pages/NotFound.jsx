import React from 'react';
import { Link } from 'react-router-dom';
import { Home } from 'lucide-react';

const NotFound = () => {
  return (
    <div className="min-h-screen flex flex-col items-center justify-center p-4">
      <img 
        src="/404.svg" 
        alt="404 Not Found" 
        className="max-w-md w-full mb-8"
      />
      
      <h1 className="text-4xl font-bold mb-4">Page Not Found</h1>
      <p className="text-gray-600 mb-8 text-center max-w-md">
        Oops! The page you're looking for doesn't exist or has been moved.
      </p>
      
      <Link 
        to="/" 
        className="btn btn-primary gap-2"
      >
        <Home size={20} />
        Back to Homepage
      </Link>
    </div>
  );
};

export default NotFound;