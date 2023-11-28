CREATE TABLE personas (
    id INT PRIMARY KEY,
    nombre VARCHAR(255)
);

ALTER TABLE avistamientos
ADD COLUMN id_reportador INT,
ADD COLUMN fecha_reporte DATETIME,
ADD FOREIGN KEY (id_reportador) REFERENCES personas(id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE movimientos_recursos
ADD COLUMN id_responsable INT,
ADD FOREIGN KEY (id_responsable) REFERENCES personas(id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE muertes
ADD COLUMN id_ejecutor INT,
ADD FOREIGN KEY (id_ejecutor) REFERENCES personas(id) ON DELETE RESTRICT ON UPDATE CASCADE;

-- persona que más titanes mató durante el año 2020
SELECT personas.nombre, COUNT(*) as num_titanes_matados
FROM personas
JOIN muertes ON personas.id = muertes.id_ejecutor
WHERE YEAR(muertes.fecha) = 2020
GROUP BY personas.nombre
ORDER BY num_titanes_matados DESC
LIMIT 1;