import React, { useState } from "react";
import { GoogleLogin } from "@react-oauth/google";
import * as jwtDecode from "jwt-decode";
import { useNavigate } from "react-router-dom";
import { useUser } from "../contexts/UserContext";
import { apiRequest } from "../utils/api"; 

const Auth = () => {
  const [error, setError] = useState(null);
  const navigate = useNavigate();
  const { signIn } = useUser();

  const handleSuccess = async (credentialResponse) => {
    try {
      const details = jwtDecode.jwtDecode(credentialResponse.credential);
      
      const userData = {
        email: details.email,
        name: details.name,
        picture: details.picture || details.picture_url,
      };

      try {
        console.log('Attempting to fetch user:', userData.email);
        const existingUser = await apiRequest(`/users/email?email=${encodeURIComponent(userData.email)}`);
        console.log('Existing user found:', existingUser);
        
        signIn({
          _id: existingUser._id, // Change from id to _id
          email: existingUser.email,
          name: existingUser.name,
          picture: existingUser.picture,
        });
        
      } catch (err) {
        console.error('Error fetching user:', err);
        if (err.message === 'User not found') {
          console.log('Creating new user:', userData);
          const newUser = await apiRequest('/users', 'POST', userData);
          console.log('New user created:', newUser);
          
          signIn({
            _id: newUser._id, // Change from id to _id
            email: newUser.email,
            name: newUser.name,
            picture: newUser.picture,
          });
        } else {
          throw err;
        }
      }

      navigate("/");
    } catch (err) {
      console.error('Authentication failed:', err);
      setError(err.message || "Failed to authenticate. Please try again.");
    }
  };

  const handleError = () => {
    setError("Login Failed");
    console.error("Login Failed");
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-100">
      <div className="bg-white p-8 rounded-lg shadow-md w-96">
        <h1 className="text-2xl font-bold text-center mb-6">
          Welcome to Nutri Meal
        </h1>
        <p className="text-gray-600 text-center mb-8">
          Sign in to access personalized meal recommendations
        </p>

        <div className="flex flex-col items-center gap-4">
          {error && <div className="text-red-500 text-sm mb-4">{error}</div>}
          <GoogleLogin
            onSuccess={handleSuccess}
            onError={handleError}
            useOneTap
            scope="email profile"
            cookiePolicy={"single_host_origin"}
          />

          <p className="text-sm text-gray-500 text-center mt-4">
            By signing in, you agree to our Terms of Service and Privacy Policy
          </p>
        </div>
      </div>
    </div>
  );
};

export default Auth;
