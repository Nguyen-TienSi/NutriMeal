import React, { useState, useEffect } from 'react';
import { Calendar, Filter, Search, LogIn, Loader2 } from 'lucide-react';
import { Link } from 'react-router-dom';
import { useUser } from '../contexts/UserContext';
import { apiRequest } from '../utils/api';

const FoodLogs = () => {
  const { user } = useUser();
  const [logs, setLogs] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [filterDate, setFilterDate] = useState('');
  const [filterMeal, setFilterMeal] = useState('');

  useEffect(() => {
    const fetchLogs = async () => {
      if (!user?._id) return;

      try {
        setLoading(true);
        const data = await apiRequest(`/food-logs/user/${user._id}`);
        setLogs(data);
      } catch (err) {
        setError('Failed to load food logs');
        console.error('Error fetching food logs:', err);
      } finally {
        setLoading(false);
      }
    };

    fetchLogs();
  }, [user]);

  const filteredLogs = logs.filter(log => {
    if (filterDate && log.date !== filterDate) return false;
    if (filterMeal && log.meal_time !== filterMeal) return false;
    return true;
  });

  if (!user) {
    return (
      <div className="min-h-screen p-10 flex flex-col items-center justify-center">
        <div className="card w-96 bg-base-100 shadow-xl text-center">
          <div className="card-body">
            <LogIn className="w-16 h-16 mx-auto text-primary" />
            <h2 className="card-title justify-center text-2xl mt-4">Login Required</h2>
            <p className="text-base-content/70 mb-4">
              Please log in to view your food logs
            </p>
            <Link to="/auth" className="btn btn-primary">
              Log In Now
            </Link>
          </div>
        </div>
      </div>
    );
  }

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <Loader2 className="animate-spin h-8 w-8" />
      </div>
    );
  }

  return (
    <div className="min-h-screen p-10">
      <div className="max-w-6xl mx-auto">
        <div className="flex items-center justify-between mb-8">
          <h1 className="text-3xl font-bold flex items-center gap-2">
            <Calendar className="h-8 w-8" />
            Food Logs
          </h1>
        </div>

        {/* Filters */}
        <div className="flex gap-4 mb-8">
          <div className="form-control">
            <input
              type="date"
              value={filterDate}
              onChange={(e) => setFilterDate(e.target.value)}
              className="input input-bordered"
            />
          </div>
          <select
            value={filterMeal}
            onChange={(e) => setFilterMeal(e.target.value)}
            className="select select-bordered"
          >
            <option value="">All Meals</option>
            <option value="Breakfast">Breakfast</option>
            <option value="Lunch">Lunch</option>
            <option value="Dinner">Dinner</option>
          </select>
        </div>

        {error ? (
          <div className="alert alert-error">
            <span>{error}</span>
          </div>
        ) : filteredLogs.length === 0 ? (
          <div className="alert alert-info">
            <span>No food logs found.</span>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="table table-zebra w-full">
              <thead>
                <tr>
                  <th>Date</th>
                  <th>Meal</th>
                  <th>Food</th>
                  <th>Calories</th>
                  <th>Protein</th>
                  <th>Carbs</th>
                  <th>Fat</th>
                </tr>
              </thead>
              <tbody>
                {filteredLogs.map((log) => (
                  <tr key={log._id}>
                    <td>{new Date(log.date).toLocaleDateString()}</td>
                    <td>{log.meal_time}</td>
                    <td>
                      <Link 
                        to={`/recipe/${log.food_id}`}
                        className="link link-primary"
                      >
                        {log.food_name}
                      </Link>
                    </td>
                    <td>{log.calories} kcal</td>
                    <td>{log.protein}g</td>
                    <td>{log.carbs}g</td>
                    <td>{log.fat}g</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
};

export default FoodLogs;