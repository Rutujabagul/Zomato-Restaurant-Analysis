-- ============================================================
-- Zomato Restaurant Analysis — SQL Queries
-- Database: ZomatoDB
-- Table: dbo.cleaned_zomato
-- Author: Rutuja
-- ============================================================


-- ============================================================
-- 1. QUICK DATA CHECK
--    Goal: Verify data loaded correctly after Python cleaning
-- ============================================================

USE ZomatoDB;

SELECT TOP 10 *
FROM dbo.cleaned_zomato;


-- ============================================================
-- 2. TOP 10 RESTAURANTS BY RATING AND VOTES
--    Goal: Identify best-performing restaurants overall
--    Note: Some restaurants have high rating but low votes —
--          this reveals a visibility gap worth investigating
-- ============================================================

SELECT TOP 10
    name,
    ROUND(AVG(rating), 1)  AS avg_rating,
    SUM(votes)             AS total_votes
FROM dbo.cleaned_zomato
GROUP BY name
ORDER BY avg_rating DESC, total_votes DESC;


-- ============================================================
-- 3. LOCATION-WISE TOTAL DEMAND
--    Goal: Find which areas have the highest overall footfall
-- ============================================================

SELECT
    location,
    COUNT(*)    AS total_restaurants,
    SUM(votes)  AS total_votes
FROM dbo.cleaned_zomato
GROUP BY location
ORDER BY total_votes DESC;


-- ============================================================
-- 4. DEMAND VS SUPPLY RATIO  ← CORE BUSINESS METRIC
--    Goal: Identify high-demand but low-competition areas
--    Logic: votes per restaurant = how much demand each
--           restaurant faces on average in that location
--    Higher ratio = more unmet demand = expansion opportunity
-- ============================================================

SELECT
    location,
    COUNT(*)                        AS total_restaurants,
    SUM(votes)                      AS total_votes,
    SUM(votes) * 1.0 / COUNT(*)     AS votes_per_restaurant
FROM dbo.cleaned_zomato
GROUP BY location
ORDER BY votes_per_restaurant DESC;


-- ============================================================
-- 5. DEMAND VS SUPPLY — FILTERED (REMOVES NOISE)
--    Goal: Same as above but only locations with 50+
--          restaurants so small samples don't skew results
-- ============================================================

SELECT
    location,
    COUNT(*)                        AS total_restaurants,
    SUM(votes)                      AS total_votes,
    SUM(votes) * 1.0 / COUNT(*)     AS votes_per_restaurant
FROM dbo.cleaned_zomato
GROUP BY location
HAVING COUNT(*) > 50
ORDER BY votes_per_restaurant DESC;


-- ============================================================
-- 6. CITY AVERAGE DEMAND-SUPPLY RATIO  ← BENCHMARK
--    Goal: Calculate city-wide baseline for comparison
--    Result: ~440 votes per restaurant across Bangalore
-- ============================================================

SELECT
    ROUND(SUM(votes) * 1.0 / COUNT(*), 2) AS city_avg_votes_per_restaurant
FROM dbo.cleaned_zomato;


-- ============================================================
-- 7. TOP EXPANSION CANDIDATES
--    Goal: Locations with above-average ratio AND
--          at least 100 restaurants (meaningful market size)
--    These are the final business recommendations
-- ============================================================

SELECT
    location,
    COUNT(*)                                        AS total_restaurants,
    SUM(votes)                                      AS total_votes,
    ROUND(SUM(votes) * 1.0 / COUNT(*), 2)           AS votes_per_restaurant
FROM dbo.cleaned_zomato
GROUP BY location
HAVING
    SUM(votes) * 1.0 / COUNT(*) > (
        SELECT SUM(votes) * 1.0 / COUNT(*) FROM dbo.cleaned_zomato
    )
    AND COUNT(*) >= 100
ORDER BY votes_per_restaurant DESC;


-- ============================================================
-- 8. HIGH RATING BUT LOW VISIBILITY
--    Goal: Restaurants rated 4.0+ but with very few votes
--          These are hidden gems — good quality, low reach
-- ============================================================

SELECT
    name,
    location,
    rating,
    votes,
    approx_cost
FROM dbo.cleaned_zomato
WHERE
    rating >= 4.0
    AND votes < 100
ORDER BY rating DESC;


-- ============================================================
-- 9. COST VS RATING SEGMENT ANALYSIS
--    Goal: Does higher price mean higher rating?
--          Segments restaurants into 4 price tiers
-- ============================================================

SELECT
    CASE
        WHEN approx_cost < 300  THEN 'Budget (under 300)'
        WHEN approx_cost < 600  THEN 'Mid-range (300-600)'
        WHEN approx_cost < 1000 THEN 'Premium (600-1000)'
        ELSE                         'Luxury (1000+)'
    END                         AS price_segment,
    COUNT(*)                    AS total_restaurants,
    ROUND(AVG(rating), 2)       AS avg_rating,
    ROUND(AVG(votes),  0)       AS avg_votes
FROM dbo.cleaned_zomato
WHERE rating IS NOT NULL AND approx_cost IS NOT NULL
GROUP BY
    CASE
        WHEN approx_cost < 300  THEN 'Budget (under 300)'
        WHEN approx_cost < 600  THEN 'Mid-range (300-600)'
        WHEN approx_cost < 1000 THEN 'Premium (600-1000)'
        ELSE                         'Luxury (1000+)'
    END
ORDER BY avg_rating DESC;
