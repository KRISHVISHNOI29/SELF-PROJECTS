import pandas as pd
from sklearn.preprocessing import MinMaxScaler

# Sample dataset (you will expand this)
data = pd.DataFrame({
    "city": ["Delhi", "Mumbai", "Bangalore", "Pune"],
    "aqi": [300, 200, 120, 100],
    "cost": [70, 90, 80, 60],
    "crime": [60, 70, 40, 30],
    "education": [80, 85, 90, 88],
    "hangout": [75, 85, 80, 78],
    "healthcare": [85, 88, 87, 86],
    "jobs": [90, 95, 92, 85],
    "population": [100, 95, 80, 70],
    "traffic": [95, 90, 85, 75]
})

# Normalize
scaler = MinMaxScaler()
features = data.columns[1:]
data[features] = scaler.fit_transform(data[features])

# Invert negative features
for col in ["aqi", "cost", "crime", "traffic", "population"]:
    data[col] = 1 - data[col]

# Example user input
user_input = {
    "budget": "high",
    "safety": "low",
    "purpose": "study"
}

# Generate weights
weights = {
    "aqi": 0.1,
    "cost": 0.25 if user_input["budget"] == "low" else 0.1,
    "crime": 0.3 if user_input["safety"] == "high" else 0.1,
    "jobs": 0.3 if user_input["purpose"] == "job" else 0.1,
    "education": 0.2 if user_input["purpose"] == "study" else 0.1,
    "hangout": 0.05,
    "healthcare": 0.1,
    "population": 0.05,
    "traffic": 0.05
}

# Score calculation
def calculate_score(row):
    return sum(row[col] * weights[col] for col in weights)

data["score"] = data.apply(calculate_score, axis=1)

# Top 3 cities
top_cities = data.sort_values(by="score", ascending=False).head(3)

print(top_cities[["city", "score"]])