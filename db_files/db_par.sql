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
-- Name: dblink; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS dblink WITH SCHEMA public;


--
-- Name: EXTENSION dblink; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION dblink IS 'connect to other PostgreSQL databases from within a database';


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

    CREATE TABLE viajes AS SELECT * FROM (SELECT * FROM dblink('dbname=grupo95e3 host=localhost user=postgres password=postgres', 'SELECT * FROM viajes')  AS (id_viaje INT, id_ciudad_origen INT, id_ciudad_destino INT, hora_de_salida time without time zone, medio varchar(200), capacidad_maxima INT, duracion double precision, precio double precision)) AS viajes;

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
-- Name: artistas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.artistas (
    aid integer NOT NULL,
    nombre character varying(255),
    fecha_nacimiento date,
    descripcion character varying(8000),
    url character varying(8000)
);


ALTER TABLE public.artistas OWNER TO postgres;

--
-- Name: artistas_fallecidos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.artistas_fallecidos (
    aid integer,
    fecha_fallecimiento date
);


ALTER TABLE public.artistas_fallecidos OWNER TO postgres;

--
-- Name: ciudad_pais; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ciudad_pais (
    cid integer,
    pid integer
);


ALTER TABLE public.ciudad_pais OWNER TO postgres;

--
-- Name: ciudades; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ciudades (
    cid integer NOT NULL,
    nombre character varying(255)
);


ALTER TABLE public.ciudades OWNER TO postgres;

--
-- Name: entradas_museos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.entradas_museos (
    uid integer,
    lid integer,
    fecha_compra date
);


ALTER TABLE public.entradas_museos OWNER TO postgres;

--
-- Name: esculturas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.esculturas (
    oid integer,
    material character varying(255)
);


ALTER TABLE public.esculturas OWNER TO postgres;

--
-- Name: fotos_lugares; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fotos_lugares (
    lid integer,
    url text
);


ALTER TABLE public.fotos_lugares OWNER TO postgres;

--
-- Name: fotos_obras; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fotos_obras (
    oid integer,
    url text
);


ALTER TABLE public.fotos_obras OWNER TO postgres;

--
-- Name: frescos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.frescos (
    oid integer
);


ALTER TABLE public.frescos OWNER TO postgres;

--
-- Name: hecha_por; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hecha_por (
    aid integer,
    oid integer
);


ALTER TABLE public.hecha_por OWNER TO postgres;

--
-- Name: iglesias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.iglesias (
    lid integer,
    hora_apertura time without time zone,
    hora_cierre time without time zone
);


ALTER TABLE public.iglesias OWNER TO postgres;

--
-- Name: lugar_ciudad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lugar_ciudad (
    lid integer,
    cid integer
);


ALTER TABLE public.lugar_ciudad OWNER TO postgres;

--
-- Name: lugares; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lugares (
    lid integer NOT NULL,
    nombre character varying(255)
);


ALTER TABLE public.lugares OWNER TO postgres;

--
-- Name: museos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.museos (
    lid integer,
    precio_entrada integer,
    hora_apertura time without time zone,
    hora_cierre time without time zone
);


ALTER TABLE public.museos OWNER TO postgres;

--
-- Name: obra_lugar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.obra_lugar (
    oid integer,
    lid integer
);


ALTER TABLE public.obra_lugar OWNER TO postgres;

--
-- Name: obras; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.obras (
    oid integer NOT NULL,
    nombre character varying(255),
    fecha_inicio integer,
    fecha_culminacion integer,
    periodo character varying(255)
);


ALTER TABLE public.obras OWNER TO postgres;

--
-- Name: pais; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pais (
    pid integer NOT NULL,
    nombre character varying(255),
    numero_contacto character varying(255)
);


ALTER TABLE public.pais OWNER TO postgres;

--
-- Name: pinturas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pinturas (
    oid integer,
    tecnica character varying(255)
);


ALTER TABLE public.pinturas OWNER TO postgres;

--
-- Name: plazas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.plazas (
    lid integer
);


