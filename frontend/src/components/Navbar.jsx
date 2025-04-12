import React, { useState, useEffect } from "react";
import { Link, useNavigate, useLocation } from "react-router-dom";
import { useUser } from "../contexts/UserContext";
import {
  Menu,
  Search,
  Sun,
  Moon,
  Heart,
  LogOut,
  User,
  Home,
  Utensils,
  Target,
  Activity,
  Settings,
  Users,
  UtensilsCrossed,
  Clock,
} from "lucide-react";

const MEAL_TIMES = {
  breakfast: { hour: 7, minute: 0, label: "Breakfast" },
  lunch: { hour: 12, minute: 0, label: "Lunch" },
  dinner: { hour: 18, minute: 0, label: "Dinner" },
};

const Navbar = () => {
  const [theme, setTheme] = useState(
    localStorage.getItem("theme") || "lemonade"
  );
  const [isSearchOpen, setIsSearchOpen] = useState(false);
  const { user, signOut } = useUser();
  const navigate = useNavigate();
  const location = useLocation();
  const [nextMeal, setNextMeal] = useState(null);
  const [timeUntilMeal, setTimeUntilMeal] = useState("");
  const [showMealAlert, setShowMealAlert] = useState(false);

  const menuItems = [
    { path: "/", label: "Homepage", icon: Home },
    { path: "/meal-suggestion", label: "Meal Suggestions", icon: Utensils },
    { path: "/health-goals", label: "Health Goals", icon: Target },
    { path: "/health-progress", label: "Progress Tracking", icon: Activity },
    { path: "/community", label: "Community", icon: Users },
  ];

  useEffect(() => {
    document.documentElement.setAttribute("data-theme", theme);
    localStorage.setItem("theme", theme);
  }, [theme]);

  const handleThemeChange = () => {
    const newTheme = theme === "lemonade" ? "forest" : "lemonade";
    setTheme(newTheme);
  };

  const handleSignOut = async () => {
    try {
      await signOut();
      navigate("/");
    } catch (error) {
      console.error("Error signing out:", error);
    }
  };

  useEffect(() => {
    const checkMealTime = () => {
      const now = new Date();
      const currentHour = now.getHours();
      const currentMinute = now.getMinutes();

      Object.entries(MEAL_TIMES).forEach(([meal, time]) => {
        if (currentHour === time.hour && currentMinute === 0) {
          // Show message box when it's exactly meal time
          showNotification(time.label);
        }
      });

      // Find next meal
      let nextMealTime = null;
      let shortestDiff = Infinity;

      Object.entries(MEAL_TIMES).forEach(([meal, time]) => {
        const mealDate = new Date();
        mealDate.setHours(time.hour, time.minute, 0);

        if (mealDate < now) {
          mealDate.setDate(mealDate.getDate() + 1);
        }

        const diff = mealDate - now;
        if (diff < shortestDiff) {
          shortestDiff = diff;
          nextMealTime = { ...time, name: meal };
        }
      });

      if (nextMealTime) {
        setNextMeal(nextMealTime);
        const hours = Math.floor(shortestDiff / (1000 * 60 * 60));
        const minutes = Math.floor(
          (shortestDiff % (1000 * 60 * 60)) / (1000 * 60)
        );
        setTimeUntilMeal(`${hours}h ${minutes}m`);
      }
    };

    checkMealTime();
    const interval = setInterval(checkMealTime, 60000);
    return () => clearInterval(interval);
  }, []);

  const showNotification = (mealType) => {
    setShowMealAlert(true);
    setTimeout(() => setShowMealAlert(false), 10000); // Hide after 10 seconds
  };

  return (
    <>
      <div className="fixed top-0 left-0 right-0 z-50">
        {/* Meal Alert */}
        {showMealAlert && nextMeal && (
          <div className="alert alert-info shadow-lg max-w-md mx-auto mt-2">
            <UtensilsCrossed className="h-6 w-6" />
            <div>
              <h3 className="font-bold">Time for {nextMeal.label}!</h3>
              <div className="text-xs">Don't forget to eat healthy 🥗</div>
            </div>
            <button
              onClick={() => setShowMealAlert(false)}
              className="btn btn-sm btn-ghost"
            >
              Dismiss
            </button>
          </div>
        )}

        <div className="navbar bg-base-100 shadow-md px-4">
          {/* Navbar Start */}
          <div className="navbar-start">
            <div className="dropdown">
              <label
                tabIndex={0}
                className="btn btn-ghost btn-circle lg:hidden"
              >
                <Menu size={20} />
              </label>
              <ul
                tabIndex={0}
                className="menu menu-lg dropdown-content bg-base-200 rounded-box z-10 w-56 shadow-lg mt-2"
              >
                {menuItems.map((item) => (
                  <li key={item.path}>
                    <Link
                      to={item.path}
                      className={`flex items-center gap-2 ${
                        location.pathname === item.path ? "active" : ""
                      }`}
                    >
                      <item.icon size={18} />
                      {item.label}
                    </Link>
                  </li>
                ))}
              </ul>
            </div>
            <Link to="/" className="btn btn-ghost text-xl gap-2 normal-case">
              <Heart className="text-primary" />
              NutriMeal
            </Link>
          </div>

          {/* Navbar Center - Hidden on mobile */}
          <div className="navbar-center hidden lg:flex">
            <ul className="menu menu-horizontal gap-2">
              {menuItems.map((item) => (
                <li key={item.path}>
                  <Link
                    to={item.path}
                    className={`flex items-center gap-2 hover:bg-base-200 ${
                      location.pathname === item.path ? "bg-base-200" : ""
                    }`}
                  >
                    <item.icon size={18} />
                    {item.label}
                  </Link>
                </li>
              ))}
            </ul>
          </div>

          {/* Navbar End */}
          <div className="navbar-end gap-2">
            {/* Meal Time Indicator */}
            {nextMeal && (
              <div
                className="tooltip tooltip-bottom hidden md:flex items-center gap-2"
                data-tip={`Next meal (${nextMeal.label}) in ${timeUntilMeal}`}
              >
                <Clock className="text-primary" size={20} />
                <span className="text-sm font-medium">{nextMeal.label}</span>
              </div>
            )}

            {/* Search Toggle (Mobile) */}
            <button
              className="btn btn-ghost btn-circle md:hidden"
              onClick={() => setIsSearchOpen(!isSearchOpen)}
            >
              <Search size={20} />
            </button>

            {/* Theme Toggle */}
            <button
              className="btn btn-ghost btn-circle"
              onClick={handleThemeChange}
            >
              {theme === "lemonade" ? <Moon size={20} /> : <Sun size={20} />}
            </button>

            {/* User Menu */}
            {user ? (
              <div className="dropdown dropdown-end">
                <label tabIndex={0} className="btn btn-ghost btn-circle avatar">
                  <div className="w-10 rounded-full">
                    <img src={user.picture} alt="profile" />
                  </div>
                </label>
                <ul
                  tabIndex={0}
                  className="menu menu-sm dropdown-content mt-3 z-[1] p-2 shadow bg-base-200 rounded-box w-52"
                >
                  <li>
                    <Link to="/profile" className="flex items-center gap-2">
                      <User size={18} />
                      Profile
                    </Link>
                  </li>
                  <li>
                    <Link to="/settings" className="flex items-center gap-2">
                      <Settings size={18} />
                      Settings
                    </Link>
                  </li>
                  <div className="divider my-0"></div>
                  <li>
                    <button
                      onClick={handleSignOut}
                      className="flex items-center gap-2 bg-error/10 hover:bg-error/20 text-red-500 rounded-lg"
                    >
                      <LogOut size={18} />
                      Sign out
                    </button>
                  </li>
                </ul>
              </div>
            ) : (
              <Link to="/auth" className="btn btn-primary btn-sm">
                Sign In
              </Link>
            )}
          </div>
        </div>
      </div>

      {/* Push notifications if browser supports */}
      {nextMeal && Notification.permission === "granted" && (
        <div style={{ display: "none" }}>
          {setTimeout(() => {
            new Notification(`Time for ${nextMeal.label}!`, {
              body: "Don't forget to eat healthy 🥗",
              icon: "/favicon.ico",
            });
          }, 0)}
        </div>
      )}
    </>
  );
};

export default Navbar;
