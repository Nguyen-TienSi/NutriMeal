import React from "react";
import { Routes, Route } from "react-router-dom";
import Navbar from "./components/Navbar";
import Footer from "./components/Footer";
import Home from "./pages/Home";
import Test from "./pages/Test";
import Privacy from './pages/Privacy';
import Auth from './pages/Auth';
import { GoogleOAuthProvider } from '@react-oauth/google';
import { UserProvider } from './contexts/UserContext';
import MealSuggestion from './pages/MealSuggestion';
import HealthGoals from './pages/HealthGoals';
import HealthProgress from './pages/HealthProgress';
import RecipeDetails from './pages/RecipeDetails';
import NotFound from './pages/NotFound';
import Profile from './pages/Profile';

function App() {
  const clientId = import.meta.env.VITE_GOOGLE_CLIENT_ID;

  if (!clientId) {
    console.error('Google Client ID is not defined');
    return <div>Configuration Error: Google Client ID is missing</div>;
  }

  return (
    <GoogleOAuthProvider clientId={clientId}>
      <UserProvider>
        <div className="min-h-screen flex flex-col">
          <Navbar />
          <div className="flex-1 content">
            <Routes>
              <Route path="/" exact element={<Home />} />
              <Route path="/test" element={<Test />} />
              <Route path="/privacy" element={<Privacy />} />
              <Route path="/auth" element={<Auth />} />
              <Route path="/meal-suggestion" element={<MealSuggestion />} />
              <Route path="/health-goals" element={<HealthGoals />} />
              <Route path="/health-progress" element={<HealthProgress />} />
              <Route path="/recipe/:id" element={<RecipeDetails />} />
              <Route path="/profile" element={<Profile />} />
              <Route path="*" element={<NotFound />} />
            </Routes>
          </div>
          <Footer />
        </div>
      </UserProvider>
    </GoogleOAuthProvider>
  );
}

export default App;
