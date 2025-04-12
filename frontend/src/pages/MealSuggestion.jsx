import React, { useState, useMemo, useEffect } from "react";
import { Search, PlusCircle, Calendar, LogIn, Clock, Coffee, UtensilsCrossed, ChefHat, ArrowLeft, ArrowRight } from "lucide-react";
import { Link } from "react-router-dom";
import RecipeCard from "../components/RecipeCard";
import { apiRequest } from '../utils/api';
import { useUser } from '../contexts/UserContext';

const DAYS_OF_WEEK = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday'
];

const MealSuggestion = () => {
  const { user } = useUser();
  const [weeklyPlan, setWeeklyPlan] = useState(false);
  const [dailyPlans, setDailyPlans] = useState({});
  const [mealPlans, setMealPlans] = useState({});
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [currentWeekOffset, setCurrentWeekOffset] = useState(0);

  const weekDates = useMemo(() => {
    const today = new Date();
    const currentDay = today.getDay();
    const diff = currentDay === 0 ? 6 : currentDay - 1;
    
    const monday = new Date(today);
    monday.setDate(today.getDate() - diff + (currentWeekOffset * 7));
    
    return DAYS_OF_WEEK.map((_, index) => {
      const date = new Date(monday);
      date.setDate(monday.getDate() + index);
      return date;
    });
  }, [currentWeekOffset]);

  const isToday = (date) => {
    const today = new Date();
    return date.toDateString() === today.toDateString();
  };

  const hasAnyDailyPlan = useMemo(() => {
    return Object.keys(dailyPlans).length > 0;
  }, [dailyPlans]);

  const isPlanningDisabled = useMemo(() => {
    return hasAnyDailyPlan || weeklyPlan;
  }, [hasAnyDailyPlan, weeklyPlan]);

  const getWeekRange = (dates) => {
    const start = dates[0];
    const end = dates[6];
    const formatDate = (date) => {
      return date.toLocaleDateString('en-US', { 
        month: 'short',
        day: 'numeric'
      });
    };
    return `${formatDate(start)} - ${formatDate(end)}`;
  };

  useEffect(() => {
    const fetchMealPlans = async () => {
      if (!user?._id) return;

      try {
        setLoading(true);
        const data = await apiRequest(`/meal-plans/user/${user._id}`);
        
        const planMap = data.reduce((acc, plan) => {
          // Convert API date to match our date format
          const planDate = new Date(plan.date).toDateString();
          acc[planDate] = {
            meals: plan.meal,
            recipes: plan.recipes
          };
          return acc;
        }, {});
        
        setMealPlans(planMap);
        setWeeklyPlan(Object.keys(planMap).length > 0);
      } catch (err) {
        setError('Failed to load meal plans');
        console.error('Error fetching meal plans:', err);
      } finally {
        setLoading(false);
      }
    };

    fetchMealPlans();
  }, [user]);

  const handleCreateDailyPlan = async (date) => {
    if (!user?._id) {
      setError('Please log in to create meal plans');
      return;
    }

    try {
      setLoading(true);
      const response = await apiRequest('/meal-plans', 'POST', {
        user_id: user._id,
        date: date.toISOString().split('T')[0]
      });

      setMealPlans(prev => ({
        ...prev,
        [date.toDateString()]: {
          meals: response.meal,
          recipes: response.recipes
        }
      }));

      setDailyPlans(prev => ({
        ...prev,
        [date.toDateString()]: true
      }));
    } catch (err) {
      setError('Failed to create meal plan');
      console.error('Error creating meal plan:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleCreateWeeklyPlan = async () => {
    if (!user?._id) {
      setError('Please log in to create meal plans');
      return;
    }

    try {
      setLoading(true);
      const weekPlans = await Promise.all(
        weekDates.map(date => 
          apiRequest('/meal-plans', 'POST', {
            user_id: user._id,
            date: date.toISOString().split('T')[0]
          })
        )
      );

      const newMealPlans = weekPlans.reduce((acc, plan) => {
        acc[new Date(plan.date).toDateString()] = {
          meals: plan.meal,
          recipes: plan.recipes
        };
        return acc;
      }, {});

      setMealPlans(prev => ({
        ...prev,
        ...newMealPlans
      }));
      setWeeklyPlan(true);
    } catch (err) {
      setError('Failed to create weekly meal plan');
      console.error('Error creating weekly meal plan:', err);
    } finally {
      setLoading(false);
    }
  };

  const renderContent = () => {
    if (!user) {
      return (
        <div className="card w-full bg-base-100 shadow-xl mb-8">
          <div className="card-body items-center text-center">
            <LogIn className="w-16 h-16 mx-auto text-primary" />
            <h2 className="card-title justify-center text-2xl mt-4">Login Required</h2>
            <p className="text-base-content/70 mb-4">
              Please log in to create and manage your meal plans
            </p>
            <Link to="/auth" className="btn btn-primary">
              Log In Now
            </Link>
          </div>
        </div>
      );
    }

    return (
      <>
        {error && (
          <div className="alert alert-error mb-4">
            <span>{error}</span>
          </div>
        )}

        <div className="mb-8">
          <div className="flex justify-between items-center mb-4">
            <div>
              <h1 className="text-3xl font-bold mb-2">
                Weekly Meal Plan
              </h1>
              <div className="flex items-center gap-2">
                <p className={`font-semibold text-sm tracking-tight ${
                  weeklyPlan ? 'text-slate-500' : hasAnyDailyPlan ? 'text-primary' : 'text-red-500'
                }`}>
                  {weeklyPlan 
                    ? "Your weekly meal plan is ready!" 
                    : hasAnyDailyPlan
                    ? "Complete your weekly plan by adding more days"
                    : "Plan your meals for the week or by day"}
                </p>
                <span className="text-sm text-base-content/50">•</span>
                <p className="text-sm text-base-content/70">
                  {getWeekRange(weekDates)}
                </p>
              </div>
            </div>

            <div className="flex items-center gap-4">
              <div className="flex gap-2">
                <button
                  onClick={() => setCurrentWeekOffset(prev => prev - 1)}
                  className="btn btn-ghost btn-sm"
                  title="Previous week"
                >
                  <ArrowLeft size={16} />
                </button>
                <button
                  onClick={() => setCurrentWeekOffset(0)}
                  className={`btn btn-ghost btn-sm ${currentWeekOffset === 0 ? 'btn-disabled' : ''}`}
                  title="Current week"
                >
                  Today
                </button>
                <button
                  onClick={() => setCurrentWeekOffset(prev => prev + 1)}
                  className="btn btn-ghost btn-sm"
                  title="Next week"
                >
                  <ArrowRight size={16} />
                </button>
              </div>

              <button
                onClick={handleCreateWeeklyPlan}
                disabled={isPlanningDisabled || loading}
                className={`btn gap-2 normal-case font-semibold ${
                  isPlanningDisabled || loading ? 'btn-disabled tooltip tooltip-left' : 'btn-primary'
                }`}
                data-tip={
                  weeklyPlan 
                    ? "Weekly plan is already set" 
                    : hasAnyDailyPlan 
                    ? "Clear daily plans to enable weekly planning" 
                    : ""
                }
              >
                {loading ? (
                  <span className="loading loading-spinner"></span>
                ) : (
                  <PlusCircle size={18} />
                )}
                Plan Entire Week
              </button>
            </div>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-7 gap-4 mb-8">
          {DAYS_OF_WEEK.map((day, index) => {
            const currentDate = weekDates[index];
            const dateString = currentDate.toDateString();
            const planForDay = mealPlans[dateString];
            const isCurrentDay = isToday(currentDate);
            
            return (
              <div 
                key={day} 
                className={`card ${
                  isCurrentDay 
                    ? 'bg-primary/5 border-2 border-primary shadow-lg' 
                    : 'bg-base-100 shadow-md'
                } hover:shadow-xl transition-all duration-300`}
              >
                <div className="card-body p-4">
                  <div className={`flex items-center justify-between mb-4 pb-2 border-b ${
                    isCurrentDay ? 'border-primary/20' : 'border-base-200'
                  }`}>
                    <div>
                      <h3 className={`card-title text-lg ${
                        isCurrentDay ? 'text-primary font-bold' : 'font-semibold'
                      }`}>
                        {day}
                      </h3>
                      <p className={`text-sm ${
                        isCurrentDay ? 'text-primary/70' : 'text-base-content/70'
                      }`}>
                        {currentDate.toLocaleDateString('en-US', { 
                          month: 'short', 
                          day: 'numeric',
                          year: 'numeric'
                        })}
                      </p>
                    </div>
                    <Calendar size={20} className={
                      isCurrentDay ? "text-primary" : "text-base-content/50"
                    } />
                  </div>
                  
                  {!planForDay ? (
                    <div className="flex flex-col items-center justify-center h-32">
                      <button
                        onClick={() => handleCreateDailyPlan(currentDate)}
                        disabled={loading}
                        className={`btn btn-outline ${
                          isCurrentDay ? 'btn-primary' : 'btn-ghost'
                        } btn-sm w-full gap-2`}
                      >
                        {loading ? (
                          <span className="loading loading-spinner"></span>
                        ) : (
                          <PlusCircle size={16} />
                        )}
                        Plan Meals
                      </button>
                    </div>
                  ) : (
                    <div className="space-y-3 overflow-hidden">
                      <div className="flex items-start gap-2 text-sm">
                        <Coffee className="w-4 h-4 text-primary flex-shrink-0 mt-1" />
                        <div className="flex-1">
                          <span className="text-base-content/70 block">Breakfast</span>
                          <Link 
                            to={`/recipe/${planForDay.recipes[0]}`}
                            className="font-medium break-words hover:text-primary transition-colors"
                          >
                            {planForDay.meals.Breakfast}
                          </Link>
                        </div>
                      </div>
                      <div className="flex items-start gap-2 text-sm">
                        <UtensilsCrossed className="w-4 h-4 text-primary flex-shrink-0 mt-1" />
                        <div className="flex-1">
                          <span className="text-base-content/70 block">Lunch</span>
                          <Link 
                            to={`/recipe/${planForDay.recipes[1]}`}
                            className="font-medium break-words hover:text-primary transition-colors"
                          >
                            {planForDay.meals.Lunch}
                          </Link>
                        </div>
                      </div>
                      <div className="flex items-start gap-2 text-sm">
                        <ChefHat className="w-4 h-4 text-primary flex-shrink-0 mt-1" />
                        <div className="flex-1">
                          <span className="text-base-content/70 block">Dinner</span>
                          <Link 
                            to={`/recipe/${planForDay.recipes[2]}`}
                            className="font-medium break-words hover:text-primary transition-colors"
                          >
                            {planForDay.meals.Dinner}
                          </Link>
                        </div>
                      </div>
                    </div>
                  )}
                </div>
              </div>
            );
          })}
        </div>
      </>
    );
  };

  return (
    <div className="min-h-screen p-10">
      <div className="max-w-7xl mx-auto">
        <h1 className="text-3xl font-bold mb-2">Meal Planning</h1>
        <p className="text-base-content/70 mb-8">Plan your meals for the week or discover new recipes</p>

        {renderContent()}

        {/* RandomSection is always visible */}
        <RandomSection />
      </div>
    </div>
  );
};

const RandomSection = () => {
  const [recipes, setRecipes] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchRandomRecipes = async () => {
      try {
        setLoading(true);
        const data = await apiRequest('/recipes?limit=3');
        
        const transformedRecipes = data.recipes.map(recipe => ({
          recipeId: recipe.id,
          title: recipe.name,
          description: recipe.instructions.slice(0, 100) + '...',
          calories: recipe.nutrition_info.calories,
          cookTime: recipe.preparationTime,
          image: recipe.image || '/2.jpg',
          tags: [recipe.category, recipe.difficulty].concat(recipe.allergens || [])
        }));

        setRecipes(transformedRecipes);
      } catch (err) {
        setError('Failed to load random recipes');
        console.error('Error fetching recipes:', err);
      } finally {
        setLoading(false);
      }
    };

    fetchRandomRecipes();
  }, []);

  return (
    <div>
      <h1 className="text-3xl font-bold mt-8 mb-8">Random Meal Suggestions</h1>
      {loading ? (
        <div className="grid gap-6 grid-cols-1 md:grid-cols-2 lg:grid-cols-3">
          {[1, 2, 3].map((_, index) => (
            <div key={index} className="card bg-base-100 shadow animate-pulse">
              <div className="h-48 bg-base-200 rounded-t-lg"></div>
              <div className="card-body">
                <div className="h-4 bg-base-200 rounded w-3/4"></div>
                <div className="h-3 bg-base-200 rounded w-1/2 mt-2"></div>
                <div className="flex gap-2 mt-4">
                  <div className="h-6 bg-base-200 rounded w-16"></div>
                  <div className="h-6 bg-base-200 rounded w-16"></div>
                </div>
              </div>
            </div>
          ))}
        </div>
      ) : error ? (
        <div className="alert alert-error">
          <span>{error}</span>
        </div>
      ) : (
        <div className="grid gap-6 grid-cols-1 md:grid-cols-2 lg:grid-cols-3">
          {recipes.map((recipe) => (
            <RecipeCard key={recipe.recipeId} {...recipe} />
          ))}
        </div>
      )}
    </div>
  );
};

export default MealSuggestion;
