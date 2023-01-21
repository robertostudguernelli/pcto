--
-- PostgreSQL database dump
--

-- Dumped from database version 13.7 (Ubuntu 13.7-0ubuntu0.21.10.1)
-- Dumped by pg_dump version 14.1

-- Started on 2023-01-21 17:05:08

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
-- TOC entry 232 (class 1255 OID 17053)
-- Name: manager_must_be_a_teacher(); Type: FUNCTION; Schema: public; Owner: pcto
--

CREATE FUNCTION public.manager_must_be_a_teacher() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    INSERT INTO "echo"(number, time) VALUES(22, now());
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.manager_must_be_a_teacher() OWNER TO pcto;

--
-- TOC entry 245 (class 1255 OID 16914)
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
        disability  := MOD(i, 100/10) != 0; -- 10% of classroom are NOT disability enabled
        INSERT INTO "classroom"(name, description, capacity, disability) VALUES(name, description, capacity, disability);
    END LOOP;
END;
$$;


ALTER PROCEDURE public.populate_classrooms() OWNER TO pcto;

--
-- TOC entry 247 (class 1255 OID 17048)
-- Name: populate_courses(); Type: PROCEDURE; Schema: public; Owner: pcto
--

CREATE PROCEDURE public.populate_courses()
    LANGUAGE plpgsql
    AS $$DECLARE
    title TEXT;
    description TEXT;
    min_ratio_for_attendance_certificate DOUBLE PRECISION;
    max_in_presence_partecipants INTEGER;
    id_user INTEGER; -- manager

    number_of_courses INTEGER := 100;
BEGIN
	FOR i IN 0..(number_of_courses-1) LOOP
        title        := 'Course' || i;
        description := 'This is the ' || i || ' course';
        min_ratio_for_attendance_certificate := 0.75;
        max_in_presence_partecipants  := 3;
        SELECT id INTO id_user FROM "user" WHERE is_active=true AND is_teacher=true ORDER BY RANDOM() LIMIT 1;
        INSERT INTO "course"(title, description, min_ratio_for_attendance_certificate, max_in_presence_partecipants, id_user) VALUES(title, description, min_ratio_for_attendance_certificate, max_in_presence_partecipants, id_user);
    END LOOP;
END;
$$;


ALTER PROCEDURE public.populate_courses() OWNER TO pcto;

--
-- TOC entry 248 (class 1255 OID 16907)
-- Name: populate_database(); Type: PROCEDURE; Schema: public; Owner: pcto
--

CREATE PROCEDURE public.populate_database()
    LANGUAGE plpgsql
    AS $$DECLARE
    number_of_teacher INTEGER := 10;
    number_of_student INTEGER := 100;
BEGIN
    DELETE FROM "many_courses_has_many_students";
    DELETE FROM "course";
    DELETE FROM "user";
    DELETE FROM "classroom";
    CALL public.populate_users_teachers();
    CALL public.populate_users_students();
    CALL public.populate_classrooms();
    CALL public.populate_courses();
    CALL public.populate_many_courses_has_many_students();
END;$$;


ALTER PROCEDURE public.populate_database() OWNER TO pcto;

--
-- TOC entry 249 (class 1255 OID 17578)
-- Name: populate_many_courses_has_many_students(); Type: PROCEDURE; Schema: public; Owner: pcto
--

CREATE PROCEDURE public.populate_many_courses_has_many_students()
    LANGUAGE plpgsql
    AS $$DECLARE
    id_user INTEGER; -- student
    id_course INTEGER;

    number_of_couple_student_courses INTEGER := 1000;
BEGIN
	FOR i IN 0..(number_of_couple_student_courses-1) LOOP
        SELECT id INTO id_user FROM "user"   WHERE is_active=true AND is_teacher=false ORDER BY RANDOM() LIMIT 1;
        SELECT id INTO id_course  FROM "course" ORDER BY RANDOM() LIMIT 1;
        INSERT INTO "many_courses_has_many_students"(id_user, id_course) VALUES(id_user, id_course);
    END LOOP;
END;$$;


ALTER PROCEDURE public.populate_many_courses_has_many_students() OWNER TO pcto;

