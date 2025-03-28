import React, { useEffect, useState } from 'react';
import { 
  User, Mail, Scale, Ruler, Calendar, Activity,
  Camera, Save, FileEdit, Target 
} from 'lucide-react';
import { useUser } from '../contexts/UserContext';
import { apiRequest } from '../utils/api';

const Profile = () => {
  const { user: currentUser } = useUser(); // Get logged in user from context
  const [user, setUser] = useState(null);
  const [error, setError] = useState(null);
  const [isEditing, setIsEditing] = useState(false);
  const [profile, setProfile] = useState({
    name: '',
    email: '',
    weight: '70',
    height: '170',
    birthDate: '1990-01-01',
    activityLevel: 'moderate',
    dietaryPreferences: ['vegetarian'],
    allergies: ['nuts']
  });
  const [healthGoals, setHealthGoals] = useState(null);

  useEffect(() => {
    const fetchHealthGoals = async (userId) => {
      try {
        const data = await apiRequest(`/health-goals/user/${userId}`);
        if (data && !data.error) {
          setHealthGoals(data);
        } else {
          console.warn('No health goals found:', data?.error);
          setHealthGoals(null);
        }
      } catch (err) {
        console.error('Error fetching health goals:', err);
        setHealthGoals(null);
      }
    };

    const fetchData = async () => {
      try {
        if (!currentUser?._id) {
          setError('No user ID found');
          return;
        }

        const userData = await apiRequest(`/users/${currentUser._id}`);
        setUser(userData);
        setProfile({
          name: userData.name || '',
          email: userData.email || '',
          weight: userData.weight || '70',
          height: userData.height || '170',
          birthDate: userData.birthDate || '1990-01-01',
          activityLevel: userData.activityLevel || 'moderate',
          dietaryPreferences: userData.dietaryPreferences || ['vegetarian'],
          allergies: userData.allergies || ['nuts']
        });

        // Fetch health goals
        await fetchHealthGoals(currentUser._id);
      } catch (err) {
        setError(err.message);
      }
    };

    fetchData();
  }, [currentUser]);

  const activityLevels = [
    { value: 'sedentary', label: 'Sedentary (little or no exercise)' },
    { value: 'light', label: 'Light (exercise 1-3 times/week)' },
    { value: 'moderate', label: 'Moderate (exercise 4-5 times/week)' },
    { value: 'active', label: 'Active (daily exercise)' },
    { value: 'veryActive', label: 'Very Active (intense exercise 6-7 times/week)' }
  ];

  const handleChange = (e) => {
    const { name, value } = e.target;
    setProfile(prev => ({
      ...prev,
      [name]: value
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await apiRequest(`/users/${currentUser._id}`, 'PUT', profile); // Change from .id to ._id
      setIsEditing(false);
      // Refresh user data
      const updatedUser = await apiRequest(`/users/${currentUser._id}`); // Change from .id to ._id
      setUser(updatedUser);
    } catch (err) {
      setError(err.message);
    }
  };

  if (error) {
    return <div>Error: {error}</div>;
  }

  if (!user) {
    return <div>Loading...</div>;
  }

  return (
    <div className="min-h-screen p-10">
      <div className="max-w-4xl mx-auto">
        <div className="flex justify-between items-center mb-8">
          <h1 className="text-3xl font-bold flex items-center gap-2">
            <User className="h-8 w-8" />
            User Profile
          </h1>
          <button 
            onClick={() => setIsEditing(!isEditing)}
            className="btn btn-ghost gap-2"
          >
            <FileEdit size={20} />
            {isEditing ? 'Cancel' : 'Edit Profile'}
          </button>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          {/* Profile Picture Section */}
          <div className="card bg-base-100 shadow-xl p-6 md:col-span-1">
            <div className="relative w-32 h-32 mx-auto mb-4">
              <img
                src={user?.picture || '/default-avatar.png'}
                alt="Profile"
                className="w-full h-full rounded-full object-cover"
              />
              <button className="btn btn-circle btn-sm absolute bottom-0 right-0">
                <Camera size={16} />
              </button>
            </div>
            <h2 className="text-center text-xl font-semibold">{user?.name}</h2>
            <p className="text-center text-sm text-gray-500">{user?.email}</p>
          </div>

          {/* Profile Details Section */}
          <div className="card bg-base-100 shadow-xl p-6 md:col-span-2">
            <form onSubmit={handleSubmit} className="space-y-4">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div className="form-control">
                  <label className="label">
                    <span className="label-text flex items-center gap-2">
                      <Scale size={16} />
                      Weight (kg)
                    </span>
                  </label>
                  <input
                    type="number"
                    name="weight"
                    value={profile.weight}
                    onChange={handleChange}
                    disabled={!isEditing}
                    className="input input-bordered"
                  />
                </div>

                <div className="form-control">
                  <label className="label">
                    <span className="label-text flex items-center gap-2">
                      <Ruler size={16} />
                      Height (cm)
                    </span>
                  </label>
                  <input
                    type="number"
                    name="height"
                    value={profile.height}
                    onChange={handleChange}
                    disabled={!isEditing}
                    className="input input-bordered"
                  />
                </div>

                <div className="form-control">
                  <label className="label">
                    <span className="label-text flex items-center gap-2">
                      <Calendar size={16} />
                      Birth Date
                    </span>
                  </label>
                  <input
                    type="date"
                    name="birthDate"
                    value={profile.birthDate}
                    onChange={handleChange}
                    disabled={!isEditing}
                    className="input input-bordered"
                  />
                </div>

                <div className="form-control">
                  <label className="label">
                    <span className="label-text flex items-center gap-2">
                      <Activity size={16} />
                      Activity Level
                    </span>
                  </label>
                  <select
                    name="activityLevel"
                    value={profile.activityLevel}
                    onChange={handleChange}
                    disabled={!isEditing}
                    className="select select-bordered"
                  >
                    {activityLevels.map(level => (
                      <option key={level.value} value={level.value}>
                        {level.label}
                      </option>
                    ))}
                  </select>
                </div>
              </div>

              {isEditing && (
                <div className="flex justify-end mt-6">
                  <button type="submit" className="btn btn-primary gap-2">
                    <Save size={20} />
                    Save Changes
                  </button>
                </div>
              )}
            </form>
          </div>
        </div>

        {/* Health Goals Section */}
        <div className="card bg-base-100 shadow-xl p-6 mt-6">
          <h2 className="text-xl font-semibold mb-4 flex items-center gap-2">
            <Target className="h-6 w-6" />
            Health Goals
          </h2>
          
          {healthGoals === null ? (
            <div className="text-center py-4">
              <p className="text-gray-500">No health goals set yet</p>
              <a 
                href="/health-goals" 
                className="btn btn-primary mt-4"
              >
                Set Health Goals
              </a>
            </div>
          ) : healthGoals === undefined ? (
            <div className="flex justify-center py-4">
              <div className="loading loading-spinner loading-md"></div>
            </div>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div className="stat">
                <div className="stat-title">Current Weight</div>
                <div className="stat-value">{healthGoals.currentWeight} kg</div>
              </div>
              
              <div className="stat">
                <div className="stat-title">Target Weight</div>
                <div className="stat-value">{healthGoals.targetWeight} kg</div>
              </div>
              
              <div className="stat">
                <div className="stat-title">Activity Level</div>
                <div className="stat-value text-lg capitalize">
                  {healthGoals.activityLevel}
                </div>
              </div>
              
              {healthGoals.dietaryPreferences?.length > 0 && (
                <div className="md:col-span-3">
                  <h3 className="font-semibold mb-2">Dietary Preferences</h3>
                  <div className="flex flex-wrap gap-2">
                    {healthGoals.dietaryPreferences.map((pref) => (
                      <span 
                        key={pref} 
                        className="badge badge-primary"
                      >
                        {pref}
                      </span>
                    ))}
                  </div>
                </div>
              )}
              
              {healthGoals.weeklyGoal && (
                <div className="md:col-span-3">
                  <h3 className="font-semibold mb-2">Weekly Goal</h3>
                  <p>{healthGoals.weeklyGoal}</p>
                </div>
              )}
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default Profile;