ALTER TABLE public.plazas OWNER TO postgres;

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
-- Data for Name: artistas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.artistas (aid, nombre, fecha_nacimiento, descripcion, url) FROM stdin;
1	Gian Lorenzo Bernini	1598-12-07	Fue un escultor, arquitecto y pintor italiano. Trabajó principalmente en Roma y es considerado el más destacado escultor de su generación, creador del estilo escultórico barroco.	https://upload.wikimedia.org/wikipedia/commons/thumb/d/d5/Gian_Lorenzo_Bernini%2C_self-portrait%2C_c1623.jpg/220px-Gian_Lorenzo_Bernini%2C_self-portrait%2C_c1623.jpg
12	Giacomo della Porta	1540-12-07	Fue un escultor y arquitecto italiano que trabajó en muchos edificios importantes en Roma, incluyendo la Basílica de San Pedro de la Ciudad del Vaticano.	https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/San_Pudenziana.040.JPG/220px-San_Pudenziana.040.JPG
2	Jacques-Louis David	1748-08-30	Fue un pintor francés de gran influencia en el estilo neoclásico. Buscó la inspiración en los modelos escultóricos y mitológicos griegos, basándose en su austeridad y severidad, algo que cuadraba con el clima moral de los últimos años del antiguo régimen.	https://historia-arte.com/_/eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpbSI6WyJcL2FydGlzdFwvaW1hZ2VGaWxlXC9kYXZpZC5qcGciLCJyZXNpemVDcm9wLDQwMCw0MDAsQ1JPUF9FTlRST1BZIl19.Q-Kjs95_MDlY2Xeilicfe0U3j5utKoY3xIiZenraKC0.jpg
8	Caravaggio	1571-09-29	Fue un pintor italiano, activo en Roma, Nápoles, Malta y Sicilia. Su pintura combina una observación realista de la figura humana, tanto en lo físico como en lo emocional, con un uso dramático de la luz, lo cual ejerció una influencia decisiva en la formación de la pintura del Barroco.	https://ep01.epimg.net/cultura/imagenes/2018/09/19/actualidad/1537356575_463991_1537356775_noticia_normal_recorte1.jpg
13	Giorgio Vasari	1511-07-30	Fue un arquitecto, pintor y escritor italiano. Considerado uno de los primeros historiadores del arte, es célebre por sus biografías de artistas italianos, colección de datos, anécdotas, leyendas y curiosidades recogidas en su libro Las vidas de los más excelentes pintores, escultores y arquitectos.	https://upload.wikimedia.org/wikipedia/commons/thumb/e/ef/Vasari_autoritratto.jpg/200px-Vasari_autoritratto.jpg
5	Federico Zuccaro	1542-06-27	Fue un pintor, arquitecto y escritor italiano, que trabajó en España. Fue alumno de su hermano Taddeo Zuccaro, a quien ayudó en sus trabajos en el Vaticano y el Palazzo Caprarola. El duque de Toscana Cosimo I le llamó luego a su corte en Florencia para que terminase allí la decoración de la cúpula de Santa María del Fiore, iniciada por Giorgio Vasari.	https://upload.wikimedia.org/wikipedia/commons/thumb/0/0b/Fede_Galizia_-_Portrait_of_Federico_Zuccari_-_WGA8432.jpg/220px-Fede_Galizia_-_Portrait_of_Federico_Zuccari_-_WGA8432.jpg
16	Andrea del Verrocchio	1435-04-15	Fue un pintor, escultor y orfebre cuatrocentista italiano. Trabajó en la corte de Lorenzo de Medici en Florencia. Entre sus alumnos estuvieron Leonardo da Vinci, Perugino, Ghirlandaio y Sandro Botticelli, pero también influyó en Miguel Ángel. Trabajó en el estilo serenamente clásico del primer renacimiento florentino.	https://vignette.wikia.nocookie.net/theassassinscreed/images/6/6a/Andrea-del-verrocchio-1-sized.jpg/revision/latest?cb=20110422234830&path-prefix=es
19	Eugene Delacroix	1798-04-26	Fue un pintor y litógrafo francés. A sus 30 años logra provocar controversia en el público con el cuadro La muerte de Sardanápalo pintado en 1827 y expuesto en el Salón de París. Es un cuadro en el que hace gala de una de sus más espléndidas combinaciones del color.	https://upload.wikimedia.org/wikipedia/commons/thumb/9/9d/Eugene_delacroix.jpg/220px-Eugene_delacroix.jpg
18	Arnolfo di Cambio	1748-08-30	Fue un arquitecto y escultor florentino. Su obra arquitectónica incluye el proyecto de la catedral de Santa María del Fiore, en Florencia (1294), la Basílica de Santa Cruz, en la misma ciudad y la catedral de Orvieto en Italia.	https://upload.wikimedia.org/wikipedia/commons/thumb/3/35/Vite_de_pi%C3%B9_eccellenti_pittori_scultori_ed_architetti_%281767%29_%2814597572560%29.jpg/250px-Vite_de_pi%C3%B9_eccellenti_pittori_scultori_ed_architetti_%281767%29_%2814597572560%29.jpg
4	Floris Geerts	1975-05-17	Es un profesor investigador en la Universidad de Amberes, Bélgica. Antes de eso, ocupó un puesto de investigador senior en el grupo de base de datos en la Universidad de Edimburgo y un puesto postdoctoral en el grupo de minería de datos en la Universidad de Helsinki. Recibió su doctorado en 2001 en la Universidad de Hasselt, Bélgica. Construyó junto a su esposa una inteligencia artificial que hace pitufiesculturas.	https://www.uantwerpen.be/images/uantwerpen/personalpage03868/c593ab0554a0f3100cff508d84bc44c6.jpg
9	Giotto	1267-01-08	Fue un pintor, muralista, escultor y arquitecto florentino de la Baja Edad Media, un autor del Trecento considerado uno de los iniciadores del movimiento renacentista en Italia. Su obra tuvo una influencia determinante en los movimientos pictóricos posteriores. Un contemporáneo de Giotto, el banquero y cronista Giovanni Villani, lo describió como el maestro de pintura más soberano de su tiempo, quien dibujó todas sus figuras y sus posturas de acuerdo con la naturaleza, y reconoció públicamente su talento y excelencia.	https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/15th-century_unknown_painters_-_Five_Famous_Men_%28detail%29_-_WGA23920.jpg/220px-15th-century_unknown_painters_-_Five_Famous_Men_%28detail%29_-_WGA23920.jpg
15	Donatello	1386-12-13	Fue un artista y escultor italiano de principios del Renacimiento, uno de los padres del periodo junto con Leon Battista Alberti, Brunelleschi y Masaccio. Donatello se convirtió en una fuerza innovadora en el campo de la escultura monumental y en el tratamiento de los relieves, donde logró representar una gran profundidad dentro de un mínimo plano, denominándose con el nombre de stiacciato, es decir relieve aplanado o aplastado.	https://www.biografiasyvidas.com/biografia/d/fotos/donatello.jpg
14	Andrea Mantegna	1431-09-13	Fue un pintor del Quattrocento italiano. Andrea construyó y pintó para su uso personal una hermosa casa en Mantua, en la cual residió toda su vida. Los últimos años de Andrea Mantegna en la Corte de Mantua los pasó bajo la protección de Isabel de Este, unánimemente reconocida como una de las damas humanistas más ilustradas del Renacimiento Italiano que se rodeó en su pequeño estudio del Castillo de San Jorge de una importante corte de artistas y pintores del momento.	https://www.arteespana.com/imagenes/mantegna-francescogonzaga.jpg
3	Sandro Botticelli	1451-03-01	Fue un pintor del Quattrocento italiano. Pertenece, a su vez, a la tercera generación cuatrocentista, encabezada por Lorenzo de Médici el Magnífico y Angelo Poliziano	https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/Sandro_Botticelli_083.jpg/220px-Sandro_Botticelli_083.jpg
10	Kristin Geerts	1976-08-21	Es una doctora en bioquímica de la Universidad de Leuven, Bélgica. Es una experta cocinera, que hace el mejor Humus en toda Europa. Justo a su esposo Floris, construyó una inteligencia artificial que hace pitufiesculturas.	https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png
17	Raffaello Sanzio	1483-04-06	Fue un pintor y arquitecto italiano del Renacimiento. Además de su labor pictórica, que sería admirada e imitada durante siglos, realizó importantes aportes en la arquitectura y, como inspector de antigüedades, se interesó en el estudio y conservación de los vestigios grecorromanos.	https://www.buscabiografias.com/img/people/Rafael_Sanzio.jpg
11	Leonardo da Vinci	1452-04-15	Fue un polímata florentino del Renacimiento italiano. Fue a la vez pintor, anatomista, arquitecto, paleontólogo, artista, botánico, científico, escritor, escultor, filósofo, ingeniero, inventor, músico, poeta y urbanista. Sus primeros trabajos de importancia fueron creados en Milán al servicio del duque Ludovico Sforza. Trabajó a continuación en Roma, Bolonia y Venecia, y pasó sus últimos años en Francia, por invitación del rey Francisco I.	https://e00-elmundo.uecdn.es/assets/multimedia/imagenes/2018/11/28/15434346653973.jpg
6	Jerome Duquesnoy	1570-04-28	Fue un escultor flamenco que jugó un papel importante en el renacimiento artístico en el sur de los Países Bajos tras los disturbios religiosos e iconoclastas del siglo XVI. Fuentes documentales muestran que estaba ocupado y encargado de encargos escultóricos para todas las iglesias principales, así como para los edificios del gobierno. Nada de esto ha sobrevivido.	https://upload.wikimedia.org/wikipedia/commons/thumb/7/72/Duquesnoy1776.jpg/220px-Duquesnoy1776.jpg
7	Michelangelo Buonarroti	1475-03-06	Fue un arquitecto, escultor y pintor italiano renacentista, considerado uno de los más grandes artistas de la historia tanto por sus esculturas como por sus pinturas y obra arquitectónica. Desarrolló su labor artística a lo largo de más de setenta años entre Florencia y Roma, que era donde vivían sus grandes mecenas, la familia Médici de Florencia y los diferentes papas romanos.	https://mymodernmet.com/wp/wp-content/uploads/2019/04/michelangelo-facts-7.jpg
\.


