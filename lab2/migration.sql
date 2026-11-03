BEGIN;

CREATE TABLE categories
(
    id       BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name     VARCHAR(50)    NOT NULL,
    price    DECIMAL(10, 2) NOT NULL DEFAULT 0 CHECK ( price >= 0 ),
    event_id BIGINT         NOT NULL REFERENCES events (id) ON DELETE RESTRICT,

    CONSTRAINT event_category_name_unique UNIQUE (name, event_id)
);

INSERT INTO
    categories(name, price, event_id)
SELECT
    'Базовая', 0.0, id
FROM
    events;

ALTER TABLE
    tickets
ADD COLUMN
    category_id BIGINT REFERENCES categories (id) ON DELETE RESTRICT;

UPDATE
    tickets
SET
    category_id =
        (
        SELECT
            id
        FROM
            categories
        WHERE
            tickets.event_id = categories.event_id AND categories.name = 'Базовая'
        )
WHERE
    category_id IS NULL;

ALTER TABLE
    tickets
ALTER COLUMN
    category_id
SET
    NOT NULL;

ALTER TABLE
    tickets
DROP COLUMN
    event_id;

COMMIT;
