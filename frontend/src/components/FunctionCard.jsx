import React from 'react';
import { Link } from 'react-router-dom';

const FunctionCard = ({ title, description, icon: Icon, path, color }) => {
  return (
    <Link 
      to={path}
      className="card bg-base-100 shadow-xl hover:shadow-2xl transition-shadow"
    >
      <div className="card-body">
        <div className={`w-12 h-12 rounded-lg ${color} flex items-center justify-center text-white mb-4`}>
          <Icon size={24} />
        </div>
        <h3 className="card-title">{title}</h3>
        <p className="text-sm text-gray-600">{description}</p>
      </div>
    </Link>
  );
};

export default FunctionCard;