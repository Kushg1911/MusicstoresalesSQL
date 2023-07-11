SET-1

Q1. Who is the senior most employee based on job title?

select * from employee
order by levels desc
limit 1

Q2. Which countries have the most Invoices?

select billing_country, count(*) as total_invoices from invoice
group by billing_country
order by total_invoices desc

Q3. What are top 3 values of total invoice?

select total from invoice
order by total desc
limit 3

Q4. Which city has the best customers? We would like to throw a promotional Music 
Festival in the city we made the most money. Write a query that returns one city that 
has the highest sum of invoice totals. Return both the city name & sum of all invoice 
totals

select billing_city, sum(total) as total_sales from invoice
group by billing_city
order by total_sales desc
limit 1

Q5. Who is the best customer? The customer who has spent the most money will be 
declared the best customer. Write a query that returns the person who has spent the 
most money

select c.first_name, c.last_name, sum(total) as total_sale from invoice as i
join customer as c on i.customer_id=c.customer_id
group by c.first_name, c.last_name
order by total_sale desc
limit 1

select * from genre

SET-2

Q1. Write query to return the email, first name, last name, & Genre of all Rock Music 
listeners. Return your list ordered alphabetically by email starting with A

select distinct customer.email, customer.first_name, customer.last_name, genre.name from customer
join invoice on customer.customer_id=invoice.customer_id
join invoice_line on invoice.invoice_id=invoice_line.invoice_id
join track on invoice_line.track_id=track.track_id
join genre on track.genre_id=genre.genre_id
where genre.name = 'Rock'
order by customer.email asc

Another way to get the answer:

SELECT DISTINCT email, first_name, last_name
 FROM customer
JOIN invoice ON customer.customer_id= invoice. customer_id
 JOIN invoiceline ON invoice. invoice_id = invoiceline. invoice_id
WHERE track_id IN(
     SELECT track_id FROM track
     JOIN genre ON track. genre_id = genre.genre_id
    WHERE genre.name LIKE 'Rock'I
 )
ORDER BY email;



Q2. Lets invite the artists who have written the most rock music in our dataset. Write a 
query that returns the Artist name and total track count of the top 10 rock bands

select distinct artist.name, count(track.track_id) as no_of_tracks from artist
join album on artist.artist_id=album.artist_id
join track on album.album_id=track.album_id
where genre_id = '1'
group by artist.name
order by no_of_tracks desc
limit 10


Q3. Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the 
longest songs listed first

select name, Milliseconds from track
where milliseconds > (select avg(milliseconds) as avg_length from track)
order by milliseconds desc


SET-3

Q1. Find how much amount spent by each customer on artists? Write a query to return
customer name, artist name and total spent

WITH ABC as (
select Ar.artist_id, Ar.name, sum(T.unit_price*IL.quantity) as total_sale  
from invoice_line as IL 
join track as T on IL.track_id=T.track_id
join album as A on T.album_id=A.album_id
join artist as Ar on A.artist_id=Ar.artist_id
group by Ar.artist_id, Ar.name
order by total_sale desc)

select C.first_name,C.last_name, ABC.name, sum(T.unit_price*IL.quantity)
from customer as C
join invoice as I on C.customer_id=I.customer_id
join invoice_line as IL on I.invoice_id=IL.invoice_id
join track as T on IL.track_id=T.track_id
join album as AL on T.album_id=AL.album_id
join ABC on AL.artist_id = ABC.artist_id
group by C.first_name,C.last_name, ABC.name


Q2. We want to find out the most popular music Genre for each country. We determine the 
most popular genre as the genre with the highest amount of purchases. Write a query 
that returns each country along with the top Genre. For countries where the maximum 
number of purchases is shared return all Genres

with popular_genre as (
select I.billing_country, G.name, count(IL.quantity) as purchases,
row_number() over (partition by I.billing_country order by count(IL.quantity) desc  ) 
from invoice as I
join invoice_line as IL on I.invoice_id=IL.invoice_id
join track as T on IL.track_id=T.track_id
join genre as G on T.genre_id=G.genre_id
group by I.billing_country, G.name
order by I.billing_country,  row_number() over (partition by I.billing_country order by count(IL.quantity) desc  )
)
select * from popular_genre
where row_number <= 1
order by purchases

Q3. Write a query that determines the customer that has spent the most on music for each 
country. Write a query that returns the country along with the top customer and how
much they spent. For countries where the top amount spent is shared, provide all 
customers who spent this amount

select I.billing_country, first_name, last_name,sum(total) as total_sale, rank() over (partition by I.billing_country order by sum(total)) as Top_customers
from customer as C
join invoice as I on I.customer_id=C.customer_id
group by I.billing_country, first_name, last_name
order by 1

select * from (select I.billing_country, first_name, last_name,sum(total) as total_sale, rank() over (partition by I.billing_country order by sum(total)) as Top_customers
from customer as C
join invoice as I on I.customer_id=C.customer_id
group by I.billing_country, first_name, last_name
order by 1) Country_wise_top
where top_customers = '1'
order by 4 desc
















