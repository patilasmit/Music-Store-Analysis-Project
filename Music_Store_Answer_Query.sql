											SQL PROJECT- MUSIC STORE DATA ANALYSIS 
													Question Set 1 - Easy 


1.
select *
from employee
order by levels desc
limit 1

2.
select billing_country , count(*) as c
from invoice
group by billing_country
order by c desc
limit 1

3.
select total from invoice
order by total desc
limit 3

select * from customer
select * from track

4.
select sum(total) invoice_total , billing_city
from invoice
group by billing_city
order by invoice_total desc

5.
select customer.customer_id , customer.first_name , customer.last_name , sum(invoice.total) as most_spent
from customer
join invoice on customer.customer_id = invoice.invoice_id
group by customer.customer_id 
order by most_spent desc
limit 1
                     						
                     						Question Set 2 – Moderate 
1.
select  first_name , last_name ,email 
from customer 
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id 
where track_id in (
	select track_id from track 
	join genre on track.genre_id = genre.genre_id  
	where genre.name like 'Rock'
)
order by email 

select * from customer
select * from artist
select * from album
select * from invoice

2.
select artist.artist_id , artist.name ,count(artist.artist_id ) as a
from artist
join album on album.artist_id = artist.artist_id
join track on track.album_id = album.album_id
join genre on track.genre_id = genre.genre_id  
where genre.name like 'Rock'
group by artist.artist_id 
order by a desc 
limit 10


3.
select  milliseconds , name
from track
where milliseconds > (
	select avg(milliseconds) as avg_len_songs
	from track
)
order by  milliseconds desc
	

										Question Set 3 – Advance 
1.
with  best_selling_artist as (
	select artist.artist_id as aid , artist.name as an ,
	sum (invoice_line.unit_price * invoice_line.quantity) as tot
	from invoice_line
	join track on track.tarck_id = invoice_line.track_id
	join album on album.album_id = track.album_id
	join artist on artist.artist_id = album.artist_id
	group by 1
	order by 3 desc 
	limit 1
)


2.
select customer.customer_id , customer.first_name, customer.last_name , artist.artist_id , artist.name, 
sum (invoice_line.unit_price * invoice_line.quantity) as total_spend
from invoice  
join customer on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id 
join track on invoice_line.track_id = track.track_id
join album on track.album_id = album.album_id
join artist on album.artist_id = artist.artist_id
group by customer.customer_id , customer.first_name, customer.last_name ,artist.artist_id , artist.name
order by total_spend desc
limit 1 

3.
with popular_pur as 
	(select count(invoice_line.quantity) as most_purchase,customer.country , genre.name , genre.genre_id ,
	row_number() over(partition by customer.country order by count(invoice_line.quantity) desc) as row_numb
	from invoice_line
	join invoice on  invoice.invoice_id = invoice_line.invoice_id
	join customer on  customer.customer_id = invoice.customer_id  
	join track on track.track_id = invoice_line.track_id
	join genre on track.genre_id = genre.genre_id 
	group by 2,3,4
	order by 2 asc , 1 desc
)
select * from popular_pur where row_numb <= 1