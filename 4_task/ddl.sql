create database if not exists otus_db;

create user if not exists otus_db_user with password 'db_pass';
grant otus_db_role to otus_db_user;

create schema if not exists products;
create schema if not exists buyers;
create schema if not exists orders;

create table if not exists products.category (
    category_id smallint GENERATED ALWAYS AS IDENTITY,
    name varchar(255) NOT NULL,
    CONSTRAINT category_pk PRIMARY KEY (category_id)
);

create table if not exists products.provider (
    provider_id integer GENERATED ALWAYS AS IDENTITY,
    name varchar(255) NOT NULL,
    CONSTRAINT provider_pk PRIMARY KEY (provider_id)
);

create table if not exists products.manufacturer (
    manufacturer_id integer GENERATED ALWAYS AS IDENTITY,
    name varchar(255) NOT NULL,
    CONSTRAINT manufacturer_pk PRIMARY KEY (manufacturer_id)
);

create table if not exists products.product (
     product_id bigint GENERATED ALWAYS AS IDENTITY,
     name varchar(255) NOT NULL,
     description TEXT NOT NULL,
     category_id smallint NOT NULL REFERENCES products.category ON DELETE RESTRICT,
     manufacturer_id integer NOT NULL REFERENCES products.manufacturer ON DELETE RESTRICT,
     is_visible BOOLEAN NOT NULL,
     CONSTRAINT product_pk PRIMARY KEY (product_id)
);

create table if not exists products.provider_product_price (
    provider_product_id bigint GENERATED ALWAYS AS IDENTITY,
    product_id bigint NOT NULL REFERENCES products.product ON DELETE RESTRICT,
    provider_id integer NOT NULL REFERENCES products.provider ON DELETE RESTRICT,
    price NUMERIC(10,2) NOT NULL CHECK (price > 0),
    CONSTRAINT provider_product_price_pk PRIMARY KEY (provider_product_id),
    UNIQUE(product_id, provider_id)
);

create table if not exists buyers.buyer (
    buyer_id bigint GENERATED ALWAYS AS IDENTITY,
    name varchar(255) NOT NULL,
    CONSTRAINT buyer_pk PRIMARY KEY (buyer_id)
);

create table if not exists orders.order_status (
    status_id smallint GENERATED ALWAYS AS IDENTITY,
    name varchar(255) NOT NULL,
    CONSTRAINT "order_status_pk" PRIMARY KEY ("status_id")
);

create table if not exists orders.order (
    order_id bigint GENERATED ALWAYS AS IDENTITY,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    status_id smallint NOT NULL REFERENCES orders.order_status ON DELETE RESTRICT,
    buyer_id bigint NOT NULL REFERENCES buyers.buyer ON DELETE RESTRICT,
    CONSTRAINT order_pk PRIMARY KEY (order_id)
);

create table if not exists orders.order_item (
    order_id bigint NOT NULL REFERENCES orders.order ON DELETE RESTRICT,
    provider_product_id bigint NOT NULL REFERENCES products.provider_product_price ON DELETE RESTRICT,
    quantity integer NOT NULL CHECK (quantity >= 1),
    price NUMERIC(10,2) NOT NULL CHECK (price > 0),
    CONSTRAINT order_item_pk PRIMARY KEY (order_id,provider_product_id)
);

create role otus_db_role;

alter schema products owner to otus_db_role;
alter schema orders owner to otus_db_role;
alter schema buyers owner to otus_db_role;

alter table products.provider_product_price owner to otus_db_role;
alter table products.provider owner to otus_db_role;
alter table products.category owner to otus_db_role;
alter table products.product owner to otus_db_role;
alter table products.manufacturer owner to otus_db_role;
alter table orders.order_status owner to otus_db_role;
alter table orders.order owner to otus_db_role;
alter table orders.order_item owner to otus_db_role;
alter table buyers.buyer owner to otus_db_role;