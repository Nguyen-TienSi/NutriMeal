# Nutri-meal Application

A web application for managing nutritional goals and meal planning.

## Project Structure

```
nutri-meal/
├── backend/
│   ├── handlers/
│   │   └── health_goal_handler.go
│   ├── models/
│   └── database/
└── frontend/
```

## Features

- Health goal management
- User-specific nutritional tracking
- CRUD operations for health goals

## Backend API Endpoints

### Health Goals

- `POST /health-goals` - Create a new health goal
- `GET /health-goals/:user_id` - Retrieve a user's health goal
- `PUT /health-goals/:user_id` - Update a user's health goal
- `GET /health-goals/user/:userId` - Get health goals by user ID

## Setup

1. Clone the repository:
```bash
git clone https://github.com/yourusername/nutri-meal.git
cd nutri-meal
```

2. Install dependencies:
```bash
# Backend (Go)
cd backend
go mod download
```

3. Configure environment variables:
```env
MONGODB_URI=your_mongodb_connection_string
PORT=8080
```

4. Run the application:
```bash
# From the backend directory
go run main.go
```

## Tech Stack

- Backend: Go with Fiber framework
- Database: MongoDB
- Frontend: (To be added)

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.