-- 1.1
ALTER TABLE events
    ADD COLUMN IF NOT EXISTS status VARCHAR(20) DEFAULT 'created';

INSERT INTO users (email, password, name, age)
VALUES ('ghost_user@mail.com', 'pass', 'Иван Безбилетников', 25)
ON CONFLICT (email) DO NOTHING;

INSERT INTO users (email, password, name, age)
SELECT 'user_mass_' || seq || '@test.com', 'pass', 'Покупатель ' || seq, 20 + (seq % 30)
FROM generate_series(1, 15) seq
ON CONFLICT (email) DO NOTHING;

INSERT INTO locations (name, description, address)
VALUES ('Заброшенный ДК', 'Тут не было и не будет мероприятий', 'ул. Пустоты, 0'),
       ('Main Hall', 'Главная площадка', 'ул. Ленина, д. 10')
ON CONFLICT (name, address) DO NOTHING;

INSERT INTO companies (name, description)
VALUES ('Rock Agency', 'Организатор рок-концертов'),
       ('Expo Group', 'Организатор выставок')
ON CONFLICT (name) DO NOTHING;

INSERT INTO events (name, description, start_date, end_date, location_id, company_id, status)
SELECT 'Грандиозный Концерт',
       'Настоящий рок Концерт года',
       '2026-08-15 19:00:00+03',
       '2026-08-15 23:00:00+03',
       (SELECT id FROM locations WHERE name = 'Main Hall' LIMIT 1),
       (SELECT id FROM companies WHERE name = 'Rock Agency' LIMIT 1),
       'completed'
WHERE NOT EXISTS (SELECT 1 FROM events WHERE name = 'Грандиозный Концерт');

INSERT INTO events (name, description, start_date, end_date, location_id, company_id, status)
SELECT 'Сентябрьская Выставка',
       'Просто выставка технологий',
       '2026-09-10 10:00:00+03',
       '2026-09-10 18:00:00+03',
       (SELECT id FROM locations WHERE name != 'Заброшенный ДК' LIMIT 1),
       (SELECT id FROM companies WHERE name = 'Expo Group' LIMIT 1),
       'created'
WHERE NOT EXISTS (SELECT 1 FROM events WHERE name = 'Сентябрьская Выставка');

INSERT INTO events (name, description, start_date, end_date, location_id, company_id, status)
SELECT 'Октябрьский Рейв',
       'Танцы до утра',
       '2026-10-31 23:00:00+03',
       '2026-11-01 06:00:00+03',
       (SELECT id FROM locations WHERE name = 'Main Hall' LIMIT 1),
       (SELECT id FROM companies WHERE name = 'Rock Agency' LIMIT 1),
       'cancelled'
WHERE NOT EXISTS (SELECT 1 FROM events WHERE name = 'Октябрьский Рейв');

INSERT INTO categories (name, price, event_id)
SELECT 'VIP', 5000.00, id
FROM events
WHERE name = 'Грандиозный Концерт'
ON CONFLICT DO NOTHING;

INSERT INTO categories (name, price, event_id)
SELECT 'Promo', 0.00, id
FROM events
WHERE name = 'Грандиозный Концерт'
ON CONFLICT DO NOTHING;

INSERT INTO categories (name, price, event_id)
SELECT 'Базовая', 1500.00, id
FROM events
WHERE name = 'Сентябрьская Выставка'
ON CONFLICT DO NOTHING;

INSERT INTO categories (name, price, event_id)
SELECT 'Танцпол', 2500.00, id
FROM events
WHERE name = 'Октябрьский Рейв'
ON CONFLICT DO NOTHING;

INSERT INTO tickets (user_id, category_id, price)
SELECT u.id,
       c.id,
       c.price
FROM users u
         CROSS JOIN categories c
WHERE u.email != 'ghost_user@mail.com'
LIMIT 110;

-- 1.2
BEGIN;

INSERT INTO companies (name, description)
VALUES ('Scam Company LLC', 'Организатор-мошенник');

INSERT INTO events (name, description, start_date, end_date, location_id, company_id, status)
VALUES ('Фейковый концерт', 'Обман зрителей',
        '2026-12-31 20:00:00+03', '2026-12-31 23:00:00+03',
        (SELECT id FROM locations LIMIT 1),
        (SELECT id FROM companies WHERE name = 'Scam Company LLC'),
        'created');

UPDATE events
SET status = 'cancelled'
WHERE name = 'Фейковый концерт';

UPDATE tickets
SET price = price * 1.10
WHERE price > 2000.00;

DELETE
FROM events
WHERE name = 'Фейковый концерт';
DELETE
FROM companies
WHERE name = 'Scam Company LLC';

ROLLBACK;