--
-- Data for Name: artistas_fallecidos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.artistas_fallecidos (aid, fecha_fallecimiento) FROM stdin;
1	1680-11-28
2	1825-12-29
3	1510-05-07
5	1609-06-27
6	1641-04-26
7	1564-02-18
8	1610-07-18
9	1337-01-08
11	1519-05-02
12	1602-12-07
13	1574-06-27
14	1506-09-13
15	1466-12-13
16	1488-05-02
17	1520-04-06
18	1825-12-29
19	1863-08-13
\.


--
-- Data for Name: ciudad_pais; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ciudad_pais (cid, pid) FROM stdin;
1	4
2	3
3	4
4	2
5	1
6	2
7	4
8	1
9	5
10	2
\.


--
-- Data for Name: ciudades; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ciudades (cid, nombre) FROM stdin;
1	Florencia
2	Westminster
3	Roma
4	Nancy
5	Antwerp
6	Chantilly
7	Milán
8	Bruselas
9	Dresde
10	París
\.


--
-- Data for Name: entradas_museos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.entradas_museos (uid, lid, fecha_compra) FROM stdin;
\.


--
-- Data for Name: esculturas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.esculturas (oid, material) FROM stdin;
1	Mármol
2	Mármol
4	Flores [] (arreglos florales)
12	Madera
17	Mármol blanco
18	Bronce
20	Mármol
22	Mármol
23	Mármol
26	Bronce
27	Mármol
31	Mármol
37	Mármol
38	Mármol blanco
\.


