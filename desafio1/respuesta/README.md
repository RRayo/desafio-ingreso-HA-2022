# Instrucciones

La versión de PHP utilizada es la PHP 8.3.0

Para ejecutarlo se puede correr con VSCode, teniendo instalando PHP, y ejecutarlo con el modo debug.

El algoritmo lee el archivo `last_year.json` y genera un arreglo con cada uno de los días donde hubo un avistamiento de un titan.
Luego se llama a la función `get_nearest_day` que genera un arreglo contando la frecuencia de cada día y se recorre dicho arrelo para encontrar el día con menor cantidad de titanes, con la restricción que el día no se encuentre en enero o diciembre.

El algoritmo como tal es O(n), ya que primero lee todos los datos en O(n), luego se cuentan las instancias con la función nativa `array_count_values` la cual tambien es O(n) y finalmente se recorre dicho arreglo para obtener el día más próximo con menor cantidad de titanes, sin considerar los meses de enero o diciembre. Esto último es O(m) con m<=n, por lo que está acotado por a O(n). Por lo tanto la solución tendría complejidad de 2O(n) + O(m) <= 3O(n), lo que finalmente se reduce en O(n).

En el caso que los datos no esten estructurados en el formato esperado el algoritmo mostratá un error, y en caso que no se cuente con días en los datos o esten mal estructurados, el algoritmo arrojará INF, ya que no se encontrará un día optimo para salir de la ciudad.
