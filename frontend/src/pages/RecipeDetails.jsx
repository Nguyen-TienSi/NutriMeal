import React, { useState, useEffect } from "react";
import { useParams } from "react-router-dom";
import { Search, Apple, Weight, Timer, Soup, ChefHat, Info, Loader2, PlusCircle } from "lucide-react";
import { apiRequest } from '../utils/api';
import { useUser } from '../contexts/UserContext';

const RecipeDetails = () => {
  const { user } = useUser();
  const { id } = useParams();
  const [recipe, setRecipe] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [activeTab, setActiveTab] = useState("nutrition");
  const [mealTime, setMealTime] = useState("Breakfast");
  const [isLogging, setIsLogging] = useState(false);

  useEffect(() => {
    const fetchRecipe = async () => {
      try {
        setLoading(true);
        const data = await apiRequest(`/recipes/${id}`);
        setRecipe(data);
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchRecipe();
  }, [id]);

  const renderTabs = () => (
    <div className="tabs tabs-boxed mb-8">
      <button
        className={`tab ${activeTab === "nutrition" ? "tab-active" : ""}`}
        onClick={() => setActiveTab("nutrition")}
      >
        <Weight className="w-4 h-4 mr-2" />
        Nutrition
      </button>
      <button
        className={`tab ${activeTab === "cooking" ? "tab-active" : ""}`}
        onClick={() => setActiveTab("cooking")}
      >
        <ChefHat className="w-4 h-4 mr-2" />
        Cooking Guide
      </button>
    </div>
  );

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <Loader2 className="animate-spin h-8 w-8" />
      </div>
    );
  }

  if (error) {
    return (
      <div className="min-h-screen p-10">
        <div className="alert alert-error max-w-2xl mx-auto">
          <Info className="w-6 h-6" />
          <span>Failed to load recipe: {error}</span>
        </div>
      </div>
    );
  }

  if (!recipe) {
    return (
      <div className="min-h-screen p-10">
        <div className="alert alert-warning max-w-2xl mx-auto">
          <Info className="w-6 h-6" />
          <span>Recipe not found</span>
        </div>
      </div>
    );
  }

  const handleLogMeal = async () => {
    if (!user) {
      alert("Please log in to track meals");
      return;
    }

    try {
      setIsLogging(true);
      const today = new Date().toISOString().split('T')[0];

      const foodLog = {
        user_id: user._id,
        food_name: recipe.name,
        calories: recipe.nutrition_info.calories,
        protein: recipe.nutrition_info.protein,
        carbs: recipe.nutrition_info.carbs,
        fat: recipe.nutrition_info.fat,
        meal_time: mealTime,
        date: today,
        food_id: recipe.id
      };

      await apiRequest('/food-logs', 'POST', foodLog);
      alert("Meal logged successfully!");
    } catch (err) {
      console.error("Error logging meal:", err);
      alert("Failed to log meal");
    } finally {
      setIsLogging(false);
    }
  };

  return (
    <div className="min-h-screen p-10">
      <div className="max-w-6xl mx-auto">
        <div className="mb-8">
          <h1 className="text-3xl font-bold mb-2 flex items-center gap-2">
            <Apple className="h-8 w-8" />
            {recipe.name}
          </h1>
          <div className="flex items-center gap-4">
            <span className="badge badge-primary">{recipe.category}</span>
            <div className="flex items-center gap-2">
              <Timer className="w-4 h-4" />
              <span>{recipe.preparationTime}</span>
            </div>
            <span className="badge badge-outline">{recipe.difficulty}</span>
          </div>
        </div>

        {renderTabs()}

        <div className="card bg-base-100 shadow-xl">
          <div className="card-body">
            {activeTab === "nutrition" ? (
              <div className="grid grid-cols-2 md:grid-cols-4 gap-4 my-4">
                <div className="stat bg-base-200 rounded-lg p-2">
                  <div className="stat-title text-xs">Calories</div>
                  <div className="stat-value text-lg">
                    {recipe.nutrition_info.calories}
                  </div>
                  <div className="stat-desc">per serving</div>
                </div>
                <div className="stat bg-base-200 rounded-lg p-2">
                  <div className="stat-title text-xs">Protein</div>
                  <div className="stat-value text-lg">
                    {recipe.nutrition_info.protein}g
                  </div>
                  <div className="stat-desc">per serving</div>
                </div>
                <div className="stat bg-base-200 rounded-lg p-2">
                  <div className="stat-title text-xs">Carbs</div>
                  <div className="stat-value text-lg">
                    {recipe.nutrition_info.carbs}g
                  </div>
                  <div className="stat-desc">per serving</div>
                </div>
                <div className="stat bg-base-200 rounded-lg p-2">
                  <div className="stat-title text-xs">Fat</div>
                  <div className="stat-value text-lg">
                    {recipe.nutrition_info.fat}g
                  </div>
                  <div className="stat-desc">per serving</div>
                </div>
              </div>
            ) : (
              <div className="mt-4">
                <div className="mb-6">
                  <h3 className="text-lg font-semibold mb-2 flex items-center gap-2">
                    <Soup className="w-4 h-4" />
                    Ingredients
                  </h3>
                  <ul className="list-disc pl-5">
                    {recipe.ingredients.map((ingredient, index) => (
                      <li key={index} className="mb-1">
                        {ingredient.name} - {ingredient.amount}
                      </li>
                    ))}
                  </ul>
                </div>

                <div className="mb-6">
                  <h3 className="text-lg font-semibold mb-2 flex items-center gap-2">
                    <ChefHat className="w-4 h-4" />
                    Cooking Instructions
                  </h3>
                  <p className="whitespace-pre-wrap">{recipe.instructions}</p>
                </div>

                {recipe.allergens?.length > 0 && (
                  <div className="alert alert-warning">
                    <Info className="w-4 h-4" />
                    <span>Allergens: {recipe.allergens.join(", ")}</span>
                  </div>
                )}

                {recipe.tips && (
                  <div className="mt-4 p-4 bg-base-200 rounded-lg">
                    <h3 className="font-semibold mb-2">Chef's Tips</h3>
                    <p>{recipe.tips}</p>
                  </div>
                )}
              </div>
            )}
          </div>
        </div>

        <div className="card bg-base-100 shadow-xl mt-8">
          <div className="card-body">
            <h3 className="card-title text-lg mb-4">I just finished eating it.</h3>
            <div className="flex items-center gap-4">
              <select 
                value={mealTime}
                onChange={(e) => setMealTime(e.target.value)}
                className="select select-bordered"
              >
                <option value="Breakfast">Breakfast</option>
                <option value="Lunch">Lunch</option>
                <option value="Dinner">Dinner</option>
                {/* <option value="Snack">Snack</option> */}
              </select>
              <button
                onClick={handleLogMeal}
                disabled={isLogging}
                className="btn btn-primary gap-2"
              >
                {isLogging ? (
                  <Loader2 className="animate-spin" size={20} />
                ) : (
                  <PlusCircle size={20} />
                )}
                Log Meal
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default RecipeDetails;
