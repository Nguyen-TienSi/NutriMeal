package models

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

type User struct {
	ID                 primitive.ObjectID `json:"id,omitempty" bson:"_id,omitempty"`
	Email              string            `json:"email" bson:"email"`
	Name              string            `json:"name" bson:"name"`
	Picture           string            `json:"picture" bson:"picture"`
	Weight            float64           `json:"weight" bson:"weight"`
	Height            float64           `json:"height" bson:"height"`
	TargetWeight      float64           `json:"target_weight" bson:"target_weight"`
	ActivityLevel     string            `json:"activity_level" bson:"activity_level"`
	DietaryPreference []string          `json:"dietary_preferences" bson:"dietary_preferences"`
	CreatedAt         time.Time         `json:"created_at" bson:"created_at"`
	UpdatedAt         time.Time         `json:"updated_at" bson:"updated_at"`
}
