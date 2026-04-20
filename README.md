# Zomato Restaurant Analysis — Bangalore Expansion Strategy

![Python](https://img.shields.io/badge/Python-3.x-blue) ![SQL](https://img.shields.io/badge/SQL-Server-orange) ![PowerBI](https://img.shields.io/badge/Power%20BI-Dashboard-yellow) ![Status](https://img.shields.io/badge/Status-Complete-green)

---

## Business Problem

A restaurant chain planning to expand in Bangalore needs to identify locations with **high customer demand but low existing competition** — minimising risk while maximising footfall potential.

> Which 3 locations in Bangalore offer the best opportunity for a new restaurant, based on demand-supply gap analysis?

---

## Project Summary

Analysed 50,000+ Zomato restaurant records to rank Bangalore locations by **demand-supply ratio** (votes per restaurant) and delivered data-backed expansion recommendations.

**Key Finding:** Church Street delivers 1,090 votes per restaurant — **2.5x the city average of 440** — with only 546 restaurants, making it the strongest expansion candidate in the dataset.

---

## Tools & Technologies

| Tool | Purpose |
|------|---------|
| Python (Pandas) | Data cleaning and preprocessing |
| SQL Server | Business analysis and querying |
| Power BI | Interactive dashboard and visualisation |

---

## Project Structure

```
Zomato-Restaurant-Analysis/
│
├── data/
│   ├── zomato.csv               # Raw dataset (~50,000 rows)
│   └── cleaned_zomato.csv       # Cleaned dataset (~41,000 rows)
│
├── notebooks/
│   └── zomato_project.py        # Data cleaning script (Python + Pandas)
│
├── sql/
│   └── analysis_queries.sql     # All SQL queries with comments
│
├── dashboard/
│   └── Dashboard_restaurants.pbix   # Power BI dashboard file
│
└── docs/
    └── Zomato_Project_Guide.pdf     # Full business framing document
```

---

## Step 1 — Data Cleaning (Python)

The raw dataset had several quality issues that needed fixing before analysis:

- Ratings stored as strings like `4.1/5`, `NEW`, `-`
- Cost and votes stored as text instead of numbers
- Duplicate restaurant entries
- Null values across multiple columns

**After cleaning:** reduced from ~50,000 to ~41,000 usable rows.

---

## Step 2 — SQL Analysis

Imported cleaned data into SQL Server and ran 7 key analyses:

1. Top restaurants by rating and votes
2. Location-wise total demand
3. **Demand vs supply ratio** ← core business metric
4. City average ratio (benchmark)
5. Top expansion candidates (above-average ratio + 100+ restaurants)
6. High-rating but low-visibility restaurants
7. Cost vs rating segment analysis

**Core query logic:**
```sql
SELECT
    location,
    COUNT(*)                    AS total_restaurants,
    SUM(votes)                  AS total_votes,
    SUM(votes) * 1.0 / COUNT(*) AS votes_per_restaurant
FROM dbo.cleaned_zomato
GROUP BY location
ORDER BY votes_per_restaurant DESC;
```

---

## Step 3 — Key Insights

| Location | Restaurants | Votes/Restaurant | vs City Avg |
|----------|-------------|-----------------|-------------|
| Church Street | 546 | 1,090 | 2.5x |
| Lavelle Road | 481 | 1,050 | 2.4x |
| Koramangala 5th Block | 2,297 | 964 | 2.2x |
| Cunningham Road | 475 | 606 | 1.4x |
| **City Average** | — | **440** | 1.0x |

- **Koramangala & Indiranagar** are high-demand hubs but heavily saturated
- **Church Street and Lavelle Road** offer the best demand-to-competition balance
- Some restaurants have **4.0+ ratings but under 100 votes** — visibility gap opportunity

---

## Step 4 — Power BI Dashboard

Built an interactive dashboard with:
- Bar chart: votes by location
- Top 10 restaurants table (filterable by rating)
- KPI cards: 6,593 total restaurants, avg rating, total votes
- Slicers: location filter, rating range filter

---

## Business Recommendation

> Prioritise **Church Street, Lavelle Road, and Cunningham Road** for new restaurant expansion. These locations show demand-supply ratios 2x+ above the city average, indicating strong unmet customer demand with manageable existing competition.

---

## Dataset

- **Source:** [Zomato Bangalore Restaurants — Kaggle](https://www.kaggle.com/datasets/himanshupoddar/zomato-bangalore-restaurants)
- **Size:** ~50,000 rows, 17 columns
- **Fields:** name, location, rating, votes, approx_cost, cuisines, rest_type

---

## Author

**Rutuja** — Aspiring Data / Business Analyst  
Feel free to connect on [LinkedIn](#) <!-- replace # with your LinkedIn URL -->
