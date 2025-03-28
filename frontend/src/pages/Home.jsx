import React from "react";
import { Search, Utensils, Target, ActivitySquare, ChefHat } from "lucide-react";
import RecipeCard from "../components/RecipeCard";
import FunctionCard from "../components/FunctionCard";

const FUNCTION_CARDS = [
  {
    title: "Meal Suggestions",
    description: "Get personalized meal recommendations",
    icon: Utensils,
    path: "/meal-suggestion",
    color: "bg-primary",
  },
  {
    title: "Health Goals",
    description: "Set and track your health objectives",
    icon: Target,
    path: "/health-goals",
    color: "bg-secondary",
  },
  {
    title: "Progress Tracking",
    description: "Monitor your health journey",
    icon: ActivitySquare,
    path: "/health-progress",
    color: "bg-accent",
  },
  {
    title: "Recipe Details",
    description: "Explore detailed cooking instructions",
    icon: ChefHat,
    path: "/recipe/1",
    color: "bg-info",
  },
];

const RECIPE_CARDS = [
  {
    recipeId: 1,
    title: "Grilled Chicken",
    description: "Healthy grilled chicken breast",
    calories: "165",
    image: "/2.jpg",
    tags: ["Protein-rich", "Low-carb"],
  },
  {
    recipeId: 2,
    title: "Grilled Chicken Breast with Herbs",
    description: "Grilled chicken with fresh herbs",
    calories: "180",
    image: "/3.jpg",
    tags: ["Protein-rich", "Low-carb"],
  }
];

const Home = () => {
  return (
    <div className="min-h-screen p-10">
      <SearchBar />
      <QuickAccess />
      <RecommendedRecipes />
    </div>
  );
};

const SearchBar = () => (
  <form action="">
    <label htmlFor="" className="input shadow-md flex items-center gap-2">
      <Search size={24} />
      <input
        type="text"
        className="text-sm md:text-md grow"
        placeholder="What do you want to eat today?"
      />
    </label>
  </form>
);

const QuickAccess = () => (
  <div className="my-8">
    <h2 className="font-bold text-3xl mb-4">Quick Access</h2>
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
      {FUNCTION_CARDS.map((card, index) => (
        <FunctionCard key={index} {...card} />
      ))}
    </div>
  </div>
);

const RecommendedRecipes = () => (
  <>
    <p className="font-bold text-2xl md:text-3xl mt-8">Recommended for you</p>
    <p className="text-slate-500 font-semibold ml-1 my-2 text-sm tracking-tight">
      Choose from our wide range of meal options
    </p>
    <div className="grid gap-3 grid-cols-1 md:grid-cols-2 lg:grid-cols-4">
      {RECIPE_CARDS.map((recipe, index) => (
        <RecipeCard key={index} {...recipe} />
      ))}
    </div>
  </>
);

export default Home;
