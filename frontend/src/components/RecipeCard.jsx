import React from "react";
import { Link } from "react-router-dom";
import { HeartPulse, Soup, Info, Clock } from "lucide-react";

const RecipeCard = ({
  recipeId = 1,
  title = "Recipe Title",
  description = "Recipe description",
  calories = "000",
  cookTime = "30 min",
  image = "/1.jpg",
  tags = ["Healthy", "Quick"],
}) => {
  return (
    <div className="group card bg-base-100 shadow-xl hover:shadow-2xl transition-all duration-300">
      <figure className="relative aspect-[4/3] overflow-hidden">
        <img
          src={image}
          alt={title}
          className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
        />
        {/* ovenlay gradient */}
        <div className="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300" />

        {/* recipe info badges */}
        <div className="absolute bottom-3 left-3 flex gap-2">
          <div className="badge badge-primary gap-1">
            <Soup size={14} /> {calories} cal
          </div>
          <div className="badge badge-secondary gap-1">
            <Clock size={14} /> {cookTime}
          </div>
        </div>

        {/* details buton */}
        <Link
          to={`/recipe/${recipeId}`}
          className="absolute top-3 right-3 btn btn-circle btn-sm bg-base-100/80 backdrop-blur-sm hover:bg-base-100"
          title="View recipe details"
        >
          <Info size={16} />
        </Link>
      </figure>

      <div className="card-body p-4">
        <h2 className="card-title text-lg font-bold tracking-tight line-clamp-1">
          {title}
        </h2>
        <p className="text-sm text-base-content/70 line-clamp-2 mb-3">
          {description}
        </p>
        <div className="flex flex-wrap gap-2">
          {tags.map((tag, index) => (
            <div key={index} className="badge badge-outline gap-1 text-xs">
              <HeartPulse size={12} />
              {tag}
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default RecipeCard;