--
-- Data for Name: fotos_lugares; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fotos_lugares (lid, url) FROM stdin;
1	https://pm1.narvii.com/6798/e74b9b3dc6a00154c73f9054ec662718a963e77cv2_hq.jpg
2	https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/Basilica_di_San_Pietro_in_Vaticano_September_2015-1a.jpg/1200px-Basilica_di_San_Pietro_in_Vaticano_September_2015-1a.jpg
3	https://upload.wikimedia.org/wikipedia/commons/thumb/7/76/Chateau_de_Chantilly_garden.jpg/1200px-Chateau_de_Chantilly_garden.jpg
4	https://upload.wikimedia.org/wikipedia/commons/2/24/Dresden-Zwinger-Courtyard.11.JPG
5	https://www.inexhibit.com/wp-content/uploads/2014/06/Royal-Academy-of-Arts-London-facade-870x495.jpg
6	https://upload.wikimedia.org/wikipedia/commons/6/65/Nancy_Musee_des_Beaux-Arts_BW_2015-07-18_13-55-20.jpg
7	https://guiadeviaje.info/wp-content/uploads/2020/05/piazza-navona.jpg
8	https://upload.wikimedia.org/wikipedia/commons/c/c0/Roma%2C_Piazza_della_Minerva.jpg
9	https://cdn.getyourguide.com/img/location_img-30161-1488472696-148.jpg
10	https://www.experienciasviajeras.blog/wp-content/uploads/2019/05/Museo-Vaticanos-alta.jpg
11	https://civitavecchia.portmobility.it/sites/default/files/basilica_di_santa_maria_del_popolo_a_roma.jpg
12	https://i.ytimg.com/vi/vXtXAT5WIGg/hqdefault.jpg
13	https://i1.wp.com/thehappening.com/wp-content/uploads/2019/11/museo-louvre.jpg?fit=1024%2C694&ssl=1
14	https://fotos00.lne.es/mmp/2020/02/18/690x278/capilla-sixtina2.jpg
15	https://abruselas.com/wp-content/uploads/2017/10/museo-ciudad-bruselas.jpeg
16	https://creciendoentreflores.files.wordpress.com/2016/04/plaza-espac3b1a-otra.jpg
17	https://www.enmilan.net/wp-content/uploads/2019/01/cenacolo-vinciano.jpeg
18	https://www.laguiadeflorencia.com/wp-content/uploads/2017/12/museo-opera-duomo.jpg
19	https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/Santa_Maria_della_Vittoria_in_Rome_-_Front.jpg/1200px-Santa_Maria_della_Vittoria_in_Rome_-_Front.jpg
20	https://4.bp.blogspot.com/-kbzK5OTuyYo/WDXUOITTDwI/AAAAAAAAIpg/UUGKCRNsQYUJmMGJiNxFFZhwZfmeujQbwCLcB/s1600/Galeria%2Bde%2Blos%2BUffizi.jpg
21	https://media.wsimag.com/attachments/1cb8a878c95d020af08f80403e9ee39d7035ebce/store/fill/1090/613/997a8d353cf25305ba41861b758258dc2e0a65cbcc2753a1017479ba8c16/Catedral-de-Santa-Maria-del-Fiore-Florencia.jpg
22	https://red-viajes.com/wp-content/uploads/2019/08/galeria-borghese-una-guia-completamuseo-de-arte-galleria-borghese-en-roma.jpg
\.


