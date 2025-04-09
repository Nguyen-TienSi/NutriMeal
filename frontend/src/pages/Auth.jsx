import React, { useState } from "react";
import { GoogleLogin } from "@react-oauth/google";
import * as jwtDecode from "jwt-decode";
import { useNavigate } from "react-router-dom";
import { useUser } from "../contexts/UserContext";
import { apiRequest } from "../utils/api";
import { AlertCircle } from "lucide-react";

const Auth = () => {
  const [activeTab, setActiveTab] = useState("signin");
  const [error, setError] = useState(null);
  const navigate = useNavigate();
  const { signIn } = useUser();

  const handleGoogleSignIn = async (userData) => {
    try {
      const response = await apiRequest('/auth/signin', 'POST', {
        email: userData.email
      });
      
      signIn({
        _id: response._id,
        email: response.email,
        name: response.name,
        picture: response.picture,
      });

      navigate("/");
    } catch (err) {
      if (err.message === 'User not found') {
        setError("Account not found. Please sign up first.");
        setActiveTab("signup");
      } else {
        throw err;
      }
    }
  };

  const handleGoogleSignUp = async (userData) => {
    try {
      const response = await apiRequest('/auth/signup', 'POST', userData);
      
      signIn({
        _id: response._id,
        email: response.email,
        name: response.name,
        picture: response.picture,
      });

      navigate("/");
    } catch (err) {
      if (err.message === 'Email already exists') {
        setError("Account already exists. Please sign in.");
        setActiveTab("signin");
      } else {
        throw err;
      }
    }
  };

  const handleGoogleSuccess = async (credentialResponse) => {
    try {
      const details = jwtDecode.jwtDecode(credentialResponse.credential);
      
      const userData = {
        email: details.email,
        name: details.name,
        picture: details.picture || details.picture_url,
      };

      if (activeTab === "signin") {
        await handleGoogleSignIn(userData);
      } else {
        await handleGoogleSignUp(userData);
      }
    } catch (err) {
      console.error('Authentication failed:', err);
      setError(err.message || "Failed to authenticate. Please try again.");
    }
  };

  const handleGoogleError = () => {
    setError("Login Failed");
    console.error("Login Failed");
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-base-200">
      <div className="card bg-base-100 shadow-xl w-96">
        <div className="card-body">
          <h1 className="card-title text-2xl font-bold text-center justify-center mb-2">
            Welcome to Nutri Meal
          </h1>

          {/* Tabs */}
          <div className="tabs tabs-boxed mb-6">
            <button
              className={`tab flex-1 ${activeTab === "signin" ? "tab-active" : ""}`}
              onClick={() => setActiveTab("signin")}
            >
              Sign In
            </button>
            <button
              className={`tab flex-1 ${activeTab === "signup" ? "tab-active" : ""}`}
              onClick={() => setActiveTab("signup")}
            >
              Sign Up
            </button>
          </div>

          <p className="text-center text-base-content/70 mb-6">
            {activeTab === "signin" 
              ? "Sign in with your account" 
              : "Create a new account"}
          </p>

          {/* Error Message */}
          {error && (
            <div className="alert alert-error mb-4">
              <AlertCircle size={16} />
              <span>{error}</span>
            </div>
          )}

          {/* Google Login */}
          <div className="flex justify-center">
            <GoogleLogin
              onSuccess={handleGoogleSuccess}
              onError={handleGoogleError}
              useOneTap
              scope="email profile"
              cookiePolicy={"single_host_origin"}
            />
          </div>

          {/* Terms */}
          <p className="text-xs text-center text-base-content/70 mt-4">
            By continuing, you agree to our{" "}
            <a href="/terms" className="link">Terms of Service</a> and{" "}
            <a href="/privacy" className="link">Privacy Policy</a>
          </p>
        </div>
      </div>
    </div>
  );
};

export default Auth;
