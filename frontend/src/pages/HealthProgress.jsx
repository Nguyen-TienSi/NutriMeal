import React, { useState, useEffect, useMemo } from 'react';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend } from 'recharts';
import { Scale, Target, TrendingUp, Calendar, LogIn, ListFilter } from 'lucide-react';
import { Link } from 'react-router-dom';
import { useUser } from '../contexts/UserContext';
import { apiRequest } from '../utils/api';

const HealthProgress = () => {
  const { user } = useUser();
  const [selectedMetric, setSelectedMetric] = useState('calories');
  const [foodLogs, setFoodLogs] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchFoodLogs = async () => {
      if (!user?._id) return;

      try {
        setLoading(true);
        const data = await apiRequest(`/food-logs/user/${user._id}`);
        
        // Get current week's dates
        const today = new Date();
        const monday = new Date(today);
        monday.setDate(today.getDate() - today.getDay() + 1);
        const sunday = new Date(monday);
        sunday.setDate(monday.getDate() + 6);

        // Group logs by date and calculate daily totals
        const dailyTotals = data.reduce((acc, log) => {
          const logDate = new Date(log.date);
          const date = log.date;
          
          if (!acc[date]) {
            acc[date] = {
              date,
              calories: 0,
              protein: 0,
              carbs: 0,
              fat: 0,
              count: 0,
              isCurrentWeek: logDate >= monday && logDate <= sunday
            };
          }
          acc[date].calories += log.calories;
          acc[date].protein += log.protein;
          acc[date].carbs += log.carbs;
          acc[date].fat += log.fat;
          acc[date].count += 1;
          return acc;
        }, {});

        // Convert to array and sort by date
        const processedData = Object.values(dailyTotals)
          .sort((a, b) => new Date(a.date) - new Date(b.date));

        setFoodLogs(processedData);
      } catch (err) {
        setError('Failed to load food logs');
        console.error('Error fetching food logs:', err);
      } finally {
        setLoading(false);
      }
    };

    fetchFoodLogs();
  }, [user]);

  // Calculate weekly totals
  const weeklyTotals = useMemo(() => {
    return foodLogs
      .filter(log => log.isCurrentWeek)
      .reduce((acc, log) => {
        acc.calories += log.calories;
        acc.protein += log.protein;
        acc.carbs += log.carbs;
        acc.fat += log.fat;
        return acc;
      }, { calories: 0, protein: 0, carbs: 0, fat: 0 });
  }, [foodLogs]);

  const metrics = [
    { id: 'calories', name: 'Calories', icon: Target, unit: 'kcal', color: '#8884d8' },
    { id: 'protein', name: 'Protein', icon: Scale, unit: 'g', color: '#82ca9d' },
    { id: 'carbs', name: 'Carbs', icon: Scale, unit: 'g', color: '#ffc658' },
    { id: 'fat', name: 'Fat', icon: Scale, unit: 'g', color: '#ff8042' }
  ];

  const formatDate = (dateStr) => {
    return new Date(dateStr).toLocaleDateString('en-US', {
      month: 'short',
      day: 'numeric'
    });
  };

  if (!user) {
    return (
      <div className="min-h-screen p-10 flex flex-col items-center justify-center">
        <div className="card w-96 bg-base-100 shadow-xl text-center">
          <div className="card-body">
            <LogIn className="w-16 h-16 mx-auto text-primary" />
            <h2 className="card-title justify-center text-2xl mt-4">Login Required</h2>
            <p className="text-base-content/70 mb-4">
              Please log in to view your health progress
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
        <div className="loading loading-spinner loading-lg"></div>
      </div>
    );
  }

  return (
    <div className="min-h-screen p-10">
      <div className="max-w-6xl mx-auto">
        <div className="flex items-center justify-between mb-8">
          <h1 className="text-3xl font-bold flex items-center gap-2">
            <Calendar className="h-8 w-8" />
            Nutrition Progress Tracking
          </h1>
          <Link to="/food-logs" className="btn btn-primary gap-2">
            <ListFilter size={20} />
            See Detailed Logs
          </Link>
        </div>

        {error ? (
          <div className="alert alert-error">
            <span>{error}</span>
          </div>
        ) : foodLogs.length === 0 ? (
          <div className="alert alert-info">
            <span>No nutrition data available yet. Log your meals to see progress.</span>
          </div>
        ) : (
          <>
            {/* Progress Charts */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
              {metrics.map(metric => (
                <div key={metric.id} className="bg-base-100 p-6 rounded-lg shadow-lg">
                  <div className="flex items-center justify-between mb-4">
                    <h3 className="text-lg font-semibold flex items-center gap-2">
                      <metric.icon size={20} />
                      {metric.name}
                    </h3>
                    <div className="text-sm text-base-content/70">
                      Weekly Total: {weeklyTotals[metric.id]} {metric.unit}
                    </div>
                  </div>
                  <LineChart
                    width={400}
                    height={200}
                    data={foodLogs}
                    margin={{ top: 5, right: 20, left: 20, bottom: 5 }}
                  >
                    <CartesianGrid strokeDasharray="3 3" />
                    <XAxis 
                      dataKey="date" 
                      tickFormatter={formatDate}
                    />
                    <YAxis />
                    <Tooltip 
                      labelFormatter={formatDate}
                      formatter={(value) => [`${value} ${metric.unit}`, metric.name]}
                    />
                    <Line
                      type="monotone"
                      dataKey={metric.id}
                      stroke={metric.color}
                      activeDot={{ r: 8 }}
                    />
                  </LineChart>
                </div>
              ))}
            </div>

            {/* Weekly Summary Cards */}
            <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
              {metrics.map(metric => (
                <div key={metric.id} className="stat bg-base-100 rounded-lg shadow-lg">
                  <div className="stat-title flex items-center gap-2">
                    <metric.icon size={16} />
                    Weekly {metric.name}
                  </div>
                  <div className="stat-value text-primary">
                    {weeklyTotals[metric.id]}
                    <span className="text-lg ml-1">
                      {metric.unit}
                    </span>
                  </div>
                  <div className="stat-desc">
                    Current week total
                  </div>
                </div>
              ))}
            </div>
          </>
        )}
      </div>
    </div>
  );
};

export default HealthProgress;