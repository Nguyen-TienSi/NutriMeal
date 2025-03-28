import React, { useState } from "react";
import {
  Search,
  Apple,
  Leaf,
  Weight,
  Timer,
  Soup,
  ChefHat,
  Info,
} from "lucide-react";

const RecipeDetails = () => {
  const [searchTerm, setSearchTerm] = useState("");
  const [activeTab, setActiveTab] = useState("nutrition");

  const foodData = [
    {
      id: 1,
      name: "Grilled Chicken Breast",
      category: "Protein",
      image: "/chicken-breast.jpg",
      nutrition: {
        calories: 165,
        protein: 31,
        carbs: 0,
        fat: 3.6,
        serving: "100g",
      },
      ingredients: [
        { name: "Chicken Breast", amount: "200g" },
        { name: "Olive Oil", amount: "1 tbsp" },
        { name: "Salt", amount: "1/2 tsp" },
        { name: "Black Pepper", amount: "1/4 tsp" },
      ],
      instructions: [
        "Preheat the grill to medium-high heat",
        "Brush chicken with olive oil",
        "Season with salt and pepper",
        "Grill for 6-8 minutes per side",
        "Let rest for 5 minutes before serving",
      ],
      tips: "Best grilled or baked",
      preparationTime: "20-30 min",
      difficulty: "Easy",
      allergens: ["None"],
    },
  ];

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

  return (
    <div className="min-h-screen p-10">
      <div className="max-w-6xl mx-auto">
        <h1 className="text-3xl font-bold mb-8 flex items-center gap-2">
          <Apple className="h-8 w-8" />
          Food Information
        </h1>
        {/* Search Bar */}
        <div className="form-control mb-8">
          <label className="input input-bordered flex items-center gap-2">
            <Search className="w-6 h-6" />
            <input
              type="text"
              className="grow"
              placeholder="Search recipes..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
            />
          </label>
        </div>

        {renderTabs()}

        {/* Food Cards */}
        <div className="grid grid-cols-1 gap-6">
          {foodData.map((food) => (
            <div key={food.id} className="card bg-base-100 shadow-xl">
              <div className="card-body">
                <div className="flex justify-between items-start">
                  <h2 className="card-title text-2xl">
                    {food.name}
                    <span className="badge badge-primary">{food.category}</span>
                  </h2>
                  <div className="flex items-center gap-2">
                    <Timer className="w-4 h-4" />
                    <span>{food.preparationTime}</span>
                    <span className="badge badge-outline">
                      {food.difficulty}
                    </span>
                  </div>
                </div>

                {activeTab === "nutrition" ? (
                  <div className="grid grid-cols-2 md:grid-cols-4 gap-4 my-4">
                    <div className="stat bg-base-200 rounded-lg p-2">
                      <div className="stat-title text-xs">Calories</div>
                      <div className="stat-value text-lg">
                        {food.nutrition.calories}
                      </div>
                      <div className="stat-desc">
                        per {food.nutrition.serving}
                      </div>
                    </div>
                    <div className="stat bg-base-200 rounded-lg p-2">
                      <div className="stat-title text-xs">Protein</div>
                      <div className="stat-value text-lg">
                        {food.nutrition.protein}g
                      </div>
                      <div className="stat-desc">
                        per {food.nutrition.serving}
                      </div>
                    </div>
                    <div className="stat bg-base-200 rounded-lg p-2">
                      <div className="stat-title text-xs">Carbs</div>
                      <div className="stat-value text-lg">
                        {food.nutrition.carbs}g
                      </div>
                      <div className="stat-desc">
                        per {food.nutrition.serving}
                      </div>
                    </div>
                    <div className="stat bg-base-200 rounded-lg p-2">
                      <div className="stat-title text-xs">Fat</div>
                      <div className="stat-value text-lg">
                        {food.nutrition.fat}g
                      </div>
                      <div className="stat-desc">
                        per {food.nutrition.serving}
                      </div>
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
                        {food.ingredients.map((ingredient, index) => (
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
                      <ol className="list-decimal pl-5">
                        {food.instructions.map((step, index) => (
                          <li key={index} className="mb-2">
                            {step}
                          </li>
                        ))}
                      </ol>
                    </div>

                    {food.allergens.length > 0 && (
                      <div className="alert alert-warning">
                        <Info className="w-4 h-4" />
                        <span>Allergens: {food.allergens.join(", ")}</span>
                      </div>
                    )}

                    <div className="mt-4 p-4 bg-base-200 rounded-lg">
                      <h3 className="font-semibold mb-2">Chef's Tips</h3>
                      <p>{food.tips}</p>
                    </div>
                  </div>
                )}
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default RecipeDetails;
