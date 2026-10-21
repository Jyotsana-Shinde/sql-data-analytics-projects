create database megaproject2;
use megaproject2;

select * from customers;
select * from orders;
select * from order_items; 
select * from products;
select * from payments;
select * from shipping;
select * from returns;
select * from user_activity;

-- Q1. Top 10 customers by total spending
SELECT 
    c.customer_id, 
    c.customer_name, 
    SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC
LIMIT 10;


-- Q2. Customers with no orders in last 6 months
SELECT 
    customer_id, 
    customer_name, 
    email
FROM Customers
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id 
    FROM Orders 
    WHERE order_date >= DATE_SUB((SELECT MAX(order_date) FROM Orders), INTERVAL 6 MONTH)
);


-- Q3. Segment customers by number of orders
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders,
    CASE 
        WHEN COUNT(o.order_id) >= 5 THEN 'Frequent Buyer'
        WHEN COUNT(o.order_id) BETWEEN 2 AND 4 THEN 'Regular Buyer'
        ELSE 'Occasional Buyer'
    END AS customer_segment
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;


-- Q4. High-value low-frequency customers
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS order_count,
    AVG(o.total_amount) AS avg_order_value
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) <= 2 
   AND AVG(o.total_amount) > (SELECT AVG(total_amount) FROM Orders);


-- Q5. New vs returning customers
SELECT 
    CASE 
        WHEN order_count = 1 THEN 'New Customer'
        ELSE 'Returning Customer'
    END AS customer_type,
    COUNT(customer_id) AS total_customers
FROM (
    SELECT customer_id, COUNT(order_id) AS order_count
    FROM Orders
    GROUP BY customer_id
) subquery
GROUP BY customer_type;


-- Q6. Customers with increasing order trend (monthly)
WITH MonthlyOrders AS (
    SELECT 
        customer_id,
        EXTRACT(MONTH FROM order_date) AS order_month,
        COUNT(order_id) AS monthly_count,
        LAG(COUNT(order_id)) OVER(PARTITION BY customer_id ORDER BY EXTRACT(MONTH FROM order_date)) AS prev_month_count
    FROM Orders
    GROUP BY customer_id, EXTRACT(MONTH FROM order_date)
)
SELECT DISTINCT customer_id 
FROM MonthlyOrders
WHERE monthly_count > prev_month_count;


-- Q7. Customers with declining order trend
WITH MonthlyOrders AS (
    SELECT 
        customer_id,
        EXTRACT(MONTH FROM order_date) AS order_month,
        COUNT(order_id) AS monthly_count,
        LAG(COUNT(order_id)) OVER(PARTITION BY customer_id ORDER BY EXTRACT(MONTH FROM order_date)) AS prev_month_count
    FROM Orders
    GROUP BY customer_id, EXTRACT(MONTH FROM order_date)
)
SELECT DISTINCT customer_id 
FROM MonthlyOrders
WHERE monthly_count < prev_month_count;


-- Q8. Average order value per customer
SELECT 
    c.customer_id,
    c.customer_name,
    ROUND(AVG(o.total_amount), 2) AS avg_order_value
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY avg_order_value DESC;


-- Q9. Customers with highest return rate
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders,
    SUM(CASE WHEN o.order_status = 'Returned' THEN 1 ELSE 0 END) AS returned_orders,
    ROUND(SUM(CASE WHEN o.order_status = 'Returned' THEN 1 ELSE 0 END) * 100.0 / COUNT(o.order_id), 2) AS return_rate_pct
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY return_rate_pct DESC;


-- Q10. Customers using multiple payment methods
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT p.payment_method) AS distinct_payment_methods
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Payments p ON o.payment_id = p.payment_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(DISTINCT p.payment_method) > 1;


-- Q11. Customers who purchased with discounts only
SELECT 
    c.customer_id,
    c.customer_name
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING MIN(o.discount_amount) > 0;


-- Q12. Customer lifetime value (total spend)
SELECT 
    c.customer_id,
    c.customer_name,
    ROUND(SUM(o.total_amount), 2) AS customer_lifetime_value
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_status != 'Cancelled'  -- कैंसल ऑर्डर्स को हटाकर वास्तविक कमाई
GROUP BY c.customer_id, c.customer_name
ORDER BY customer_lifetime_value DESC;


-- Q13. High spend but low login activity customers
SELECT 
    c.customer_id,
    c.customer_name,
    SUM(o.total_amount) AS total_spent,
    c.last_login_date
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.last_login_date
HAVING SUM(o.total_amount) > (SELECT AVG(total_amount)*3 FROM Orders) -- हाई स्पेंडर की परिभाषा
ORDER BY c.last_login_date ASC;


-- Q14. Customers with multiple orders
SELECT 
    c.customer_id,
    c.customer_name,
    SUM(o.total_amount) AS total_spent,
    c.last_login_date
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.last_login_date
HAVING SUM(o.total_amount) > (SELECT AVG(total_amount)*3 FROM Orders) -- हाई स्पेंडर की परिभाषा
ORDER BY c.last_login_date ASC;


