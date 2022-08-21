delimiter //
create procedure score_finder(in statename varchar(50),
							  in prdtcateg varchar(100),
							  in `year` int,
							  out avegscore double)
begin
select avg(review_score)
from order_items o_i
left join products p on o_i.product_id = p.product_id
left join product_category_name_translation pcnt on p.product_category_name = pcnt.product_category_name
left join order_reviews o_r on o_i.order_id = o_r.order_id
left join orders o on o_i.order_id = o.order_id
left join customers c on o.customer_id = c.customer_id
left join geo g on c.customer_zip_code_prefix = g.zip_code_prefix
left join brazilian_states_data bsd on bsd.`Code` = g.state
where o.order_status = 'delivered' and bsd.`Name` = statename and 
	  pcnt.product_category_name_english = prdtcateg and year(o_r.review_creation_date) = `year`;
end//

delimiter ;

use magist;

call score_finder('Sao Paulo', 'baby', 2017, @avegscore); 
select @avegscore;