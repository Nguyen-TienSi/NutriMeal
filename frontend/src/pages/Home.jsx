import React, { useState, useEffect } from "react";
import {
  Search,
  Utensils,
  Target,
  ActivitySquare,
  ChefHat,
  X,
  Loader2,
} from "lucide-react";
import RecipeCard from "../components/RecipeCard";
import FunctionCard from "../components/FunctionCard";
import TypewriterText from "../components/TypewriterText";
import { apiRequest } from "../utils/api";

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

const Home = () => {
  const [isSearchOpen, setIsSearchOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");
  const [aiResponse, setAiResponse] = useState(null);
  const [isLoading, setIsLoading] = useState(false);

  const handleSearch = async (e) => {
    e.preventDefault();
    if (!searchQuery.trim()) return;

    setIsLoading(true);
    setAiResponse(null);

    try {
      const response = await fetch("/api/ai/chat", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ query: searchQuery }),
      });

      if (!response.ok) {
        throw new Error("API not available");
      }

      const data = await response.json();
      setAiResponse(data.response);
    } catch (error) {
      console.error("AI API Error:", error);
      setAiResponse(
        "AI feature is still in development. Please try burger or pizza."
      );
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <>
      {/* Main content */}
      <div
        className={`min-h-screen p-10 relative ${
          isSearchOpen ? "blur-sm" : ""
        }`}
      >
        {/* <QuickAccess /> */}
        <RecommendedRecipes />
        <FloatingButton isOpen={isSearchOpen} setIsOpen={setIsSearchOpen} />
      </div>

      {/* Quick Search Modal  */}
      {isSearchOpen && (
        <div className="fixed inset-0 flex items-center justify-center p-4 z-50">
          <div className="bg-base-100/90 backdrop-blur-xl rounded-lg shadow-xl w-full max-w-2xl">
            <div className="p-4 flex justify-between items-center border-b">
              <h3 className="text-lg font-semibold">Nutri AI Assistant</h3>
              <button
                onClick={() => setIsSearchOpen(false)}
                className="btn btn-ghost btn-circle btn-sm"
              >
                <X size={20} />
              </button>
            </div>
            <div className="p-4">
              <form onSubmit={handleSearch} className="form-control">
                <label className="input input-bordered flex items-center gap-2">
                  <Search size={20} />
                  <input
                    type="text"
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.target.value)}
                    placeholder="Ask about nutrition, recipes, or meal plans..."
                    className="grow"
                    autoFocus
                  />
                </label>
              </form>

              {/* AI Response Area */}
              {(isLoading || aiResponse) && (
                <div className="mt-6 p-4 bg-base-200 rounded-lg">
                  {isLoading ? (
                    <div className="flex items-center gap-2 text-base-content/70">
                      <Loader2 className="animate-spin" size={20} />
                      <span>Thinking...</span>
                    </div>
                  ) : (
                    <div className="prose">
                      <TypewriterText text={aiResponse} speed={30} />
                    </div>
                  )}
                </div>
              )}

              {/* suggest Searches */}
              <div className="mt-4">
                <h4 className="text-sm font-semibold text-base-content/70 mb-2">
                  Suggested Questions
                </h4>
                <div className="flex flex-wrap gap-2">
                  {[
                    "Healthy breakfast ideas",
                    "Best foods for weight loss",
                    "Quick protein recipes",
                  ].map((term) => (
                    <button
                      key={term}
                      className="btn btn-sm btn-ghost"
                      onClick={() => {
                        setSearchQuery(term);
                        handleSearch({ preventDefault: () => {} });
                      }}
                    >
                      {term}
                    </button>
                  ))}
                </div>
              </div>
            </div>
          </div>
        </div>
      )}
    </>
  );
};

const FloatingButton = ({ isOpen, setIsOpen }) => (
  <div className="fixed bottom-12 right-6 flex flex-col gap-4">
    <button
      onClick={() => setIsOpen(true)}
      className="btn btn-primary shadow-lg hover:shadow-xl rounded-full px-6"
      title="AI & Quick Search"
    >
      <div className="flex items-center gap-2">
        <Search size={20} />
        <span className="font-medium">NUTRI AI</span>
      </div>
    </button>
  </div>
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

// Update the RecommendedRecipes component
const RecommendedRecipes = () => {
  const [recipes, setRecipes] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchRecommendedRecipes = async () => {
      try {
        setLoading(true);
        const data = await apiRequest("/recipes?limit=8");

        // Transform recipe data to match RecipeCard props
        const transformedRecipes = data.recipes.map((recipe) => ({
          recipeId: recipe.id,
          title: recipe.name,
          description: recipe.instructions.slice(0, 100) + "...",
          calories: recipe.nutrition_info.calories,
          cookTime: recipe.preparationTime,
          image: recipe.image || "/2.jpg",
          tags: [recipe.category, recipe.difficulty].concat(
            recipe.allergens || []
          ),
        }));

        setRecipes(transformedRecipes);
      } catch (err) {
        setError("Failed to load recommended recipes");
        console.error("Error fetching recipes:", err);
      } finally {
        setLoading(false);
      }
    };

    fetchRecommendedRecipes();
  }, []);

  return (
    <>
      <p className="font-bold text-2xl md:text-3xl mt-8">Recommended for you</p>
      <p className="text-slate-500 font-semibold ml-1 my-2 text-sm tracking-tight">
        Choose from our wide range of meal options
      </p>
      <div className="grid gap-3 grid-cols-1 md:grid-cols-2 lg:grid-cols-4">
        {loading ? (
          Array(8)
            .fill(0)
            .map((_, index) => (
              <div
                key={index}
                className="card bg-base-100 shadow animate-pulse"
              >
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
            ))
        ) : error ? (
          <div className="col-span-full">
            <div className="alert alert-error">
              <span>{error}</span>
            </div>
          </div>
        ) : (
          recipes.map((recipe) => (
            <RecipeCard key={recipe.recipeId} {...recipe} />
          ))
        )}
      </div>
    </>
  );
};

export default Home;
