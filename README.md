# Vehicle Rental System — Documentation

## Project Overview

This repository contains a set of SQL queries for a vehicle booking system. The queries demonstrate common tasks such as listing bookings with customer and vehicle details, finding vehicles without bookings, filtering available vehicles by type, and aggregating booking counts per vehicle.
- **ERD:** https://drawsql.app/teams/area-6/diagrams/vehicle-rental-system
- **Files:** [queries.sql](queries.sql): SQL queries used in this assignment.

## Database Context (Assumptions)

These queries assume a relational schema with at least the following tables and columns:
- `users` (columns: `user_id`, `name`, ...)
- `vehicles` (columns: `vehicle_id`, `name`, `type`, `status`, ...)
- `bookings` (columns: `booking_id`, `user_id`, `vehicle_id`, `start_date`, `end_date`, `status`, ...)

Adjust table or column names if your schema differs.

## Queries and Solutions

Below are each of the queries from `queries.sql` with an explanation of what they return and notes about expected results.

1) List bookings with customer and vehicle details

SQL:

```sql
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
```

Results:

| booking_id | customer_name | vehicle_name   | start_date  | end_date    | status    |
|-----------:|---------------|----------------|-------------|-------------|-----------|
| 1          | Alice         | Honda Civic    | 2023-10-01  | 2023-10-05  | completed |
| 2          | Alice         | Honda Civic    | 2023-11-01  | 2023-11-03  | completed |
| 3          | Charlie       | Honda Civic    | 2023-12-01  | 2023-12-02  | confirmed |
| 4          | Alice         | Toyota Corolla | 2023-12-10  | 2023-12-12  | pending   |

Solution / Explanation:
- Returns one row per booking, joining the `bookings` table to `users` and `vehicles` to provide readable customer and vehicle names alongside booking dates and status.
- Use this query to display a booking ledger or admin view. If a booking references a missing user or vehicle, those bookings will be omitted because of the `INNER JOIN`s.

2) Find vehicles with no bookings

SQL:

```sql
SELECT *
FROM vehicles v
WHERE NOT EXISTS (
	SELECT 1
	FROM bookings b
	WHERE b.vehicle_id = v.vehicle_id
);
```

Results:

| vehicle_id | name        | type  | model | registration_number | rental_price | status      |
|-----------:|-------------|-------|-------|---------------------|-------------:|-------------|
| 3          | Yamaha R15  | bike  | 2023  | GHI-789             | 30           | available   |
| 4          | Ford F-150  | truck | 2020  | JKL-012             | 100          | maintenance |

Solution / Explanation:
- Returns all vehicles that have no rows in the `bookings` table (i.e., never been booked).
- Useful for listing unused or new vehicles. `NOT EXISTS` is efficient and correct even when `bookings.vehicle_id` can be NULL.

3) Filter available cars

SQL:

```sql
SELECT *
FROM vehicles
WHERE status = 'available'
AND type = 'car';
```

Results:

| vehicle_id | name           | type | model | registration_number | rental_price | status    |
|-----------:|----------------|------|-------|---------------------|-------------:|-----------|
| 1          | Toyota Corolla | car  | 2022  | ABC-123             | 50           | available |

Solution / Explanation:
- Returns vehicles whose `status` is `'available'` and whose `type` is `'car'`.
- Useful for presenting inventory to customers filtered by vehicle type. If you expect case-insensitive matching, consider using `LOWER(type) = 'car'`.

4) Vehicles with more than 2 bookings (booking counts)

SQL:

```sql
SELECT
	v.name as vehicle_name,
	COUNT(b.booking_id) AS total_bookings
FROM bookings b
INNER JOIN vehicles v ON b.vehicle_id = v.vehicle_id
GROUP BY v.name
HAVING COUNT(b.booking_id) > 2;
```

Results:

| vehicle_name | total_bookings  |
|--------------|----------------:|
| Honda Civic  | 3               |

Solution / Explanation:
- Aggregates bookings by `vehicles.name` and returns vehicles that have more than two bookings.
- Useful for identifying high-utilization vehicles. If multiple vehicles can share the same `name`, grouping by `v.vehicle_id, v.name` is safer to avoid conflating different vehicles with identical names.

## Conclusion

This short project documents four representative SQL queries for a vehicle booking system, including example results and usage notes. The examples demonstrate how to join tables for readable booking listings, detect unbooked vehicles, filter available inventory, and aggregate booking counts. These queries can be adapted to your production schema and extended with parameters, indexes, and prepared statements for robustness.

## Contact / Accounts

- **GitHub:** https://github.com/alamin-87
- **LinkedIn:** https://www.linkedin.com/in/alamin87/
- **Portfolio:** https://personalportfolioalamin.netlify.app/
