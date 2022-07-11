--
-- PostgreSQL database dump
--

-- Dumped from database version 13.7 (Ubuntu 13.7-0ubuntu0.21.10.1)
-- Dumped by pg_dump version 13.7 (Ubuntu 13.7-0ubuntu0.21.10.1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: classroom; Type: TABLE; Schema: public; Owner: pcto
--

CREATE TABLE public.classroom (
    id integer NOT NULL,
    name character(20) NOT NULL,
    capacity integer,
    disability boolean,
    CONSTRAINT check_capacity CHECK ((capacity >= 1)),
    CONSTRAINT classroom_capacity CHECK ((capacity >= 1))
);


ALTER TABLE public.classroom OWNER TO pcto;

--
-- Name: course; Type: TABLE; Schema: public; Owner: pcto
--

CREATE TABLE public.course (
    id integer NOT NULL,
    title character(20) NOT NULL,
    description character(1024) NOT NULL,
    min_ratio_for_attendance_certificate double precision DEFAULT 1.0,
    max_partecipants integer,
    CONSTRAINT check_max_partecipants CHECK ((max_partecipants >= 1)),
    CONSTRAINT check_ratio CHECK ((min_ratio_for_attendance_certificate > (0)::double precision))
);


ALTER TABLE public.course OWNER TO pcto;

--
-- Name: lesson; Type: TABLE; Schema: public; Owner: pcto
--

CREATE TABLE public.lesson (
    id integer NOT NULL,
    secret_token character(8) NOT NULL,
    title character(20) NOT NULL,
    start_date_time date,
    end_date_time date,
    in_presence boolean,
    online boolean,
    recording_will_be_available boolean,
    on_line_link character(256),
    on_line_recording_link character(256),
    id_course integer,
    id_classroom integer,
    email_person character(20),
    CONSTRAINT date_time_start_end CHECK ((start_date_time < end_date_time))
);


ALTER TABLE public.lesson OWNER TO pcto;

--
-- Name: many_lesson_has_many_person; Type: TABLE; Schema: public; Owner: pcto
--

CREATE TABLE public.many_lesson_has_many_person (
    id_lesson integer NOT NULL,
    email_person character(20) NOT NULL
);


ALTER TABLE public.many_lesson_has_many_person OWNER TO pcto;

--
-- Name: person; Type: TABLE; Schema: public; Owner: pcto
--

CREATE TABLE public.person (
    email character(20) NOT NULL,
    password character(20) NOT NULL,
    name character(20),
    surname character(20),
    is_teacher boolean NOT NULL
);


ALTER TABLE public.person OWNER TO pcto;

--
-- Data for Name: classroom; Type: TABLE DATA; Schema: public; Owner: pcto
--

COPY public.classroom (id, name, capacity, disability) FROM stdin;
\.


--
-- Data for Name: course; Type: TABLE DATA; Schema: public; Owner: pcto
--

COPY public.course (id, title, description, min_ratio_for_attendance_certificate, max_partecipants) FROM stdin;
\.


--
-- Data for Name: lesson; Type: TABLE DATA; Schema: public; Owner: pcto
--

COPY public.lesson (id, secret_token, title, start_date_time, end_date_time, in_presence, online, recording_will_be_available, on_line_link, on_line_recording_link, id_course, id_classroom, email_person) FROM stdin;
\.


--
-- Data for Name: many_lesson_has_many_person; Type: TABLE DATA; Schema: public; Owner: pcto
--

COPY public.many_lesson_has_many_person (id_lesson, email_person) FROM stdin;
\.


--
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: pcto
--

COPY public.person (email, password, name, surname, is_teacher) FROM stdin;
\.


--
-- Name: classroom classroom_pkey; Type: CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.classroom
    ADD CONSTRAINT classroom_pkey PRIMARY KEY (id);


--
-- Name: classroom classroom_unique; Type: CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.classroom
    ADD CONSTRAINT classroom_unique UNIQUE (name);


--
-- Name: course course_pkey; Type: CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.course
    ADD CONSTRAINT course_pkey PRIMARY KEY (id);


--
-- Name: lesson lesson_pkey; Type: CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_pkey PRIMARY KEY (id);


--
-- Name: many_lesson_has_many_person many_lesson_has_many_person_pk; Type: CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.many_lesson_has_many_person
    ADD CONSTRAINT many_lesson_has_many_person_pk PRIMARY KEY (id_lesson, email_person);


--
-- Name: person person_pkey; Type: CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_pkey PRIMARY KEY (email);


--
-- Name: person_index; Type: INDEX; Schema: public; Owner: pcto
--

CREATE INDEX person_index ON public.person USING btree (email);


--
-- Name: lesson classroom_fk; Type: FK CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT classroom_fk FOREIGN KEY (id_classroom) REFERENCES public.classroom(id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: lesson course_fk; Type: FK CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT course_fk FOREIGN KEY (id_course) REFERENCES public.course(id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: many_lesson_has_many_person lesson_fk; Type: FK CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.many_lesson_has_many_person
    ADD CONSTRAINT lesson_fk FOREIGN KEY (id_lesson) REFERENCES public.lesson(id) MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: many_lesson_has_many_person person_fk; Type: FK CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.many_lesson_has_many_person
    ADD CONSTRAINT person_fk FOREIGN KEY (email_person) REFERENCES public.person(email) MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: lesson person_fk; Type: FK CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT person_fk FOREIGN KEY (email_person) REFERENCES public.person(email) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

