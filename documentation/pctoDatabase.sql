--
-- PostgreSQL database dump
--

-- Dumped from database version 13.7 (Ubuntu 13.7-0ubuntu0.21.10.1)
-- Dumped by pg_dump version 14.1

-- Started on 2022-08-14 12:56:57

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
-- TOC entry 229 (class 1255 OID 16914)
-- Name: populate_classrooms(); Type: PROCEDURE; Schema: public; Owner: pcto
--

CREATE PROCEDURE public.populate_classrooms()
    LANGUAGE plpgsql
    AS $$DECLARE
    name TEXT;
    description TEXT;
    capacity INTEGER;
    disability BOOLEAN;

    number_of_classrooms INTEGER := 100;
BEGIN
	FOR i IN 0..(number_of_classrooms-1) LOOP
        name        := 'Classroom' || i;
        description := 'This is the ' || i || ' classroom';
        capacity    := MOD(i, 3) * 5; -- classroom as infinite, 5 or 10 capacity
        disability  := MOD(i, 100/10) != 0; -- 10% of classroom are disability ebabled
        INSERT INTO "classroom"(name, description, capacity, disability) VALUES(name, description, capacity, disability);
    END LOOP;
END;
$$;


ALTER PROCEDURE public.populate_classrooms() OWNER TO pcto;

--
-- TOC entry 231 (class 1255 OID 16907)
-- Name: populate_database(); Type: PROCEDURE; Schema: public; Owner: pcto
--

CREATE PROCEDURE public.populate_database()
    LANGUAGE plpgsql
    AS $$DECLARE
    number_of_teacher INTEGER := 10;
    number_of_student INTEGER := 100;
BEGIN
    DELETE FROM "user";
    DELETE FROM "classroom";
    CALL public.populate_users_teachers();
    CALL public.populate_users_students();
    CALL public.populate_classrooms();
END;$$;


ALTER PROCEDURE public.populate_database() OWNER TO pcto;

--
-- TOC entry 230 (class 1255 OID 16913)
-- Name: populate_users_students(); Type: PROCEDURE; Schema: public; Owner: pcto
--

CREATE PROCEDURE public.populate_users_students()
    LANGUAGE plpgsql
    AS $_$DECLARE
    email TEXT;
    password_hash TEXT;
    name TEXT;
    surname TEXT;
    is_active BOOLEAN;
    is_teacher BOOLEAN := false;
    number_of_students INTEGER := 100;
    user_type TEXT := 'student';
BEGIN
	FOR i IN 0..(number_of_students-1) LOOP
        email         := user_type || i || '@localhost';
        password_hash := 'pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3';
        name          := 'Name' || i || user_type;
        surname       := 'Surname' || i || user_type;
        is_active     := MOD(i, 100/25) != 0; -- 25% of student are NON active
        INSERT INTO "user"(email, password_hash, name, surname, is_active, is_teacher) VALUES(email, password_hash, name, surname, is_active, is_teacher);
    END LOOP;
END;
$_$;


ALTER PROCEDURE public.populate_users_students() OWNER TO pcto;

--
-- TOC entry 228 (class 1255 OID 16828)
-- Name: populate_users_teachers(); Type: PROCEDURE; Schema: public; Owner: pcto
--

CREATE PROCEDURE public.populate_users_teachers()
    LANGUAGE plpgsql
    AS $_$DECLARE
    email TEXT;
    password_hash TEXT;
    name TEXT;
    surname TEXT;
    is_active BOOLEAN;
    is_teacher BOOLEAN := true;
    
    number_of_teachers INTEGER := 10;
    user_type TEXT := 'teacher';
BEGIN
	FOR i IN 0..(number_of_teachers-1) LOOP
        email         := user_type || i || '@localhost';
        password_hash := 'pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3';
        name          := 'Name'    || i || user_type;
        surname       := 'Surname' || i || user_type;
        is_active     := MOD(i, 100/25) != 0; -- 25% of teacher are NON active
        INSERT INTO "user"(email, password_hash, name, surname, is_active, is_teacher) VALUES(email, password_hash, name, surname, is_active, is_teacher);
    END LOOP;
END;
$_$;


