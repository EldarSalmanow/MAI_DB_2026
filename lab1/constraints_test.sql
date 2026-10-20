-- Проверка возраста
INSERT INTO users (email, password, name, age)
VALUES ('bill@gmail.com', 'smth', 'Билл', -5);

-- Проверка уникальности почты
INSERT INTO users (email, password, name, age)
VALUES ('alex.smith@gmail.com', 'smth2', 'Алекс', 22);

-- Проверка отношения времени конца к началу
INSERT INTO events (name, description, start_date, end_date, location_id, company_id)
VALUES ('smth',
        'description',
        '2026-10-20 18:00:00+03',
        '2026-10-20 12:00:00+03',
        1,
        1);

-- Проверка ценника
INSERT INTO tickets (user_id, event_id, price)
VALUES (1, 1, -500.00);

-- Проверка совместного ограничения на имя и адрес
INSERT INTO locations (name, description, address)
VALUES ('Main Hall', 'smth description', 'ул. Ленина, д. 10');