--
-- TOC entry 246 (class 1255 OID 16913)
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
        is_active     := MOD(i, 100/25) != 0; -- 25% of student are NOT active
        INSERT INTO "user"(email, password_hash, name, surname, is_active, is_teacher) VALUES(email, password_hash, name, surname, is_active, is_teacher);
    END LOOP;
END;
$_$;


ALTER PROCEDURE public.populate_users_students() OWNER TO pcto;

--
-- TOC entry 244 (class 1255 OID 16828)
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
        is_active     := MOD(i, 100/25) != 0; -- 25% of teacher are NOT active
        INSERT INTO "user"(email, password_hash, name, surname, is_active, is_teacher) VALUES(email, password_hash, name, surname, is_active, is_teacher);
    END LOOP;
END;
$_$;


ALTER PROCEDURE public.populate_users_teachers() OWNER TO pcto;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 223 (class 1259 OID 17739)
-- Name: classroom; Type: TABLE; Schema: public; Owner: pcto
--

CREATE TABLE public.classroom (
    id integer NOT NULL,
    name character(40) NOT NULL,
    description character(1024),
    capacity integer,
    disability_enabled boolean,
    CONSTRAINT classroom_capacity_check CHECK ((capacity >= 0))
);


ALTER TABLE public.classroom OWNER TO pcto;

--
-- TOC entry 221 (class 1259 OID 16904)
-- Name: classroom_id_seq; Type: SEQUENCE; Schema: public; Owner: pcto
--

CREATE SEQUENCE public.classroom_id_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE -2147483648
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE public.classroom_id_seq OWNER TO pcto;

--
-- TOC entry 222 (class 1259 OID 17737)
-- Name: classroom_id_seq1; Type: SEQUENCE; Schema: public; Owner: pcto
--

CREATE SEQUENCE public.classroom_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.classroom_id_seq1 OWNER TO pcto;

--
-- TOC entry 3137 (class 0 OID 0)
-- Dependencies: 222
-- Name: classroom_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: pcto
--

ALTER SEQUENCE public.classroom_id_seq1 OWNED BY public.classroom.id;


--
-- TOC entry 225 (class 1259 OID 17753)
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
-- TOC entry 224 (class 1259 OID 17751)
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
-- TOC entry 3138 (class 0 OID 0)
-- Dependencies: 224
-- Name: course_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pcto
--

ALTER SEQUENCE public.course_id_seq OWNED BY public.course.id;


--
-- TOC entry 227 (class 1259 OID 17768)
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
-- TOC entry 226 (class 1259 OID 17766)
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
-- TOC entry 3139 (class 0 OID 0)
-- Dependencies: 226
-- Name: lesson_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pcto
--

ALTER SEQUENCE public.lesson_id_seq OWNED BY public.lesson.id;


--
-- TOC entry 231 (class 1259 OID 17817)
-- Name: many_courses_has_many_students; Type: TABLE; Schema: public; Owner: pcto
--

CREATE TABLE public.many_courses_has_many_students (
    id_course integer NOT NULL,
    id_user integer NOT NULL
);


ALTER TABLE public.many_courses_has_many_students OWNER TO pcto;

--
-- TOC entry 230 (class 1259 OID 17812)
-- Name: many_lessons_has_many_students; Type: TABLE; Schema: public; Owner: pcto
--

CREATE TABLE public.many_lessons_has_many_students (
    id_lesson integer NOT NULL,
    id_user integer NOT NULL
);


ALTER TABLE public.many_lessons_has_many_students OWNER TO pcto;

--
-- TOC entry 229 (class 1259 OID 17784)
-- Name: user; Type: TABLE; Schema: public; Owner: pcto
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    email character(120) NOT NULL,
    password_hash character(128) NOT NULL,
    name character(40),
    surname character(40),
    is_active boolean DEFAULT true NOT NULL,
    is_teacher boolean DEFAULT false NOT NULL,
    password character(20)
);


ALTER TABLE public."user" OWNER TO pcto;

--
-- TOC entry 220 (class 1259 OID 16801)
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
-- TOC entry 228 (class 1259 OID 17782)
-- Name: user_id_seq1; Type: SEQUENCE; Schema: public; Owner: pcto
--