ALTER PROCEDURE public.populate_users_teachers() OWNER TO pcto;

--
-- TOC entry 216 (class 1259 OID 16904)
-- Name: classroom_id_seq; Type: SEQUENCE; Schema: public; Owner: pcto
--

CREATE SEQUENCE public.classroom_id_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE -2147483648
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE public.classroom_id_seq OWNER TO pcto;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 206 (class 1259 OID 16651)
-- Name: classroom; Type: TABLE; Schema: public; Owner: pcto
--

CREATE TABLE public.classroom (
    id integer DEFAULT nextval('public.classroom_id_seq'::regclass) NOT NULL,
    name character(40) NOT NULL,
    description character(1024),
    capacity integer,
    disability boolean,
    CONSTRAINT classroom_capacity_check CHECK ((capacity >= 1))
);


ALTER TABLE public.classroom OWNER TO pcto;

--
-- TOC entry 208 (class 1259 OID 16673)
-- Name: course; Type: TABLE; Schema: public; Owner: pcto
--

CREATE TABLE public.course (
    id integer NOT NULL,
    title character(128) NOT NULL,
    description character(1024),
    min_ratio_for_attendance_certificate double precision DEFAULT 0.75,
    max_in_presence_partecipants integer DEFAULT 0 NOT NULL,
    id_user integer,
    CONSTRAINT course_max_in_presence_partecipants_check CHECK ((max_in_presence_partecipants >= 0)),
    CONSTRAINT course_ratio_check CHECK ((min_ratio_for_attendance_certificate > (0)::double precision))
);


ALTER TABLE public.course OWNER TO pcto;

--
-- TOC entry 207 (class 1259 OID 16671)
-- Name: course_id_seq; Type: SEQUENCE; Schema: public; Owner: pcto
--

CREATE SEQUENCE public.course_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.course_id_seq OWNER TO pcto;

--
-- TOC entry 3127 (class 0 OID 0)
-- Dependencies: 207
-- Name: course_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pcto
--

ALTER SEQUENCE public.course_id_seq OWNED BY public.course.id;


--
-- TOC entry 210 (class 1259 OID 16688)
-- Name: lesson; Type: TABLE; Schema: public; Owner: pcto
--

CREATE TABLE public.lesson (
    id integer NOT NULL,
    secret_token character(8) NOT NULL,
    title character(40) NOT NULL,
    description character(1024),
    start_date_time date,
    end_date_time date,
    in_presence boolean DEFAULT true NOT NULL,
    online boolean DEFAULT true NOT NULL,
    recording_will_be_available boolean DEFAULT false NOT NULL,
    on_line_link character(256),
    on_line_recording_link character(256),
    id_course integer,
    id_classroom integer,
    id_user integer,
    CONSTRAINT lesson_date_time_start_end_check CHECK ((start_date_time < end_date_time)),
    CONSTRAINT lesson_how_check CHECK ((in_presence OR online))
);


ALTER TABLE public.lesson OWNER TO pcto;

--
-- TOC entry 209 (class 1259 OID 16686)
-- Name: lesson_id_seq; Type: SEQUENCE; Schema: public; Owner: pcto
--

CREATE SEQUENCE public.lesson_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lesson_id_seq OWNER TO pcto;

--
-- TOC entry 3128 (class 0 OID 0)
-- Dependencies: 209
-- Name: lesson_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pcto
--

ALTER SEQUENCE public.lesson_id_seq OWNED BY public.lesson.id;


--
-- TOC entry 212 (class 1259 OID 16729)
-- Name: many_courses_has_many_persons; Type: TABLE; Schema: public; Owner: pcto
--

CREATE TABLE public.many_courses_has_many_persons (
    id_course integer NOT NULL,
    id_user integer NOT NULL
);


ALTER TABLE public.many_courses_has_many_persons OWNER TO pcto;

--
-- TOC entry 211 (class 1259 OID 16724)
-- Name: many_lessons_has_many_persons; Type: TABLE; Schema: public; Owner: pcto
--

CREATE TABLE public.many_lessons_has_many_persons (
    id_lesson integer NOT NULL,
    id_user integer NOT NULL
);


ALTER TABLE public.many_lessons_has_many_persons OWNER TO pcto;

