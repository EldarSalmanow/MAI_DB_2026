INSERT INTO users (email, password, name, age)
VALUES ('alex.smith@gmail.com', 'welcome123', 'Алексей Смирнов', 25),
       ('maria.ivanova@gmail.com', '2welcome123', 'Мария Иванова', 19),
       ('dmitry_dev@yandex.ru', '3welcome123', 'Дмитрий Петров', 31);

INSERT INTO locations (name, description, address)
VALUES ('Main Hall', 'Главный концертный зал города с хорошей акустикой', 'ул. Ленина, д. 10'),
       ('Tech Space', 'Современный коворкинг и конференц-зал', 'пр. Космонавтов, д. 45'),
       ('Open Air Park', 'Открытая площадка в парке для летних фестивалей', 'Парк культуры, секция Б');

INSERT INTO companies (name, description)
VALUES ('ArtEvents LLC', 'Организация музыкальных концертов и шоу'),
       ('IT Conf Group', 'Проведение технических конференций и митапов');

INSERT INTO events (name, description, start_date, end_date, location_id, company_id)
VALUES ('Концерт Сироткина', 'Концерт популярного исполнителя Сироткина',
        '2026-07-15 18:00:00+03', '2026-07-15 23:00:00+03', 3, 1),
       ('C++ Russia', 'Ежегодная конференция по C++ в России',
        '2026-10-10 10:00:00+03', '2026-10-10 18:00:00+03', 2, 2),
       ('VK Fest', 'Самый масштабный ежегодный фестиваль современной музыки в России от VK',
        '2026-11-05 19:00:00+03', '2026-11-05 21:30:00+03', 1, 1);

INSERT INTO tickets (user_id, event_id, price)
VALUES (1, 1, 2500.00),
       (2, 1, 2500.00),
       (1, 2, 5000.00),
       (3, 2, 4500.00),
       (2, 3, 1200.00);
