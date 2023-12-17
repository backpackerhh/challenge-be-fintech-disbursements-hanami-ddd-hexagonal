--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1 (Debian 16.1-1.pgdg120+1)
-- Dumped by pg_dump version 16.1 (Debian 16.1-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: merchant_disbursement_frequency_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.merchant_disbursement_frequency_enum AS ENUM (
    'DAILY',
    'WEEKLY'
);


ALTER TYPE public.merchant_disbursement_frequency_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: disbursements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.disbursements (
    id uuid NOT NULL,
    reference character varying(12) NOT NULL,
    amount numeric(10,2) NOT NULL,
    commissions_amount numeric(10,2) NOT NULL,
    order_ids uuid[] NOT NULL,
    created_at timestamp without time zone DEFAULT (now() AT TIME ZONE 'utc'::text) NOT NULL,
    merchant_id uuid NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL
);


ALTER TABLE public.disbursements OWNER TO postgres;

--
-- Name: merchants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.merchants (
    id uuid NOT NULL,
    email character varying(100) NOT NULL,
    reference character varying(100) NOT NULL,
    disbursement_frequency public.merchant_disbursement_frequency_enum NOT NULL,
    live_on date NOT NULL,
    minimum_monthly_fee numeric(10,2) NOT NULL,
    created_at timestamp without time zone DEFAULT (now() AT TIME ZONE 'utc'::text) NOT NULL
);


ALTER TABLE public.merchants OWNER TO postgres;

--
-- Name: monthly_fees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.monthly_fees (
    id uuid NOT NULL,
    amount numeric(10,2) NOT NULL,
    commissions_amount numeric(10,2) NOT NULL,
    month character varying(7) NOT NULL,
    created_at timestamp without time zone DEFAULT (now() AT TIME ZONE 'utc'::text) NOT NULL,
    merchant_id uuid NOT NULL
);


ALTER TABLE public.monthly_fees OWNER TO postgres;

--
-- Name: order_commissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_commissions (
    id uuid NOT NULL,
    order_amount numeric(10,2) NOT NULL,
    amount numeric(10,2) NOT NULL,
    fee numeric(5,2) NOT NULL,
    created_at timestamp without time zone DEFAULT (now() AT TIME ZONE 'utc'::text) NOT NULL,
    order_id uuid NOT NULL
);


ALTER TABLE public.order_commissions OWNER TO postgres;

--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    id uuid NOT NULL,
    amount numeric(10,2) NOT NULL,
    created_at timestamp without time zone DEFAULT (now() AT TIME ZONE 'utc'::text) NOT NULL,
    merchant_id uuid NOT NULL,
    disbursement_id uuid
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_migrations (
    filename text NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO postgres;

--
-- Name: disbursements disbursements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disbursements
    ADD CONSTRAINT disbursements_pkey PRIMARY KEY (id);


--
-- Name: disbursements disbursements_reference_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disbursements
    ADD CONSTRAINT disbursements_reference_key UNIQUE (reference);


--
-- Name: merchants merchants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.merchants
    ADD CONSTRAINT merchants_pkey PRIMARY KEY (id);


--
-- Name: merchants merchants_reference_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.merchants
    ADD CONSTRAINT merchants_reference_key UNIQUE (reference);


--
-- Name: monthly_fees monthly_fees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monthly_fees
    ADD CONSTRAINT monthly_fees_pkey PRIMARY KEY (id);


--
-- Name: order_commissions order_commissions_order_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_commissions
    ADD CONSTRAINT order_commissions_order_id_key UNIQUE (order_id);


--
-- Name: order_commissions order_commissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_commissions
    ADD CONSTRAINT order_commissions_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (filename);


--
-- Name: disbursements_merchant_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX disbursements_merchant_id_index ON public.disbursements USING btree (merchant_id);


--
-- Name: disbursements_start_date_end_date_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX disbursements_start_date_end_date_index ON public.disbursements USING btree (start_date, end_date);


--
-- Name: monthly_fees_merchant_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX monthly_fees_merchant_id_index ON public.monthly_fees USING btree (merchant_id);


--
-- Name: disbursements disbursements_merchant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disbursements
    ADD CONSTRAINT disbursements_merchant_id_fkey FOREIGN KEY (merchant_id) REFERENCES public.merchants(id);


--
-- Name: monthly_fees monthly_fees_merchant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monthly_fees
    ADD CONSTRAINT monthly_fees_merchant_id_fkey FOREIGN KEY (merchant_id) REFERENCES public.merchants(id);


--
-- Name: order_commissions order_commissions_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_commissions
    ADD CONSTRAINT order_commissions_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id);


--
-- Name: orders orders_disbursement_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_disbursement_id_fkey FOREIGN KEY (disbursement_id) REFERENCES public.disbursements(id);


--
-- Name: orders orders_merchant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_merchant_id_fkey FOREIGN KEY (merchant_id) REFERENCES public.merchants(id);


--
-- PostgreSQL database dump complete
--