--
-- TOC entry 214 (class 1259 OID 16801)
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: pcto
--

CREATE SEQUENCE public.user_id_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE -2147483648
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE public.user_id_seq OWNER TO pcto;

--
-- TOC entry 215 (class 1259 OID 16851)
-- Name: user; Type: TABLE; Schema: public; Owner: pcto
--

CREATE TABLE public."user" (
    id integer DEFAULT nextval('public.user_id_seq'::regclass) NOT NULL,
    email character(120) NOT NULL,
    password_hash character(128) NOT NULL,
    name character(40),
    surname character(40),
    is_active boolean DEFAULT true NOT NULL,
    is_teacher boolean DEFAULT false NOT NULL
);


ALTER TABLE public."user" OWNER TO pcto;

--
-- TOC entry 213 (class 1259 OID 16792)
-- Name: user_example; Type: TABLE; Schema: public; Owner: pcto
--

CREATE TABLE public.user_example (
    id integer NOT NULL,
    username character(64),
    password_hash character(128),
    email character(120),
    about_me character(140),
    last_seen date
);


ALTER TABLE public.user_example OWNER TO pcto;

--
-- TOC entry 2936 (class 2604 OID 16676)
-- Name: course id; Type: DEFAULT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.course ALTER COLUMN id SET DEFAULT nextval('public.course_id_seq'::regclass);


--
-- TOC entry 2941 (class 2604 OID 16691)
-- Name: lesson id; Type: DEFAULT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.lesson ALTER COLUMN id SET DEFAULT nextval('public.lesson_id_seq'::regclass);


--
-- TOC entry 3111 (class 0 OID 16651)
-- Dependencies: 206
-- Data for Name: classroom; Type: TABLE DATA; Schema: public; Owner: pcto
--

COPY public.classroom (id, name, description, capacity, disability) FROM stdin;
\.


--
-- TOC entry 3113 (class 0 OID 16673)
-- Dependencies: 208
-- Data for Name: course; Type: TABLE DATA; Schema: public; Owner: pcto
--

COPY public.course (id, title, description, min_ratio_for_attendance_certificate, max_in_presence_partecipants, id_user) FROM stdin;
\.


--
-- TOC entry 3115 (class 0 OID 16688)
-- Dependencies: 210
-- Data for Name: lesson; Type: TABLE DATA; Schema: public; Owner: pcto
--

COPY public.lesson (id, secret_token, title, description, start_date_time, end_date_time, in_presence, online, recording_will_be_available, on_line_link, on_line_recording_link, id_course, id_classroom, id_user) FROM stdin;
\.


--
-- TOC entry 3117 (class 0 OID 16729)
-- Dependencies: 212
-- Data for Name: many_courses_has_many_persons; Type: TABLE DATA; Schema: public; Owner: pcto
--

COPY public.many_courses_has_many_persons (id_course, id_user) FROM stdin;
\.


--
-- TOC entry 3116 (class 0 OID 16724)
-- Dependencies: 211
-- Data for Name: many_lessons_has_many_persons; Type: TABLE DATA; Schema: public; Owner: pcto
--

COPY public.many_lessons_has_many_persons (id_lesson, id_user) FROM stdin;
\.


--
-- TOC entry 3120 (class 0 OID 16851)
-- Dependencies: 215
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: pcto
--

