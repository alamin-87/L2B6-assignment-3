
SELECT
    b.booking_id,
    u.name AS customer_name,
    v.name as vehicle_name,
    b.start_date,
    b.end_date,
    b.status
FROM bookings b
INNER JOIN users u ON b.user_id = u.user_id
INNER JOIN vehicles v ON b.vehicle_id = v.vehicle_id;


SELECT *
FROM vehicles v
WHERE NOT EXISTS (
    SELECT 1
    FROM bookings b
    WHERE b.vehicle_id = v.vehicle_id
);



SELECT *
FROM vehicles
WHERE status = 'available'
AND type = 'car';



SELECT
    v.name as vehicle_name,
    COUNT(b.booking_id) AS total_bookings
FROM bookings b
INNER JOIN vehicles v ON b.vehicle_id = v.vehicle_id
GROUP BY v.name
HAVING COUNT(b.booking_id) > 2;






