import React, { useState } from "react";
import { Search } from "lucide-react";
import RecipeCard from "../components/RecipeCard";

const MealSuggestion = () => {
  const [filters, setFilters] = useState({
    diet: "",
    cuisine: "",
    mealType: "",
  });

  const dietTypes = ["Vegetarian", "Vegan", "Keto", "Paleo", "Low-Carb"];
  const cuisineTypes = ["Italian", "Chinese", "Japanese", "Mexican", "Indian"];
  const mealTypes = ["Breakfast", "Lunch", "Dinner", "Snack"];

  const handleFilterChange = (type, value) => {
    setFilters((prev) => ({ ...prev, [type]: value }));
  };

  return (
    <div className="min-h-screen p-10">
      <h1 className="text-3xl font-bold mb-8">Get Personalized Meal Suggestions</h1>

      {/* Filters */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
        <select
          className="select select-bordered w-full"
          value={filters.diet}
          onChange={(e) => handleFilterChange("diet", e.target.value)}
        >
          <option value="">Select Diet Type</option>
          {dietTypes.map((diet) => (
            <option key={diet} value={diet.toLowerCase()}>
              {diet}
            </option>
          ))}
        </select>

        <select
          className="select select-bordered w-full"
          value={filters.cuisine}
          onChange={(e) => handleFilterChange("cuisine", e.target.value)}
        >
          <option value="">Select Cuisine</option>
          {cuisineTypes.map((cuisine) => (
            <option key={cuisine} value={cuisine.toLowerCase()}>
              {cuisine}
            </option>
          ))}
        </select>

        <select
          className="select select-bordered w-full"
          value={filters.mealType}
          onChange={(e) => handleFilterChange("mealType", e.target.value)}
        >
          <option value="">Select Meal Type</option>
          {mealTypes.map((meal) => (
            <option key={meal} value={meal.toLowerCase()}>
              {meal}
            </option>
          ))}
        </select>
      </div>

      {/* Search Bar */}
      <form className="mb-8">
        <label htmlFor="search" className="input input-bordered shadow-md flex items-center gap-2">
          <Search size={24} />
          <input
            id="search"
            type="text"
            className="grow"
            placeholder="Search ingredients or recipes..."
          />
        </label>
      </form>

      {/* Results Section */}
      <div className="grid gap-6 grid-cols-1 md:grid-cols-2 lg:grid-cols-3">
        <RecipeCard />
        <RecipeCard />
        <RecipeCard />
        <RecipeCard />
        <RecipeCard />
        <RecipeCard />
      </div>
    </div>
  );
};

export default MealSuggestion;