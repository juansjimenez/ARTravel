--
-- PostgreSQL database dump
--

-- Dumped from database version 12.5 (Ubuntu 12.5-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.5 (Ubuntu 12.5-0ubuntu0.20.04.1)

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
-- Name: crear_itinerario(integer[], integer, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.crear_itinerario(aid_seleccionados integer[], ciudad_partida integer, fecha_partida date) RETURNS TABLE(pos0 character varying, pos1 character varying, pos2 character varying, pos3 character varying, precio_v1 integer, precio_v2 integer, precio_v3 integer, fecha_v1 timestamp without time zone, fecha_v2 timestamp without time zone, fecha_v3 timestamp without time zone, duracion_v1 integer, duracion_v2 integer, duracion_v3 integer, medio_v1 character varying, medio_v2 character varying, medio_v3 character varying, precio_total integer)
    LANGUAGE plpgsql
    AS $$
DECLARE

tupla RECORD;
nombre_pos0 varchar(30);
nombre_pos1 varchar(30);
nombre_pos2 varchar(30);
nombre_pos3 varchar(30);

BEGIN
    CREATE TABLE id_lugares_posibles(lid integer);
    FOR tupla IN SELECT DISTINCT lc.cid FROM lugar_ciudad AS lc, obra_lugar AS ol, hecha_por AS hp, ciudades WHERE lc.lid = ol.lid AND ol.oid = hp.oid AND hp.aid = ANY(aid_seleccionados) LOOP
        INSERT INTO id_lugares_posibles VALUES (tupla.cid);
    END LOOP;

    CREATE TABLE viajes AS SELECT * FROM (SELECT * FROM dblink('dbname=grupo95e3 host=146.155.13.72 user=grupo95 password=benjayjavi', 'SELECT * FROM viajes')  AS (id_viaje INT, id_ciudad_origen INT, id_ciudad_destino INT, hora_de_salida time without time zone, medio varchar(200), capacidad_maxima INT, duracion double precision, precio double precision)) AS viajes;

    CREATE TABLE viajes_utiles AS (SELECT viajes.id_ciudad_origen, viajes.id_ciudad_destino, viajes.id_viaje, viajes.hora_de_salida, viajes.precio, viajes.duracion, viajes.medio FROM viajes WHERE viajes.id_ciudad_destino = ANY(SELECT * FROM id_lugares_posibles));

    CREATE TABLE itinerarios_0e AS (SELECT a.id_ciudad_origen AS pos0, a.id_ciudad_destino AS pos1, a.id_viaje AS vid1, a.precio AS v1_precio, a.duracion AS v1_duracion, a.hora_de_salida AS v1_salida, a.medio AS v1_medio FROM viajes_utiles AS a WHERE a.id_ciudad_origen = ciudad_partida);

    CREATE TABLE itinerarios_1e AS (SELECT a.pos0 AS pos0, a.pos1 AS pos1, b.id_ciudad_destino AS pos2, a.vid1 AS vid1, b.id_viaje AS vid2, a.v1_precio AS v1_precio, b.precio AS v2_precio, a.v1_duracion AS v1_duracion, b.duracion AS v2_duracion, a.v1_salida AS v1_salida, b.hora_de_salida AS v2_salida, a.v1_medio AS v1_medio, b.medio AS v2_medio FROM itinerarios_0e AS a FULL OUTER JOIN viajes_utiles AS b ON a.pos1 = b.id_ciudad_origen WHERE b.id_ciudad_destino <> a.pos0);

    CREATE TABLE itinerarios_2e AS (SELECT a.pos0 AS pos0, a.pos1 AS pos1, a.pos2 AS pos2, b.id_ciudad_destino AS pos3, a.vid1 AS vid1, a.vid2 AS vid2, b.id_viaje AS vid3, a.v1_precio AS v1_precio,a.v2_precio AS v2_precio, b.precio AS v3_precio, a.v1_duracion AS v1_duracion, a.v2_duracion AS v2_duracion, b.duracion AS v3_duracion, a.v1_salida AS v1_salida, a.v2_salida AS v2_salida, b.hora_de_salida AS v3_salida, a.v1_medio AS v1_medio, a.v2_medio AS v2_medio, b.medio AS v3_medio FROM itinerarios_1e AS a FULL OUTER JOIN viajes_utiles AS b ON a.pos2 = b.id_ciudad_origen WHERE b.id_ciudad_destino <> a.pos0 AND b.id_ciudad_destino <> a.pos1);

    CREATE TABLE itinerario_final (pos0 varchar(200), pos1 varchar(200), pos2 varchar(200), pos3 varchar(200), precio_v1 INT, precio_v2 INT, precio_v3 INT, fecha_v1 TIMESTAMP, fecha_v2 TIMESTAMP, fecha_v3 TIMESTAMP, duracion_v1 INT, duracion_v2 INT, duracion_v3 INT, medio_v1 varchar(40), medio_v2 varchar(40), medio_v3 varchar(40), costo_total INT);

    FOR tupla IN SELECT * FROM itinerarios_0e LOOP
        SELECT INTO nombre_pos0 nombre FROM ciudades WHERE cid = tupla.pos0;
        SELECT INTO nombre_pos1 nombre FROM ciudades WHERE cid = tupla.pos1;
        INSERT INTO itinerario_final VALUES (nombre_pos0, nombre_pos1, NULL, NULL, tupla.v1_precio, NULL, NULL, fecha_partida + tupla.v1_salida, NULL, NULL, tupla.v1_duracion, NULL, NULL, tupla.v1_medio, NULL, NULL, tupla.v1_precio);
    END LOOP;

    FOR tupla IN SELECT * FROM itinerarios_1e LOOP
        SELECT INTO nombre_pos0 nombre FROM ciudades WHERE cid = tupla.pos0;
        SELECT INTO nombre_pos1 nombre FROM ciudades WHERE cid = tupla.pos1;
        SELECT INTO nombre_pos2 nombre FROM ciudades WHERE cid = tupla.pos2;
        IF (fecha_partida + (CAST(tupla.v1_duracion AS INT) * interval '1 hour')) + tupla.v1_salida  >= fecha_partida + tupla.v2_salida THEN
            INSERT INTO itinerario_final VALUES (nombre_pos0, nombre_pos1, nombre_pos2, NULL, tupla.v1_precio, tupla.v2_precio, NULL, fecha_partida + tupla.v1_salida, fecha_partida + 1 + tupla.v2_salida, NULL, tupla.v1_duracion, tupla.v2_duracion, NULL, tupla.v1_medio, tupla.v2_medio, NULL, tupla.v1_precio + tupla.v2_precio);
        ELSE
            INSERT INTO itinerario_final VALUES (nombre_pos0, nombre_pos1, nombre_pos2, NULL, tupla.v1_precio, tupla.v2_precio, NULL, fecha_partida + tupla.v1_salida, fecha_partida + tupla.v2_salida, NULL, tupla.v1_duracion, tupla.v2_duracion, NULL, tupla.v1_medio, tupla.v2_medio, NULL, tupla.v1_precio + tupla.v2_precio);
        END IF;
    END LOOP;

    FOR tupla IN SELECT * FROM itinerarios_2e LOOP
        SELECT INTO nombre_pos0 nombre FROM ciudades WHERE cid = tupla.pos0;
        SELECT INTO nombre_pos1 nombre FROM ciudades WHERE cid = tupla.pos1;
        SELECT INTO nombre_pos2 nombre FROM ciudades WHERE cid = tupla.pos2;
        SELECT INTO nombre_pos3 nombre FROM ciudades WHERE cid = tupla.pos3;
        IF (fecha_partida + (CAST(tupla.v1_duracion AS INT) * interval '1 hour')) + tupla.v1_salida  >= fecha_partida + tupla.v2_salida THEN

            IF fecha_partida + 1 + tupla.v2_salida + (CAST(tupla.v2_duracion AS INT) * interval '1 hour') >= fecha_partida + 1 + tupla.v3_salida THEN

                INSERT INTO itinerario_final VALUES (nombre_pos0, nombre_pos1, nombre_pos2, nombre_pos3, tupla.v1_precio, tupla.v2_precio, tupla.v3_precio, fecha_partida + tupla.v1_salida, fecha_partida + 1 + tupla.v2_salida, fecha_partida + 2 + tupla.v3_salida, tupla.v1_duracion, tupla.v2_duracion, tupla.v3_duracion, tupla.v1_medio, tupla.v2_medio, tupla.v3_medio, tupla.v1_precio + tupla.v2_precio + tupla.v3_precio);

            ELSE

                INSERT INTO itinerario_final VALUES (nombre_pos0, nombre_pos1, nombre_pos2, nombre_pos3, tupla.v1_precio, tupla.v2_precio, tupla.v3_precio, fecha_partida + tupla.v1_salida, fecha_partida + 1 + tupla.v2_salida, fecha_partida + 1+ tupla.v3_salida, tupla.v1_duracion, tupla.v2_duracion, tupla.v3_duracion, tupla.v1_medio, tupla.v2_medio, tupla.v3_medio, tupla.v1_precio + tupla.v2_precio + tupla.v3_precio);

            END IF;

        ELSE

            IF fecha_partida + tupla.v2_salida + (CAST(tupla.v2_duracion AS INT) * interval '1 hour') >= fecha_partida + tupla.v3_salida THEN
                INSERT INTO itinerario_final VALUES (nombre_pos0, nombre_pos1, nombre_pos2, nombre_pos3, tupla.v1_precio, tupla.v2_precio, tupla.v3_precio, fecha_partida + tupla.v1_salida, fecha_partida + tupla.v2_salida, fecha_partida + 1 + tupla.v3_salida, tupla.v1_duracion, tupla.v2_duracion, tupla.v3_duracion, tupla.v1_medio, tupla.v2_medio, tupla.v3_medio, tupla.v1_precio + tupla.v2_precio + tupla.v3_precio);

            ELSE

                INSERT INTO itinerario_final VALUES (nombre_pos0, nombre_pos1, nombre_pos2, nombre_pos3, tupla.v1_precio, tupla.v2_precio, tupla.v3_precio, fecha_partida + tupla.v1_salida, fecha_partida + tupla.v2_salida, fecha_partida + tupla.v3_salida, tupla.v1_duracion, tupla.v2_duracion, tupla.v3_duracion, tupla.v1_medio, tupla.v2_medio, tupla.v3_medio, tupla.v1_precio + tupla.v2_precio + tupla.v3_precio);

            END IF;

        END IF;
    END LOOP;
    
    RETURN QUERY SELECT  * FROM itinerario_final;

    DROP TABLE itinerario_final;
    DROP TABLE itinerarios_0e;
    DROP TABLE itinerarios_1e;
    DROP TABLE itinerarios_2e;
    DROP TABLE viajes_utiles;
    DROP TABLE viajes;
    DROP TABLE id_lugares_posibles;

    RETURN;
END;
$$;


ALTER FUNCTION public.crear_itinerario(aid_seleccionados integer[], ciudad_partida integer, fecha_partida date) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ciudades; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ciudades (
    id_ciudad integer NOT NULL,
    cnombre character varying(255),
    pnombre character varying(255)
);


ALTER TABLE public.ciudades OWNER TO postgres;

--
-- Name: hoteles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hoteles (
    id_hotel integer NOT NULL,
    nombre_hotel character varying(255),
    id_ciudad integer,
    direccion character varying(255),
    telefono character varying(255),
    precio real
);


ALTER TABLE public.hoteles OWNER TO postgres;

--
-- Name: paises; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.paises (
    pnombre character varying(255) NOT NULL,
    numero_contacto character varying(255)
);


ALTER TABLE public.paises OWNER TO postgres;

--
-- Name: reservas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reservas (
    id_reserva integer NOT NULL,
    id_hotel integer,
    usuario_id integer,
    fecha_llegada date,
    fecha_salida date
);


ALTER TABLE public.reservas OWNER TO postgres;

--
-- Name: tickets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tickets (
    numero_ticket integer NOT NULL,
    usuario_id integer,
    id_viaje integer,
    fecha_compra date,
    numero_de_asiento character varying(255),
    fecha_viaje date
);


ALTER TABLE public.tickets OWNER TO postgres;

--
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    usuario_id integer NOT NULL,
    username character varying(255),
    nombre character varying(255),
    correo character varying(255),
    direccion character varying(255),
    password text
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- Name: viajes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.viajes (
    id_viaje integer NOT NULL,
    id_ciudad_origen integer,
    id_ciudad_destino integer,
    hora_de_salida time without time zone,
    medio character varying(255),
    capacidad_maxima integer,
    duracion real,
    precio real
);


ALTER TABLE public.viajes OWNER TO postgres;

--
-- Data for Name: ciudades; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ciudades (id_ciudad, cnombre, pnombre) FROM stdin;
1	Roma	Italia
2	Florencia	Italia
3	ParÃ­s	Francia
4	Chantilly	Francia
5	Nancy	Francia
6	Bruselas	BÃ©lgica
7	Antwerp	BÃ©lgica
8	Dresde	Alemania
9	Westminster	Inglaterra
10	MilÃ¡n	Italia
\.


--
-- Data for Name: hoteles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hoteles (id_hotel, nombre_hotel, id_ciudad, direccion, telefono, precio) FROM stdin;
10	Hilton Florence Metropole	2	518 Hall Dam New Jesse, NM 01087	233-347-518	30
13	CitizenM Paris	3	833 Flores Key Suite 707 South Elizabethchester, IA 08393	799-491-215	50
20	The Sanctuary House Hotel	9	1281 Robert Mountain Schneidermouth, HI 23898	698-634-912	70
15	Le cocon de Leon	5	8927 Hurst Harbor Apt. 156 Timothyfort, CA 72308	485-531-155	55
3	Domo Vaticano	1	7802 Scott Garden Apt. 827 Jerryport, WI 13545	647-252-126	30
9	Hotel Jane	2	65223 Valdez Viaduct Lake Seanview, WY 97324	214-454-587	23
18	PitufiHotel	7	PSC 3268, Box 6667 APO AE 63637	241-126-819	20
2	Palazzo Coliseo	1	8183 Michael Glen Apt. 437 Petersonland, VA 66579	771-764-467	43
16	Royal Hotel	6	37962 Sanders Circles Apt. 357 Port Timothy, TN 24656	315-196-562	30
7	Hotel delle Nazioni	2	511 Karen Neck Terriborough, WV 55292	321-718-523	28
1	Hotel Roma	1	PSC 1716, Box 5186 APO AP 18920	294-527-692	35
19	B&B Hotel Dresden	8	703 Garcia Drive Suite 239 West Carolside, NV 09666	633-564-612	35
17	Hotel Phenix	6	Unit 6357 Box 9808 DPO AA 45781	282-833-326	38
21	Hotel Rex Milano	10	71677 Theresa Fields Chadchester, TN 58947	527-989-688	21
12	Eiffel Hotel	3	PSC 4851, Box 9887 APO AP 86712	717-744-934	70
14	Hyatt Regency Chantilly	4	9381 Melissa Walks Apt. 623 Port Barbarafurt, MI 38305	441-127-177	50
5	DomusAmor Navona	1	47081 Rosales Islands Suite 864 Port Sydney, UT 33108	998-171-811	18
4	Hotel Trastevere	1	Unit 5444 Box 3960 DPO AE 23180	738-387-267	22
8	Hotel Alba Palace	2	8300 Kemp Gateway Suite 979 Blackhaven, WV 71663	745-819-474	25
6	Roma Gondola	1	75237 Ross Radial Ashleeburgh, GA 15492	734-544-857	20
11	Montparnasse	3	0943 Harmon Ways Collinsburgh, ME 20733	692-622-914	60
\.


--
-- Data for Name: paises; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.paises (pnombre, numero_contacto) FROM stdin;
Italia	433-666-975
Francia	133-154-268
BÃ©lgica	758-382-381
Alemania	199-786-913
Inglaterra	129-666-539
\.


--
-- Data for Name: reservas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reservas (id_reserva, id_hotel, usuario_id, fecha_llegada, fecha_salida) FROM stdin;
1	10	36	2018-07-27	2018-07-28
2	13	12	2019-01-21	2019-01-27
3	20	44	2018-05-18	2018-05-25
4	15	32	2020-01-02	2020-01-12
5	3	5	2019-07-19	2019-07-21
6	9	35	2018-01-23	2018-02-04
7	18	17	2018-06-27	2018-07-10
8	15	49	2019-08-03	2019-08-17
9	2	24	2020-11-27	2020-11-28
10	20	12	2018-01-05	2018-01-15
11	16	29	2018-08-20	2018-08-22
12	13	15	2019-10-23	2019-11-01
13	7	8	2020-09-04	2020-09-15
14	1	14	2018-07-07	2018-07-21
15	1	2	2020-04-11	2020-04-20
16	19	48	2018-06-23	2018-07-01
17	9	3	2018-09-05	2018-09-09
18	17	23	2020-03-04	2020-03-17
19	9	3	2018-07-18	2018-07-24
20	21	32	2018-09-01	2018-09-10
21	12	18	2019-05-06	2019-05-13
22	17	40	2019-04-01	2019-04-12
23	18	3	2018-11-26	2018-12-07
24	14	26	2019-06-07	2019-06-12
25	5	8	2018-01-16	2018-01-22
26	13	9	2018-12-20	2018-12-28
27	18	4	2018-12-21	2018-12-31
28	4	16	2019-07-06	2019-07-13
29	18	26	2018-02-13	2018-02-14
30	3	45	2018-01-24	2018-02-02
31	16	5	2020-02-14	2020-02-16
32	15	23	2020-05-27	2020-06-06
33	12	26	2018-02-09	2018-02-20
34	3	20	2019-12-04	2019-12-18
35	8	4	2018-01-18	2018-01-21
36	4	29	2020-08-20	2020-08-27
37	18	49	2019-12-26	2020-01-07
38	16	32	2018-05-18	2018-05-22
39	12	38	2018-12-13	2018-12-24
40	18	14	2018-10-15	2018-10-20
41	3	2	2018-09-11	2018-09-16
42	12	10	2019-01-16	2019-01-28
43	5	41	2019-09-06	2019-09-07
44	19	14	2018-10-03	2018-10-15
45	19	9	2018-12-15	2018-12-21
46	17	24	2019-07-04	2019-07-15
47	17	34	2018-05-23	2018-06-05
48	19	14	2020-07-14	2020-07-15
49	15	45	2019-12-05	2019-12-19
50	6	9	2018-07-25	2018-08-02
51	3	45	2020-07-15	2020-07-22
52	6	31	2019-09-21	2019-09-22
53	2	25	2019-05-05	2019-05-10
54	20	16	2018-11-19	2018-11-29
55	21	46	2020-12-27	2021-01-07
56	21	33	2019-11-08	2019-11-16
57	18	35	2020-12-04	2020-12-17
58	7	9	2018-10-08	2018-10-11
59	16	43	2018-02-14	2018-02-18
60	3	17	2019-02-28	2019-03-06
61	2	50	2020-11-26	2020-12-03
62	3	26	2019-04-12	2019-04-25
63	19	41	2018-06-18	2018-06-21
64	8	45	2020-09-13	2020-09-21
65	1	48	2020-11-17	2020-11-30
66	20	4	2019-01-16	2019-01-24
67	21	45	2018-12-17	2018-12-21
68	21	27	2019-02-13	2019-02-25
69	19	17	2018-09-09	2018-09-20
70	2	48	2019-09-08	2019-09-15
71	9	34	2019-11-05	2019-11-07
72	16	32	2018-04-28	2018-04-30
73	17	1	2018-08-24	2018-08-26
74	11	24	2020-10-08	2020-10-17
75	4	23	2019-07-21	2019-07-30
76	3	1	2020-01-09	2020-01-11
77	4	31	2019-05-06	2019-05-18
78	21	27	2019-05-12	2019-05-15
79	11	25	2019-01-11	2019-01-22
80	21	13	2018-06-06	2018-06-18
81	19	44	2018-08-22	2018-08-26
82	8	13	2019-02-26	2019-03-05
83	4	22	2018-07-03	2018-07-17
84	17	18	2019-04-15	2019-04-21
85	6	39	2018-05-26	2018-05-31
86	8	43	2019-03-13	2019-03-27
87	5	37	2019-05-28	2019-06-10
88	12	32	2018-06-06	2018-06-07
89	16	47	2020-06-07	2020-06-17
90	17	20	2018-10-10	2018-10-17
91	15	47	2019-06-03	2019-06-06
92	12	17	2018-12-13	2018-12-24
93	5	30	2018-08-13	2018-08-15
94	4	31	2020-01-19	2020-01-20
95	5	20	2020-08-26	2020-08-28
96	1	1	2020-06-01	2020-06-09
97	4	20	2018-09-09	2018-09-11
98	15	33	2020-12-08	2020-12-19
99	20	6	2019-07-25	2019-08-08
100	1	11	2018-12-11	2018-12-17
101	\N	21	\N	\N
102	\N	19	\N	\N
103	\N	28	\N	\N
104	\N	42	\N	\N
105	\N	7	\N	\N
106	10	\N	2020-12-24	2020-12-25
107	10	51	2020-12-24	2020-12-26
\.


--
-- Data for Name: tickets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tickets (numero_ticket, usuario_id, id_viaje, fecha_compra, numero_de_asiento, fecha_viaje) FROM stdin;
1	1	1	2020-03-02	752	2020-10-28
2	1	2	2019-11-04	325	2020-02-02
3	2	3	2018-12-23	469	2019-04-22
4	2	4	2019-11-09	16	2020-01-08
5	2	4	2020-01-20	18	2020-02-19
6	2	5	2018-09-04	96	2019-07-01
7	3	6	2020-08-05	613	2021-05-02
8	3	7	2019-01-09	137	2019-04-09
9	3	8	2020-12-19	144	2021-03-19
10	3	5	2018-02-09	141	2018-04-10
11	3	9	2018-05-22	29	2018-11-18
12	4	10	2019-11-08	708	2020-05-06
13	4	11	2018-05-04	335	2018-12-30
14	4	12	2020-12-07	284	2021-09-03
15	4	13	2019-03-11	370	2019-08-08
16	5	14	2020-05-16	75	2020-11-12
17	5	15	2018-06-09	30	2019-02-04
18	5	13	2019-03-24	601	2019-09-20
19	5	16	2019-09-18	517	2020-07-14
20	6	17	2019-02-17	84	2019-04-18
21	6	13	2020-02-27	229	2020-09-24
22	6	18	2019-07-11	555	2019-10-09
23	6	19	2020-02-28	332	2020-10-25
24	7	20	2020-08-12	32	2021-03-10
25	8	21	2020-05-11	7	2020-08-09
26	8	22	2018-12-13	130	2019-06-11
27	8	23	2018-11-05	328	2019-02-03
28	8	24	2020-04-01	81	2020-08-29
29	8	25	2020-12-22	36	2021-09-18
30	9	26	2019-02-04	23	2019-05-05
31	9	17	2018-07-01	154	2019-02-26
32	9	27	2020-07-10	175	2020-08-09
33	9	28	2020-10-08	763	2021-07-05
34	9	1	2018-08-15	535	2018-12-13
35	9	10	2019-02-18	102	2019-12-15
36	10	29	2020-02-10	41	2020-04-10
37	10	5	2018-08-15	32	2019-05-12
38	10	30	2018-11-20	221	2019-05-19
39	11	31	2020-05-20	595	2020-10-17
40	11	16	2018-01-12	125	2018-11-08
41	11	5	2020-05-08	15	2020-06-07
42	11	32	2018-07-09	108	2018-08-08
43	11	33	2018-10-19	66	2019-08-15
44	11	34	2019-04-15	23	2019-08-13
45	12	35	2019-01-26	115	2019-07-25
46	12	36	2020-08-14	21	2021-04-11
47	13	37	2019-09-04	788	2019-12-03
48	13	38	2018-03-12	155	2018-10-08
49	13	39	2019-12-12	40	2020-08-08
50	13	40	2019-07-18	10	2020-01-14
51	13	37	2020-02-27	567	2020-06-26
52	13	41	2018-07-10	153	2019-03-07
53	14	42	2018-05-10	72	2018-11-06
54	15	6	2020-10-16	249	2021-03-15
55	15	22	2020-10-15	503	2021-07-12
56	15	43	2018-03-05	35	2018-10-31
57	16	21	2019-07-22	38	2020-02-17
58	16	44	2020-08-22	648	2020-09-21
59	16	45	2018-05-05	85	2018-12-31
60	16	38	2020-02-10	23	2020-12-06
61	17	1	2019-08-25	31	2020-03-22
62	17	46	2019-12-10	28	2020-07-07
63	18	47	2020-09-25	553	2021-06-22
64	18	29	2020-06-11	33	2020-09-09
65	18	38	2020-09-08	130	2020-10-08
66	18	48	2020-10-16	12	2021-08-12
67	19	14	2019-09-26	451	2020-06-22
68	19	46	2020-10-18	4	2021-06-15
69	19	49	2020-03-18	90	2020-09-14
70	20	23	2018-12-19	465	2019-03-19
71	20	50	2018-10-14	168	2019-01-12
72	20	4	2020-04-02	40	2020-08-30
73	20	28	2019-05-22	325	2019-08-20
74	20	10	2020-10-08	269	2021-05-06
75	20	51	2020-02-14	38	2020-09-11
76	20	43	2020-05-05	42	2020-12-01
77	21	52	2019-03-19	19	2019-12-14
78	21	34	2020-03-19	43	2020-06-17
79	22	37	2019-05-06	570	2019-06-05
80	22	35	2019-06-14	62	2019-07-14
81	23	50	2018-12-22	174	2019-01-21
82	23	53	2018-02-01	5	2018-04-02
83	23	23	2018-12-27	168	2019-08-24
84	23	47	2019-04-11	437	2019-12-07
85	24	54	2018-08-05	26	2019-03-03
86	24	49	2020-02-02	27	2020-10-29
87	24	55	2019-03-01	63	2019-12-26
88	25	56	2020-05-17	303	2020-06-16
89	25	57	2019-10-04	395	2020-01-02
90	25	38	2019-08-28	21	2020-06-23
91	25	58	2020-09-18	123	2021-06-15
92	26	13	2018-06-15	506	2019-04-11
93	26	34	2019-04-23	37	2019-07-22
94	26	45	2019-11-10	33	2020-08-06
95	26	59	2019-12-18	24	2020-01-17
96	26	20	2018-07-04	22	2018-10-02
97	26	60	2019-02-17	7	2019-05-18
98	27	61	2020-08-07	703	2020-12-05
99	27	22	2019-08-24	413	2020-01-21
100	27	37	2019-05-14	71	2019-10-11
101	28	14	2019-02-09	256	2019-04-10
102	28	21	2019-06-22	16	2019-09-20
103	28	62	2019-09-14	381	2019-11-13
104	28	63	2020-09-18	58	2021-04-16
105	29	20	2019-06-11	28	2020-04-06
106	29	40	2018-04-15	43	2019-01-10
107	29	37	2018-03-11	235	2018-11-06
108	29	14	2018-12-25	387	2019-01-24
109	30	55	2019-06-08	64	2020-04-03
110	30	21	2019-05-16	41	2020-03-11
111	30	43	2019-04-06	27	2019-07-05
112	30	51	2020-02-22	22	2020-10-19
113	30	64	2018-03-06	709	2018-12-31
114	31	48	2018-03-25	16	2018-05-24
115	31	65	2020-07-17	33	2020-12-14
116	31	59	2018-09-11	20	2019-05-09
117	31	3	2018-06-25	312	2018-09-23
118	32	25	2019-02-12	34	2019-12-09
119	32	33	2020-04-16	169	2021-01-11
120	32	3	2019-01-22	729	2019-04-22
121	32	66	2018-09-21	30	2019-05-19
122	32	29	2018-09-10	27	2019-06-07
123	33	27	2019-02-28	216	2019-03-30
124	33	1	2018-04-08	288	2018-09-05
125	34	67	2018-06-12	11	2018-12-09
126	34	65	2018-12-01	94	2019-09-27
127	34	52	2020-02-20	352	2020-03-21
128	34	42	2020-03-17	101	2020-04-16
129	35	68	2019-12-10	117	2020-10-05
130	35	64	2019-07-18	369	2019-11-15
131	35	34	2019-01-03	27	2019-08-31
132	36	30	2018-06-10	655	2018-12-07
133	36	22	2020-09-04	673	2021-06-01
134	36	45	2018-05-19	28	2018-07-18
135	37	1	2020-10-12	351	2021-05-10
136	37	36	2019-09-26	38	2019-10-26
137	38	69	2018-12-21	386	2019-10-17
138	38	51	2020-02-25	25	2020-05-25
139	38	45	2019-07-11	195	2020-03-07
140	38	59	2018-01-06	8	2018-07-05
141	38	19	2019-01-01	470	2019-05-31
142	39	70	2018-10-05	39	2019-05-03
143	39	9	2019-12-02	9	2020-04-30
144	40	71	2019-09-13	575	2020-07-09
145	40	9	2018-05-06	13	2018-06-05
146	40	70	2018-04-26	90	2018-06-25
147	40	72	2018-12-13	795	2019-06-11
148	41	39	2018-07-17	512	2018-10-15
149	41	16	2018-01-28	317	2018-04-28
150	41	61	2019-06-08	422	2020-04-03
151	42	55	2019-11-14	643	2020-04-12
152	42	68	2019-09-10	786	2019-11-09
153	42	16	2019-07-06	660	2019-12-03
154	42	19	2020-07-04	244	2020-10-02
155	42	27	2018-01-15	89	2018-06-14
156	42	59	2018-01-22	29	2018-08-20
157	42	54	2019-06-21	41	2019-08-20
158	42	28	2019-01-04	651	2019-07-03
159	42	11	2020-04-12	683	2020-08-10
160	43	47	2020-11-10	165	2021-02-08
161	43	25	2020-07-17	6	2020-10-15
162	43	8	2018-10-23	417	2018-12-22
163	43	68	2019-03-20	36	2019-12-15
164	43	58	2020-09-12	145	2021-05-10
165	44	72	2018-08-24	566	2019-05-21
166	44	50	2019-07-19	44	2020-03-15
167	44	20	2020-04-04	4	2020-06-03
168	44	63	2018-01-18	79	2018-09-15
169	44	69	2018-01-24	12	2018-04-24
170	44	58	2020-10-15	188	2021-04-13
171	44	41	2019-11-25	151	2020-01-24
172	44	73	2020-09-15	775	2021-04-13
173	45	4	2020-03-07	35	2020-08-04
174	45	18	2019-02-05	273	2019-03-07
175	45	74	2020-12-13	158	2021-10-09
176	45	18	2018-03-25	84	2019-01-19
177	46	71	2020-04-28	737	2020-06-27
178	46	19	2019-12-23	278	2020-03-22
179	46	50	2020-06-24	160	2020-10-22
180	46	50	2019-03-19	60	2019-06-17
181	47	34	2019-01-13	13	2019-08-11
182	47	75	2019-07-27	5	2020-04-22
183	47	25	2019-12-21	42	2020-06-18
184	47	26	2019-01-01	17	2019-03-02
185	48	23	2018-04-26	53	2019-01-21
186	48	53	2018-10-21	109	2019-06-18
187	48	34	2018-11-15	12	2019-01-14
188	49	67	2020-03-17	10	2020-08-14
189	49	76	2020-10-04	318	2021-01-02
190	49	3	2020-05-26	385	2021-03-22
191	49	52	2019-08-25	591	2020-05-21
192	49	27	2020-07-23	519	2021-03-20
193	49	50	2018-01-05	99	2018-05-05
194	49	36	2018-11-21	9	2019-01-20
195	50	30	2020-09-27	788	2021-07-24
196	50	64	2020-06-11	147	2021-02-06
197	50	77	2018-10-24	188	2018-12-23
198	50	7	2019-07-23	58	2020-01-19
199	50	18	2020-10-10	794	2020-11-09
200	50	36	2018-07-28	3	2019-03-25
201	\N	78	\N	\N	\N
202	\N	79	\N	\N	\N
203	\N	80	\N	\N	\N
204	\N	81	\N	\N	\N
205	\N	82	\N	\N	\N
206	\N	83	\N	\N	\N
207	\N	84	\N	\N	\N
208	\N	85	\N	\N	\N
209	\N	86	\N	\N	\N
\.


--
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarios (usuario_id, username, nombre, correo, direccion, password) FROM stdin;
1	ChristinaBrown	Christina Brown	Christina.Brown@gmail.com	145 Fisher Plain Port Phillipville, OH 56904	dummypass
2	ChadHolloway	Chad Holloway	Chad.Holloway@gmail.com	075 Samantha Mews Jeremiahberg, MD 35545	dummypass
3	PhillipHall	Phillip Hall	Phillip.Hall@gmail.com	9349 Petersen Meadows Jonesland, WY 40858	dummypass
4	EmilyJackson	Emily Jackson	Emily.Jackson@gmail.com	PSC 0039, Box 7414 APO AE 01858	dummypass
5	MarkDalton	Mark Dalton	Mark.Dalton@gmail.com	876 Gabriel Plaza Port Brandonburgh, DC 44886	dummypass
6	JohnMitchell	John Mitchell	John.Mitchell@gmail.com	7247 April Ville Suite 533 West Christinashire, NM 20136	dummypass
7	NicholasHoward	Nicholas Howard	Nicholas.Howard@gmail.com	970 Patel Fort Callahanland, AZ 29356	dummypass
8	GregoryJones	Gregory Jones	Gregory.Jones@gmail.com	715 John Falls Apt. 167 Alyssashire, KY 79697	dummypass
9	KarenConley	Karen Conley	Karen.Conley@gmail.com	1364 Michael Hill Suite 750 Madisontown, CT 37329	dummypass
10	MatthewRandall	Matthew Randall	Matthew.Randall@gmail.com	639 Theresa Causeway New Kimberly, OH 15747	dummypass
13	SabrinaWang	Sabrina Wang	Sabrina.Wang@gmail.com	2566 Emily Ports Suite 151 Jamesshire, LA 84360	dummypass
11	MatthewWalker	Matthew Walker	Matthew.Walker@gmail.com	9994 Denise Mills Suite 245 Samanthashire, ID 56928	dummypass
12	Mrs.Jennifer	Mrs. Jennifer Herrera	Mrs..Jennifer@gmail.com	789 Cynthia Canyon Suite 606 Robintown, MA 16782	dummypass
14	MeredithLindsey	Meredith Lindsey	Meredith.Lindsey@gmail.com	0125 Pamela Roads Suite 573 Robertview, TN 81130	dummypass
15	VernonGonzales	Vernon Gonzales	Vernon.Gonzales@gmail.com	8703 Amy Pike Garciachester, IA 27013	dummypass
16	JackMyers	Jack Myers	Jack.Myers@gmail.com	3556 Tamara Road Apt. 376 North Maryshire, NC 83844	dummypass
17	VincentLeonard	Vincent Leonard	Vincent.Leonard@gmail.com	08849 Kevin Rapids New Baileytown, WY 45966	dummypass
18	JoshuaHansen	Joshua Hansen	Joshua.Hansen@gmail.com	Unit 9153 Box 5256 DPO AA 17953	dummypass
19	MirandaSchroeder	Miranda Schroeder	Miranda.Schroeder@gmail.com	99833 Jason Unions Suite 828 Gabrielmouth, VT 17200	dummypass
20	JustinGonzalez	Justin Gonzalez	Justin.Gonzalez@gmail.com	6493 Davis Walks Suite 766 New Robert, ME 32152	dummypass
21	MatthewHardy	Matthew Hardy	Matthew.Hardy@gmail.com	7653 Michelle Extensions Apt. 073 New Donald, AZ 84920	dummypass
22	JohnMorrow	John Morrow	John.Morrow@gmail.com	3115 Ronald Radial Suite 453 Carrfort, OK 90593	dummypass
23	CharlesEsparza	Charles Esparza	Charles.Esparza@gmail.com	0680 Adam Key South Chad, HI 15004	dummypass
24	NicholasDunn	Nicholas Dunn	Nicholas.Dunn@gmail.com	61079 Thomas Shore Gardnerton, IN 15710	dummypass
25	MiguelSantiago	Miguel Santiago	Miguel.Santiago@gmail.com	Unit 8487 Box 8033 DPO AE 08178	dummypass
26	BrianDuke	Brian Duke	Brian.Duke@gmail.com	400 Thompson Springs Port Amyland, AR 65691	dummypass
27	MichaelHernandez	Michael Hernandez	Michael.Hernandez@gmail.com	72374 Sandra Haven New Andrewstad, NV 94835	dummypass
28	LoriCampos	Lori Campos	Lori.Campos@gmail.com	429 Angela Pike Apt. 389 Port Wanda, OR 44178	dummypass
29	SheilaHubbard	Sheila Hubbard	Sheila.Hubbard@gmail.com	USNV Reyes FPO AE 86453	dummypass
30	SheilaHolmes	Sheila Holmes	Sheila.Holmes@gmail.com	4518 Johnson Throughway Mayshaven, KS 69102	dummypass
31	CourtneyGarcia	Courtney Garcia DDS	Courtney.Garcia@gmail.com	794 James Freeway Mathewsfurt, MI 18712	dummypass
32	DarrenGray	Darren Gray	Darren.Gray@gmail.com	95058 Powers Island Johnsonside, WA 89838	dummypass
33	Mr.Stanley	Mr. Stanley Davis	Mr..Stanley@gmail.com	47013 Caldwell Parkway Apt. 925 Davidsonmouth, OK 87204	dummypass
34	FrancesHenry	Frances Henry	Frances.Henry@gmail.com	USNS Fitzpatrick FPO AP 74170	dummypass
35	JamesBrooks	James Brooks	James.Brooks@gmail.com	701 Tonya Hills Brittanyport, NJ 91013	dummypass
36	JessicaGraham	Jessica Graham	Jessica.Graham@gmail.com	65431 Harris Plaza Apt. 658 Hillhaven, NV 54338	dummypass
37	ShannonTucker	Shannon Tucker	Shannon.Tucker@gmail.com	2643 Brian Lakes Aguirrebury, CA 70775	dummypass
38	DebraFranklin	Debra Franklin	Debra.Franklin@gmail.com	056 Richard Heights Suite 943 Port Kristibury, SD 75378	dummypass
39	GeorgeStout	George Stout	George.Stout@gmail.com	50663 Stacy Isle Georgefurt, PA 81787	dummypass
40	JasonKemp	Jason Kemp	Jason.Kemp@gmail.com	51005 Timothy Underpass Woodsburgh, VA 21674	dummypass
41	JenniferSmith	Jennifer Smith	Jennifer.Smith@gmail.com	783 Kimberly Court Apt. 695 East Sharon, TN 15847	dummypass
42	MarcoCurtis	Marco Curtis	Marco.Curtis@gmail.com	10221 Paula Highway Suite 342 Garrisonmouth, HI 48762	dummypass
43	DennisRios	Dennis Rios	Dennis.Rios@gmail.com	008 Rowland Plains Jacksonport, NH 34492	dummypass
44	OscarCaldwell	Oscar Caldwell	Oscar.Caldwell@gmail.com	982 Andrew Underpass Suite 779 New Michaelshire, OH 97878	dummypass
45	DavidRandall	David Randall	David.Randall@gmail.com	PSC 0949, Box 2041 APO AA 71725	dummypass
46	SamuelSanders	Samuel Sanders	Samuel.Sanders@gmail.com	6968 Harrison Meadows New Meganland, AL 47398	dummypass
47	EricMarshall	Eric Marshall	Eric.Marshall@gmail.com	7729 Bradford Springs Apt. 296 Christieland, AL 52634	dummypass
48	KennethMiller	Kenneth Miller	Kenneth.Miller@gmail.com	60602 Henderson Fords Apt. 764 North Frankhaven, HI 85863	dummypass
49	AaronEstrada	Aaron Estrada	Aaron.Estrada@gmail.com	48764 Clark Ramp Bradfordmouth, UT 55780	dummypass
50	JuanHicks	Juan Hicks	Juan.Hicks@gmail.com	80203 Walter Estates Suite 342 Port Dana, WA 52677	dummypass
51	junchai	Juan	juan@gmail.com	ras 123123	$2y$10$ENxCmluq3gpxh6sjm3NT4eCRKPSisaMpjO4yOH.7FtgigVGrhSIqO
\.


--
-- Data for Name: viajes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.viajes (id_viaje, id_ciudad_origen, id_ciudad_destino, hora_de_salida, medio, capacidad_maxima, duracion, precio) FROM stdin;
1	1	2	08:54:00	Tren	800	5	35
2	4	3	11:12:00	Tren	800	4	32
3	3	2	23:50:00	Tren	800	3	40
4	5	4	14:45:00	Bus	45	6	20
5	3	6	15:45:00	AviÃ³n	150	2	100
6	3	2	23:23:00	Tren	800	3	40
7	9	6	20:23:00	AviÃ³n	200	3	150
8	3	4	09:56:00	Tren	800	4	32
9	4	3	11:12:00	Bus	45	6	20
10	7	6	23:32:00	Tren	800	1	15
11	8	6	11:22:00	Tren	800	3	47
12	2	1	11:34:00	Tren	800	5	35
13	10	8	10:43:00	Tren	800	3	42
14	3	6	13:42:00	Tren	800	5	45
15	5	4	23:23:00	Bus	45	6	20
16	2	10	21:55:00	Tren	800	3	32
17	9	6	12:34:00	AviÃ³n	200	3	150
18	7	6	09:56:00	Tren	800	1	15
19	4	5	16:12:00	Tren	800	3	32
20	1	2	08:54:00	Bus	45	6	25
21	2	10	21:55:00	Bus	45	6	20
22	10	8	07:12:00	Tren	800	3	42
23	10	2	07:12:00	Tren	800	3	32
24	3	1	21:34:00	AviÃ³n	200	3	120
25	3	4	09:56:00	Bus	45	6	20
26	7	6	09:56:00	Bus	45	1	12
27	3	4	15:34:00	Tren	800	4	32
28	6	3	09:23:00	Tren	800	3	45
29	3	4	15:34:00	Bus	45	6	20
30	6	3	15:21:00	Tren	800	3	45
31	8	10	21:55:00	Tren	800	3	42
32	3	6	23:43:00	AviÃ³n	150	2	100
33	3	1	13:15:00	AviÃ³n	200	3	120
34	10	2	18:56:00	Bus	45	6	20
35	9	6	15:55:00	AviÃ³n	200	3	150
36	7	6	23:32:00	Bus	45	1	12
37	2	3	14:45:00	Tren	800	3	40
38	6	9	18:54:00	AviÃ³n	200	3	150
39	6	3	22:43:00	Tren	800	5	45
40	1	2	13:42:00	Bus	45	6	25
41	1	3	06:17:00	AviÃ³n	200	3	120
42	6	3	22:12:00	AviÃ³n	150	2	100
43	10	2	07:12:00	Bus	45	6	20
44	8	10	23:23:00	Tren	800	3	42
45	1	3	23:56:00	AviÃ³n	200	3	120
46	6	3	12:50:00	AviÃ³n	150	2	100
47	3	6	08:54:00	Tren	800	5	45
48	2	10	10:43:00	Bus	45	6	20
49	5	4	23:23:00	Tren	800	3	32
50	9	6	10:05:00	AviÃ³n	200	3	150
51	6	7	20:42:00	Bus	45	1	12
52	8	10	11:23:00	Tren	800	3	42
53	6	3	08:30:00	AviÃ³n	150	2	100
54	6	7	11:34:00	Bus	45	1	12
55	6	7	20:42:00	Tren	800	1	15
56	6	8	09:56:00	Tren	800	1	47
57	6	8	20:42:00	Tren	800	1	47
58	6	9	22:30:00	AviÃ³n	200	3	150
59	4	3	22:22:00	Bus	45	6	20
60	2	1	11:34:00	Bus	45	6	25
61	1	2	13:42:00	Tren	800	5	35
62	3	2	07:23:00	Tren	800	3	40
63	6	9	09:55:00	AviÃ³n	200	3	150
64	4	3	22:22:00	Tren	800	4	32
65	1	3	14:45:00	AviÃ³n	200	3	120
66	6	3	16:35:00	AviÃ³n	150	2	100
67	4	5	16:12:00	Bus	45	6	20
68	3	6	11:34:00	Tren	800	5	45
69	2	10	10:43:00	Tren	800	3	32
70	3	6	09:30:00	AviÃ³n	150	2	100
71	10	2	18:56:00	Tren	800	3	32
72	5	4	14:45:00	Tren	800	3	32
73	2	3	08:23:00	Tren	800	3	49
74	10	8	18:56:00	Tren	800	3	42
75	4	5	08:23:00	Bus	45	6	20
76	8	6	23:32:00	Tren	800	1	47
77	3	1	07:12:00	AviÃ³n	200	3	120
78	2	1	22:43:00	Bus	45	6	25
79	6	8	11:34:00	Tren	800	1	47
80	6	9	14:25:00	AviÃ³n	200	3	150
81	6	7	11:34:00	Tren	800	1	15
82	2	1	22:43:00	Tren	800	5	35
83	6	9	11:33:00	AviÃ³n	200	3	150
84	2	3	16:12:00	Tren	800	3	40
85	4	5	08:23:00	Tren	800	3	32
86	8	6	09:34:00	Tren	800	3	47
\.


--
-- Name: ciudades ciudades_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ciudades
    ADD CONSTRAINT ciudades_pkey PRIMARY KEY (id_ciudad);


--
-- Name: hoteles hoteles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hoteles
    ADD CONSTRAINT hoteles_pkey PRIMARY KEY (id_hotel);


--
-- Name: paises paises_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paises
    ADD CONSTRAINT paises_pkey PRIMARY KEY (pnombre);


--
-- Name: reservas reservas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservas
    ADD CONSTRAINT reservas_pkey PRIMARY KEY (id_reserva);


--
-- Name: tickets tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_pkey PRIMARY KEY (numero_ticket);


--
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (usuario_id);


--
-- Name: viajes viajes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.viajes
    ADD CONSTRAINT viajes_pkey PRIMARY KEY (id_viaje);


--
-- Name: ciudades ciudades_pnombre_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ciudades
    ADD CONSTRAINT ciudades_pnombre_fkey FOREIGN KEY (pnombre) REFERENCES public.paises(pnombre);


--
-- Name: hoteles hoteles_id_ciudad_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hoteles
    ADD CONSTRAINT hoteles_id_ciudad_fkey FOREIGN KEY (id_ciudad) REFERENCES public.ciudades(id_ciudad);


--
-- Name: reservas reservas_id_hotel_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservas
    ADD CONSTRAINT reservas_id_hotel_fkey FOREIGN KEY (id_hotel) REFERENCES public.hoteles(id_hotel);


--
-- Name: reservas reservas_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservas
    ADD CONSTRAINT reservas_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(usuario_id);


--
-- Name: tickets tickets_id_viaje_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_id_viaje_fkey FOREIGN KEY (id_viaje) REFERENCES public.viajes(id_viaje);


--
-- Name: tickets tickets_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(usuario_id);


--
-- Name: viajes viajes_id_ciudad_destino_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.viajes
    ADD CONSTRAINT viajes_id_ciudad_destino_fkey FOREIGN KEY (id_ciudad_destino) REFERENCES public.ciudades(id_ciudad);


--
-- Name: viajes viajes_id_ciudad_origen_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.viajes
    ADD CONSTRAINT viajes_id_ciudad_origen_fkey FOREIGN KEY (id_ciudad_origen) REFERENCES public.ciudades(id_ciudad);


--
-- PostgreSQL database dump complete
--