-- Q15. Recently active customers
SELECT 
    customer_id,
    customer_name,
    last_login_date
FROM Customers
WHERE last_login_date >= DATE_SUB((SELECT MAX(last_login_date) FROM Customers), INTERVAL 30 DAY)
ORDER BY last_login_date DESC;


-- Q16. Total revenue by month
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS order_month,
    ROUND(SUM(total_amount), 2) AS total_revenue
FROM Orders
WHERE order_status != 'Cancelled'
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY order_month;


-- Q17. Revenue growth (MoM)
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS order_month,
    ROUND(SUM(total_amount), 2) AS total_revenue
FROM Orders
WHERE order_status != 'Cancelled'
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY order_month;


-- Q18. Highest revenue day
SELECT 
    DATE(order_date) AS order_day,
    ROUND(SUM(total_amount), 2) AS daily_revenue
FROM Orders
WHERE order_status != 'Cancelled'
GROUP BY DATE(order_date)
ORDER BY daily_revenue DESC
LIMIT 1;


-- Q19. Peak sales hour
SELECT 
    EXTRACT(HOUR FROM order_date) AS sales_hour,
    ROUND(SUM(total_amount), 2) AS hourly_revenue,
    COUNT(order_id) AS total_orders
FROM Orders
WHERE order_status != 'Cancelled'
GROUP BY EXTRACT(HOUR FROM order_date)
ORDER BY hourly_revenue DESC
LIMIT 1;


-- Q20. Average order value trend
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS order_month,
    ROUND(AVG(total_amount), 2) AS avg_order_value
FROM Orders
WHERE order_status != 'Cancelled'
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY order_month;


-- Q21. Revenue by product category
SELECT 
    p.category,
    ROUND(SUM(oi.total_price), 2) AS category_revenue
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
JOIN Orders o ON oi.order_id = o.order_id
WHERE o.order_status != 'Cancelled'
GROUP BY p.category
ORDER BY category_revenue DESC;


-- Q22. Revenue by city
SELECT 
    c.city,
    ROUND(SUM(o.total_amount), 2) AS city_revenue
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_status != 'Cancelled'
GROUP BY c.city
ORDER BY city_revenue DESC;


-- Q23. Top 5 products by revenue
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    ROUND(SUM(oi.total_price), 2) AS product_revenue
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
JOIN Orders o ON oi.order_id = o.order_id
WHERE o.order_status != 'Cancelled'
GROUP BY p.product_id, p.product_name, p.category
ORDER BY product_revenue DESC
LIMIT 5;


-- Q24. Lowest performing products
SELECT 
    p.product_id,
    p.product_name,
    ROUND(SUM(IFNULL(oi.total_price, 0)), 2) AS product_revenue
FROM Products p
LEFT JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY product_revenue ASC
LIMIT 10;


-- Q25. Revenue lost due to cancellations
SELECT 
    COUNT(order_id) AS cancelled_orders_count,
    ROUND(SUM(total_amount), 2) AS revenue_lost
FROM Orders
WHERE order_status = 'Cancelled';


-- Q26. Impact of discount on revenue
SELECT 
    CASE WHEN discount_amount > 0 THEN 'Discounted Order' ELSE 'Full Price Order' END AS order_type,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(total_amount), 2) AS gross_revenue,
    ROUND(SUM(discount_amount), 2) AS total_discount_given
FROM Orders
WHERE order_status != 'Cancelled'
GROUP BY CASE WHEN discount_amount > 0 THEN 'Discounted Order' ELSE 'Full Price Order' END;


-- Q27. Weekend vs weekday sales
SELECT 
    CASE WHEN DAYOFWEEK(order_date) IN (1, 7) THEN 'Weekend' ELSE 'Weekday' END AS day_type,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(total_amount), 2) AS total_sales,
    ROUND(AVG(total_amount), 2) AS avg_order_value
FROM Orders
WHERE order_status != 'Cancelled'
GROUP BY CASE WHEN DAYOFWEEK(order_date) IN (1, 7) THEN 'Weekend' ELSE 'Weekday' END;


-- Q28. Monthly seasonality trend
SELECT 
    MONTHNAME(order_date) AS month_name,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(total_amount), 2) AS seasonal_revenue
FROM Orders
WHERE order_status != 'Cancelled'
GROUP BY MONTH(order_date), MONTHNAME(order_date)
ORDER BY MONTH(order_date);


-- Q29. High discount period performance
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS order_month,
    ROUND(SUM(discount_amount), 2) AS total_discount,
    ROUND(AVG(discount_amount / total_amount) * 100, 2) AS avg_discount_percentage,
    ROUND(SUM(total_amount), 2) AS total_sales