CREATE SEQUENCE public.user_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_id_seq1 OWNER TO pcto;

--
-- TOC entry 3140 (class 0 OID 0)
-- Dependencies: 228
-- Name: user_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: pcto
--

ALTER SEQUENCE public.user_id_seq1 OWNED BY public."user".id;


--
-- TOC entry 2951 (class 2604 OID 17742)
-- Name: classroom id; Type: DEFAULT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.classroom ALTER COLUMN id SET DEFAULT nextval('public.classroom_id_seq1'::regclass);


--
-- TOC entry 2953 (class 2604 OID 17756)
-- Name: course id; Type: DEFAULT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.course ALTER COLUMN id SET DEFAULT nextval('public.course_id_seq'::regclass);


--
-- TOC entry 2958 (class 2604 OID 17771)
-- Name: lesson id; Type: DEFAULT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.lesson ALTER COLUMN id SET DEFAULT nextval('public.lesson_id_seq'::regclass);


--
-- TOC entry 2964 (class 2604 OID 17787)
-- Name: user id; Type: DEFAULT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq1'::regclass);


--
-- TOC entry 3123 (class 0 OID 17739)
-- Dependencies: 223
-- Data for Name: classroom; Type: TABLE DATA; Schema: public; Owner: pcto
--

COPY public.classroom (id, name, description, capacity, disability_enabled) FROM stdin;
\.


--
-- TOC entry 3125 (class 0 OID 17753)
-- Dependencies: 225
-- Data for Name: course; Type: TABLE DATA; Schema: public; Owner: pcto
--

COPY public.course (id, title, description, min_ratio_for_attendance_certificate, max_in_presence_partecipants, id_user) FROM stdin;
\.


--
-- TOC entry 3127 (class 0 OID 17768)
-- Dependencies: 227
-- Data for Name: lesson; Type: TABLE DATA; Schema: public; Owner: pcto
--

COPY public.lesson (id, secret_token, title, description, start_date_time, end_date_time, in_presence, online, recording_will_be_available, on_line_link, on_line_recording_link, id_course, id_classroom, id_user) FROM stdin;
\.


--
-- TOC entry 3131 (class 0 OID 17817)
-- Dependencies: 231
-- Data for Name: many_courses_has_many_students; Type: TABLE DATA; Schema: public; Owner: pcto
--

COPY public.many_courses_has_many_students (id_course, id_user) FROM stdin;
\.


--
-- TOC entry 3130 (class 0 OID 17812)
-- Dependencies: 230
-- Data for Name: many_lessons_has_many_students; Type: TABLE DATA; Schema: public; Owner: pcto
--

COPY public.many_lessons_has_many_students (id_lesson, id_user) FROM stdin;
\.


--
-- TOC entry 3129 (class 0 OID 17784)
-- Dependencies: 229
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: pcto
--

COPY public."user" (id, email, password_hash, name, surname, is_active, is_teacher, password) FROM stdin;
3	docente1@unive.it                                                                                                       	aaa                                                                                                                             	Uno                                     	Docente                                 	t	t	docente1            
4	docente2@unive.it                                                                                                       	aaa                                                                                                                             	Due                                     	Docente                                 	t	t	docente2            
1	studente1@unive.it                                                                                                      	aaa                                                                                                                             	Uno                                     	Studente                                	t	f	studente1           
2	studente2@unive.it                                                                                                      	aaa                                                                                                                             	Due                                     	Studente                                	t	f	studente2           
\.


--
-- TOC entry 3141 (class 0 OID 0)
-- Dependencies: 221
-- Name: classroom_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pcto
--

SELECT pg_catalog.setval('public.classroom_id_seq', 2, true);


--
-- TOC entry 3142 (class 0 OID 0)
-- Dependencies: 222
-- Name: classroom_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: pcto
--

SELECT pg_catalog.setval('public.classroom_id_seq1', 1, false);


--
-- TOC entry 3143 (class 0 OID 0)
-- Dependencies: 224
-- Name: course_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pcto
--

SELECT pg_catalog.setval('public.course_id_seq', 1, false);


