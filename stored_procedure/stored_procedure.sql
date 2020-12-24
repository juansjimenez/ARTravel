CREATE OR REPLACE FUNCTION crear_itinerario(aid_seleccionados INT[], ciudad_partida integer, fecha_partida DATE)
RETURNS TABLE (pos0 varchar(200), pos1 varchar(200), pos2 varchar(200), pos3 varchar(200), precio_v1 INT, precio_v2 INT, precio_v3 INT, fecha_v1 TIMESTAMP, fecha_v2 TIMESTAMP, fecha_v3 TIMESTAMP, duracion_v1 INT, duracion_v2 INT, duracion_v3 INT, medio_v1 varchar(40), medio_v2 varchar(40), medio_v3 varchar(40), precio_total INT) AS $$
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
$$ language plpgsql;