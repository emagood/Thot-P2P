# P2P Communication App with Godot 4.4
##  Thot-P2P

## Descripción

Esta aplicación permite la comunicación P2P (Peer-to-Peer) entre dos dispositivos utilizando diferentes métodos de implementación en Godot 4.4: ENet,
WebSocket, y TCP_Peer. Su objetivo principal es conectar dispositivos e intercambiar información, datos o mensajes.

## Características

- **Conexiones P2P**: Soporte para conexiones P2P utilizando ENet, WebSocket, y TCP_Peer.
- **Intercambio de Información**: Permite enviar y recibir mensajes entre dos dispositivos conectados.
- **Implementación Modular**: Cada método de conexión está implementado como un módulo independiente, facilitando su uso y modificación.

## Requisitos

- Godot Engine 4.4 o superior.
- Conexión a Internet y/o lolcalhost.
- Dos dispositivos compatibles con Godot (pueden ser ordenadores, smartphones, etc.).

## Instalación

1. **Clona el repositorio**:
    ```sh
    git clone https://github.com/emagood/Thot-P2P.git
    cd Thot-P2P
    ```

2. **Abre el proyecto en Godot**:
    - Inicia Godot Engine.
    - Selecciona "Import" y navega hasta la carpeta del proyecto.
    - Selecciona el archivo `project.godot`.

## Uso

1. **Selecciona el método de conexión**:
    - Dentro de Godot, abre la escena principal.
    - En el inspector, selecciona el método de conexión deseado (ENet, WebSocket, TCP_Peer).

2. **Inicia la aplicación en ambos dispositivos**:
    - Ejecuta el proyecto en dos dispositivos.
    - Asegúrate de que ambos dispositivos estén en la misma red (para ENet y TCP_Peer) o tengan acceso a Internet (para WebSocket).

3. **Conexión y comunicación**:
    - En uno de los dispositivos, selecciona "Host" para iniciar el servidor.
    - En el otro dispositivo, introduce la dirección IP del host y selecciona "Connect".
    - Una vez conectados, puedes enviar mensajes entre los dispositivos utilizando la interfaz de usuario.

## Métodos de Conexión

### ENet

ENet es una biblioteca de red confiable para la comunicación en tiempo real.
Es ideal para aplicaciones que requieren baja latencia y alta confiabilidad.
- Juegos en línea que necesitan comunicación en tiempo real con baja latencia.
- Aplicaciones de chat en tiempo real.
- Transferencia de archivos pequeños en redes locales.

### WebSocket

WebSocket proporciona una comunicación bidireccional a través de una sola conexión TCP.
Es ideal para aplicaciones basadas en web que requieren una comunicación en tiempo real.
- Aplicaciones web interactivas que necesitan actualizaciones en tiempo real, como chats y colaboración en línea.
- Juegos multijugador basados en navegador.
- Aplicaciones IoT que requieren comunicación constante con un servidor web.

### TCP_Peer

TCP_Peer utiliza el protocolo TCP estándar para la comunicación. Es confiable y fácil de implementar para conexiones de red básicas.
- Aplicaciones de transferencia de archivos que requieren fiabilidad en la entrega de datos.
- Herramientas de administración remota donde la fiabilidad es más importante que la latencia.
- Comunicación entre sistemas distribuidos que necesitan asegurar la entrega de mensajes.

## Usos Útiles

1. **Juegos Multijugador**: Crea juegos que permitan a los jugadores conectarse y competir en tiempo real, ya sea en una red local o a través de Internet.
2. **Aplicaciones de Chat**: Desarrolla aplicaciones de chat en tiempo real que permitan a los usuarios comunicarse instantáneamente.
3. **Colaboración en Tiempo Real**: Facilita la colaboración en tiempo real en proyectos, como editores de texto colaborativos o aplicaciones de dibujo.
4. **Intercambio de Archivos**: Implementa aplicaciones para el intercambio de archivos que aseguren la entrega fiable de datos.
5. **Control Remoto**: Crea herramientas de administración y control remoto para gestionar dispositivos o sistemas distribuidos.

## Contribuir

¡Las contribuciones son bienvenidas! Si deseas contribuir, por favor, realiza un fork del repositorio, crea una rama con tus cambios y envía un pull request.

## Licencia

Este proyecto está licenciado bajo la Licencia MIT. Consulta el archivo `LICENSE` para obtener más detalles.