--
-- TOC entry 3144 (class 0 OID 0)
-- Dependencies: 226
-- Name: lesson_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pcto
--

SELECT pg_catalog.setval('public.lesson_id_seq', 1, false);


--
-- TOC entry 3145 (class 0 OID 0)
-- Dependencies: 220
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pcto
--

SELECT pg_catalog.setval('public.user_id_seq', 2262, true);


--
-- TOC entry 3146 (class 0 OID 0)
-- Dependencies: 228
-- Name: user_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: pcto
--

SELECT pg_catalog.setval('public.user_id_seq1', 4, true);


--
-- TOC entry 2968 (class 2606 OID 17750)
-- Name: classroom classroom_name_unique; Type: CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.classroom
    ADD CONSTRAINT classroom_name_unique UNIQUE (name);


--
-- TOC entry 2970 (class 2606 OID 17748)
-- Name: classroom classroom_pkey; Type: CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.classroom
    ADD CONSTRAINT classroom_pkey PRIMARY KEY (id);


--
-- TOC entry 2972 (class 2606 OID 17765)
-- Name: course course_pkey; Type: CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.course
    ADD CONSTRAINT course_pkey PRIMARY KEY (id);


--
-- TOC entry 2974 (class 2606 OID 17781)
-- Name: lesson lesson_pkey; Type: CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_pkey PRIMARY KEY (id);


--
-- TOC entry 2983 (class 2606 OID 17821)
-- Name: many_courses_has_many_students many_courses_has_many_students_pk; Type: CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.many_courses_has_many_students
    ADD CONSTRAINT many_courses_has_many_students_pk PRIMARY KEY (id_course, id_user);


--
-- TOC entry 2981 (class 2606 OID 17816)
-- Name: many_lessons_has_many_students many_lessons_has_many_students_pk; Type: CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.many_lessons_has_many_students
    ADD CONSTRAINT many_lessons_has_many_students_pk PRIMARY KEY (id_lesson, id_user);


--
-- TOC entry 2977 (class 2606 OID 17793)
-- Name: user user_email_unique; Type: CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_email_unique UNIQUE (email);


--
-- TOC entry 2979 (class 2606 OID 17791)
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- TOC entry 2975 (class 1259 OID 17794)
-- Name: user_email_index; Type: INDEX; Schema: public; Owner: pcto
--

CREATE INDEX user_email_index ON public."user" USING btree (email);


--
-- TOC entry 2989 (class 2620 OID 17822)
-- Name: course manager_must_be_a_teacher; Type: TRIGGER; Schema: public; Owner: pcto
--

CREATE TRIGGER manager_must_be_a_teacher BEFORE INSERT OR UPDATE ON public.course FOR EACH ROW EXECUTE FUNCTION public.manager_must_be_a_teacher('');


--
-- TOC entry 2987 (class 2606 OID 17843)
-- Name: many_lessons_has_many_students lesson_fk; Type: FK CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.many_lessons_has_many_students
    ADD CONSTRAINT lesson_fk FOREIGN KEY (id_lesson) REFERENCES public.lesson(id) MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2986 (class 2606 OID 17823)
-- Name: many_lessons_has_many_students user_fk; Type: FK CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.many_lessons_has_many_students
    ADD CONSTRAINT user_fk FOREIGN KEY (id_user) REFERENCES public."user"(id) MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2985 (class 2606 OID 17828)
-- Name: lesson user_fk; Type: FK CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT user_fk FOREIGN KEY (id_user) REFERENCES public."user"(id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 2988 (class 2606 OID 17833)
-- Name: many_courses_has_many_students user_fk; Type: FK CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.many_courses_has_many_students
    ADD CONSTRAINT user_fk FOREIGN KEY (id_user) REFERENCES public."user"(id) MATCH FULL ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2984 (class 2606 OID 17838)
-- Name: course user_fk; Type: FK CONSTRAINT; Schema: public; Owner: pcto
--

ALTER TABLE ONLY public.course
    ADD CONSTRAINT user_fk FOREIGN KEY (id_user) REFERENCES public."user"(id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;


-- Completed on 2023-01-21 17:05:08

--
-- PostgreSQL database dump complete
--

