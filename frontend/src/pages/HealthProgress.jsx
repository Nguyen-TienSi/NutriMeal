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
        
        // Get current week's dates (Monday to Sunday)
        const today = new Date();
        const startOfWeek = new Date(today);
        // Get Monday (1) of current week
        const day = startOfWeek.getDay() || 7; // Convert Sunday (0) to 7
        startOfWeek.setDate(startOfWeek.getDate() - day + 1);
        startOfWeek.setHours(0, 0, 0, 0);

        const endOfWeek = new Date(startOfWeek);
        endOfWeek.setDate(startOfWeek.getDate() + 6); // Add 6 days to get to Sunday
        endOfWeek.setHours(23, 59, 59, 999);

        console.log('Week range:', { 
          startOfWeek: startOfWeek.toISOString(), 
          endOfWeek: endOfWeek.toISOString(),
          today: today.toISOString()
        }); // Debug log

        // Group logs by date and calculate daily totals
        const dailyTotals = data.reduce((acc, log) => {
          const logDate = new Date(log.date);
          const date = logDate.toISOString().split('T')[0]; // Format: YYYY-MM-DD
          
          // Check if log is in current week using timestamp comparison
          const isCurrentWeek = logDate.getTime() >= startOfWeek.getTime() && 
                               logDate.getTime() <= endOfWeek.getTime();
          
          console.log('Processing log:', { 
            date, 
            isCurrentWeek, 
            calories: log.calories,
            protein: log.protein,
            carbs: log.carbs,
            fat: log.fat
          }); // Debug log

          if (!acc[date]) {
            acc[date] = {
              date,
              calories: 0,
              protein: 0,
              carbs: 0,
              fat: 0,
              count: 0,
              isCurrentWeek
            };
          }
          
          acc[date].calories += parseFloat(log.calories) || 0;
          acc[date].protein += parseFloat(log.protein) || 0;
          acc[date].carbs += parseFloat(log.carbs) || 0;
          acc[date].fat += parseFloat(log.fat) || 0;
          acc[date].count += 1;
          
          return acc;
        }, {});

        const processedData = Object.values(dailyTotals)
          .sort((a, b) => new Date(a.date) - new Date(b.date));

        console.log('Processed data:', processedData); // Debug log
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

  // Calculate weekly totals with better logging
  const weeklyTotals = useMemo(() => {
    console.log('Calculating weekly totals from:', foodLogs); // Debug log
    
    const totals = foodLogs
      .filter(log => {
        console.log('Checking log:', { date: log.date, isCurrentWeek: log.isCurrentWeek }); // Debug log
        return log.isCurrentWeek;
      })
      .reduce((acc, log) => {
        console.log('Adding to totals:', log); // Debug log
        return {
          calories: acc.calories + (parseFloat(log.calories) || 0),
          protein: acc.protein + (parseFloat(log.protein) || 0),
          carbs: acc.carbs + (parseFloat(log.carbs) || 0),
          fat: acc.fat + (parseFloat(log.fat) || 0)
        };
      }, { calories: 0, protein: 0, carbs: 0, fat: 0 });

    console.log('Final totals:', totals); // Debug log
    return totals;
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