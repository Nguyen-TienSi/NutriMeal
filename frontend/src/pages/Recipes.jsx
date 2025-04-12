import React, { useState, useEffect, useCallback } from 'react';
import { Search, Filter, Loader2 } from 'lucide-react';
import { apiRequest } from '../utils/api';
import RecipeCard from '../components/RecipeCard';
import debounce from 'lodash/debounce';

const Recipes = () => {
  const [recipes, setRecipes] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [page, setPage] = useState(1);
  const [totalPages, setTotalPages] = useState(0);
  const [category, setCategory] = useState('');
  const [searchQuery, setSearchQuery] = useState('');
  const [allRecipes, setAllRecipes] = useState([]);

  const fetchRecipes = async () => {
    try {
      setLoading(true);
      const data = await apiRequest(`/recipes?page=${page}&limit=8`);
      
      // Transform recipe data to match RecipeCard props
      const transformedRecipes = data.recipes.map(recipe => ({
        recipeId: recipe.id,
        title: recipe.name,
        description: recipe.instructions.slice(0, 100) + '...',
        calories: recipe.nutrition_info.calories,
        cookTime: recipe.preparationTime,
        image: recipe.image || '/2.jpg',
        tags: [recipe.category, recipe.difficulty].concat(recipe.allergens || [])
      }));

      // Apply frontend filtering
      let filteredRecipes = transformedRecipes;
      
      // Filter by category
      if (category) {
        filteredRecipes = filteredRecipes.filter(recipe => 
          recipe.tags.includes(category)
        );
      }

      // Filter by search query
      if (searchQuery) {
        const query = searchQuery.toLowerCase();
        filteredRecipes = filteredRecipes.filter(recipe =>
          recipe.title.toLowerCase().includes(query)
        );
      }

      setRecipes(filteredRecipes);
      setTotalPages(Math.ceil(filteredRecipes.length / 8));
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  // Cache all recipes for frontend filtering
  useEffect(() => {
    const fetchAllRecipes = async () => {
      try {
        const data = await apiRequest('/recipes');
        const transformed = data.recipes.map(recipe => ({
          recipeId: recipe.id,
          title: recipe.name,
          description: recipe.instructions.slice(0, 100) + '...',
          calories: recipe.nutrition_info.calories,
          cookTime: recipe.preparationTime,
          image: recipe.image || '/2.jpg',
          tags: [recipe.category, recipe.difficulty].concat(recipe.allergens || [])
        }));
        setAllRecipes(transformed);
      } catch (err) {
        setError(err.message);
      }
    };
    fetchAllRecipes();
  }, []);

  // Handle frontend filtering
  useEffect(() => {
    if (allRecipes.length === 0) return;

    let filtered = [...allRecipes];

    // Apply category filter
    if (category) {
      filtered = filtered.filter(recipe => 
        recipe.tags.includes(category)
      );
    }

    // Apply search filter
    if (searchQuery) {
      const query = searchQuery.toLowerCase();
      filtered = filtered.filter(recipe =>
        recipe.title.toLowerCase().includes(query)
      );
    }

    // Apply pagination
    const startIndex = (page - 1) * 8;
    const paginatedRecipes = filtered.slice(startIndex, startIndex + 8);

    setRecipes(paginatedRecipes);
    setTotalPages(Math.ceil(filtered.length / 8));
  }, [page, category, searchQuery, allRecipes]);

  // Debounced search function
  const debouncedSearch = useCallback(
    debounce((query) => {
      setPage(1); // Reset to first page when searching
      setSearchQuery(query);
    }, 500),
    []
  );

  // Handle search input
  const handleSearchChange = (e) => {
    const query = e.target.value;
    // Update input value immediately for UI
    e.target.value = query;
    // Debounce the actual search
    debouncedSearch(query);
  };

  // Handle category filter
  const handleCategoryChange = (selectedCategory) => {
    setPage(1); // Reset to first page when filtering
    setCategory(selectedCategory);
  };

  // Clear all filters
  const handleClearFilters = () => {
    setSearchQuery('');
    setCategory('');
    setPage(1);
  };

  useEffect(() => {
    fetchRecipes();
    // Cleanup debounced function
    return () => debouncedSearch.cancel();
  }, [page, category, searchQuery]);

  return (
    <div className="min-h-screen p-10">
      <div className="max-w-7xl mx-auto">
        <div className="flex justify-between items-start mb-8">
          <div>
            <h1 className="text-3xl font-bold mb-2">Recipe Database</h1>
            <p className="text-base-content/70">
              Discover healthy and delicious recipes
            </p>
          </div>

          {/* Search and Filter */}
          <div className="flex gap-4">
            <div className="form-control">
              <label className="input input-bordered flex items-center gap-2">
                <Search size={20} />
                <input
                  type="text"
                  placeholder="Search recipes..."
                  defaultValue={searchQuery}
                  onChange={handleSearchChange}
                  className="grow"
                />
              </label>
            </div>

            <div className="dropdown dropdown-end">
              <label tabIndex={0} className="btn btn-outline gap-2">
                <Filter size={20} />
                {category || 'All Categories'}
              </label>
              <ul tabIndex={0} className="dropdown-content z-[1] menu p-2 shadow bg-base-100 rounded-box w-52">
                <li>
                  <button 
                    onClick={() => handleCategoryChange('')}
                    className={!category ? 'active' : ''}
                  >
                    All Categories
                  </button>
                </li>
                {['Protein', 'Carbs', 'Legumes'].map(cat => (
                  <li key={cat}>
                    <button 
                      onClick={() => handleCategoryChange(cat)}
                      className={category === cat ? 'active' : ''}
                    >
                      {cat}
                    </button>
                  </li>
                ))}
              </ul>
            </div>

            {/* Add clear filters button */}
            {(category || searchQuery) && (
              <button
                onClick={handleClearFilters}
                className="btn btn-ghost btn-sm"
              >
                Clear Filters
              </button>
            )}
          </div>
        </div>

        {/* Show active filters */}
        {(category || searchQuery) && (
          <div className="flex gap-2 mb-4">
            <span className="text-sm text-base-content/70">Active filters:</span>
            {category && (
              <span className="badge badge-primary">
                Category: {category}
              </span>
            )}
            {searchQuery && (
              <span className="badge badge-primary">
                Search: {searchQuery}
              </span>
            )}
          </div>
        )}

        {loading ? (
          <div className="flex justify-center items-center h-64">
            <Loader2 className="animate-spin" size={40} />
          </div>
        ) : error ? (
          <div className="alert alert-error">
            <span>{error}</span>
          </div>
        ) : (
          <>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
              {recipes.map((recipe) => (
                <RecipeCard 
                  key={recipe.recipeId} 
                  {...recipe} 
                />
              ))}
            </div>

            {/* Pagination */}
            {totalPages > 1 && (
              <div className="flex justify-center mt-8">
                <div className="join">
                  <button
                    className="join-item btn"
                    onClick={() => setPage(p => Math.max(1, p - 1))}
                    disabled={page === 1}
                  >
                    «
                  </button>
                  <button className="join-item btn">Page {page}</button>
                  <button
                    className="join-item btn"
                    onClick={() => setPage(p => Math.min(totalPages, p + 1))}
                    disabled={page === totalPages}
                  >
                    »
                  </button>
                </div>
              </div>
            )}
          </>
        )}
      </div>
    </div>
  );
};

export default Recipes;