FROM Orders
WHERE order_status != 'Cancelled'
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
HAVING avg_discount_percentage > 5  -- थ्रेशोल्ड डेटा के अनुसार सेट कर सकते हैं
ORDER BY avg_discount_percentage DESC;


-- Q30. Detect revenue spikes
WITH DailyRevenue AS (
    SELECT 
        DATE(order_date) AS order_day,
        SUM(total_amount) AS daily_rev
    FROM Orders
    WHERE order_status != 'Cancelled'
    GROUP BY DATE(order_date)
),
MovingAvg AS (
    SELECT 
        order_day,
        daily_rev,
        AVG(daily_rev) OVER (ORDER BY order_day ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING) AS avg_last_7_days
    FROM DailyRevenue
)
SELECT 
    order_day,
    ROUND(daily_rev, 2) AS spiked_revenue,
    ROUND(avg_last_7_days, 2) AS normal_7_day_avg
FROM MovingAvg
WHERE daily_rev > (avg_last_7_days * 1.5) -- जो सामान्य से 1.5 गुना अधिक हो
ORDER BY order_day;


-- Q31. Top selling products
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    SUM(oi.quantity) AS total_quantity_sold
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
JOIN Orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_quantity_sold DESC
LIMIT 10;


-- Q32. Least selling products
SELECT 
    p.product_id,
    p.product_name,
    IFNULL(SUM(oi.quantity), 0) AS total_quantity_sold
FROM Products p
LEFT JOIN Order_Items oi ON p.product_id = oi.product_id
LEFT JOIN Orders o ON oi.order_id = o.order_id AND o.order_status = 'Completed'
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold ASC
LIMIT 10;


-- Q33. Frequently returned products
SELECT 
    p.product_id,
    p.product_name,
    COUNT(r.return_id) AS total_returns,
    r.return_reason
FROM Returns r
JOIN Products p ON r.product_id = p.product_id
GROUP BY p.product_id, p.product_name, r.return_reason
ORDER BY total_returns DESC
LIMIT 10;


-- Q34. Highest rated products
SELECT 
    product_id,
    product_name,
    category,
    brand,
    rating
FROM Products
WHERE rating IS NOT NULL
ORDER BY rating DESC
LIMIT 10;


-- Q35. Low rating but high sales products
SELECT 
    p.product_id,
    p.product_name,
    p.rating,
    SUM(oi.quantity) AS total_sold
FROM Products p
JOIN Order_Items oi ON p.product_id = oi.product_id
WHERE p.rating < 3.0
GROUP BY p.product_id, p.product_name, p.rating
ORDER BY total_sold DESC
LIMIT 10;


-- Q36. Product demand trend
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
    SUM(oi.quantity) AS total_units_demanded
FROM Order_Items oi
JOIN Orders o ON oi.order_id = o.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY sales_month;


-- Q37. Out-of-stock products
SELECT 
    product_id,
    product_name,
    category,
    brand,
    stock_quantity
FROM Products
WHERE stock_quantity = 0;


-- Q38. Profit margin per product
SELECT 
    product_id,
    product_name,
    price,
    cost_price,
    ROUND((price - cost_price), 2) AS profit_per_unit,
    ROUND(((price - cost_price) / price) * 100, 2) AS profit_margin_percentage
FROM Products
ORDER BY profit_margin_percentage DESC;


-- Q39. Frequently bought together products
SELECT 
    oi1.product_id AS product_a,
    p1.product_name AS product_name_a,
    oi2.product_id AS product_b,
    p2.product_name AS product_name_b,
    COUNT(*) AS times_bought_together
FROM Order_Items oi1
JOIN Order_Items oi2 ON oi1.order_id = oi2.order_id AND oi1.product_id < oi2.product_id
JOIN Products p1 ON oi1.product_id = p1.product_id
JOIN Products p2 ON oi2.product_id = p2.product_id
GROUP BY oi1.product_id, p1.product_name, oi2.product_id, p2.product_name
ORDER BY times_bought_together DESC
LIMIT 5;


-- Q40. Category performance
SELECT 
    p.category,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    SUM(oi.quantity) AS total_quantity_sold,
    ROUND(SUM(oi.total_price), 2) AS total_revenue,
    ROUND(AVG(p.rating), 2) AS avg_product_rating
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;


-- Q41. Dead stock products
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    p.stock_quantity,
    p.launch_date
FROM Products p
LEFT JOIN Order_Items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL AND p.stock_quantity > 0;


-- Q42. High views but low purchases
WITH ProductViews AS (
    SELECT product_id, COUNT(activity_id) AS total_activities
    FROM User_Activity
    WHERE activity_type IN ('Wishlist', 'Add_to_cart')
    GROUP BY product_id
),
ProductSales AS (
    SELECT product_id, IFNULL(SUM(quantity), 0) AS total_purchased
    FROM Order_Items
    GROUP BY product_id
)
SELECT 
    p.product_id,
    p.product_name,
    v.total_activities AS customer_engagements,
    IFNULL(s.total_purchased, 0) AS units_sold
