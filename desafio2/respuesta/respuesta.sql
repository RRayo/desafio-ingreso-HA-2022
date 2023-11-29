-- Nombre, altura, y fecha de muerte de todos los titanes que hayan muerto por “Accidente”, ordenados cronológicamente.
SELECT titanes.nombre, titanes.altura, muertes.fecha
FROM titanes
JOIN muertes ON titanes.id = muertes.id_titan
WHERE muertes.causa = 'Accidente';


-- Nombre y altura del titán más alto que haya matado el “Batallón 1”.
SELECT titanes.nombre, titanes.altura
FROM titanes
JOIN muertes ON titanes.id = muertes.id_titan
WHERE muertes.causa = 'Batallón 1'
ORDER BY titanes.altura DESC
LIMIT 1;
-- comparacion entre subquery y join:
-- join
-- id	select_type	table	partitions	type	possible_keys	key	key_len	ref	rows	filtered	Extra
-- 1	SIMPLE	muertes	NULL	ALL	muertes_id_titan	NULL	NULL	NULL	66	10.00	Using where; Using temporary; Using filesort
-- 1	SIMPLE	titanes	NULL	eq_ref	PRIMARY	PRIMARY	4	sandbox_db.muertes.id_titan	1	100.00	NULL
-- subquery
-- id	select_type	table	partitions	type	possible_keys	key	key_len	ref	rows	filtered	Extra
-- 1	PRIMARY	titanes	NULL	ALL	NULL	NULL	NULL	NULL	1152	100.00	Using where
-- 2	DEPENDENT SUBQUERY	muertes	NULL	ALL	NULL	NULL	NULL	NULL	66	10.00	Using where; Using temporary; Using filesort
-- con esto podemos ver que el join es más eficiente que el subquery, ya que el subquery es un dependant subquery, lo que significa que se ejecuta por cada fila del query principal, mientras que el join se ejecuta una sola vez y luego se filtra
-- dependiendo de los indices los JOIN pueden ser más optimizados agregando indices


-- Nombre y altura de titanes que no se han podido matar aún, junto con su último avistamiento (más reciente), ordenados por altura incrementalmente.
SELECT titanes.nombre, titanes.altura, MAX(avistamientos.fecha) as ultimo_avistamiento
FROM titanes
JOIN avistamientos ON titanes.id = avistamientos.id_titan
WHERE titanes.id NOT IN (
    SELECT id_titan FROM muertes
)
GROUP BY titanes.id, titanes.nombre, titanes.altura
ORDER BY titanes.altura ASC;

-- Lista de titanes que hayan sido vistos más de una vez el mismo año, ordenados por nombre incrementalmente.
SELECT titanes.nombre, YEAR(avistamientos.fecha) as year
FROM titanes
JOIN avistamientos ON titanes.id = avistamientos.id_titan
GROUP BY titanes.nombre, YEAR(avistamientos.fecha)
HAVING COUNT(avistamientos.id) > 1
ORDER BY titanes.nombre ASC;

-- Lista de recursos que se han usado (recurso, cantidad, unidad) en matar titanes pequeños (<= 5 metros), agrupados por recurso y ordenados por cantidad.

SELECT recursos.nombre, SUM(movimientos_recursos.cantidad) as cantidad, recursos.unidad
FROM recursos
JOIN movimientos_recursos ON recursos.id = movimientos_recursos.id_recurso
JOIN muertes ON movimientos_recursos.id_muerte = muertes.id
JOIN titanes ON muertes.id_titan = titanes.id
WHERE titanes.altura <= 5
GROUP BY recursos.nombre, recursos.unidad
ORDER BY cantidad DESC;


-- Recurso que se utiliza más comúnmente para matar titanes de 9 metros, ordenado por cantidad de usos descendiente.
SELECT recursos.nombre, SUM(movimientos_recursos.cantidad) as cantidad, recursos.unidad
FROM recursos
JOIN movimientos_recursos ON recursos.id = movimientos_recursos.id_recurso
JOIN muertes ON movimientos_recursos.id_muerte = muertes.id
JOIN titanes ON muertes.id_titan = titanes.id
WHERE titanes.altura = 9
GROUP BY recursos.nombre, recursos.unidad
ORDER BY cantidad DESC;

-- Lista de titanes con incongruencias en torno a sus fechas de muerte y avistamientos, ordenados por su identificador, incrementalmente.
SELECT titanes.id, titanes.nombre, muertes.fecha as fecha_muerte, avistamientos.fecha as fecha_avistamiento
FROM titanes
JOIN muertes ON titanes.id = muertes.id_titan
JOIN avistamientos ON titanes.id = avistamientos.id_titan
WHERE muertes.fecha < avistamientos.fecha
ORDER BY titanes.id ASC;

-- Extra: teoriza (no más de 1 párrafo) por qué podrían generarse estas incongruencias
-- Puede ser por errores en el ingreso de datos, por ejemplo si se duplicaron erroneamente las entradas.
-- Tambien puede ser por ingresos de datos en el orden incorrecto, por ejemplo si se ingresaron primero los avistamientos y luego las muertes, o viceversa y quedaron con la fecha de creación de la fila.
-- Por otro lado puede que los datos no sean muy fidelignos, pudiendo haber confudido a los titanes


