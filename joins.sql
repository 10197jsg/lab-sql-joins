/* 1. List the number of films per category.*/

SELECT COUNT(film_id) FROM film_category;

/* 2. Retrieve the store ID, city, and country for each store.*/

SELECT 
    s.store_id, 
    ci.city, 
    co.country
FROM store s
JOIN address a ON s.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id;

/* 3.  Calculate the total revenue generated by each store in dollars.*/

SELECT 
    s.store_id,
    SUM(p.amount) AS total_revenue
FROM store s
JOIN staff st ON s.store_id = st.store_id
JOIN payment p ON st.staff_id = p.staff_id
GROUP BY s.store_id;

/* 4.  Determine the average running time of films for each category.*/

SELECT 
    c.name AS category_name, 
    ROUND(AVG(f.length), 2) AS avg_running_time
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
GROUP BY c.name;

/* 5.  Identify the film categories with the longest average running time.*/

SELECT 
    c.name AS category_name, 
    ROUND(AVG(f.length), 2) AS avg_running_time
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
GROUP BY c.name
ORDER BY avg_running_time DESC;

/* 6.  Display the top 10 most frequently rented movies in descending order.*/

SELECT 
    f.title AS film_title, 
    COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id
ORDER BY rental_count DESC
LIMIT 10;

/* 7. Determine if "Academy Dinosaur" can be rented from Store 1.*/

SELECT 
    f.title, 
    i.inventory_id, 
    s.store_id, 
    CASE 
        WHEN r.rental_id IS NULL THEN 'Available for rent'
        ELSE 'Already rented'
    END AS rental_status
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN store s ON i.store_id = s.store_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id AND r.return_date IS NULL
WHERE f.title = 'Academy Dinosaur' 
AND s.store_id = 1;

/* 8. Provide a list of all distinct film titles, along with their availability status in the inventory. Include a column indicating whether each title is 'Available' or 'NOT available.' Note that there are 42 titles that are not in the inventory, and this information can be obtained using a `CASE` statement combined with `IFNULL`."*/

SELECT 
    f.title AS film_title,
    CASE 
        WHEN IFNULL(i.inventory_id, 0) > 0 THEN 'Available'
        ELSE 'NOT available'
    END AS availability_status
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id;