FROM Products p
JOIN ProductViews v ON p.product_id = v.product_id
LEFT JOIN ProductSales s ON p.product_id = s.product_id
ORDER BY v.total_activities DESC, units_sold ASC
LIMIT 10;


-- Q43. Product lifecycle (sales over time)
SELECT 
    p.product_id,
    p.product_name,
    EXTRACT(YEAR_MONTH FROM o.order_date) AS sales_period,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.total_price), 2) AS periodic_revenue
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
JOIN Orders o ON oi.order_id = o.order_id
GROUP BY p.product_id, p.product_name, EXTRACT(YEAR_MONTH FROM o.order_date)
ORDER BY p.product_id, sales_period;


-- Q44. Orders per day
SELECT 
    DATE(order_date) AS order_day,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(total_amount), 2) AS total_amount_collected
FROM Orders
GROUP BY DATE(order_date)
ORDER BY order_day;


-- Q45. Cancellation rate
SELECT 
    COUNT(order_id) AS total_orders,
    SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_orders,
    ROUND((SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0 / COUNT(order_id)), 2) AS cancellation_rate_pct
FROM Orders;


-- Q46. Return rate
SELECT 
    COUNT(order_id) AS total_orders,
    SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0 END) AS returned_orders,
    ROUND((SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0 END) * 100.0 / COUNT(order_id)), 2) AS return_rate_pct
FROM Orders;


-- Q47. Average delivery time
SELECT 
    delivery_partner,
    COUNT(shipping_id) AS total_shipments,
    ROUND(AVG(DATEDIFF(delivery_date, shipping_date)), 1) AS avg_delivery_days
FROM Shipping
WHERE delivery_status = 'Delivered'
GROUP BY delivery_partner;


-- Q48. Late deliveries
SELECT 
    shipping_id,
    order_id,
    delivery_partner,
    shipping_date,
    delivery_date,
    delivery_status
FROM Shipping
WHERE delivery_status = 'Delayed';


-- Q49. Orders with multiple items
SELECT 
    order_id,
    COUNT(product_id) AS distinct_items_count,
    SUM(quantity) AS total_quantity
FROM Order_Items
GROUP BY order_id
HAVING COUNT(product_id) > 1
ORDER BY distinct_items_count DESC;


-- Q50. Payment failure rate
SELECT 
    payment_method,
    COUNT(payment_id) AS total_transactions,
    SUM(CASE WHEN payment_status = 'Failed' THEN 1 ELSE 0 END) AS failed_transactions,
    ROUND((SUM(CASE WHEN payment_status = 'Failed' THEN 1 ELSE 0 END) * 100.0 / COUNT(payment_id)), 2) AS failure_rate_pct
FROM Payments
GROUP BY payment_method;


-- Q51. Orders by payment method
SELECT 
    p.payment_method,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(o.total_amount), 2) AS total_revenue
FROM Orders o
JOIN Payments p ON o.payment_id = p.payment_id
GROUP BY p.payment_method
ORDER BY total_orders DESC;


-- Q52. High value transactions (> threshold)
SELECT 
    order_id,
    customer_id,
    order_date,
    total_amount
FROM Orders
WHERE total_amount > 50000
ORDER BY total_amount DESC;


-- Q53. Suspicious transactions (>2x avg)
SELECT 
    order_id,
    customer_id,
    total_amount
FROM Orders
WHERE total_amount > (SELECT AVG(total_amount) * 2 FROM Orders)
ORDER BY total_amount DESC;


-- Q54. Peak time orders
SELECT 
    CASE 
        WHEN EXTRACT(HOUR FROM order_date) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM order_date) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN EXTRACT(HOUR FROM order_date) BETWEEN 17 AND 21 THEN 'Evening'
        ELSE 'Night'
    END AS time_of_day,
    COUNT(order_id) AS total_orders
FROM Orders
GROUP BY time_of_day
ORDER BY total_orders DESC;


-- Q55. Repeat purchase behavior
SELECT 
    total_orders_placed,
    COUNT(customer_id) AS total_customers
FROM (
    SELECT customer_id, COUNT(order_id) AS total_orders_placed
    FROM Orders
    GROUP BY customer_id
) sub
GROUP BY total_orders_placed
ORDER BY total_orders_placed DESC;


-- Q56. Order funnel (View → Cart → Order)
SELECT 
    activity_type,
    COUNT(activity_id) AS total_actions
FROM User_Activity
GROUP BY activity_type
UNION ALL
SELECT 
    'Final Order Placed' AS activity_type,
    COUNT(order_id) AS total_actions
FROM Orders;


-- Q57. Delivery time by city
SELECT 
    city,
    COUNT(shipping_id) AS total_deliveries,
    ROUND(AVG(DATEDIFF(delivery_date, shipping_date)), 1) AS avg_delivery_days
FROM Shipping
WHERE delivery_status = 'Delivered'
GROUP BY city
ORDER BY avg_delivery_days ASC;


