import React, { useState } from 'react';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend } from 'recharts';
import { Scale, Target, TrendingUp, Calendar, LogIn } from 'lucide-react';
import { Link } from 'react-router-dom';
import { useUser } from '../contexts/UserContext';

const HealthProgress = () => {
  const { user } = useUser();
  const [selectedMetric, setSelectedMetric] = useState('weight');
  
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

  // Mock data - replace with actual data from your backend
  const progressData = [
    { date: '2024-03-01', weight: 75, calories: 2100, steps: 8000 },
    { date: '2024-03-08', weight: 74.5, calories: 2000, steps: 8500 },
    { date: '2024-03-15', weight: 74, calories: 1950, steps: 9000 },
    { date: '2024-03-22', weight: 73.2, calories: 1900, steps: 9500 },
  ];

  const metrics = [
    { id: 'weight', name: 'Weight', icon: Scale, unit: 'kg' },
    { id: 'calories', name: 'Daily Calories', icon: Target, unit: 'kcal' },
    { id: 'steps', name: 'Daily Steps', icon: TrendingUp, unit: 'steps' },
  ];

  const formatDate = (dateStr) => {
    return new Date(dateStr).toLocaleDateString('en-US', {
      month: 'short',
      day: 'numeric'
    });
  };

  return (
    <div className="min-h-screen p-10">
      <div className="max-w-6xl mx-auto">
        <div className="flex items-center justify-between mb-8">
          <h1 className="text-3xl font-bold flex items-center gap-2">
            <Calendar className="h-8 w-8" />
            Health Progress Tracking
          </h1>
          <button className="btn btn-primary">
            Log Progress
          </button>
        </div>

        {/* Metric Selection */}
        <div className="flex gap-4 mb-8">
          {metrics.map(({ id, name, icon: Icon, unit }) => (
            <button
              key={id}
              onClick={() => setSelectedMetric(id)}
              className={`btn btn-outline flex-1 gap-2 ${
                selectedMetric === id ? 'btn-active' : ''
              }`}
            >
              <Icon size={20} />
              {name}
            </button>
          ))}
        </div>

        {/* Progress Chart */}
        <div className="bg-base-100 p-6 rounded-lg shadow-lg">
          <LineChart
            width={800}
            height={400}
            data={progressData}
            margin={{ top: 5, right: 30, left: 20, bottom: 5 }}
          >
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis 
              dataKey="date" 
              tickFormatter={formatDate}
            />
            <YAxis />
            <Tooltip 
              labelFormatter={formatDate}
              formatter={(value) => [
                `${value} ${metrics.find(m => m.id === selectedMetric)?.unit}`,
                metrics.find(m => m.id === selectedMetric)?.name
              ]}
            />
            <Legend />
            <Line
              type="monotone"
              dataKey={selectedMetric}
              stroke="#8884d8"
              activeDot={{ r: 8 }}
            />
          </LineChart>
        </div>

        {/* Progress Summary */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mt-8">
          <div className="stat bg-base-100 rounded-lg shadow-lg">
            <div className="stat-title">Starting {metrics.find(m => m.id === selectedMetric)?.name}</div>
            <div className="stat-value">
              {progressData[0][selectedMetric]}
              <span className="text-lg ml-1">
                {metrics.find(m => m.id === selectedMetric)?.unit}
              </span>
            </div>
            <div className="stat-desc">From {formatDate(progressData[0].date)}</div>
          </div>

          <div className="stat bg-base-100 rounded-lg shadow-lg">
            <div className="stat-title">Current {metrics.find(m => m.id === selectedMetric)?.name}</div>
            <div className="stat-value">
              {progressData[progressData.length - 1][selectedMetric]}
              <span className="text-lg ml-1">
                {metrics.find(m => m.id === selectedMetric)?.unit}
              </span>
            </div>
            <div className="stat-desc">As of {formatDate(progressData[progressData.length - 1].date)}</div>
          </div>

          <div className="stat bg-base-100 rounded-lg shadow-lg">
            <div className="stat-title">Total Change</div>
            <div className="stat-value text-primary">
              {(progressData[progressData.length - 1][selectedMetric] - progressData[0][selectedMetric]).toFixed(1)}
              <span className="text-lg ml-1">
                {metrics.find(m => m.id === selectedMetric)?.unit}
              </span>
            </div>
            <div className="stat-desc">Over {progressData.length} weeks</div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default HealthProgress;