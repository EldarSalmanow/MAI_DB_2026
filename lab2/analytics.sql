-- Посещаемость мероприятий
SELECT events.name,
       COUNT(tickets.id) AS tickets_count
FROM events
         JOIN tickets ON events.id = tickets.event_id
GROUP BY events.name
ORDER BY tickets_count DESC, events.name DESC;

-- Средний чек на каждом мероприятии
SELECT events.name,
       AVG(tickets.price)
FROM events
         JOIN tickets ON events.id = tickets.event_id
GROUP BY events.name;

-- Выручка компаний за всё время
SELECT companies.name,
       SUM(tickets.price)
FROM companies
         JOIN events ON companies.id = events.company_id
         JOIN tickets ON events.id = tickets.event_id
GROUP BY companies.name;

-- Места проведения мероприятий, отсортированные по популярности
SELECT locations.name,
       COUNT(events.id)
FROM locations
         JOIN events ON locations.id = events.location_id
GROUP BY locations.name;

-- Таблица расходов клиентов по месяцам
SELECT users.name,
       to_char(events.start_date, 'Month') AS month_name,
       COUNT(tickets.id)
FROM users
         JOIN tickets ON users.id = tickets.user_id
         JOIN events ON tickets.event_id = events.id
GROUP BY users.name, events.start_date
ORDER BY users.name DESC, month_name;


-- SELECT companies.name,
--        to_char(events.start_date, 'Month') AS month_name
-- FROM companies
-- JOIN events ON companies.id = events.company_id
-- JOIN tickets ON events.id = tickets.event_id
-- WHERE
--
-- SELECT companies.name,
--        SUM(tickets.price)
-- FROM companies
--          JOIN events ON companies.id = events.company_id
--          JOIN tickets ON events.id = tickets.event_id
-- GROUP BY to_char(events.start_date, 'Month')
-- FILTER
-- GROUP BY companies.name;

DROP VIEW my_view;

CREATE VIEW
    my_view
AS
    SELECT
        companies.name as company_name,
        events.name as event_name,
        tickets.price as event_price
    FROM
        companies
    JOIN events ON companies.id = events.company_id
    JOIN tickets ON events.id = tickets.event_id
    WHERE tickets.price > 3000;

SELECT * FROM my_view;