-- Q58. Delayed shipments
SELECT 
    shipping_id,
    order_id,
    delivery_partner,
    shipping_cost,
    city
FROM Shipping
WHERE delivery_status = 'Delayed';


-- Q59. Delivery partner performance
SELECT 
    delivery_partner,
    COUNT(shipping_id) AS total_handled,
    SUM(CASE WHEN delivery_status = 'Delivered' THEN 1 ELSE 0 END) AS successful_deliveries,
    SUM(CASE WHEN delivery_status = 'Delayed' THEN 1 ELSE 0 END) AS delayed_deliveries,
    ROUND(AVG(DATEDIFF(delivery_date, shipping_date)), 1) AS avg_days_taken
FROM Shipping
GROUP BY delivery_partner
ORDER BY avg_days_taken ASC;


-- Q60. Shipping cost analysis
SELECT 
    delivery_partner,
    city,
    ROUND(AVG(shipping_cost), 2) AS avg_shipping_cost,
    ROUND(SUM(shipping_cost), 2) AS total_shipping_spent
FROM Shipping
GROUP BY delivery_partner, city
ORDER BY avg_shipping_cost DESC;


-- Q61. Delivered vs returned
SELECT 
    o.order_status,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(o.total_amount), 2) AS total_value
FROM Orders o
WHERE o.order_status IN ('Completed', 'Returned')
GROUP BY o.order_status;


-- Q62. Same-day delivery(delivery_date = shipping_date)
SELECT 
    COUNT(shipping_id) AS same_day_deliveries_count,
    delivery_partner,
    ROUND(SUM(shipping_cost), 2) AS total_shipping_cost
FROM Shipping
WHERE DATE(delivery_date) = DATE(shipping_date) AND delivery_status = 'Delivered'
GROUP BY delivery_partner;


-- Q63. Failed deliveries
SELECT 
    shipping_id,
    order_id,
    delivery_partner,
    city,
    delivery_status
FROM Shipping
WHERE delivery_status IN ('Failed', 'Cancelled');


-- Q64. Delivery success rate
SELECT 
    delivery_partner,
    COUNT(shipping_id) AS total_shipments,
    SUM(CASE WHEN delivery_status = 'Delivered' THEN 1 ELSE 0 END) AS delivered_count,
    ROUND((SUM(CASE WHEN delivery_status = 'Delivered' THEN 1 ELSE 0 END) * 100.0 / COUNT(shipping_id)), 2) AS success_rate_pct
FROM Shipping
GROUP BY delivery_partner;


-- 65. Discount impact on sales
SELECT 
    CASE WHEN discount_amount > 0 THEN 'Discount Applied' ELSE 'No Discount' END AS discount_status,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(total_amount), 2) AS total_sales,
    ROUND(AVG(total_amount), 2) AS avg_order_value
FROM Orders
WHERE order_status != 'Cancelled'
GROUP BY CASE WHEN discount_amount > 0 THEN 'Discount Applied' ELSE 'No Discount' END;


-- 66. Customers using highest discounts
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_discounted_orders,
    ROUND(SUM(o.discount_amount), 2) AS total_discount_availed
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.discount_amount > 0
GROUP BY c.customer_id, c.customer_name
ORDER BY total_discount_availed DESC
LIMIT 10;


-- 67. Discount vs profit
SELECT 
    CASE 
        WHEN o.discount_amount = 0 THEN '0% (No Discount)'
        WHEN (o.discount_amount / (o.total_amount + o.discount_amount)) <= 0.10 THEN 'Up to 10% Discount'
        ELSE 'Above 10% Discount'
    END AS discount_range,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.total_price), 2) AS gross_sales,
    ROUND(SUM(oi.total_price - (p.cost_price * oi.quantity)), 2) AS estimated_profit
FROM Orders o
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
WHERE o.order_status != 'Cancelled'
GROUP BY discount_range;


-- 68. Revenue during discount vs non-discount
SELECT 
    IF(discount_amount > 0, 'Discounted Orders', 'Non-Discounted Orders') AS order_type,
    ROUND(SUM(total_amount), 2) AS revenue
FROM Orders
WHERE order_status != 'Cancelled'
GROUP BY order_type;


-- 69. Conversion rate (activity → order)
SELECT 
    (SELECT COUNT(DISTINCT order_id) FROM Orders) * 100.0 / 
    (SELECT COUNT(activity_id) FROM User_Activity) AS activity_to_order_conversion_rate;


-- 70. First-time discount users
WITH FirstOrders AS (
    SELECT 
        customer_id,
        order_id,
        discount_amount,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS rn
    FROM Orders
)
SELECT 
    COUNT(customer_id) AS first_time_discount_users
FROM FirstOrders
WHERE rn = 1 AND discount_amount > 0;