--
-- Data for Name: fotos_obras; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fotos_obras (oid, url) FROM stdin;
1	https://upload.wikimedia.org/wikipedia/commons/1/14/Pulcin_della_Minerva_2006_n2.jpg
2	https://www.romaincamper.it/foto/data/images1/piazzapopolo3.jpg
3	https://i.pinimg.com/originals/15/a6/d2/15a6d2763e2b7df7a1ad42595eb7a6c8.jpg
5	https://de10.com.mx/sites/default/files/styles/detalle_nota/public/2019/11/13/juicio_final_miguel_angel_capilla_sixtina_p.jpg?itok=c3womWhp
6	https://image.posta.com.mx/sites/default/files/57bee01ec461888a0d8b4567-1.jpg
7	https://www.primeroscristianos.com/wp-content/uploads/2017/08/transfiguraci%C3%B3n.jpg
8	https://upload.wikimedia.org/wikipedia/commons/8/88/Polittico_di_Badia.jpg
9	https://content3.cdnprado.net/imagenes/Documentos/imgsem/7a/7ac9/7ac9dfc6-9032-4259-8d3b-a72de09a7d88/9d054f83-29c5-42a5-8448-f15d47b04396.jpg
10	https://upload.wikimedia.org/wikipedia/commons/thumb/7/7a/RAFAEL_-_Madonna_Sixtina_%28Gem%C3%A4ldegalerie_Alter_Meister%2C_Dresden%2C_1513-14._%C3%93leo_sobre_lienzo%2C_265_x_196_cm%29.jpg/1200px-RAFAEL_-_Madonna_Sixtina_%28Gem%C3%A4ldegalerie_Alter_Meister%2C_Dresden%2C_1513-14._%C3%93leo_sobre_lienzo%2C_265_x_196_cm%29.jpg
11	https://www.artehistoria.com/sites/default/files/imagenobra/GIA15306.jpg
12	https://pbs.twimg.com/media/DyLwjJVWsAUv1ye.jpg
13	https://upload.wikimedia.org/wikipedia/commons/thumb/4/4c/Sandro_Botticelli_054.jpg/250px-Sandro_Botticelli_054.jpg
14	https://i.pinimg.com/originals/1d/92/01/1d920158654c4c03d46f3ddd3464b8f0.jpg
15	https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/The_Last_Supper_-_Leonardo_Da_Vinci_-_High_Resolution_32x16.jpg/1200px-The_Last_Supper_-_Leonardo_Da_Vinci_-_High_Resolution_32x16.jpg
16	https://img.culturacolectiva.com/cdn-cgi/image/f=auto,w=1600,q=80,fit=contain/content_image/2019/4/26/1556307357530-delacroix%20la%20libertad%20guiando%20al%20pueblo.jpg
17	https://upload.wikimedia.org/wikipedia/commons/7/76/Lazio_Roma_Navona2_tango7174.jpg
18	https://upload.wikimedia.org/wikipedia/commons/8/8c/Rome_basilica_st_peter_011c.jpg
19	https://www.ngenespanol.com/wp-content/uploads/2018/09/labios-mona-lisa-2.png
20	https://2.bp.blogspot.com/-6tM5jIVOl_M/XAqZyxo_VzI/AAAAAAAAG2Y/nvUIZZnzqgMI5ciuxOEOeQWBpjHMHOh_ACLcBGAs/s1600/0.jpg
21	https://www.artflakes.com/artwork/products/136725/zoom/136725.jpg
22	https://i.pinimg.com/originals/9a/44/d7/9a44d7d3acfae5edb6cbc9a9ebc4ab3a.jpg
23	https://historia-arte.com/_/eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpbSI6WyJcL2FydHdvcmtcL2ltYWdlRmlsZVwvcGllZGFkLW1pZ3VlbC1hbmdlbC5qcGciLCJyZXNpemUsODAwIl19.FXiDxaXfKT3r80TZQ6cXu5615umFEHikZAAXlW2804I.jpg
25	https://historia-arte.com/_/eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpbSI6WyJcL2FydHdvcmtcL2ltYWdlRmlsZVwvNWRiN2ZhMWY4MjZlOS5qcGciLCJyZXNpemUsODAwIl19.zM1ycflDHWRcxIMZBRf_GGrNBlBsUSTVJOT-qWbuaHw.jpg
26	https://abruselas.com/wp-content/uploads/2017/10/manneken-pis.jpeg
27	https://cdn.culturagenial.com/es/imagenes/final-ayd-fondo-negro-cke.jpg
28	https://historia-arte.com/_/eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpbSI6WyJcL2FydHdvcmtcL2ltYWdlRmlsZVwvY3J1Y2lmaXhpb24tcy1wZWRyby1jYXJhdmFnZ2lvLmpwZyIsInJlc2l6ZUNyb3AsNjAwLDMwMCw1MCUsNjAlIl19.co9VgKTB6gF5pQKWmtRbtrkTBJQZE2y4Dm/KYpkUiWtc.jpg
29	https://painting-planet.com/images2/la-anunciacion-leonardo-da-vinci_1.jpg
30	https://lasestanciasderafael.es/wp-content/uploads/2018/12/cropped-rafael_la-escuela-de-atenas-1-2000x1200.jpg
31	https://dam.ngenespanol.com/wp-content/uploads/2018/12/el-moises-de-miguel-angel.png
32	https://3minutosdearte.com/wp-content/uploads/2018/06/Caravaggio-Cabeza-de-Medusa-1597-e1536759112183.jpg
33	https://upload.wikimedia.org/wikipedia/commons/6/6c/Caravaggio_-_The_Annunciation.JPG
35	https://upload.wikimedia.org/wikipedia/commons/thumb/0/0b/Sandro_Botticelli_-_La_nascita_di_Venere_-_Google_Art_Project_-_edited.jpg/1200px-Sandro_Botticelli_-_La_nascita_di_Venere_-_Google_Art_Project_-_edited.jpg
36	https://upload.wikimedia.org/wikipedia/commons/e/e1/Michelangelo_Caravaggio_052.jpg
37	https://live.staticflickr.com/4461/37464634956_407f2244a9_b.jpg
38	https://historia-arte.com/_/eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpbSI6WyJcL2FydHdvcmtcL2ltYWdlRmlsZVwvZGF2aWQtYnktbWljaGVsYW5nZWxvLWpidTAzLmpwZyIsInJlc2l6ZSw4MDAiXX0.RoW8t6LYw_gFe9r0M16vK7HNQYSGGxxoSinRoisDI1c.jpg
39	https://upload.wikimedia.org/wikipedia/commons/thumb/f/fe/Rapha%C3%ABl_-_Les_Trois_Gr%C3%A2ces_-_Google_Art_Project_2.jpg/1200px-Rapha%C3%ABl_-_Les_Trois_Gr%C3%A2ces_-_Google_Art_Project_2.jpg
\.


