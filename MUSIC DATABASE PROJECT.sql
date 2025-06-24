-- Q1 who is the senior most employee based on job title?
SELECT * FROM employee
ORDER BY levels desc
limit 1

--Q2 Which countries have thew most invoices?
Select COUNT(*) as c,billing_country
from invoice
group by billing_country
order by c desc

--Q3 What are top three values of total invoice?
SELECT total FROM invoice
ORDER BY total desc
limit 3

--Q4which city has the best customer?Wer would like to throw a promotional miusic festval in the city we made the most money.Write a query that returns one city has the highest sum of invoice totals.return both the city name & sum lf all invoice totals
select SUM(total) as invoice_total,billing_city
from invoice
group by billing_city
order by invoice_total desc

--Q5 Who is the best customer?The customer who has the spent the most money will be declared the best customer .Write a query that returns the person who has spent the most money.
Select customer.customer_id,customer.first_name,customer.last_name, SUM(invoice.total) as total
from customer
JOIN invoice ON customer.customer_id=invoice.customer_id
GROUP BY customer.customer_id
ORDER BY total desc
limit 1


--Q6 Write query to return the e-mail,first name,last name,& genre of all rock music listeners,
--Return the list ordered alphabetically by e-mail starting with A
select DISTINCT email,first_name,last_name
from customer
JOIN invoice on customer.customer_id=invoice.customer_id
JOIN invoice_line on invoice.invoice_id=invoice_line.invoice_id
WHERE track_id IN(
Select track_id from track
JOIN genre on track.genre_id=genre.genre_id
WHERE genre.name LIKE 'Rock'
)
ORDER BY email;

--Q7 Let's invite the artists who have writtren the most rock music in our dataset.
--Write a query that returns the artist name and  total track count of the  top 10 rock bands 
 Select artist.artist_id,artist.name,COUNT( artist.artist_id) AS number_of_songs
 From track
 JOIN album ON album.album_id=track.album_id
 JOIN artist ON  artist.artist_id= album.artist_id
 JOIN genre ON genre.genre_id=track.genre_id
 WHERE genre.name LIKE 'Rock'
 GROUP BY artist.artist_id
 ORDER BY number_of_songs DESC
 LIMIT 10
--Q8 Return all the track names that have a song length longer than the average song length.
--Return the name and milliseconds for each track.Order by the song lentgh with the  longest songs listed first.
 Select name,milliseconds
 FROM track
 WHERE milliseconds>(SELECT AVG (milliseconds) as avg_track_length
 From track)
 ORDER BY milliseconds DESC;

--Or
 Select name,milliseconds
 FROM track
 WHERE milliseconds>393599 
 ORDER BY milliseconds DESC;


--Q9Find how much amount spent by each customer on artists?
--Write a query to return customer name,artist name and total spent

WITH best_selling_artist AS (
SELECT artist.artist_id AS artist_id,artist.name AS artist_name,
SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
FROM invoice_line
JOIN track ON track.track_id = invoice_line.track_id
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
GROUP BY 1
ORDER BY 3 DESC
LIMIT 1
)
Select c.customer_id,c.first_name,c.last_name,bsa.artist_name,
SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id=i.customer_id
JOIN invoice_line il ON il.invoice_id=i.invoice_id
JOIN track t ON t.track_id=il.track_id
JOIN album alb ON alb.album_id=t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id=alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

--Q10 Write a query that determines the  customer that has spent the most on music for each country. 
--Write a query that returns  the country along with the top customer and how much they spent.
--For countries where the top amount spent is shared,provide all customer who has spent this amount.
WITH customer_with_country AS (
Select customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
ROW_NUMBER() OVER (PARTITION BY billing_country ORDER BY SUM(total) DESC )AS RowNo
from invoice
JOIN customer ON customer.customer_id=invoice.customer_id
GROUP BY 1,2,3,4
ORDER BY 4 ASC,5 DESC)
SELECT * FROM  customer_with_country WHERE RowNo<=1


























    

 



