-- 71. Stock vs demand
SELECT 
    p.product_id,
    p.product_name,
    p.stock_quantity AS current_stock,
    IFNULL(SUM(oi.quantity), 0) AS units_sold,
    CASE 
        WHEN p.stock_quantity < IFNULL(SUM(oi.quantity), 0) THEN 'High Risk (Low Stock)'
        ELSE 'Safe Stock Levels'
    END AS stock_status
FROM Products p
LEFT JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name, p.stock_quantity;


-- 72. Fast vs slow moving products
SELECT 
    p.product_id,
    p.product_name,
    IFNULL(SUM(oi.quantity), 0) AS total_units_sold,
    CASE 
        WHEN IFNULL(SUM(oi.quantity), 0) >= 50 THEN 'Fast Moving'
        WHEN IFNULL(SUM(oi.quantity), 0) BETWEEN 10 AND 49 THEN 'Medium Moving'
        ELSE 'Slow Moving'
    END AS movement_velocity
FROM Products p
LEFT JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name;


-- 73. Inventory turnover
SELECT 
    p.product_id,
    p.product_name,
    ROUND(SUM(oi.quantity) / NULLIF(p.stock_quantity, 0), 2) AS inventory_turnover_ratio
FROM Products p
JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name, p.stock_quantity;


-- 74. Overstock vs understock
SELECT 
    product_id,
    product_name,
    stock_quantity,
    CASE 
        WHEN stock_quantity > 400 THEN 'Overstocked'
        WHEN stock_quantity < 50 THEN 'Understocked'
        ELSE 'Normal'
    END AS inventory_status
FROM Products;


-- 75. Reorder level (low stock items)
SELECT 
    product_id,
    product_name,
    stock_quantity
FROM Products
WHERE stock_quantity < 30;


-- 76. Warehouse (city) stock performance
SELECT 
    s.city AS warehouse_location,
    COUNT(DISTINCT p.product_id) AS unique_products_stored,
    SUM(p.stock_quantity) AS total_stock_available
FROM Shipping s
JOIN Order_Items oi ON s.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
GROUP BY s.city;


-- 77. Dead inventory
SELECT 
    p.product_id,
    p.product_name,
    p.stock_quantity
FROM Products p
LEFT JOIN Order_Items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL AND p.stock_quantity > 0;


-- 78. Most used payment method
SELECT 
    payment_method,
    COUNT(payment_id) AS usage_count
FROM Payments
GROUP BY payment_method
ORDER BY usage_count DESC
LIMIT 1;


-- 79. Payment success vs failure
SELECT 
    payment_method,
    SUM(CASE WHEN payment_status = 'Success' THEN 1 ELSE 0 END) AS success_count,
    SUM(CASE WHEN payment_status = 'Failed' THEN 1 ELSE 0 END) AS failure_count,
    ROUND(SUM(CASE WHEN payment_status = 'Success' THEN 1 ELSE 0 END) * 100.0 / COUNT(payment_id), 2) AS success_rate_pct
FROM Payments
GROUP BY payment_method;


-- 80. COD vs online behavior
SELECT 
    IF(p.payment_method = 'COD', 'COD Users', 'Online Payment Users') AS user_type,
    COUNT(o.order_id) AS total_orders,
    ROUND(AVG(o.total_amount), 2) AS avg_spending
FROM Orders o
JOIN Payments p ON o.payment_id = p.payment_id
GROUP BY IF(p.payment_method = 'COD', 'COD Users', 'Online Payment Users');


-- 81. High value payment methods (Define high value = amount > 50,000)
SELECT 
    p.payment_method,
    COUNT(o.order_id) AS high_value_transactions_count
FROM Orders o
JOIN Payments p ON o.payment_id = p.payment_id
WHERE o.total_amount > 50000
GROUP BY p.payment_method
ORDER BY high_value_transactions_count DESC;


-- 82. Refund processing time
SELECT 
    refund_status,
    COUNT(return_id) AS refund_requests,
    ROUND(AVG(DATEDIFF(return_date, (SELECT MIN(order_date) FROM Orders))), 1) AS avg_days_to_process
FROM Returns
GROUP BY refund_status;


-- 83. Payment trend over time (Group by month using payment_date)
SELECT 
    DATE_FORMAT(payment_date, '%Y-%m') AS payment_month,
    payment_method,
    COUNT(payment_id) AS transaction_count,
    ROUND(SUM(transaction_amount), 2) AS total_amount
FROM Payments
GROUP BY DATE_FORMAT(payment_date, '%Y-%m'), payment_method
ORDER BY payment_month ASC, transaction_count DESC;


-- 84. Rating vs sales
SELECT 
    CASE 
        WHEN rating >= 4.5 THEN 'Excellent (4.5 - 5.0)'
        WHEN rating >= 3.5 THEN 'Good (3.5 - 4.4)'
        WHEN rating >= 2.5 THEN 'Average (2.5 - 3.4)'
        ELSE 'Poor (Below 2.5)'
    END AS rating_range,
    COUNT(p.product_id) AS total_products,
    IFNULL(SUM(oi.quantity), 0) AS total_units_sold
