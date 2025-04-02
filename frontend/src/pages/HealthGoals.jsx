import React, { useState, useEffect } from 'react';
import { Target, Scale, Activity, Apple, ArrowRight, ArrowLeft } from 'lucide-react';
import { apiRequest } from '../utils/api'; // Import apiRequest
import { useUser } from '../contexts/UserContext'; // Import the user context
import { useNavigate } from 'react-router-dom';

const HealthGoals = () => {
  // Move all Hook declarations to the top
  const [isLoading, setIsLoading] = useState(true);
  const [currentStep, setCurrentStep] = useState(1);
  const [errors, setErrors] = useState({});
  const [isSubmitted, setIsSubmitted] = useState(false);
  const [goals, setGoals] = useState({
    targetWeight: '',
    currentWeight: '',
    activityLevel: '',
    dietaryPreferences: [],
    weeklyGoal: ''
  });

  const { user } = useUser();
  const navigate = useNavigate();

  useEffect(() => {
    if (!user) {
      navigate('/auth');
    } else {
      setIsLoading(false);
    }
  }, [user, navigate]);

  // Rest of your component logic
  const validateStep = (step) => {
    const newErrors = {};
    switch (step) {
      case 1:
        if (!goals.currentWeight) newErrors.currentWeight = 'Current weight is required';
        break;
      case 2:
        if (!goals.targetWeight) newErrors.targetWeight = 'Target weight is required';
        break;
      case 3:
        if (!goals.activityLevel) newErrors.activityLevel = 'Activity level is required';
        break;
      case 4:
        if (goals.dietaryPreferences.length === 0) newErrors.dietaryPreferences = 'Select at least one dietary preference';
        break;
      default:
        break;
    }
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    setGoals(prev => ({
      ...prev,
      [name]: value
    }));
    // Clear error when user starts typing
    if (errors[name]) {
      setErrors(prev => ({ ...prev, [name]: '' }));
    }
  };

  const handleDietaryPreference = (preference) => {
    setGoals(prev => ({
      ...prev,
      dietaryPreferences: prev.dietaryPreferences.includes(preference)
        ? prev.dietaryPreferences.filter(p => p !== preference)
        : [...prev.dietaryPreferences, preference]
    }));
  };

  const handleNext = () => {
    if (validateStep(currentStep)) {
      setCurrentStep(prev => Math.min(prev + 1, 4));
    }
  };

  const handlePrevious = () => {
    setCurrentStep(prev => Math.max(prev - 1, 1));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (validateStep(currentStep)) {
        try {
            if (!user || !user._id) { // check  _id
                console.error('User context:', user);
                throw new Error('User ID not found. Please log in.');
            }
            
            const formattedGoals = {
                targetWeight: parseFloat(goals.targetWeight),
                currentWeight: parseFloat(goals.currentWeight),
                activityLevel: goals.activityLevel,
                dietaryPreferences: goals.dietaryPreferences || [],
                weeklyGoal: goals.weeklyGoal || '',
                user_id: user._id // Use _id
            };

            console.log('User ID:', user._id);
            console.log('Submitted goals:', formattedGoals);
            
            await saveHealthGoal(formattedGoals, user._id);
            setIsSubmitted(true);
        } catch (err) {
            console.error('Failed to save health goals:', err);
            alert('Failed to save health goals: ' + err.message);
        }
    }
};

  const saveHealthGoal = async (goalData, userId) => {
    try {
        if (!userId || userId.length !== 24) {
            throw new Error('Invalid user ID format');
        }

        const response = await apiRequest('/health-goals', 'POST', goalData);
        console.log('Health goal saved:', response);

        if (!response || response.error) {
            throw new Error(response?.error || 'Failed to save health goal');
        }

        setIsSubmitted(true);
        alert('Health goal saved successfully!');
    } catch (err) {
        console.error('Failed to save health goal:', err);
        throw err;
    }
};

const renderStep = () => {
  switch (currentStep) {
    case 1:
      return (
        <div>
          <h2 className="text-xl font-semibold mb-4 flex items-center gap-2">
            <Scale className="h-6 w-6" />
            Current Weight
          </h2>
          <div className="form-control">
            <input
              type="number"
              name="currentWeight"
              value={goals.currentWeight}
              min="1"
              onChange={handleChange}
              placeholder="Enter your current weight in kg"
              className={`input input-bordered w-full ${errors.currentWeight ? 'input-error' : ''}`}
            />
            {errors.currentWeight && (
              <label className="label">
                <span className="label-text-alt text-error">{errors.currentWeight}</span>
              </label>
            )}
          </div>
        </div>
      );

    case 2:
      return (
        <div>
          <h2 className="text-xl font-semibold mb-4 flex items-center gap-2">
            <Target className="h-6 w-6" />
            Target Weight
          </h2>
          <div className="form-control">
            <input
              type="number"
              name="targetWeight"
              value={goals.targetWeight}
              onChange={handleChange}
              min="1"
              placeholder="Enter your target weight in kg"
              className={`input input-bordered w-full ${errors.targetWeight ? 'input-error' : ''}`}
            />
            {errors.targetWeight && (
              <label className="label">
                <span className="label-text-alt text-error">{errors.targetWeight}</span>
              </label>
            )}
          </div>
        </div>
      );

    case 3:
      return (
        <div>
          <h2 className="text-xl font-semibold mb-4 flex items-center gap-2">
            <Activity className="h-6 w-6" />
            Activity Level
          </h2>
          <div className="form-control">
            <select
              name="activityLevel"
              value={goals.activityLevel}
              onChange={handleChange}
              className={`select select-bordered w-full ${errors.activityLevel ? 'select-error' : ''}`}
            >
              <option value="">Select your activity level</option>
              <option value="sedentary">Sedentary</option>
              <option value="light">Light</option>
              <option value="moderate">Moderate</option>
              <option value="active">Active</option>
              <option value="very active">Very Active</option>
            </select>
            {errors.activityLevel && (
              <label className="label">
                <span className="label-text-alt text-error">{errors.activityLevel}</span>
              </label>
            )}
          </div>
        </div>
      );

    case 4:
      return (
        <div>
          <h2 className="text-xl font-semibold mb-4 flex items-center gap-2">
            <Apple className="h-6 w-6" />
            Dietary Preferences
          </h2>
          <div className="form-control">
            <div className="flex flex-wrap gap-2">
              {['Vegetarian', 'Vegan', 'Pescatarian', 'Keto', 'Paleo'].map(preference => (
                <label key={preference} className="cursor-pointer label">
                  <input
                    type="checkbox"
                    name="dietaryPreferences"
                    checked={goals.dietaryPreferences.includes(preference)}
                    onChange={() => handleDietaryPreference(preference)}
                    className="checkbox checkbox-primary"
                  />
                  <span className="label-text">{preference}</span>
                </label>
              ))}
            </div>
            {errors.dietaryPreferences && (
              <label className="label">
                <span className="label-text-alt text-error">{errors.dietaryPreferences}</span>
              </label>
            )}
          </div>
        </div>
      );

    default:
      return null;
  }
};

  // Render loading state
  if (isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="loading loading-spinner loading-lg"></div>
      </div>
    );
  }

  // Render success state
  if (isSubmitted) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center">
          <h1 className="text-3xl font-bold mb-4">Health Goal Saved!</h1>
          <p className="text-gray-600 mb-8">Your health goals have been successfully saved.</p>
          <button
            onClick={() => setIsSubmitted(false)} // Reset form or navigate elsewhere
            className="btn btn-primary"
          >
            Set Another Goal
          </button>
        </div>
      </div>
    );
  }

  // Main render
  return (
    <div className="min-h-screen p-10">
      <div className="max-w-3xl mx-auto">
        <h1 className="text-3xl font-bold mb-8 flex items-center gap-2">
          <Target className="h-8 w-8" />
          Set Your Health Goals
        </h1>

        <ul className="steps w-full mb-8">
          <li className={`step ${currentStep >= 1 ? 'step-primary' : ''}`}>Weight</li>
          <li className={`step ${currentStep >= 2 ? 'step-primary' : ''}`}>Target</li>
          <li className={`step ${currentStep >= 3 ? 'step-primary' : ''}`}>Activity</li>
          <li className={`step ${currentStep >= 4 ? 'step-primary' : ''}`}>Diet</li>
        </ul>

        <form onSubmit={handleSubmit} className="space-y-6">
          {renderStep()}

          <div className="flex justify-between mt-8">
            {currentStep > 1 && (
              <button 
                type="button" 
                onClick={handlePrevious}
                className="btn btn-outline gap-2"
              >
                <ArrowLeft size={16} /> Previous
              </button>
            )}
            {currentStep < 4 ? (
              <button 
                type="button" 
                onClick={handleNext}
                className="btn btn-primary gap-2 ml-auto"
              >
                Next <ArrowRight size={16} />
              </button>
            ) : (
              <button 
                type="submit"
                className="btn btn-primary gap-2 ml-auto"
              >
                Save Goals
              </button>
            )}
          </div>
        </form>
      </div>
    </div>
  );
};

export default HealthGoals;