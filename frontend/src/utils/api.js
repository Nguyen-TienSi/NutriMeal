const API_BASE_URL = 'http://localhost:3000/api';

export const apiRequest = async (endpoint, method = 'GET', body = null, isFormData = false) => {
  try {
    const options = {
      method,
      credentials: 'include',
      mode: 'cors'
    };

    if (body) {
      if (isFormData) {
        // For FormData, let the browser handle the Content-Type
        options.body = body;
      } else {
        options.headers = {
          'Content-Type': 'application/json'
        };
        options.body = JSON.stringify(body);
      }
    }

    // Always accept JSON response
    options.headers = {
      ...options.headers,
      'Accept': 'application/json'
    };

    const response = await fetch(`${API_BASE_URL}${endpoint}`, options);
    const data = await response.json();

    if (!response.ok) {
      throw new Error(data.error || `Request failed with status ${response.status}`);
    }

    return data;
  } catch (error) {
    throw error;
  }
};