--
-- Data for Name: frescos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.frescos (oid) FROM stdin;
5
6
11
14
15
24
30
34
\.


--
-- Data for Name: hecha_por; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hecha_por (aid, oid) FROM stdin;
1	1
12	2
9	3
10	4
4	4
13	5
5	5
7	6
17	7
9	8
11	9
16	9
17	10
9	11
15	12
14	13
7	14
11	15
19	16
1	17
18	18
11	19
1	20
2	21
8	22
7	23
1	24
3	25
6	26
1	27
8	28
11	29
16	29
17	30
7	31
8	32
8	33
4	34
3	35
8	36
1	37
7	38
17	39
\.


--
-- Data for Name: iglesias; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.iglesias (lid, hora_apertura, hora_cierre) FROM stdin;
2	07:00:00	19:00:00
11	09:00:00	18:30:00
12	07:00:00	12:00:00
14	09:00:00	16:00:00
17	07:00:00	19:30:00
19	07:00:00	19:30:00
21	08:00:00	19:00:00
\.


--
-- Data for Name: lugar_ciudad; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lugar_ciudad (lid, cid) FROM stdin;
1	1
2	3
3	6
4	9
5	2
6	4
7	3
8	3
9	3
10	3
11	3
12	3
13	10
14	3
15	8
16	5
17	7
18	1
19	3
20	1
21	1
22	3
\.


--
-- Data for Name: lugares; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lugares (lid, nombre) FROM stdin;
1	Galería de la Academia
2	La basílica de San Pedro
3	Museo Condé
4	Galería de Pinturas de los Maestros Antiguos
5	Royal Academy of Arts
6	El Museo de Bellas Artes de Nancy
7	Piazza Navona
8	Piazza della Minerva
9	Piazza San Pietro
10	Museos Vaticanos
11	Basílica de Santa María del Popolo
12	San Pietro in Vincoli
13	Museo del Louvre
14	Capilla Sixtina
15	Museo de la ciudad de Bruselas
16	Piazza di Floros
17	Santa Maria delle Grazie
18	Museo de la Ópera del duomo
19	Iglesia de Santa María de la Victoria
20	Galería Uffizi
21	Santa María del Fiore
22	Galería Borghese
\.


