--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'Standard public schema';


--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: postgres
--

CREATE PROCEDURAL LANGUAGE plpgsql;


ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO postgres;

SET search_path = public, pg_catalog;

--
-- Name: actor_actor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE actor_actor_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.actor_actor_id_seq OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: actor; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE actor (
    actor_id integer DEFAULT nextval('actor_actor_id_seq'::regclass) NOT NULL,
    first_name character varying(45) NOT NULL,
    last_name character varying(45) NOT NULL,
    last_update timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.actor OWNER TO postgres;

--
-- Name: mpaa_rating; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE mpaa_rating AS ENUM (
    'G',
    'PG',
    'PG-13',
    'R',
    'NC-17'
);


ALTER TYPE public.mpaa_rating OWNER TO postgres;

--
-- Name: year; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN year AS integer
	CONSTRAINT year_check CHECK (((VALUE >= 1901) AND (VALUE <= 2155)));


ALTER DOMAIN public.year OWNER TO postgres;

--
-- Name: _group_concat(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _group_concat(text, text) RETURNS text
    AS $_$
SELECT CASE
  WHEN $2 IS NULL THEN $1
  WHEN $1 IS NULL THEN $2
  ELSE $1 || ', ' || $2
END
$_$
    LANGUAGE sql IMMUTABLE;


ALTER FUNCTION public._group_concat(text, text) OWNER TO postgres;

--
-- Name: group_concat(text); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE group_concat(text) (
    SFUNC = _group_concat,
    STYPE = text
);


ALTER AGGREGATE public.group_concat(text) OWNER TO postgres;

--
-- Name: category_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE category_category_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.category_category_id_seq OWNER TO postgres;

--
-- Name: category; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE category (
    category_id integer DEFAULT nextval('category_category_id_seq'::regclass) NOT NULL,
    name character varying(25) NOT NULL,
    last_update timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.category OWNER TO postgres;

--
-- Name: film_film_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE film_film_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.film_film_id_seq OWNER TO postgres;

--
-- Name: film; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE film (
    film_id integer DEFAULT nextval('film_film_id_seq'::regclass) NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    release_year year,
    language_id smallint NOT NULL,
    original_language_id smallint,
    rental_duration smallint DEFAULT 3 NOT NULL,
    rental_rate numeric(4,2) DEFAULT 4.99 NOT NULL,
    length smallint,
    replacement_cost numeric(5,2) DEFAULT 19.99 NOT NULL,
    rating mpaa_rating DEFAULT 'G'::mpaa_rating,
    last_update timestamp without time zone DEFAULT now() NOT NULL,
    special_features text[],
    fulltext tsvector NOT NULL
);


ALTER TABLE public.film OWNER TO postgres;

--
-- Name: film_actor; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE film_actor (
    actor_id smallint NOT NULL,
    film_id smallint NOT NULL,
    last_update timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.film_actor OWNER TO postgres;

--
-- Name: film_category; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE film_category (
    film_id smallint NOT NULL,
    category_id smallint NOT NULL,
    last_update timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.film_category OWNER TO postgres;

--
-- Name: actor_info; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW actor_info AS
    SELECT a.actor_id, a.first_name, a.last_name, group_concat(DISTINCT (((c.name)::text || ': '::text) || (SELECT group_concat((f.title)::text) AS group_concat FROM ((film f JOIN film_category fc ON ((f.film_id = fc.film_id))) JOIN film_actor fa ON ((f.film_id = fa.film_id))) WHERE ((fc.category_id = c.category_id) AND (fa.actor_id = a.actor_id)) GROUP BY fa.actor_id))) AS film_info FROM (((actor a LEFT JOIN film_actor fa ON ((a.actor_id = fa.actor_id))) LEFT JOIN film_category fc ON ((fa.film_id = fc.film_id))) LEFT JOIN category c ON ((fc.category_id = c.category_id))) GROUP BY a.actor_id, a.first_name, a.last_name;


ALTER TABLE public.actor_info OWNER TO postgres;

--
-- Name: address_address_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE address_address_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.address_address_id_seq OWNER TO postgres;

--
-- Name: address; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE address (
    address_id integer DEFAULT nextval('address_address_id_seq'::regclass) NOT NULL,
    address character varying(50) NOT NULL,
    address2 character varying(50),
    district character varying(20) NOT NULL,
    city_id smallint NOT NULL,
    postal_code character varying(10),
    phone character varying(20) NOT NULL,
    last_update timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.address OWNER TO postgres;

--
-- Name: city_city_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE city_city_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.city_city_id_seq OWNER TO postgres;

--
-- Name: city; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE city (
    city_id integer DEFAULT nextval('city_city_id_seq'::regclass) NOT NULL,
    city character varying(50) NOT NULL,
    country_id smallint NOT NULL,
    last_update timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.city OWNER TO postgres;

--
-- Name: country_country_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE country_country_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.country_country_id_seq OWNER TO postgres;

--
-- Name: country; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE country (
    country_id integer DEFAULT nextval('country_country_id_seq'::regclass) NOT NULL,
    country character varying(50) NOT NULL,
    last_update timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.country OWNER TO postgres;

--
-- Name: customer_customer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE customer_customer_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.customer_customer_id_seq OWNER TO postgres;

--
-- Name: customer; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE customer (
    customer_id integer DEFAULT nextval('customer_customer_id_seq'::regclass) NOT NULL,
    store_id smallint NOT NULL,
    first_name character varying(45) NOT NULL,
    last_name character varying(45) NOT NULL,
    email character varying(50),
    address_id smallint NOT NULL,
    activebool boolean DEFAULT true NOT NULL,
    create_date date DEFAULT ('now'::text)::date NOT NULL,
    last_update timestamp without time zone DEFAULT now(),
    active integer
);


ALTER TABLE public.customer OWNER TO postgres;

--
-- Name: customer_list; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW customer_list AS
    SELECT cu.customer_id AS id, (((cu.first_name)::text || ' '::text) || (cu.last_name)::text) AS name, a.address, a.postal_code AS "zip code", a.phone, city.city, country.country, CASE WHEN cu.activebool THEN 'active'::text ELSE ''::text END AS notes, cu.store_id AS sid FROM (((customer cu JOIN address a ON ((cu.address_id = a.address_id))) JOIN city ON ((a.city_id = city.city_id))) JOIN country ON ((city.country_id = country.country_id)));


ALTER TABLE public.customer_list OWNER TO postgres;

--
-- Name: film_list; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW film_list AS
    SELECT film.film_id AS fid, film.title, film.description, category.name AS category, film.rental_rate AS price, film.length, film.rating, group_concat((((actor.first_name)::text || ' '::text) || (actor.last_name)::text)) AS actors FROM ((((category LEFT JOIN film_category ON ((category.category_id = film_category.category_id))) LEFT JOIN film ON ((film_category.film_id = film.film_id))) JOIN film_actor ON ((film.film_id = film_actor.film_id))) JOIN actor ON ((film_actor.actor_id = actor.actor_id))) GROUP BY film.film_id, film.title, film.description, category.name, film.rental_rate, film.length, film.rating;


ALTER TABLE public.film_list OWNER TO postgres;

--
-- Name: inventory_inventory_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE inventory_inventory_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.inventory_inventory_id_seq OWNER TO postgres;

--
-- Name: inventory; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE inventory (
    inventory_id integer DEFAULT nextval('inventory_inventory_id_seq'::regclass) NOT NULL,
    film_id smallint NOT NULL,
    store_id smallint NOT NULL,
    last_update timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.inventory OWNER TO postgres;

--
-- Name: language_language_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE language_language_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.language_language_id_seq OWNER TO postgres;

--
-- Name: language; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE language (
    language_id integer DEFAULT nextval('language_language_id_seq'::regclass) NOT NULL,
    name character(20) NOT NULL,
    last_update timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.language OWNER TO postgres;

--
-- Name: nicer_but_slower_film_list; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW nicer_but_slower_film_list AS
    SELECT film.film_id AS fid, film.title, film.description, category.name AS category, film.rental_rate AS price, film.length, film.rating, group_concat((((upper("substring"((actor.first_name)::text, 1, 1)) || lower("substring"((actor.first_name)::text, 2))) || upper("substring"((actor.last_name)::text, 1, 1))) || lower("substring"((actor.last_name)::text, 2)))) AS actors FROM ((((category LEFT JOIN film_category ON ((category.category_id = film_category.category_id))) LEFT JOIN film ON ((film_category.film_id = film.film_id))) JOIN film_actor ON ((film.film_id = film_actor.film_id))) JOIN actor ON ((film_actor.actor_id = actor.actor_id))) GROUP BY film.film_id, film.title, film.description, category.name, film.rental_rate, film.length, film.rating;


ALTER TABLE public.nicer_but_slower_film_list OWNER TO postgres;

--
-- Name: payment_payment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE payment_payment_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.payment_payment_id_seq OWNER TO postgres;

--
-- Name: payment; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE payment (
    payment_id integer DEFAULT nextval('payment_payment_id_seq'::regclass) NOT NULL,
    customer_id smallint NOT NULL,
    staff_id smallint NOT NULL,
    rental_id integer NOT NULL,
    amount numeric(5,2) NOT NULL,
    payment_date timestamp without time zone NOT NULL
);


ALTER TABLE public.payment OWNER TO postgres;

--
-- Name: payment_p2007_01; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE payment_p2007_01 (CONSTRAINT payment_p2007_01_payment_date_check CHECK (((payment_date >= '2007-01-01 00:00:00'::timestamp without time zone) AND (payment_date < '2007-02-01 00:00:00'::timestamp without time zone)))
)
INHERITS (payment);


ALTER TABLE public.payment_p2007_01 OWNER TO postgres;

--
-- Name: payment_p2007_02; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE payment_p2007_02 (CONSTRAINT payment_p2007_02_payment_date_check CHECK (((payment_date >= '2007-02-01 00:00:00'::timestamp without time zone) AND (payment_date < '2007-03-01 00:00:00'::timestamp without time zone)))
)
INHERITS (payment);


ALTER TABLE public.payment_p2007_02 OWNER TO postgres;

--
-- Name: payment_p2007_03; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE payment_p2007_03 (CONSTRAINT payment_p2007_03_payment_date_check CHECK (((payment_date >= '2007-03-01 00:00:00'::timestamp without time zone) AND (payment_date < '2007-04-01 00:00:00'::timestamp without time zone)))
)
INHERITS (payment);


ALTER TABLE public.payment_p2007_03 OWNER TO postgres;

--
-- Name: payment_p2007_04; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE payment_p2007_04 (CONSTRAINT payment_p2007_04_payment_date_check CHECK (((payment_date >= '2007-04-01 00:00:00'::timestamp without time zone) AND (payment_date < '2007-05-01 00:00:00'::timestamp without time zone)))
)
INHERITS (payment);


ALTER TABLE public.payment_p2007_04 OWNER TO postgres;

--
-- Name: payment_p2007_05; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE payment_p2007_05 (CONSTRAINT payment_p2007_05_payment_date_check CHECK (((payment_date >= '2007-05-01 00:00:00'::timestamp without time zone) AND (payment_date < '2007-06-01 00:00:00'::timestamp without time zone)))
)
INHERITS (payment);


ALTER TABLE public.payment_p2007_05 OWNER TO postgres;

--
-- Name: payment_p2007_06; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE payment_p2007_06 (CONSTRAINT payment_p2007_06_payment_date_check CHECK (((payment_date >= '2007-06-01 00:00:00'::timestamp without time zone) AND (payment_date < '2007-07-01 00:00:00'::timestamp without time zone)))
)
INHERITS (payment);


ALTER TABLE public.payment_p2007_06 OWNER TO postgres;

--
-- Name: rental_rental_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE rental_rental_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.rental_rental_id_seq OWNER TO postgres;

--
-- Name: rental; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE rental (
    rental_id integer DEFAULT nextval('rental_rental_id_seq'::regclass) NOT NULL,
    rental_date timestamp without time zone NOT NULL,
    inventory_id integer NOT NULL,
    customer_id smallint NOT NULL,
    return_date timestamp without time zone,
    staff_id smallint NOT NULL,
    last_update timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.rental OWNER TO postgres;

--
-- Name: sales_by_film_category; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW sales_by_film_category AS
    SELECT c.name AS category, sum(p.amount) AS total_sales FROM (((((payment p JOIN rental r ON ((p.rental_id = r.rental_id))) JOIN inventory i ON ((r.inventory_id = i.inventory_id))) JOIN film f ON ((i.film_id = f.film_id))) JOIN film_category fc ON ((f.film_id = fc.film_id))) JOIN category c ON ((fc.category_id = c.category_id))) GROUP BY c.name ORDER BY sum(p.amount) DESC;


ALTER TABLE public.sales_by_film_category OWNER TO postgres;

--
-- Name: staff_staff_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE staff_staff_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.staff_staff_id_seq OWNER TO postgres;

--
-- Name: staff; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE staff (
    staff_id integer DEFAULT nextval('staff_staff_id_seq'::regclass) NOT NULL,
    first_name character varying(45) NOT NULL,
    last_name character varying(45) NOT NULL,
    address_id smallint NOT NULL,
    email character varying(50),
    store_id smallint NOT NULL,
    active boolean DEFAULT true NOT NULL,
    username character varying(16) NOT NULL,
    password character varying(40),
    last_update timestamp without time zone DEFAULT now() NOT NULL,
    picture bytea
);


ALTER TABLE public.staff OWNER TO postgres;

--
-- Name: store_store_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE store_store_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.store_store_id_seq OWNER TO postgres;

--
-- Name: store; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE store (
    store_id integer DEFAULT nextval('store_store_id_seq'::regclass) NOT NULL,
    manager_staff_id smallint NOT NULL,
    address_id smallint NOT NULL,
    last_update timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.store OWNER TO postgres;

--
-- Name: sales_by_store; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW sales_by_store AS
    SELECT (((c.city)::text || ','::text) || (cy.country)::text) AS store, (((m.first_name)::text || ' '::text) || (m.last_name)::text) AS manager, sum(p.amount) AS total_sales FROM (((((((payment p JOIN rental r ON ((p.rental_id = r.rental_id))) JOIN inventory i ON ((r.inventory_id = i.inventory_id))) JOIN store s ON ((i.store_id = s.store_id))) JOIN address a ON ((s.address_id = a.address_id))) JOIN city c ON ((a.city_id = c.city_id))) JOIN country cy ON ((c.country_id = cy.country_id))) JOIN staff m ON ((s.manager_staff_id = m.staff_id))) GROUP BY cy.country, c.city, s.store_id, m.first_name, m.last_name ORDER BY cy.country, c.city;


ALTER TABLE public.sales_by_store OWNER TO postgres;

--
-- Name: staff_list; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW staff_list AS
    SELECT s.staff_id AS id, (((s.first_name)::text || ' '::text) || (s.last_name)::text) AS name, a.address, a.postal_code AS "zip code", a.phone, city.city, country.country, s.store_id AS sid FROM (((staff s JOIN address a ON ((s.address_id = a.address_id))) JOIN city ON ((a.city_id = city.city_id))) JOIN country ON ((city.country_id = country.country_id)));


ALTER TABLE public.staff_list OWNER TO postgres;

--
-- Name: film_in_stock(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION film_in_stock(p_film_id integer, p_store_id integer, OUT p_film_count integer) RETURNS SETOF integer
    AS $_$
     SELECT inventory_id
     FROM inventory
     WHERE film_id = $1
     AND store_id = $2
     AND inventory_in_stock(inventory_id);
$_$
    LANGUAGE sql;


ALTER FUNCTION public.film_in_stock(p_film_id integer, p_store_id integer, OUT p_film_count integer) OWNER TO postgres;

--
-- Name: film_not_in_stock(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION film_not_in_stock(p_film_id integer, p_store_id integer, OUT p_film_count integer) RETURNS SETOF integer
    AS $_$
    SELECT inventory_id
    FROM inventory
    WHERE film_id = $1
    AND store_id = $2
    AND NOT inventory_in_stock(inventory_id);
$_$
    LANGUAGE sql;


ALTER FUNCTION public.film_not_in_stock(p_film_id integer, p_store_id integer, OUT p_film_count integer) OWNER TO postgres;

--
-- Name: get_customer_balance(integer, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_customer_balance(p_customer_id integer, p_effective_date timestamp without time zone) RETURNS numeric
    AS $$
       --#OK, WE NEED TO CALCULATE THE CURRENT BALANCE GIVEN A CUSTOMER_ID AND A DATE
       --#THAT WE WANT THE BALANCE TO BE EFFECTIVE FOR. THE BALANCE IS:
       --#   1) RENTAL FEES FOR ALL PREVIOUS RENTALS
       --#   2) ONE DOLLAR FOR EVERY DAY THE PREVIOUS RENTALS ARE OVERDUE
       --#   3) IF A FILM IS MORE THAN RENTAL_DURATION * 2 OVERDUE, CHARGE THE REPLACEMENT_COST
       --#   4) SUBTRACT ALL PAYMENTS MADE BEFORE THE DATE SPECIFIED
DECLARE
    v_rentfees DECIMAL(5,2); --#FEES PAID TO RENT THE VIDEOS INITIALLY
    v_overfees INTEGER;      --#LATE FEES FOR PRIOR RENTALS
    v_payments DECIMAL(5,2); --#SUM OF PAYMENTS MADE PREVIOUSLY
BEGIN
    SELECT COALESCE(SUM(film.rental_rate),0) INTO v_rentfees
    FROM film, inventory, rental
    WHERE film.film_id = inventory.film_id
      AND inventory.inventory_id = rental.inventory_id
      AND rental.rental_date <= p_effective_date
      AND rental.customer_id = p_customer_id;

    SELECT COALESCE(SUM(IF((rental.return_date - rental.rental_date) > (film.rental_duration * '1 day'::interval),
        ((rental.return_date - rental.rental_date) - (film.rental_duration * '1 day'::interval)),0)),0) INTO v_overfees
    FROM rental, inventory, film
    WHERE film.film_id = inventory.film_id
      AND inventory.inventory_id = rental.inventory_id
      AND rental.rental_date <= p_effective_date
      AND rental.customer_id = p_customer_id;

    SELECT COALESCE(SUM(payment.amount),0) INTO v_payments
    FROM payment
    WHERE payment.payment_date <= p_effective_date
    AND payment.customer_id = p_customer_id;

    RETURN v_rentfees + v_overfees - v_payments;
END
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.get_customer_balance(p_customer_id integer, p_effective_date timestamp without time zone) OWNER TO postgres;

--
-- Name: inventory_held_by_customer(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION inventory_held_by_customer(p_inventory_id integer) RETURNS integer
    AS $$
DECLARE
    v_customer_id INTEGER;
BEGIN

  SELECT customer_id INTO v_customer_id
  FROM rental
  WHERE return_date IS NULL
  AND inventory_id = p_inventory_id;

  RETURN v_customer_id;
END $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.inventory_held_by_customer(p_inventory_id integer) OWNER TO postgres;

--
-- Name: inventory_in_stock(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION inventory_in_stock(p_inventory_id integer) RETURNS boolean
    AS $$
DECLARE
    v_rentals INTEGER;
    v_out     INTEGER;
BEGIN
    -- AN ITEM IS IN-STOCK IF THERE ARE EITHER NO ROWS IN THE rental TABLE
    -- FOR THE ITEM OR ALL ROWS HAVE return_date POPULATED

    SELECT count(*) INTO v_rentals
    FROM rental
    WHERE inventory_id = p_inventory_id;

    IF v_rentals = 0 THEN
      RETURN TRUE;
    END IF;

    SELECT COUNT(rental_id) INTO v_out
    FROM inventory LEFT JOIN rental USING(inventory_id)
    WHERE inventory.inventory_id = p_inventory_id
    AND rental.return_date IS NULL;

    IF v_out > 0 THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
END $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.inventory_in_stock(p_inventory_id integer) OWNER TO postgres;

--
-- Name: last_day(timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION last_day(timestamp without time zone) RETURNS date
    AS $_$
  SELECT CASE
    WHEN EXTRACT(MONTH FROM $1) = 12 THEN
      (((EXTRACT(YEAR FROM $1) + 1) operator(pg_catalog.||) '-01-01')::date - INTERVAL '1 day')::date
    ELSE
      ((EXTRACT(YEAR FROM $1) operator(pg_catalog.||) '-' operator(pg_catalog.||) (EXTRACT(MONTH FROM $1) + 1) operator(pg_catalog.||) '-01')::date - INTERVAL '1 day')::date
    END
$_$
    LANGUAGE sql IMMUTABLE STRICT;


ALTER FUNCTION public.last_day(timestamp without time zone) OWNER TO postgres;

--
-- Name: last_updated(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION last_updated() RETURNS trigger
    AS $$
BEGIN
    NEW.last_update = CURRENT_TIMESTAMP;
    RETURN NEW;
END $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.last_updated() OWNER TO postgres;

--
-- Name: rewards_report(integer, numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION rewards_report(min_monthly_purchases integer, min_dollar_amount_purchased numeric) RETURNS SETOF customer
    AS $_$
DECLARE
    last_month_start DATE;
    last_month_end DATE;
rr RECORD;
tmpSQL TEXT;
BEGIN

    /* Some sanity checks... */
    IF min_monthly_purchases = 0 THEN
        RAISE EXCEPTION 'Minimum monthly purchases parameter must be > 0';
    END IF;
    IF min_dollar_amount_purchased = 0.00 THEN
        RAISE EXCEPTION 'Minimum monthly dollar amount purchased parameter must be > $0.00';
    END IF;

    last_month_start := CURRENT_DATE - '3 month'::interval;
    last_month_start := to_date((extract(YEAR FROM last_month_start) || '-' || extract(MONTH FROM last_month_start) || '-01'),'YYYY-MM-DD');
    last_month_end := LAST_DAY(last_month_start);

    /*
    Create a temporary storage area for Customer IDs.
    */
    CREATE TEMPORARY TABLE tmpCustomer (customer_id INTEGER NOT NULL PRIMARY KEY);

    /*
    Find all customers meeting the monthly purchase requirements
    */

    tmpSQL := 'INSERT INTO tmpCustomer (customer_id)
        SELECT p.customer_id
        FROM payment AS p
        WHERE DATE(p.payment_date) BETWEEN '||quote_literal(last_month_start) ||' AND '|| quote_literal(last_month_end) || '
        GROUP BY customer_id
        HAVING SUM(p.amount) > '|| min_dollar_amount_purchased || '
        AND COUNT(customer_id) > ' ||min_monthly_purchases ;

    EXECUTE tmpSQL;

    /*
    Output ALL customer information of matching rewardees.
    Customize output as needed.
    */
    FOR rr IN EXECUTE 'SELECT c.* FROM tmpCustomer AS t INNER JOIN customer AS c ON t.customer_id = c.customer_id' LOOP
        RETURN NEXT rr;
    END LOOP;

    /* Clean up */
    tmpSQL := 'DROP TABLE tmpCustomer';
    EXECUTE tmpSQL;

RETURN;
END
$_$
    LANGUAGE plpgsql SECURITY DEFINER;


ALTER FUNCTION public.rewards_report(min_monthly_purchases integer, min_dollar_amount_purchased numeric) OWNER TO postgres;

--
-- Name: actor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY actor
    ADD CONSTRAINT actor_pkey PRIMARY KEY (actor_id);


--
-- Name: address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY address
    ADD CONSTRAINT address_pkey PRIMARY KEY (address_id);


--
-- Name: category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY category
    ADD CONSTRAINT category_pkey PRIMARY KEY (category_id);


--
-- Name: city_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY city
    ADD CONSTRAINT city_pkey PRIMARY KEY (city_id);


--
-- Name: country_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY country
    ADD CONSTRAINT country_pkey PRIMARY KEY (country_id);


--
-- Name: customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (customer_id);


--
-- Name: film_actor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY film_actor
    ADD CONSTRAINT film_actor_pkey PRIMARY KEY (actor_id, film_id);


--
-- Name: film_category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY film_category
    ADD CONSTRAINT film_category_pkey PRIMARY KEY (film_id, category_id);


--
-- Name: film_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY film
    ADD CONSTRAINT film_pkey PRIMARY KEY (film_id);


--
-- Name: inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY inventory
    ADD CONSTRAINT inventory_pkey PRIMARY KEY (inventory_id);


--
-- Name: language_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY language
    ADD CONSTRAINT language_pkey PRIMARY KEY (language_id);


--
-- Name: payment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (payment_id);


--
-- Name: rental_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY rental
    ADD CONSTRAINT rental_pkey PRIMARY KEY (rental_id);


--
-- Name: staff_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY staff
    ADD CONSTRAINT staff_pkey PRIMARY KEY (staff_id);


--
-- Name: store_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY store
    ADD CONSTRAINT store_pkey PRIMARY KEY (store_id);


--
-- Name: film_fulltext_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX film_fulltext_idx ON film USING gist (fulltext);


--
-- Name: idx_actor_last_name; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_actor_last_name ON actor USING btree (last_name);


--
-- Name: idx_fk_address_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_address_id ON customer USING btree (address_id);


--
-- Name: idx_fk_city_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_city_id ON address USING btree (city_id);


--
-- Name: idx_fk_country_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_country_id ON city USING btree (country_id);


--
-- Name: idx_fk_customer_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_customer_id ON payment USING btree (customer_id);


--
-- Name: idx_fk_film_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_film_id ON film_actor USING btree (film_id);


--
-- Name: idx_fk_inventory_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_inventory_id ON rental USING btree (inventory_id);


--
-- Name: idx_fk_language_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_language_id ON film USING btree (language_id);


--
-- Name: idx_fk_original_language_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_original_language_id ON film USING btree (original_language_id);


--
-- Name: idx_fk_payment_p2007_01_customer_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_payment_p2007_01_customer_id ON payment_p2007_01 USING btree (customer_id);


--
-- Name: idx_fk_payment_p2007_01_staff_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_payment_p2007_01_staff_id ON payment_p2007_01 USING btree (staff_id);


--
-- Name: idx_fk_payment_p2007_02_customer_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_payment_p2007_02_customer_id ON payment_p2007_02 USING btree (customer_id);


--
-- Name: idx_fk_payment_p2007_02_staff_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_payment_p2007_02_staff_id ON payment_p2007_02 USING btree (staff_id);


--
-- Name: idx_fk_payment_p2007_03_customer_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_payment_p2007_03_customer_id ON payment_p2007_03 USING btree (customer_id);


--
-- Name: idx_fk_payment_p2007_03_staff_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_payment_p2007_03_staff_id ON payment_p2007_03 USING btree (staff_id);


--
-- Name: idx_fk_payment_p2007_04_customer_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_payment_p2007_04_customer_id ON payment_p2007_04 USING btree (customer_id);


--
-- Name: idx_fk_payment_p2007_04_staff_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_payment_p2007_04_staff_id ON payment_p2007_04 USING btree (staff_id);


--
-- Name: idx_fk_payment_p2007_05_customer_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_payment_p2007_05_customer_id ON payment_p2007_05 USING btree (customer_id);


--
-- Name: idx_fk_payment_p2007_05_staff_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_payment_p2007_05_staff_id ON payment_p2007_05 USING btree (staff_id);


--
-- Name: idx_fk_payment_p2007_06_customer_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_payment_p2007_06_customer_id ON payment_p2007_06 USING btree (customer_id);


--
-- Name: idx_fk_payment_p2007_06_staff_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_payment_p2007_06_staff_id ON payment_p2007_06 USING btree (staff_id);


--
-- Name: idx_fk_staff_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_staff_id ON payment USING btree (staff_id);


--
-- Name: idx_fk_store_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_fk_store_id ON customer USING btree (store_id);


--
-- Name: idx_last_name; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_last_name ON customer USING btree (last_name);


--
-- Name: idx_store_id_film_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_store_id_film_id ON inventory USING btree (store_id, film_id);


--
-- Name: idx_title; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_title ON film USING btree (title);


--
-- Name: idx_unq_manager_staff_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX idx_unq_manager_staff_id ON store USING btree (manager_staff_id);


--
-- Name: idx_unq_rental_rental_date_inventory_id_customer_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX idx_unq_rental_rental_date_inventory_id_customer_id ON rental USING btree (rental_date, inventory_id, customer_id);


--
-- Name: payment_insert_p2007_01; Type: RULE; Schema: public; Owner: postgres
--

CREATE RULE payment_insert_p2007_01 AS ON INSERT TO payment WHERE ((new.payment_date >= '2007-01-01 00:00:00'::timestamp without time zone) AND (new.payment_date < '2007-02-01 00:00:00'::timestamp without time zone)) DO INSTEAD INSERT INTO payment_p2007_01 (payment_id, customer_id, staff_id, rental_id, amount, payment_date) VALUES (DEFAULT, new.customer_id, new.staff_id, new.rental_id, new.amount, new.payment_date);


--
-- Name: payment_insert_p2007_02; Type: RULE; Schema: public; Owner: postgres
--

CREATE RULE payment_insert_p2007_02 AS ON INSERT TO payment WHERE ((new.payment_date >= '2007-02-01 00:00:00'::timestamp without time zone) AND (new.payment_date < '2007-03-01 00:00:00'::timestamp without time zone)) DO INSTEAD INSERT INTO payment_p2007_02 (payment_id, customer_id, staff_id, rental_id, amount, payment_date) VALUES (DEFAULT, new.customer_id, new.staff_id, new.rental_id, new.amount, new.payment_date);


--
-- Name: payment_insert_p2007_03; Type: RULE; Schema: public; Owner: postgres
--

CREATE RULE payment_insert_p2007_03 AS ON INSERT TO payment WHERE ((new.payment_date >= '2007-03-01 00:00:00'::timestamp without time zone) AND (new.payment_date < '2007-04-01 00:00:00'::timestamp without time zone)) DO INSTEAD INSERT INTO payment_p2007_03 (payment_id, customer_id, staff_id, rental_id, amount, payment_date) VALUES (DEFAULT, new.customer_id, new.staff_id, new.rental_id, new.amount, new.payment_date);


--
-- Name: payment_insert_p2007_04; Type: RULE; Schema: public; Owner: postgres
--

CREATE RULE payment_insert_p2007_04 AS ON INSERT TO payment WHERE ((new.payment_date >= '2007-04-01 00:00:00'::timestamp without time zone) AND (new.payment_date < '2007-05-01 00:00:00'::timestamp without time zone)) DO INSTEAD INSERT INTO payment_p2007_04 (payment_id, customer_id, staff_id, rental_id, amount, payment_date) VALUES (DEFAULT, new.customer_id, new.staff_id, new.rental_id, new.amount, new.payment_date);


--
-- Name: payment_insert_p2007_05; Type: RULE; Schema: public; Owner: postgres
--

CREATE RULE payment_insert_p2007_05 AS ON INSERT TO payment WHERE ((new.payment_date >= '2007-05-01 00:00:00'::timestamp without time zone) AND (new.payment_date < '2007-06-01 00:00:00'::timestamp without time zone)) DO INSTEAD INSERT INTO payment_p2007_05 (payment_id, customer_id, staff_id, rental_id, amount, payment_date) VALUES (DEFAULT, new.customer_id, new.staff_id, new.rental_id, new.amount, new.payment_date);


--
-- Name: payment_insert_p2007_06; Type: RULE; Schema: public; Owner: postgres
--

CREATE RULE payment_insert_p2007_06 AS ON INSERT TO payment WHERE ((new.payment_date >= '2007-06-01 00:00:00'::timestamp without time zone) AND (new.payment_date < '2007-07-01 00:00:00'::timestamp without time zone)) DO INSTEAD INSERT INTO payment_p2007_06 (payment_id, customer_id, staff_id, rental_id, amount, payment_date) VALUES (DEFAULT, new.customer_id, new.staff_id, new.rental_id, new.amount, new.payment_date);


--
-- Name: film_fulltext_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER film_fulltext_trigger
    BEFORE INSERT OR UPDATE ON film
    FOR EACH ROW
    EXECUTE PROCEDURE tsvector_update_trigger('fulltext', 'pg_catalog.english', 'title', 'description');


--
-- Name: last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated
    BEFORE UPDATE ON actor
    FOR EACH ROW
    EXECUTE PROCEDURE last_updated();


--
-- Name: last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated
    BEFORE UPDATE ON address
    FOR EACH ROW
    EXECUTE PROCEDURE last_updated();


--
-- Name: last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated
    BEFORE UPDATE ON category
    FOR EACH ROW
    EXECUTE PROCEDURE last_updated();


--
-- Name: last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated
    BEFORE UPDATE ON city
    FOR EACH ROW
    EXECUTE PROCEDURE last_updated();


--
-- Name: last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated
    BEFORE UPDATE ON country
    FOR EACH ROW
    EXECUTE PROCEDURE last_updated();


--
-- Name: last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated
    BEFORE UPDATE ON customer
    FOR EACH ROW
    EXECUTE PROCEDURE last_updated();


--
-- Name: last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated
    BEFORE UPDATE ON film
    FOR EACH ROW
    EXECUTE PROCEDURE last_updated();


--
-- Name: last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated
    BEFORE UPDATE ON film_actor
    FOR EACH ROW
    EXECUTE PROCEDURE last_updated();


--
-- Name: last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated
    BEFORE UPDATE ON film_category
    FOR EACH ROW
    EXECUTE PROCEDURE last_updated();


--
-- Name: last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated
    BEFORE UPDATE ON inventory
    FOR EACH ROW
    EXECUTE PROCEDURE last_updated();


--
-- Name: last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated
    BEFORE UPDATE ON language
    FOR EACH ROW
    EXECUTE PROCEDURE last_updated();


--
-- Name: last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated
    BEFORE UPDATE ON rental
    FOR EACH ROW
    EXECUTE PROCEDURE last_updated();


--
-- Name: last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated
    BEFORE UPDATE ON staff
    FOR EACH ROW
    EXECUTE PROCEDURE last_updated();


--
-- Name: last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated
    BEFORE UPDATE ON store
    FOR EACH ROW
    EXECUTE PROCEDURE last_updated();


--
-- Name: address_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY address
    ADD CONSTRAINT address_city_id_fkey FOREIGN KEY (city_id) REFERENCES city(city_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: city_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY city
    ADD CONSTRAINT city_country_id_fkey FOREIGN KEY (country_id) REFERENCES country(country_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: customer_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY customer
    ADD CONSTRAINT customer_address_id_fkey FOREIGN KEY (address_id) REFERENCES address(address_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: customer_store_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY customer
    ADD CONSTRAINT customer_store_id_fkey FOREIGN KEY (store_id) REFERENCES store(store_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: film_actor_actor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY film_actor
    ADD CONSTRAINT film_actor_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES actor(actor_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: film_actor_film_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY film_actor
    ADD CONSTRAINT film_actor_film_id_fkey FOREIGN KEY (film_id) REFERENCES film(film_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: film_category_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY film_category
    ADD CONSTRAINT film_category_category_id_fkey FOREIGN KEY (category_id) REFERENCES category(category_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: film_category_film_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY film_category
    ADD CONSTRAINT film_category_film_id_fkey FOREIGN KEY (film_id) REFERENCES film(film_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: film_language_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY film
    ADD CONSTRAINT film_language_id_fkey FOREIGN KEY (language_id) REFERENCES language(language_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: film_original_language_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY film
    ADD CONSTRAINT film_original_language_id_fkey FOREIGN KEY (original_language_id) REFERENCES language(language_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inventory_film_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY inventory
    ADD CONSTRAINT inventory_film_id_fkey FOREIGN KEY (film_id) REFERENCES film(film_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inventory_store_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY inventory
    ADD CONSTRAINT inventory_store_id_fkey FOREIGN KEY (store_id) REFERENCES store(store_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: payment_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY payment
    ADD CONSTRAINT payment_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: payment_p2007_01_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY payment_p2007_01
    ADD CONSTRAINT payment_p2007_01_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customer(customer_id);


--
-- Name: payment_p2007_01_rental_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY payment_p2007_01
    ADD CONSTRAINT payment_p2007_01_rental_id_fkey FOREIGN KEY (rental_id) REFERENCES rental(rental_id);


--
-- Name: payment_p2007_01_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY payment_p2007_01
    ADD CONSTRAINT payment_p2007_01_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES staff(staff_id);


--
-- Name: payment_p2007_02_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY payment_p2007_02
    ADD CONSTRAINT payment_p2007_02_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customer(customer_id);


--
-- Name: payment_p2007_02_rental_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY payment_p2007_02
    ADD CONSTRAINT payment_p2007_02_rental_id_fkey FOREIGN KEY (rental_id) REFERENCES rental(rental_id);


--
-- Name: payment_p2007_02_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY payment_p2007_02
    ADD CONSTRAINT payment_p2007_02_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES staff(staff_id);


--
-- Name: payment_p2007_03_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY payment_p2007_03
    ADD CONSTRAINT payment_p2007_03_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customer(customer_id);


--
-- Name: payment_p2007_03_rental_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY payment_p2007_03
    ADD CONSTRAINT payment_p2007_03_rental_id_fkey FOREIGN KEY (rental_id) REFERENCES rental(rental_id);


--
-- Name: payment_p2007_03_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY payment_p2007_03
    ADD CONSTRAINT payment_p2007_03_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES staff(staff_id);


--
-- Name: payment_p2007_04_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY payment_p2007_04
    ADD CONSTRAINT payment_p2007_04_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customer(customer_id);


--
-- Name: payment_p2007_04_rental_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY payment_p2007_04
    ADD CONSTRAINT payment_p2007_04_rental_id_fkey FOREIGN KEY (rental_id) REFERENCES rental(rental_id);


--
-- Name: payment_p2007_04_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY payment_p2007_04
    ADD CONSTRAINT payment_p2007_04_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES staff(staff_id);


--
-- Name: payment_p2007_05_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY payment_p2007_05
    ADD CONSTRAINT payment_p2007_05_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customer(customer_id);


--
-- Name: payment_p2007_05_rental_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY payment_p2007_05
    ADD CONSTRAINT payment_p2007_05_rental_id_fkey FOREIGN KEY (rental_id) REFERENCES rental(rental_id);


--
-- Name: payment_p2007_05_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY payment_p2007_05
    ADD CONSTRAINT payment_p2007_05_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES staff(staff_id);


--
-- Name: payment_p2007_06_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY payment_p2007_06
    ADD CONSTRAINT payment_p2007_06_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customer(customer_id);


--
-- Name: payment_p2007_06_rental_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY payment_p2007_06
    ADD CONSTRAINT payment_p2007_06_rental_id_fkey FOREIGN KEY (rental_id) REFERENCES rental(rental_id);


--
-- Name: payment_p2007_06_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY payment_p2007_06
    ADD CONSTRAINT payment_p2007_06_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES staff(staff_id);


--
-- Name: payment_rental_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY payment
    ADD CONSTRAINT payment_rental_id_fkey FOREIGN KEY (rental_id) REFERENCES rental(rental_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: payment_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY payment
    ADD CONSTRAINT payment_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: rental_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY rental
    ADD CONSTRAINT rental_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: rental_inventory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY rental
    ADD CONSTRAINT rental_inventory_id_fkey FOREIGN KEY (inventory_id) REFERENCES inventory(inventory_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: rental_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY rental
    ADD CONSTRAINT rental_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: staff_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY staff
    ADD CONSTRAINT staff_address_id_fkey FOREIGN KEY (address_id) REFERENCES address(address_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: staff_store_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY staff
    ADD CONSTRAINT staff_store_id_fkey FOREIGN KEY (store_id) REFERENCES store(store_id);


--
-- Name: store_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY store
    ADD CONSTRAINT store_address_id_fkey FOREIGN KEY (address_id) REFERENCES address(address_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: store_manager_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY store
    ADD CONSTRAINT store_manager_staff_id_fkey FOREIGN KEY (manager_staff_id) REFERENCES staff(staff_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--



--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

--
-- Name: actor_actor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('actor_actor_id_seq', 200, true);


--
-- Name: category_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('category_category_id_seq', 16, true);


--
-- Name: film_film_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('film_film_id_seq', 1000, true);


--
-- Name: address_address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('address_address_id_seq', 605, true);


--
-- Name: city_city_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('city_city_id_seq', 600, true);


--
-- Name: country_country_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('country_country_id_seq', 109, true);


--
-- Name: customer_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('customer_customer_id_seq', 599, true);


--
-- Name: inventory_inventory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('inventory_inventory_id_seq', 4581, true);


--
-- Name: language_language_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('language_language_id_seq', 6, true);


--
-- Name: payment_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('payment_payment_id_seq', 32098, true);


--
-- Name: rental_rental_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('rental_rental_id_seq', 16049, true);


--
-- Name: staff_staff_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('staff_staff_id_seq', 2, true);


--
-- Name: store_store_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('store_store_id_seq', 2, true);


--
-- Data for Name: actor; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE actor DISABLE TRIGGER ALL;

INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (1, 'PENELOPE', 'GUINESS', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (2, 'NICK', 'WAHLBERG', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (3, 'ED', 'CHASE', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (4, 'JENNIFER', 'DAVIS', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (5, 'JOHNNY', 'LOLLOBRIGIDA', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (6, 'BETTE', 'NICHOLSON', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (7, 'GRACE', 'MOSTEL', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (8, 'MATTHEW', 'JOHANSSON', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (9, 'JOE', 'SWANK', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (10, 'CHRISTIAN', 'GABLE', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (11, 'ZERO', 'CAGE', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (12, 'KARL', 'BERRY', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (13, 'UMA', 'WOOD', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (14, 'VIVIEN', 'BERGEN', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (15, 'CUBA', 'OLIVIER', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (16, 'FRED', 'COSTNER', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (17, 'HELEN', 'VOIGHT', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (18, 'DAN', 'TORN', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (19, 'BOB', 'FAWCETT', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (20, 'LUCILLE', 'TRACY', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (21, 'KIRSTEN', 'PALTROW', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (22, 'ELVIS', 'MARX', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (23, 'SANDRA', 'KILMER', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (24, 'CAMERON', 'STREEP', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (25, 'KEVIN', 'BLOOM', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (26, 'RIP', 'CRAWFORD', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (27, 'JULIA', 'MCQUEEN', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (28, 'WOODY', 'HOFFMAN', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (29, 'ALEC', 'WAYNE', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (30, 'SANDRA', 'PECK', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (31, 'SISSY', 'SOBIESKI', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (32, 'TIM', 'HACKMAN', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (33, 'MILLA', 'PECK', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (34, 'AUDREY', 'OLIVIER', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (35, 'JUDY', 'DEAN', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (36, 'BURT', 'DUKAKIS', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (37, 'VAL', 'BOLGER', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (38, 'TOM', 'MCKELLEN', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (39, 'GOLDIE', 'BRODY', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (40, 'JOHNNY', 'CAGE', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (41, 'JODIE', 'DEGENERES', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (42, 'TOM', 'MIRANDA', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (43, 'KIRK', 'JOVOVICH', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (44, 'NICK', 'STALLONE', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (45, 'REESE', 'KILMER', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (46, 'PARKER', 'GOLDBERG', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (47, 'JULIA', 'BARRYMORE', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (48, 'FRANCES', 'DAY-LEWIS', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (49, 'ANNE', 'CRONYN', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (50, 'NATALIE', 'HOPKINS', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (51, 'GARY', 'PHOENIX', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (52, 'CARMEN', 'HUNT', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (53, 'MENA', 'TEMPLE', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (54, 'PENELOPE', 'PINKETT', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (55, 'FAY', 'KILMER', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (56, 'DAN', 'HARRIS', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (57, 'JUDE', 'CRUISE', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (58, 'CHRISTIAN', 'AKROYD', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (59, 'DUSTIN', 'TAUTOU', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (60, 'HENRY', 'BERRY', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (61, 'CHRISTIAN', 'NEESON', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (62, 'JAYNE', 'NEESON', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (63, 'CAMERON', 'WRAY', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (64, 'RAY', 'JOHANSSON', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (65, 'ANGELA', 'HUDSON', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (66, 'MARY', 'TANDY', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (67, 'JESSICA', 'BAILEY', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (68, 'RIP', 'WINSLET', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (69, 'KENNETH', 'PALTROW', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (70, 'MICHELLE', 'MCCONAUGHEY', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (71, 'ADAM', 'GRANT', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (72, 'SEAN', 'WILLIAMS', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (73, 'GARY', 'PENN', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (74, 'MILLA', 'KEITEL', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (75, 'BURT', 'POSEY', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (76, 'ANGELINA', 'ASTAIRE', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (77, 'CARY', 'MCCONAUGHEY', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (78, 'GROUCHO', 'SINATRA', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (79, 'MAE', 'HOFFMAN', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (80, 'RALPH', 'CRUZ', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (81, 'SCARLETT', 'DAMON', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (82, 'WOODY', 'JOLIE', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (83, 'BEN', 'WILLIS', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (84, 'JAMES', 'PITT', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (85, 'MINNIE', 'ZELLWEGER', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (86, 'GREG', 'CHAPLIN', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (87, 'SPENCER', 'PECK', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (88, 'KENNETH', 'PESCI', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (89, 'CHARLIZE', 'DENCH', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (90, 'SEAN', 'GUINESS', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (91, 'CHRISTOPHER', 'BERRY', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (92, 'KIRSTEN', 'AKROYD', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (93, 'ELLEN', 'PRESLEY', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (94, 'KENNETH', 'TORN', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (95, 'DARYL', 'WAHLBERG', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (96, 'GENE', 'WILLIS', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (97, 'MEG', 'HAWKE', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (98, 'CHRIS', 'BRIDGES', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (99, 'JIM', 'MOSTEL', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (100, 'SPENCER', 'DEPP', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (101, 'SUSAN', 'DAVIS', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (102, 'WALTER', 'TORN', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (103, 'MATTHEW', 'LEIGH', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (104, 'PENELOPE', 'CRONYN', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (105, 'SIDNEY', 'CROWE', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (106, 'GROUCHO', 'DUNST', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (107, 'GINA', 'DEGENERES', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (108, 'WARREN', 'NOLTE', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (109, 'SYLVESTER', 'DERN', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (110, 'SUSAN', 'DAVIS', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (111, 'CAMERON', 'ZELLWEGER', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (112, 'RUSSELL', 'BACALL', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (113, 'MORGAN', 'HOPKINS', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (114, 'MORGAN', 'MCDORMAND', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (115, 'HARRISON', 'BALE', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (116, 'DAN', 'STREEP', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (117, 'RENEE', 'TRACY', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (118, 'CUBA', 'ALLEN', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (119, 'WARREN', 'JACKMAN', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (120, 'PENELOPE', 'MONROE', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (121, 'LIZA', 'BERGMAN', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (122, 'SALMA', 'NOLTE', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (123, 'JULIANNE', 'DENCH', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (124, 'SCARLETT', 'BENING', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (125, 'ALBERT', 'NOLTE', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (126, 'FRANCES', 'TOMEI', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (127, 'KEVIN', 'GARLAND', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (128, 'CATE', 'MCQUEEN', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (129, 'DARYL', 'CRAWFORD', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (130, 'GRETA', 'KEITEL', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (131, 'JANE', 'JACKMAN', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (132, 'ADAM', 'HOPPER', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (133, 'RICHARD', 'PENN', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (134, 'GENE', 'HOPKINS', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (135, 'RITA', 'REYNOLDS', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (136, 'ED', 'MANSFIELD', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (137, 'MORGAN', 'WILLIAMS', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (138, 'LUCILLE', 'DEE', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (139, 'EWAN', 'GOODING', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (140, 'WHOOPI', 'HURT', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (141, 'CATE', 'HARRIS', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (142, 'JADA', 'RYDER', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (143, 'RIVER', 'DEAN', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (144, 'ANGELA', 'WITHERSPOON', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (145, 'KIM', 'ALLEN', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (146, 'ALBERT', 'JOHANSSON', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (147, 'FAY', 'WINSLET', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (148, 'EMILY', 'DEE', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (149, 'RUSSELL', 'TEMPLE', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (150, 'JAYNE', 'NOLTE', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (151, 'GEOFFREY', 'HESTON', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (152, 'BEN', 'HARRIS', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (153, 'MINNIE', 'KILMER', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (154, 'MERYL', 'GIBSON', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (155, 'IAN', 'TANDY', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (156, 'FAY', 'WOOD', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (157, 'GRETA', 'MALDEN', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (158, 'VIVIEN', 'BASINGER', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (159, 'LAURA', 'BRODY', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (160, 'CHRIS', 'DEPP', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (161, 'HARVEY', 'HOPE', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (162, 'OPRAH', 'KILMER', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (163, 'CHRISTOPHER', 'WEST', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (164, 'HUMPHREY', 'WILLIS', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (165, 'AL', 'GARLAND', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (166, 'NICK', 'DEGENERES', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (167, 'LAURENCE', 'BULLOCK', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (168, 'WILL', 'WILSON', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (169, 'KENNETH', 'HOFFMAN', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (170, 'MENA', 'HOPPER', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (171, 'OLYMPIA', 'PFEIFFER', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (172, 'GROUCHO', 'WILLIAMS', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (173, 'ALAN', 'DREYFUSS', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (174, 'MICHAEL', 'BENING', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (175, 'WILLIAM', 'HACKMAN', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (176, 'JON', 'CHASE', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (177, 'GENE', 'MCKELLEN', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (178, 'LISA', 'MONROE', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (179, 'ED', 'GUINESS', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (180, 'JEFF', 'SILVERSTONE', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (181, 'MATTHEW', 'CARREY', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (182, 'DEBBIE', 'AKROYD', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (183, 'RUSSELL', 'CLOSE', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (184, 'HUMPHREY', 'GARLAND', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (185, 'MICHAEL', 'BOLGER', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (186, 'JULIA', 'ZELLWEGER', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (187, 'RENEE', 'BALL', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (188, 'ROCK', 'DUKAKIS', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (189, 'CUBA', 'BIRCH', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (190, 'AUDREY', 'BAILEY', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (191, 'GREGORY', 'GOODING', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (192, 'JOHN', 'SUVARI', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (193, 'BURT', 'TEMPLE', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (194, 'MERYL', 'ALLEN', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (195, 'JAYNE', 'SILVERSTONE', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (196, 'BELA', 'WALKEN', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (197, 'REESE', 'WEST', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (198, 'MARY', 'KEITEL', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (199, 'JULIA', 'FAWCETT', '2006-02-15 09:34:33');
INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES (200, 'THORA', 'TEMPLE', '2006-02-15 09:34:33');


ALTER TABLE actor ENABLE TRIGGER ALL;

--
-- Data for Name: address; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE address DISABLE TRIGGER ALL;



ALTER TABLE address ENABLE TRIGGER ALL;

--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE category DISABLE TRIGGER ALL;

INSERT INTO category (category_id, name, last_update) VALUES (1, 'Action', '2006-02-15 09:46:27');
INSERT INTO category (category_id, name, last_update) VALUES (2, 'Animation', '2006-02-15 09:46:27');
INSERT INTO category (category_id, name, last_update) VALUES (3, 'Children', '2006-02-15 09:46:27');
INSERT INTO category (category_id, name, last_update) VALUES (4, 'Classics', '2006-02-15 09:46:27');
INSERT INTO category (category_id, name, last_update) VALUES (5, 'Comedy', '2006-02-15 09:46:27');
INSERT INTO category (category_id, name, last_update) VALUES (6, 'Documentary', '2006-02-15 09:46:27');
INSERT INTO category (category_id, name, last_update) VALUES (7, 'Drama', '2006-02-15 09:46:27');
INSERT INTO category (category_id, name, last_update) VALUES (8, 'Family', '2006-02-15 09:46:27');
INSERT INTO category (category_id, name, last_update) VALUES (9, 'Foreign', '2006-02-15 09:46:27');
INSERT INTO category (category_id, name, last_update) VALUES (10, 'Games', '2006-02-15 09:46:27');
INSERT INTO category (category_id, name, last_update) VALUES (11, 'Horror', '2006-02-15 09:46:27');
INSERT INTO category (category_id, name, last_update) VALUES (12, 'Music', '2006-02-15 09:46:27');
INSERT INTO category (category_id, name, last_update) VALUES (13, 'New', '2006-02-15 09:46:27');
INSERT INTO category (category_id, name, last_update) VALUES (14, 'Sci-Fi', '2006-02-15 09:46:27');
INSERT INTO category (category_id, name, last_update) VALUES (15, 'Sports', '2006-02-15 09:46:27');
INSERT INTO category (category_id, name, last_update) VALUES (16, 'Travel', '2006-02-15 09:46:27');


ALTER TABLE category ENABLE TRIGGER ALL;

--
-- Data for Name: city; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE city DISABLE TRIGGER ALL;



ALTER TABLE city ENABLE TRIGGER ALL;

--
-- Data for Name: country; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE country DISABLE TRIGGER ALL;

INSERT INTO country (country_id, country, last_update) VALUES (1, 'Afghanistan', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (2, 'Algeria', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (3, 'American Samoa', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (4, 'Angola', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (5, 'Anguilla', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (6, 'Argentina', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (7, 'Armenia', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (8, 'Australia', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (9, 'Austria', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (10, 'Azerbaijan', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (11, 'Bahrain', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (12, 'Bangladesh', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (13, 'Belarus', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (14, 'Bolivia', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (15, 'Brazil', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (16, 'Brunei', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (17, 'Bulgaria', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (18, 'Cambodia', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (19, 'Cameroon', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (20, 'Canada', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (21, 'Chad', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (22, 'Chile', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (23, 'China', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (24, 'Colombia', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (25, 'Congo, The Democratic Republic of the', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (26, 'Czech Republic', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (27, 'Dominican Republic', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (28, 'Ecuador', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (29, 'Egypt', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (30, 'Estonia', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (31, 'Ethiopia', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (32, 'Faroe Islands', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (33, 'Finland', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (34, 'France', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (35, 'French Guiana', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (36, 'French Polynesia', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (37, 'Gambia', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (38, 'Germany', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (39, 'Greece', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (40, 'Greenland', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (41, 'Holy See (Vatican City State)', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (42, 'Hong Kong', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (43, 'Hungary', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (44, 'India', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (45, 'Indonesia', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (46, 'Iran', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (47, 'Iraq', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (48, 'Israel', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (49, 'Italy', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (50, 'Japan', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (51, 'Kazakstan', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (52, 'Kenya', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (53, 'Kuwait', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (54, 'Latvia', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (55, 'Liechtenstein', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (56, 'Lithuania', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (57, 'Madagascar', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (58, 'Malawi', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (59, 'Malaysia', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (60, 'Mexico', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (61, 'Moldova', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (62, 'Morocco', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (63, 'Mozambique', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (64, 'Myanmar', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (65, 'Nauru', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (66, 'Nepal', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (67, 'Netherlands', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (68, 'New Zealand', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (69, 'Nigeria', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (70, 'North Korea', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (71, 'Oman', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (72, 'Pakistan', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (73, 'Paraguay', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (74, 'Peru', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (75, 'Philippines', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (76, 'Poland', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (77, 'Puerto Rico', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (78, 'Romania', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (79, 'Runion', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (80, 'Russian Federation', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (81, 'Saint Vincent and the Grenadines', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (82, 'Saudi Arabia', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (83, 'Senegal', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (84, 'Slovakia', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (85, 'South Africa', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (86, 'South Korea', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (87, 'Spain', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (88, 'Sri Lanka', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (89, 'Sudan', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (90, 'Sweden', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (91, 'Switzerland', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (92, 'Taiwan', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (93, 'Tanzania', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (94, 'Thailand', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (95, 'Tonga', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (96, 'Tunisia', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (97, 'Turkey', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (98, 'Turkmenistan', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (99, 'Tuvalu', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (100, 'Ukraine', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (101, 'United Arab Emirates', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (102, 'United Kingdom', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (103, 'United States', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (104, 'Venezuela', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (105, 'Vietnam', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (106, 'Virgin Islands, U.S.', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (107, 'Yemen', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (108, 'Yugoslavia', '2006-02-15 09:44:00');
INSERT INTO country (country_id, country, last_update) VALUES (109, 'Zambia', '2006-02-15 09:44:00');


ALTER TABLE country ENABLE TRIGGER ALL;

--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE customer DISABLE TRIGGER ALL;



ALTER TABLE customer ENABLE TRIGGER ALL;

--
-- Data for Name: film; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE film DISABLE TRIGGER ALL;



ALTER TABLE film ENABLE TRIGGER ALL;

--
-- Data for Name: film_actor; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE film_actor DISABLE TRIGGER ALL;



ALTER TABLE film_actor ENABLE TRIGGER ALL;

--
-- Data for Name: film_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE film_category DISABLE TRIGGER ALL;



ALTER TABLE film_category ENABLE TRIGGER ALL;

--
-- Data for Name: inventory; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE inventory DISABLE TRIGGER ALL;



ALTER TABLE inventory ENABLE TRIGGER ALL;

--
-- Data for Name: language; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE language DISABLE TRIGGER ALL;



ALTER TABLE language ENABLE TRIGGER ALL;

--
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE payment DISABLE TRIGGER ALL;



ALTER TABLE payment ENABLE TRIGGER ALL;

--
-- Data for Name: payment_p2007_01; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE payment_p2007_01 DISABLE TRIGGER ALL;



ALTER TABLE payment_p2007_01 ENABLE TRIGGER ALL;

--
-- Data for Name: payment_p2007_02; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE payment_p2007_02 DISABLE TRIGGER ALL;



ALTER TABLE payment_p2007_02 ENABLE TRIGGER ALL;

--
-- Data for Name: payment_p2007_03; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE payment_p2007_03 DISABLE TRIGGER ALL;



ALTER TABLE payment_p2007_03 ENABLE TRIGGER ALL;

--
-- Data for Name: payment_p2007_04; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE payment_p2007_04 DISABLE TRIGGER ALL;



ALTER TABLE payment_p2007_04 ENABLE TRIGGER ALL;

--
-- Data for Name: payment_p2007_05; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE payment_p2007_05 DISABLE TRIGGER ALL;



ALTER TABLE payment_p2007_05 ENABLE TRIGGER ALL;

--
-- Data for Name: payment_p2007_06; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE payment_p2007_06 DISABLE TRIGGER ALL;



ALTER TABLE payment_p2007_06 ENABLE TRIGGER ALL;

--
-- Data for Name: rental; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE rental DISABLE TRIGGER ALL;



ALTER TABLE rental ENABLE TRIGGER ALL;

--
-- Data for Name: staff; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE staff DISABLE TRIGGER ALL;



ALTER TABLE staff ENABLE TRIGGER ALL;

--
-- Data for Name: store; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE store DISABLE TRIGGER ALL;



ALTER TABLE store ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--