FROM Products p
LEFT JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY rating_range;


-- 85. Low rating products
SELECT 
    product_id,
    product_name,
    category,
    brand,
    rating
FROM Products
WHERE rating < 2.5
ORDER BY rating ASC;


-- 86. Delivery delay impact (proxy), Delayed = delivery_status = 'Delayed'
SELECT 
    s.delivery_status,
    COUNT(DISTINCT o.customer_id) AS total_impacted_customers,
    ROUND(AVG(o.total_amount), 2) AS avg_next_order_value
FROM Shipping s
JOIN Orders o ON s.order_id = o.order_id
GROUP BY s.delivery_status;


-- 87. Repeat purchase vs rating
SELECT 
    p.rating,
    COUNT(oi.product_id) AS repeat_purchase_count
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
JOIN Orders o ON oi.order_id = o.order_id
WHERE o.customer_id IN (
    SELECT customer_id FROM Orders GROUP BY customer_id HAVING COUNT(order_id) > 1
)
GROUP BY p.rating
ORDER BY p.rating DESC;


-- 88. Engagement vs purchase
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT ua.activity_id) AS engagement_count,
    COUNT(DISTINCT o.order_id) AS purchase_count
FROM Customers c
LEFT JOIN User_Activity ua ON c.customer_id = ua.customer_id
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY engagement_count DESC;


-- 89. Cohort analysis
WITH CustomerCohort AS (
    SELECT 
        customer_id,
        DATE_FORMAT(signup_date, '%Y-%m') AS cohort_month
    FROM Customers
),
OrderActivity AS (
    SELECT 
        customer_id,
        DATE_FORMAT(order_date, '%Y-%m') AS order_month
    FROM Orders
)
SELECT 
    cc.cohort_month,
    oa.order_month,
    COUNT(DISTINCT cc.customer_id) AS active_customers
FROM CustomerCohort cc
JOIN OrderActivity oa ON cc.customer_id = oa.customer_id
GROUP BY cc.cohort_month, oa.order_month
ORDER BY cc.cohort_month, oa.order_month;


-- 90. RFM segmentation, RFM = Recency, Frequency, Monetary
WITH RFM_Base AS (
    SELECT 
        customer_id,
        DATEDIFF((SELECT MAX(order_date) FROM Orders), MAX(order_date)) AS recency,
        COUNT(order_id) AS frequency,
        SUM(total_amount) AS monetary
    FROM Orders
    WHERE order_status != 'Cancelled'
    GROUP BY customer_id
)
SELECT 
    customer_id,
    recency, frequency, monetary,
    NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
    NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
    NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
FROM RFM_Base;


-- 91. Basket analysis
SELECT 
    oi1.product_id AS product_a,
    oi2.product_id AS product_b,
    COUNT(*) AS times_ordered_together
FROM Order_Items oi1
JOIN Order_Items oi2 ON oi1.order_id = oi2.order_id AND oi1.product_id < oi2.product_id
GROUP BY oi1.product_id, oi2.product_id
ORDER BY times_ordered_together DESC
LIMIT 10;


-- 92. Churn prediction (inactive users) No orders in last 6 months = churn
SELECT 
    c.customer_id,
    c.customer_name,
    MAX(o.order_date) AS last_order_date
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING last_order_date IS NULL 
   OR last_order_date < DATE_SUB((SELECT MAX(order_date) FROM Orders), INTERVAL 6 MONTH);


-- 93. Identify unusual drop in product sales
WITH MonthlySales AS (
    SELECT 
        product_id,
        DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
        SUM(oi.quantity) AS current_month_qty
    FROM Order_Items oi
    JOIN Orders o ON oi.order_id = o.order_id
    GROUP BY product_id, DATE_FORMAT(o.order_date, '%Y-%m')
),
SalesComparison AS (
    SELECT 
        product_id,
        sales_month,
        current_month_qty,
        LAG(current_month_qty) OVER (PARTITION BY product_id ORDER BY sales_month) AS prev_month_qty
    FROM MonthlySales
)
SELECT * 
FROM SalesComparison
WHERE current_month_qty < (prev_month_qty * 0.5);


-- 94. Detect spikes in orders
WITH DailyOrders AS (
    SELECT DATE(order_date) AS order_day, COUNT(order_id) AS order_count FROM Orders GROUP BY DATE(order_date)
),
MovingAvg AS (
    SELECT order_day, order_count,
           AVG(order_count) OVER (ORDER BY order_day ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING) AS avg_7_days
    FROM DailyOrders
)
SELECT order_day, order_count AS spiked_orders, ROUND(avg_7_days, 2) AS normal_avg
FROM MovingAvg 
WHERE order_count > (avg_7_days * 1.8);