COPY public."user" (id, email, password_hash, name, surname, is_active, is_teacher) FROM stdin;
1603	teacher0@localhost                                                                                                      	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name0teacher                            	Surname0teacher                         	f	t
1604	teacher1@localhost                                                                                                      	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name1teacher                            	Surname1teacher                         	t	t
1605	teacher2@localhost                                                                                                      	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name2teacher                            	Surname2teacher                         	f	t
1606	teacher3@localhost                                                                                                      	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name3teacher                            	Surname3teacher                         	t	t
1607	teacher4@localhost                                                                                                      	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name4teacher                            	Surname4teacher                         	f	t
1608	teacher5@localhost                                                                                                      	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name5teacher                            	Surname5teacher                         	t	t
1609	teacher6@localhost                                                                                                      	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name6teacher                            	Surname6teacher                         	f	t
1610	teacher7@localhost                                                                                                      	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name7teacher                            	Surname7teacher                         	t	t
1611	teacher8@localhost                                                                                                      	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name8teacher                            	Surname8teacher                         	f	t
1612	teacher9@localhost                                                                                                      	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name9teacher                            	Surname9teacher                         	t	t
1613	student0@localhost                                                                                                      	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name0student                            	Surname0student                         	f	f
1614	student1@localhost                                                                                                      	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name1student                            	Surname1student                         	t	f
1615	student2@localhost                                                                                                      	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name2student                            	Surname2student                         	t	f
1616	student3@localhost                                                                                                      	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name3student                            	Surname3student                         	t	f
1617	student4@localhost                                                                                                      	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name4student                            	Surname4student                         	f	f
1618	student5@localhost                                                                                                      	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name5student                            	Surname5student                         	t	f
1619	student6@localhost                                                                                                      	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name6student                            	Surname6student                         	t	f
1620	student7@localhost                                                                                                      	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name7student                            	Surname7student                         	t	f
1621	student8@localhost                                                                                                      	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name8student                            	Surname8student                         	f	f
1622	student9@localhost                                                                                                      	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name9student                            	Surname9student                         	t	f
1623	student10@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name10student                           	Surname10student                        	t	f
1624	student11@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name11student                           	Surname11student                        	t	f
1625	student12@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name12student                           	Surname12student                        	f	f
1626	student13@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name13student                           	Surname13student                        	t	f
1627	student14@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name14student                           	Surname14student                        	t	f
1628	student15@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name15student                           	Surname15student                        	t	f
1629	student16@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name16student                           	Surname16student                        	f	f
1630	student17@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name17student                           	Surname17student                        	t	f
1631	student18@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name18student                           	Surname18student                        	t	f
1632	student19@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name19student                           	Surname19student                        	t	f
1633	student20@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name20student                           	Surname20student                        	f	f
1634	student21@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name21student                           	Surname21student                        	t	f
1635	student22@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name22student                           	Surname22student                        	t	f
1636	student23@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name23student                           	Surname23student                        	t	f
1637	student24@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name24student                           	Surname24student                        	f	f
1638	student25@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name25student                           	Surname25student                        	t	f
1639	student26@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name26student                           	Surname26student                        	t	f
1640	student27@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name27student                           	Surname27student                        	t	f
1641	student28@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name28student                           	Surname28student                        	f	f
1642	student29@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name29student                           	Surname29student                        	t	f
1643	student30@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name30student                           	Surname30student                        	t	f
1644	student31@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name31student                           	Surname31student                        	t	f
1645	student32@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name32student                           	Surname32student                        	f	f
1646	student33@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name33student                           	Surname33student                        	t	f
1647	student34@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name34student                           	Surname34student                        	t	f
1648	student35@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name35student                           	Surname35student                        	t	f
1649	student36@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name36student                           	Surname36student                        	f	f
1650	student37@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name37student                           	Surname37student                        	t	f
1651	student38@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name38student                           	Surname38student                        	t	f
1652	student39@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name39student                           	Surname39student                        	t	f
1653	student40@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name40student                           	Surname40student                        	f	f
1654	student41@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name41student                           	Surname41student                        	t	f
1655	student42@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name42student                           	Surname42student                        	t	f
1656	student43@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name43student                           	Surname43student                        	t	f
1657	student44@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name44student                           	Surname44student                        	f	f
1658	student45@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name45student                           	Surname45student                        	t	f
1659	student46@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name46student                           	Surname46student                        	t	f
1660	student47@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name47student                           	Surname47student                        	t	f
1661	student48@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name48student                           	Surname48student                        	f	f
1662	student49@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name49student                           	Surname49student                        	t	f
1663	student50@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name50student                           	Surname50student                        	t	f
1664	student51@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name51student                           	Surname51student                        	t	f
1665	student52@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name52student                           	Surname52student                        	f	f
1666	student53@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name53student                           	Surname53student                        	t	f
1667	student54@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name54student                           	Surname54student                        	t	f
1668	student55@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name55student                           	Surname55student                        	t	f
1669	student56@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name56student                           	Surname56student                        	f	f
1670	student57@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name57student                           	Surname57student                        	t	f
1671	student58@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name58student                           	Surname58student                        	t	f
1672	student59@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name59student                           	Surname59student                        	t	f
1673	student60@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name60student                           	Surname60student                        	f	f
1674	student61@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name61student                           	Surname61student                        	t	f
1675	student62@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name62student                           	Surname62student                        	t	f
1676	student63@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name63student                           	Surname63student                        	t	f
1677	student64@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name64student                           	Surname64student                        	f	f
1678	student65@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name65student                           	Surname65student                        	t	f
1679	student66@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name66student                           	Surname66student                        	t	f
1680	student67@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name67student                           	Surname67student                        	t	f
1681	student68@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name68student                           	Surname68student                        	f	f
1682	student69@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name69student                           	Surname69student                        	t	f
1683	student70@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name70student                           	Surname70student                        	t	f
1684	student71@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name71student                           	Surname71student                        	t	f
1685	student72@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name72student                           	Surname72student                        	f	f
1686	student73@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name73student                           	Surname73student                        	t	f
1687	student74@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name74student                           	Surname74student                        	t	f
1688	student75@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name75student                           	Surname75student                        	t	f
1689	student76@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name76student                           	Surname76student                        	f	f
1690	student77@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name77student                           	Surname77student                        	t	f
1691	student78@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name78student                           	Surname78student                        	t	f
1692	student79@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name79student                           	Surname79student                        	t	f
1693	student80@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name80student                           	Surname80student                        	f	f
1694	student81@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name81student                           	Surname81student                        	t	f
1695	student82@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name82student                           	Surname82student                        	t	f
1696	student83@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name83student                           	Surname83student                        	t	f
1697	student84@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name84student                           	Surname84student                        	f	f
1698	student85@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name85student                           	Surname85student                        	t	f
1699	student86@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name86student                           	Surname86student                        	t	f
1700	student87@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name87student                           	Surname87student                        	t	f
1701	student88@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name88student                           	Surname88student                        	f	f
1702	student89@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name89student                           	Surname89student                        	t	f
1703	student90@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name90student                           	Surname90student                        	t	f
1704	student91@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name91student                           	Surname91student                        	t	f
1705	student92@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name92student                           	Surname92student                        	f	f
1706	student93@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name93student                           	Surname93student                        	t	f
1707	student94@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name94student                           	Surname94student                        	t	f
1708	student95@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name95student                           	Surname95student                        	t	f
1709	student96@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name96student                           	Surname96student                        	f	f
1710	student97@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name97student                           	Surname97student                        	t	f
1711	student98@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name98student                           	Surname98student                        	t	f
1712	student99@localhost                                                                                                     	pbkdf2:sha256:260000$IuDb2xz2LK0iFMQa$54d5d778e2d6101674e6ba672973dbdedea35aaf3fa75362922fe211648615d3                          	Name99student                           	Surname99student                        	t	f
\.


