BEGIN;

CREATE TABLE category
(
    id       BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name     VARCHAR(50)    NOT NULL,
    price    DECIMAL(10, 2) NOT NULL DEFAULT 0 CHECK ( price >= 0 ),
    event_id BIGINT         NOT NULL REFERENCES events (id) ON DELETE RESTRICT,

    CONSTRAINT event_category_name_unique UNIQUE (name, event_id)
);

INSERT INTO
    category(name, price, event_id)
SELECT
    'Базовая', 0.0, id
FROM
    events;

ALTER TABLE
    tickets
ADD COLUMN
    category_id BIGINT REFERENCES category (id) ON DELETE RESTRICT;

UPDATE
    tickets
SET
    category_id =
        (
        SELECT
            id
        FROM
            category
        WHERE
            tickets.event_id = category.event_id AND category.name = 'Базовая'
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
