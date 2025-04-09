import React, { createContext, useContext, useState, useEffect } from 'react';
import { apiRequest } from '../utils/api';

const UserContext = createContext();

export const UserProvider = ({ children }) => {
  const [user, setUser] = useState(() => {
    try {
      const savedUser = localStorage.getItem('user');
      return savedUser ? JSON.parse(savedUser) : null;
    } catch (error) {
      console.error('Error parsing user from localStorage:', error);
      return null;
    }
  });

  useEffect(() => {
    if (user) {
      localStorage.setItem('user', JSON.stringify(user));
    }
  }, [user]);

  const signIn = (userData) => {
    if (!userData._id) {
      console.error('User data missing _id:', userData);
      return;
    }
    setUser(userData);
    localStorage.setItem('user', JSON.stringify(userData));
  };

  const signOut = async () => {
    try {
      await apiRequest('/auth/signout', 'POST');
      setUser(null);
      localStorage.removeItem('user');
    } catch (error) {
      console.error('Failed to sign out:', error);
      // Still clear local state even if API call fails
      setUser(null);
      localStorage.removeItem('user');
    }
  };

  return (
    <UserContext.Provider value={{ user, signIn, signOut }}>
      {children}
    </UserContext.Provider>
  );
};

export const useUser = () => {
  const context = useContext(UserContext);
  if (!context) {
    throw new Error('useUser must be used within a UserProvider');
  }
  return context;
};