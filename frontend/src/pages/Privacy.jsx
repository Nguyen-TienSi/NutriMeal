import React from 'react';

const Privacy = () => {
  return (
    <div className="max-w-4xl mx-auto p-8">
      <h1 className="text-3xl font-bold mb-6">Privacy Policy</h1>
      <div className="prose">
        {/* Add your privacy policy content here */}
        <p>Last updated: {new Date().toLocaleDateString()}</p>
        <h2>Information We Collect</h2>
        <p>When you sign in with Google, we collect:</p>
        <ul>
          <li>Your email address</li>
          <li>Your name</li>
          <li>Your profile picture</li>
        </ul>
      </div>
    </div>
  );
};

export default Privacy;