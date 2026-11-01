CREATE TABLE users
(
    id       BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    email    VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    name     VARCHAR(50)  NOT NULL,
    age      INT          NOT NULL CHECK ( age >= 0 )
);

CREATE TABLE locations
(
    id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    description TEXT         NOT NULL,
    address     VARCHAR(255) NOT NULL,

    CONSTRAINT name_address_unique_check UNIQUE (name, address)
);

CREATE TABLE companies
(
    id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name        VARCHAR(100) NOT NULL UNIQUE,
    description TEXT         NOT NULL
);

CREATE TABLE events
(
    id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    description TEXT         NOT NULL,
    start_date  TIMESTAMPTZ  NOT NULL,
    end_date    TIMESTAMPTZ  NOT NULL CHECK ( end_date >= start_date ),
    location_id BIGINT       NOT NULL REFERENCES locations (id) ON DELETE RESTRICT,
    company_id  BIGINT       NOT NULL REFERENCES companies (id) ON DELETE RESTRICT
);

CREATE TABLE tickets
(
    id       BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id  BIGINT         NOT NULL REFERENCES users (id) ON DELETE RESTRICT,
    event_id BIGINT         NOT NULL REFERENCES events (id) ON DELETE RESTRICT,
    price    DECIMAL(10, 2) NOT NULL DEFAULT 0 CHECK ( price >= 0 )
);

-- категории билетов (для каждой своя цена).
-- при изменении цены в категории билета не должна изменяться цена уже существующих билетов
