const API_BASE_URL = 'http://localhost:3000/api';

export const apiRequest = async (endpoint, method = "GET", data = null, isFormData = false) => {
    const url = `${import.meta.env.VITE_API_BASE_URL}${endpoint}`;
    
    const headers = {};
    if (!isFormData) {
        headers["Content-Type"] = "application/json";
    }

    const options = {
        method,
        headers,
        credentials: "include",
        mode: "cors",
    };

    if (data) {
        options.body = isFormData ? data : JSON.stringify(data);
    }

    const response = await fetch(url, options);
    
    if (!response.ok) {
        const error = await response.json().catch(() => ({ error: "Server error" }));
        throw new Error(error.error || `HTTP error! status: ${response.status}`);
    }

    return response.json();
};