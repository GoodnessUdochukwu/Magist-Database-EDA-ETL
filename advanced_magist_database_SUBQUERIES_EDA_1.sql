use magist;

-- Find the average review score by state of the customer.
select state, `Name`, Capital, avg(review_score) as aveg_rev_score
from orders o
left join order_reviews o_r on o_r.order_id = o.order_id
left join customers c on o.customer_id = c.customer_id
left join geo g on c.customer_zip_code_prefix = g.zip_code_prefix
left join brazilian_states_data bsd on bsd.`Code` = g.state
group by state
order by aveg_rev_score desc;


-- Do reviews containing positive words have a better score? 
-- Some Portuguese positive words are: “bom”, “otimo”, “gostei”, “recomendo” and “excelente”.
with res1 as (select avg(review_score) ave_postv
			  from order_reviews o_r
			  where review_comment_message like '%bom%' or 
				    review_comment_message like '%otimo%' or 
				    review_comment_message like '%gostei%' or
				    review_comment_message like '%recomendo%' or
				    review_comment_message like '%excelente%'),
	 res2 as (select avg(review_score) ave_negtv
			  from order_reviews o_r
			  where review_comment_message not like '%bom%' and 
			  review_comment_message not like '%otimo%' and 
			  review_comment_message not like '%gostei%' and
			  review_comment_message not like '%recomendo%' and
			  review_comment_message not like '%excelente%')
select *
from res1
left outer join res2 on res1.ave_postv = res2.ave_negtv
union
select *
from res1
right outer join res2 on res1.ave_postv = res2.ave_negtv; 


-- Considering only states having at least 30 reviews containing these words, what is the state with the highest score?
select state, `Name`, Capital, avg(review_score) as aveg_rev_score, count(review_score) as cnt
from orders o
left join order_reviews o_r on o_r.order_id = o.order_id
left join customers c on o.customer_id = c.customer_id
left join geo g on c.customer_zip_code_prefix = g.zip_code_prefix
left join brazilian_states_data bsd on bsd.`Code` = g.state
where review_comment_message like '%bom%' or 
	  review_comment_message like '%otimo%' or 
      review_comment_message like '%gostei%' or
      review_comment_message like '%recomendo%' or
      review_comment_message like '%excelente%'
group by state
having cnt >= 30
order by aveg_rev_score desc;


-- What is the state where there is a greater score change between all reviews and reviews containing positive words?
with res1 as (select state, `Name`, Capital, max(review_score) `max`
			  from orders o
			  left join order_reviews o_r on o_r.order_id = o.order_id
			  left join customers c on o.customer_id = c.customer_id
			  left join geo g on c.customer_zip_code_prefix = g.zip_code_prefix
			  left join brazilian_states_data bsd on bsd.`Code` = g.state
			  where review_comment_message like '%bom%' or 
					review_comment_message like '%otimo%' or 
					review_comment_message like '%gostei%' or
					review_comment_message like '%recomendo%' or
					review_comment_message like '%excelente%'
			  group by state),
	 res2 as (select state, `Name`, Capital, min(review_score) `min`
			  from orders o
			  left join order_reviews o_r on o_r.order_id = o.order_id
			  left join customers c on o.customer_id = c.customer_id
			  left join geo g on c.customer_zip_code_prefix = g.zip_code_prefix
			  left join brazilian_states_data bsd on bsd.`Code` = g.state
              group by state)
select res1.state, res1.`Name`, res1.Capital, (res1.`max` - res2.`min`)
from res1
left join res2
on res1.state = res2.state;


