-- 2.1.1 Реестр проданных билетов
SELECT users.name,
       events.name,
       categories.name,
       tickets.price,
       locations.name
FROM users
JOIN tickets ON users.id = tickets.user_id
JOIN categories ON tickets.category_id = categories.id
JOIN events ON categories.event_id = events.id
JOIN locations ON events.location_id = locations.id;

-- 2.1.2 Локации без мероприятий
SELECT locations.name,
       locations.address
FROM locations
LEFT JOIN events ON locations.id = events.location_id
WHERE events.location_id IS NULL;

-- 2.1.3 Пользователи, которые покупали билеты, где цена > 3000
SELECT users.email,
       events.name,
       tickets.price
FROM users
JOIN tickets ON users.id = tickets.user_id
JOIN categories ON tickets.category_id = categories.id
JOIN events ON categories.event_id = events.id
WHERE tickets.price > 3000;

-- 2.2.1 Общее количество проданных билетов и суммарная выручка на каждом мероприятии
SELECT events.name,
       COUNT(tickets.id),
       SUM(tickets.price)
FROM events
JOIN categories ON events.id = categories.event_id
JOIN tickets ON tickets.category_id = categories.id
GROUP BY events.name
HAVING COUNT(tickets.id) > 5;

-- 2.2.2 "Богатые" клиенты.
SELECT users.name,
       AVG(tickets.price)
FROM users
JOIN tickets ON users.id = tickets.user_id
GROUP BY users.name
HAVING AVG(tickets.price) > 2000;

-- 2.2.3 Суммарная выручка сервиса в разбивке по месяцам проведения мероприятий
SELECT to_char(events.start_date, 'Month'),
       SUM(tickets.price)
FROM events
JOIN categories ON events.id = categories.event_id
JOIN tickets ON categories.id = tickets.category_id
GROUP BY to_char(events.start_date, 'Month')
ORDER BY SUM(tickets.price) DESC;

-- 3.1 Билеты, проданные по цене, которая строго больше, чем средняя цена всех проданных билетов
SELECT tickets.id,
       users.name,
       tickets.price
FROM tickets
JOIN users ON tickets.user_id = users.id
WHERE tickets.price > (SELECT AVG(tickets.price) FROM tickets);

-- 3.2 Компании, которые провели/проведут хотя бы одно мероприятие со словом "концерт" в описании
SELECT companies.name
FROM companies
WHERE EXISTS(SELECT 1 FROM events WHERE events.company_id = companies.id AND events.description ILIKE '%концерт%');

-- 3.3 Имена пользователей, которые зарегистрированы в системе, но не купили ни одного билета
SELECT users.name
FROM users
WHERE NOT EXISTS(SELECT 1 FROM tickets WHERE tickets.user_id = users.id);

-- 3.4 Самое дорогое мероприятие у каждой компании
SELECT c.name AS company_name,
       e.name AS event_name,
       cat.price AS max_price
FROM companies c
JOIN events e ON c.id = e.company_id
JOIN categories cat ON e.id = cat.event_id
WHERE cat.price = (
    SELECT MAX(cat_inner.price)
    FROM events e_inner
    JOIN categories cat_inner ON e_inner.id = cat_inner.event_id
    WHERE e_inner.company_id = c.id
);

-- 4 "Рейтинг привлекательности организаторов" (конверсия и доходность каждой компании)
WITH EventStats AS (
    SELECT events.id AS event_id,
           events.company_id AS company_id,
           COUNT(tickets.id) AS tickets_count,
           SUM(tickets.price) AS revenue
    FROM events
    JOIN categories ON events.id = categories.event_id
    JOIN tickets ON categories.id = tickets.category_id
    GROUP BY events.id, events.company_id
), CompanyAgg AS (
    SELECT companies.id AS company_id,
           COUNT(EventStats.event_id) AS events_count,
           SUM(EventStats.tickets_count) AS company_tickets_count,
           SUM(EventStats.revenue) AS company_revenue
    FROM companies
    JOIN EventStats ON companies.id = EventStats.company_id
    GROUP BY companies.id
)
SELECT companies.name,
       CompanyAgg.company_tickets_count,
       CompanyAgg.company_revenue,
       CompanyAgg.company_revenue / NULLIF(CompanyAgg.company_tickets_count, 0) AS avg_revenue_per_event
FROM companies
JOIN CompanyAgg ON companies.id = CompanyAgg.company_id
ORDER BY avg_revenue_per_event DESC;

-- для каждой категории билета посчитать количество проданных билетов, доход с них (для каждой категории).
-- в результате оставить только те категории, у которых средний доход выше, чем средний доход по абсолютно всем билетам

-- 5
SELECT categories.id AS category_id,
       categories.name AS category_name,
       COUNT(tickets.id) AS category_tickets_count,
       SUM(tickets.price) AS category_revenue
FROM categories
JOIN tickets ON categories.id = tickets.category_id
GROUP BY categories.id, categories.name
HAVING AVG(tickets.price) > (SELECT AVG(tickets.price) FROM tickets);