--
-- Data for Name: museos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.museos (lid, precio_entrada, hora_apertura, hora_cierre) FROM stdin;
1	6	09:00:00	16:00:00
3	40	10:00:00	18:00:00
4	20	10:00:00	18:00:00
5	30	10:00:00	18:00:00
6	30	10:00:00	18:00:00
10	17	09:00:00	16:00:00
13	20	09:00:00	18:00:00
15	10	10:00:00	17:00:00
18	15	10:00:00	18:00:00
20	12	10:00:00	18:00:00
22	15	09:00:00	16:00:00
\.


--
-- Data for Name: obra_lugar; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.obra_lugar (oid, lid) FROM stdin;
1	8
2	7
3	20
4	16
5	21
6	14
7	10
8	20
9	20
10	4
11	13
12	18
13	13
14	14
15	17
16	13
17	7
18	2
19	13
20	19
21	13
22	5
23	2
24	13
25	20
26	15
27	22
28	11
29	20
30	10
31	12
32	20
33	6
34	13
35	20
36	10
37	9
38	1
39	3
\.


--
-- Data for Name: obras; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.obras (oid, nombre, fecha_inicio, fecha_culminacion, periodo) FROM stdin;
1	Pulcin della Minerva	1666	1667	Barroco
2	La Fuente de Neptuno	1573	1574	Renacimiento
3	Maesta di Ognissanti	1309	1310	Gótico
4	Pitufiescultura	2018	2019	Neoclasicismo Romano de mediados del siglo XVII 1/2
5	El juicio Final	1541	1563	Renacimiento
6	La creación de Adán	1500	1511	Renacimiento
7	La transfiguración	1517	1520	Renacimiento
8	Polittico di Badia	1299	1300	Gótico
9	Bautismo de Cristo	1472	1475	Renacimiento
10	Madonna Sixtina	1513	1514	Renacimiento
11	La anunciación	1300	1304	Gótico
12	María Magdalena Penitente	1453	1455	Renacimiento
13	San Sebastián	1479	1480	Renacimiento
14	El Juicio Final	1537	1541	Renacimiento
15	La última cena	1495	1498	Renacimiento
16	La Libertad guiando al pueblo	1829	1830	Romanticismo
17	La Fuente de los Cuatro Ríos	1648	1651	Barroco
18	La Estatua de San Pedro	1300	1305	Gótico
19	La Mona Lisa	1503	1519	Renacimiento
20	Éxtasis de Santa Teresa	1645	1652	Barroco
21	La consagración de Napoleón	1805	1807	Neoclasicismo
22	Tondo Taddei	1504	1506	Renacimiento
23	La Piedad	1498	1499	Renacimiento
24	La anunciación	1618	1619	Barroco
25	La primavera	1477	1478	Renacimiento
26	Manneken Pis	1618	1619	Barroco
27	Apolo y Dafne	1622	1625	Barroco
28	Crucifixión de San Pedro	1600	1601	Barroco
29	La Anunciación	1472	1475	Renacimiento
30	Estancias de Rafael	1508	1524	Renacimiento
31	El Moisés	1513	1515	Renacimiento
32	La cabeza de Medusa	1596	1597	Barroco
33	La Anunciación	1607	1608	Barroco
34	PitufiFresco	2019	2020	Neoclasicismo Romano de mediados del siglo XVII 1/2
35	El nacimiento de Venus	1482	1485	Renacimiento
36	El Santo Entierro	1602	1604	Barroco
37	Santos Piazza San Pietro	1656	1667	Barroco
38	El David	1501	1504	Renacimiento
39	Las Gracias	1504	1505	Renacimiento
\.


--
-- Data for Name: pais; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pais (pid, nombre, numero_contacto) FROM stdin;
1	Bélgica	758-382-381
2	Francia	133-154-268
3	Inglaterra	129-666-539
4	Italia	433-666-975
5	Alemania	199-786-913
\.


--
-- Data for Name: pinturas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pinturas (oid, tecnica) FROM stdin;
3	Panel
7	Temple y óleo sobre madera
8	Tempera sobre panel
9	Óleo sobre tabla
10	Óleo sobre lienzo
13	Óleo sobre lienzo
16	Óleo sobre lienzo
19	Pintura al óleo sobre tabla de álamo
21	Óleo sobre lienzo
25	Temple sobre tabla
28	Óleo sobre lienzo
29	Óleo y temple sobre tabla
32	Óleo sobre lienzo
33	Pintura al Óleo
35	Temple sobre lienzo
36	Óleo sobre lienzo
39	Óleo sobre tabla
\.


--
-- Data for Name: plazas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.plazas (lid) FROM stdin;
7
8
9
16
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
51	junchai	Juan	juan@gmail.com	ras 123123	$2y$10$r8lrOVMer.cocBbqB30RaehbGW4tuN8gxRt0AU5MSUcgksVwD6Zku
\.


