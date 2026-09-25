## Alcance y Arquitectura (Monolito / Offline)
- Se espera que la app sea standalone para que funcione por si sola.
- Respuestas Flutter / SQLite CrossPlatform.


## Requerimientos Funcionales (Tablero / Movimientos)
- Se espera que la app use funcionalidades del dispositivo, como vibración para dar un feedback a los errores del usuario.
- La aplicación permite al jugador ver una lista con los mejores puntajes alcanzados.
- El sistema debe poder guardar los puntajes o el mejor puntaje alcanzados por el jugador.
- El sistema debe tener la capacidad de guardar el estado del tablero en caso de que el usuario salga de la aplicación.
- El tablero debe ofrecer una retroalimentación visual cuando una de sus fichas disponibles sea seleccionada.


## Restricciones Técnicas / RNF (Hardware / Persistencia)
- La aplicación no debe tardar mas de 0.5 segundos en cargar su tablero inicial.
- La aplicacion debe funcionar en cualquier sistema operativo.