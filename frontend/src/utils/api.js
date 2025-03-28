const API_BASE_URL = 'http://localhost:3000/api';

export const apiRequest = async (endpoint, method = 'GET', body = null) => {
  try {
    const headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    const options = {
      method,
      headers,
      mode: 'cors',
      credentials: 'include'
    };

    if (body) {
      options.body = JSON.stringify(body);
    }

    // Log request details
    console.log('Making API request:', {
      url: `${API_BASE_URL}${endpoint}`,
      method,
      headers: options.headers,
      body: options.body
    });

    const response = await fetch(`${API_BASE_URL}${endpoint}`, options);
    
    if (!response) {
      throw new Error('No response received from server');
    }

    // Log response status
    console.log('Response status:', response.status);

    const data = await response.json();

    if (!response.ok) {
      throw new Error(data.error || `Request failed with status ${response.status}`);
    }

    return data;
  } catch (error) {
    console.error('API Request failed:', {
      error: error.message,
      stack: error.stack
    });
    
    if (!navigator.onLine) {
      throw new Error('No internet connection. Please check your network and try again.');
    }
    
    if (error.message === 'Failed to fetch') {
      throw new Error('Unable to connect to the server. Please ensure the backend is running.');
    }
    
    throw error;
  }
};