--
-- Name: artistas artistas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artistas
    ADD CONSTRAINT artistas_pkey PRIMARY KEY (aid);


--
-- Name: ciudades ciudades_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ciudades
    ADD CONSTRAINT ciudades_pkey PRIMARY KEY (cid);


--
-- Name: lugares lugares_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lugares
    ADD CONSTRAINT lugares_pkey PRIMARY KEY (lid);


--
-- Name: obras obras_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.obras
    ADD CONSTRAINT obras_pkey PRIMARY KEY (oid);


--
-- Name: pais pais_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pais
    ADD CONSTRAINT pais_pkey PRIMARY KEY (pid);


--
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (usuario_id);


--
-- Name: artistas_fallecidos artistas_fallecidos_aid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artistas_fallecidos
    ADD CONSTRAINT artistas_fallecidos_aid_fkey FOREIGN KEY (aid) REFERENCES public.artistas(aid);


--
-- Name: ciudad_pais ciudad_pais_cid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ciudad_pais
    ADD CONSTRAINT ciudad_pais_cid_fkey FOREIGN KEY (cid) REFERENCES public.ciudades(cid);


--
-- Name: ciudad_pais ciudad_pais_pid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ciudad_pais
    ADD CONSTRAINT ciudad_pais_pid_fkey FOREIGN KEY (pid) REFERENCES public.pais(pid);


--
-- Name: entradas_museos entradas_museos_lid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entradas_museos
    ADD CONSTRAINT entradas_museos_lid_fkey FOREIGN KEY (lid) REFERENCES public.lugares(lid);


--
-- Name: entradas_museos entradas_museos_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entradas_museos
    ADD CONSTRAINT entradas_museos_uid_fkey FOREIGN KEY (uid) REFERENCES public.usuarios(usuario_id);


--
-- Name: esculturas esculturas_oid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.esculturas
    ADD CONSTRAINT esculturas_oid_fkey FOREIGN KEY (oid) REFERENCES public.obras(oid);


--
-- Name: fotos_lugares fotos_lugares_lid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fotos_lugares
    ADD CONSTRAINT fotos_lugares_lid_fkey FOREIGN KEY (lid) REFERENCES public.lugares(lid);


--
-- Name: fotos_obras fotos_obras_oid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fotos_obras
    ADD CONSTRAINT fotos_obras_oid_fkey FOREIGN KEY (oid) REFERENCES public.obras(oid);


--
-- Name: frescos frescos_oid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.frescos
    ADD CONSTRAINT frescos_oid_fkey FOREIGN KEY (oid) REFERENCES public.obras(oid);


--
-- Name: hecha_por hecha_por_aid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hecha_por
    ADD CONSTRAINT hecha_por_aid_fkey FOREIGN KEY (aid) REFERENCES public.artistas(aid);


--
-- Name: hecha_por hecha_por_oid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hecha_por
    ADD CONSTRAINT hecha_por_oid_fkey FOREIGN KEY (oid) REFERENCES public.obras(oid);


--
-- Name: iglesias iglesias_lid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.iglesias
    ADD CONSTRAINT iglesias_lid_fkey FOREIGN KEY (lid) REFERENCES public.lugares(lid);


--
-- Name: lugar_ciudad lugar_ciudad_cid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lugar_ciudad
    ADD CONSTRAINT lugar_ciudad_cid_fkey FOREIGN KEY (cid) REFERENCES public.ciudades(cid);


--
-- Name: lugar_ciudad lugar_ciudad_lid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lugar_ciudad
    ADD CONSTRAINT lugar_ciudad_lid_fkey FOREIGN KEY (lid) REFERENCES public.lugares(lid);


--
-- Name: museos museos_lid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.museos
    ADD CONSTRAINT museos_lid_fkey FOREIGN KEY (lid) REFERENCES public.lugares(lid);


--
-- Name: obra_lugar obra_lugar_lid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.obra_lugar
    ADD CONSTRAINT obra_lugar_lid_fkey FOREIGN KEY (lid) REFERENCES public.lugares(lid);


--
-- Name: obra_lugar obra_lugar_oid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.obra_lugar
    ADD CONSTRAINT obra_lugar_oid_fkey FOREIGN KEY (oid) REFERENCES public.obras(oid);


--
-- Name: pinturas pinturas_oid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pinturas
    ADD CONSTRAINT pinturas_oid_fkey FOREIGN KEY (oid) REFERENCES public.obras(oid);


--
-- Name: plazas plazas_lid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plazas
    ADD CONSTRAINT plazas_lid_fkey FOREIGN KEY (lid) REFERENCES public.lugares(lid);


--
-- PostgreSQL database dump complete
--