-- 95. Pareto (Top 20% revenue customers)
WITH CustomerRevenue AS (
    SELECT customer_id, SUM(total_amount) AS total_spend,
           SUM(SUM(total_amount)) OVER () AS global_revenue,
           ROW_NUMBER() OVER (ORDER BY SUM(total_amount) DESC) AS row_num,
           COUNT(*) OVER () AS total_customers
    FROM Orders
    WHERE order_status != 'Cancelled'
    GROUP BY customer_id
)
SELECT customer_id, total_spend
FROM CustomerRevenue
WHERE row_num <= (total_customers * 0.20);


-- 96. Cross-selling opportunities
SELECT 
    oi1.product_id AS primary_product,
    oi2.product_id AS cross_sell_product,
    p1.category,
    COUNT(*) AS frequency
FROM Order_Items oi1
JOIN Order_Items oi2 ON oi1.order_id = oi2.order_id AND oi1.product_id != oi2.product_id
JOIN Products p1 ON oi1.product_id = p1.product_id
JOIN Products p2 ON oi2.product_id = p2.product_id
WHERE p1.category = p2.category
GROUP BY oi1.product_id, oi2.product_id, p1.category
ORDER BY frequency DESC
LIMIT 10;


-- 97. Price vs demand relationship (Compare price vs quantity sold)
SELECT 
    p.product_id,
    p.price,
    SUM(oi.quantity) AS total_units_sold,
    ROUND(SUM(oi.total_price), 2) AS total_revenue
FROM Products p
LEFT JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.price
ORDER BY p.price DESC;


-- 98. Likely to purchase customers (Recent activity + high past orders)
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS past_orders
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN User_Activity ua ON c.customer_id = ua.customer_id
WHERE ua.activity_date >= DATE_SUB((SELECT MAX(activity_date) FROM User_Activity), INTERVAL 15 DAY)
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(DISTINCT o.order_id) >= 3;


-- 99. Seasonal demand trend (Use month/quarter grouping)
SELECT 
    EXTRACT(QUARTER FROM order_date) AS sales_quarter,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(total_amount), 2) AS total_revenue
FROM Orders
WHERE order_status != 'Cancelled'
GROUP BY EXTRACT(QUARTER FROM order_date)
ORDER BY sales_quarter;


-- 100. Monthly retention rate
WITH MonthlyActive AS (
    SELECT DISTINCT customer_id, DATE_FORMAT(order_date, '%Y-%m') AS order_month
    FROM Orders
)
SELECT 
    m1.order_month AS current_month,
    COUNT(DISTINCT m1.customer_id) AS retained_customers,
    ROUND(COUNT(DISTINCT m1.customer_id) * 100.0 / COUNT(DISTINCT m2.customer_id), 2) AS retention_rate_pct
FROM MonthlyActive m1
JOIN MonthlyActive m2 ON m1.customer_id = m2.customer_id 
    AND m1.order_month = DATE_FORMAT(DATE_ADD(STR_TO_DATE(CONCAT(m2.order_month, '-01'), '%Y-%m-%d'), INTERVAL 1 MONTH), '%Y-%m')
GROUP BY m1.order_month;


-- 101. Avg days between purchases
WITH OrderDates AS (
    SELECT customer_id, order_date,
           LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_order_date
    FROM Orders
)
SELECT 
    customer_id,
    ROUND(AVG(DATEDIFF(order_date, prev_order_date)), 1) AS avg_days_between_purchases
FROM OrderDates
WHERE prev_order_date IS NOT NULL
GROUP BY customer_id;


-- 102. Top categories per customer
WITH CustomerCategoryOrders AS (
    SELECT 
        o.customer_id, p.category, COUNT(oi.order_item_id) AS item_count,
        ROW_NUMBER() OVER (PARTITION BY o.customer_id ORDER BY COUNT(oi.order_item_id) DESC) AS rn
    FROM Orders o
    JOIN Order_Items oi ON o.order_id = oi.order_id
    JOIN Products p ON oi.product_id = p.product_id
    GROUP BY o.customer_id, p.category
)
SELECT customer_id, category AS top_preferred_category, item_count
FROM CustomerCategoryOrders
WHERE rn = 1;


-- 103. Order frequency distribution
WITH OrderCounts AS (
    SELECT customer_id, COUNT(order_id) AS total_orders FROM Orders GROUP BY customer_id
)
SELECT 
    total_orders AS orders_placed,
    COUNT(customer_id) AS customer_count
FROM OrderCounts
GROUP BY total_orders
ORDER BY orders_placed;


-- 104. Revenue contribution per segment
SELECT 
    c.customer_segment,
    COUNT(DISTINCT c.customer_id) AS unique_customers,
    ROUND(SUM(o.total_amount), 2) AS total_revenue_contributed,
    ROUND((SUM(o.total_amount) * 100.0 / (SELECT SUM(total_amount) FROM Orders WHERE order_status != 'Cancelled')), 2) AS contribution_percentage
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_status != 'Cancelled'
GROUP BY c.customer_segment
ORDER BY total_revenue_contributed DESC;