--
-- TOC entry 3118 (class 0 OID 16792)
-- Dependencies: 213
-- Data for Name: user_example; Type: TABLE DATA; Schema: public; Owner: pcto
--

COPY public.user_example (id, username, password_hash, email, about_me, last_seen) FROM stdin;
\.


--
-- TOC entry 3129 (class 0 OID 0)
-- Dependencies: 216
-- Name: classroom_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pcto
--

SELECT pg_catalog.setval('public.classroom_id_seq', 2, true);


--
-- TOC entry 3130 (class 0 OID 0)
-- Dependencies: 207
-- Name: course_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pcto
--

SELECT pg_catalog.setval('public.course_id_seq', 1, false);


--
-- TOC entry 3131 (class 0 OID 0)
-- Dependencies: 209
-- Name: lesson_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pcto
--

SELECT pg_catalog.setval('public.lesson_id_seq', 1, false);


--
-- TOC entry 3132 (class 0 OID 0)
-- Dependencies: 214
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pcto
--

SELECT pg_catalog.setval('public.user_id_seq', 2262, true);


--
-- TOC entry 2951 (class 2606 OID 16661)
-- Name: classroom classroom_name_unique; Type: CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.classroom
    ADD CONSTRAINT classroom_name_unique UNIQUE (name);


