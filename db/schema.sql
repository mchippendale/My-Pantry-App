create database mypantry;

CREATE TABLE users (
    id SERIAL PRIMARY KEY, 
    email TEXT,
    password_digest TEXT
)

CREATE TABLE items (
    id SERIAL PRIMARY KEY, 
    name TEXT,
    image_url TEXT,
    comment TEXT,
    user_id INTEGER
);

