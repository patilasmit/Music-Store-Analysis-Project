# Music Store Analysis Project

## Project Overview
The **Music Store Analysis Project** aims to analyze data from an online music store, utilizing SQL to gain insights into the store's business growth. This project provides a comprehensive examination of the music playlist database, allowing stakeholders to make data-driven decisions by answering various analytical questions.

## Objectives
- Analyze the music store's customer data, invoices, and sales trends.
- Understand customer preferences and spending patterns based on genre and artist.
- Identify the best-selling artists and top customers to drive business strategies.

## Dataset
The dataset used in this project includes tables related to customers, invoices, tracks, albums, genres, and artists. Key tables involved are:
- **Customer**: Contains customer information.
- **Invoice**: Contains billing and sales data.
- **Track**: Contains details about individual music tracks.
- **Album**: Contains information about albums, including artist details.
- **Genre**: Contains music genre classifications.

## SQL Queries

### Question Set 1 - Easy
1. **Find the highest-level employee:**
    ```sql
    SELECT *
    FROM employee
    ORDER BY levels DESC
    LIMIT 1;
    ```

2. **Determine the country with the most invoices:**
    ```sql
    SELECT billing_country, COUNT(*) AS c
    FROM invoice
    GROUP BY billing_country
    ORDER BY c DESC
    LIMIT 1;
    ```

3. **Retrieve the top three invoice totals:**
    ```sql
    SELECT total
    FROM invoice
    ORDER BY total DESC
    LIMIT 3;
    ```

4. **Calculate the total invoices per billing city:**
    ```sql
    SELECT SUM(total) AS invoice_total, billing_city
    FROM invoice
    GROUP BY billing_city
    ORDER BY invoice_total DESC;
    ```

5. **Identify the customer who spent the most:**
    ```sql
    SELECT customer.customer_id, customer.first_name, customer.last_name, SUM(invoice.total) AS most_spent
    FROM customer
    JOIN invoice ON customer.customer_id = invoice.customer_id
    GROUP BY customer.customer_id 
    ORDER BY most_spent DESC
    LIMIT 1;
    ```

### Question Set 2 - Moderate
1. **Find customers who purchased Rock genre tracks:**
    ```sql
    SELECT first_name, last_name, email
    FROM customer
    JOIN invoice ON customer.customer_id = invoice.customer_id
    JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
    WHERE track_id IN (
        SELECT track_id
        FROM track
        JOIN genre ON track.genre_id = genre.genre_id  
        WHERE genre.name LIKE 'Rock'
    )
    ORDER BY email;
    ```

2. **Identify the top 10 artists in the Rock genre:**
    ```sql
    SELECT artist.artist_id, artist.name, COUNT(artist.artist_id) AS a
    FROM artist
    JOIN album ON album.artist_id = artist.artist_id
    JOIN track ON track.album_id = album.album_id
    JOIN genre ON track.genre_id = genre.genre_id  
    WHERE genre.name LIKE 'Rock'
    GROUP BY artist.artist_id 
    ORDER BY a DESC 
    LIMIT 10;
    ```

3. **Find tracks longer than the average length:**
    ```sql
    SELECT milliseconds, name
    FROM track
    WHERE milliseconds > (
        SELECT AVG(milliseconds) AS avg_len_songs
        FROM track
    )
    ORDER BY milliseconds DESC;
    ```

### Question Set 3 - Advanced
1. **Identify the best-selling artist:**
    ```sql
    WITH best_selling_artist AS (
        SELECT artist.artist_id AS aid, artist.name AS an,
               SUM(invoice_line.unit_price * invoice_line.quantity) AS tot
        FROM invoice_line
        JOIN track ON track.track_id = invoice_line.track_id
        JOIN album ON album.album_id = track.album_id
        JOIN artist ON artist.artist_id = album.artist_id
        GROUP BY 1
        ORDER BY 3 DESC 
        LIMIT 1
    )
    SELECT * FROM best_selling_artist;
    ```

2. **Find the top spending customer by artist:**
    ```sql
    SELECT customer.customer_id, customer.first_name, customer.last_name, artist.artist_id, artist.name, 
           SUM(invoice_line.unit_price * invoice_line.quantity) AS total_spend
    FROM invoice  
    JOIN customer ON customer.customer_id = invoice.customer_id
    JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id 
    JOIN track ON invoice_line.track_id = track.track_id
    JOIN album ON track.album_id = album.album_id
    JOIN artist ON album.artist_id = artist.artist_id
    GROUP BY customer.customer_id, customer.first_name, customer.last_name, artist.artist_id, artist.name
    ORDER BY total_spend DESC
    LIMIT 1;
    ```

3. **Determine the most purchased genre by country:**
    ```sql
    WITH popular_pur AS (
        SELECT COUNT(invoice_line.quantity) AS most_purchase, customer.country, genre.name, genre.genre_id,
               ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS row_numb
        FROM invoice_line
        JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
        JOIN customer ON customer.customer_id = invoice.customer_id  
        JOIN track ON track.track_id = invoice_line.track_id
        JOIN genre ON track.genre_id = genre.genre_id 
        GROUP BY 2, 3, 4
        ORDER BY 2 ASC, 1 DESC
    )
    SELECT * FROM popular_pur WHERE row_numb <= 1;
    ```

## Conclusion
This **SQL Music Store Project** demonstrates the ability to analyze real-world music store data, offering insights into customer behavior, genre popularity, and sales performance. The findings can guide business decisions, marketing strategies, and inventory management to foster growth and customer satisfaction.