--
-- TOC entry 2953 (class 2606 OID 16659)
-- Name: classroom classroom_pkey; Type: CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.classroom
    ADD CONSTRAINT classroom_pkey PRIMARY KEY (id);


--
-- TOC entry 2955 (class 2606 OID 16685)
-- Name: course course_pkey; Type: CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.course
    ADD CONSTRAINT course_pkey PRIMARY KEY (id);


--
-- TOC entry 2957 (class 2606 OID 16701)
-- Name: lesson lesson_pkey; Type: CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_pkey PRIMARY KEY (id);


--
-- TOC entry 2961 (class 2606 OID 16871)
-- Name: many_courses_has_many_persons many_courses_has_many_persons_pk; Type: CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.many_courses_has_many_persons
    ADD CONSTRAINT many_courses_has_many_persons_pk PRIMARY KEY (id_course, id_user);


--
-- TOC entry 2959 (class 2606 OID 16869)
-- Name: many_lessons_has_many_persons many_lessons_has_many_persons_pk; Type: CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.many_lessons_has_many_persons
    ADD CONSTRAINT many_lessons_has_many_persons_pk PRIMARY KEY (id_lesson, id_user);


--
-- TOC entry 2970 (class 2606 OID 16860)
-- Name: user user_email_unique; Type: CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_email_unique UNIQUE (email);


--
-- TOC entry 2963 (class 2606 OID 16867)
-- Name: user_example user_example_email_unique; Type: CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.user_example
    ADD CONSTRAINT user_example_email_unique UNIQUE (email);


--
-- TOC entry 2965 (class 2606 OID 16863)
-- Name: user_example user_example_pkey; Type: CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.user_example
    ADD CONSTRAINT user_example_pkey PRIMARY KEY (id);


--
-- TOC entry 2967 (class 2606 OID 16865)
-- Name: user_example user_example_username_unique; Type: CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.user_example
    ADD CONSTRAINT user_example_username_unique UNIQUE (username);


--
-- TOC entry 2972 (class 2606 OID 16858)
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- TOC entry 2968 (class 1259 OID 16861)
-- Name: user_email_index; Type: INDEX; Schema: public; Owner: pcto
--

CREATE INDEX user_email_index ON public."user" USING btree (email);


--
-- TOC entry 2976 (class 2606 OID 16739)
-- Name: lesson classroom_fk; Type: FK CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT classroom_fk FOREIGN KEY (id_classroom) REFERENCES public.classroom(id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 2975 (class 2606 OID 16734)
-- Name: lesson course_fk; Type: FK CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT course_fk FOREIGN KEY (id_course) REFERENCES public.course(id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 2979 (class 2606 OID 16882)
-- Name: many_courses_has_many_persons course_fk; Type: FK CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.many_courses_has_many_persons
    ADD CONSTRAINT course_fk FOREIGN KEY (id_course) REFERENCES public.course(id) MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2977 (class 2606 OID 16872)
-- Name: many_lessons_has_many_persons lesson_fk; Type: FK CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.many_lessons_has_many_persons
    ADD CONSTRAINT lesson_fk FOREIGN KEY (id_lesson) REFERENCES public.lesson(id) MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2978 (class 2606 OID 16877)
-- Name: many_lessons_has_many_persons user_fk; Type: FK CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.many_lessons_has_many_persons
    ADD CONSTRAINT user_fk FOREIGN KEY (id_user) REFERENCES public."user"(id) MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2980 (class 2606 OID 16887)
-- Name: many_courses_has_many_persons user_fk; Type: FK CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.many_courses_has_many_persons
    ADD CONSTRAINT user_fk FOREIGN KEY (id_user) REFERENCES public."user"(id) MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2974 (class 2606 OID 16917)
-- Name: lesson user_fk; Type: FK CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT user_fk FOREIGN KEY (id_user) REFERENCES public."user"(id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 2973 (class 2606 OID 16922)
-- Name: course user_fk; Type: FK CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.course
    ADD CONSTRAINT user_fk FOREIGN KEY (id_user) REFERENCES public."user"(id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;


-- Completed on 2022-08-14 12:56:57

--
-- PostgreSQL database dump complete
--

