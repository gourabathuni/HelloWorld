CREATE TABLE users 
(
    id SERIAL PRIMARY KEY, 
    username varchar(64), 
    first_name varchar(64), 
    last_name varchar(64), 
    password varchar(64),
    last_login timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE files
(
    id SERIAL PRIMARY KEY,
    filename varchar(256),
    path varchar(1024),
    upload_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_id int REFERENCES users
);

CREATE TYPE user_records AS
(
    id integer,
    username VARCHAR(64),
    first_name VARCHAR(64),
    last_name VARCHAR(64),
    last_login TIMESTAMP WITH TIME ZONE
);

CREATE OR REPLACE FUNCTION get_all_active_users()
RETURNS SETOF user_records
LANGUAGE SQL
AS $$


    SELECT DISTINCT u.id, u.username, u.first_name, u.last_name, u.last_login
    FROM users u
    JOIN files ON (u.id = files.user_id)
    WHERE u.last_login < CURRENT_TIMESTAMP + '1 week'::interval;

$$;


