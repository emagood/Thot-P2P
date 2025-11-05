# P2P Communication App with Godot 4.4

## Thot-P2P## DescriptionThis application allows P2P (Peer-to-Peer) communication between devices using different implementation methods in Godot 4.4: ENet, WebSocket, and tcp, udp, libp2p, nostr. Its main goal is to connect devices and exchange information, data, or messages.

## Features
- **P2P Connections**: Support for P2P connections using ENet, WebSocket, webrtc, and TCP, UDP, and in beta libp2p, torrent, nostr.
- **Information Exchange**: Allows sending and receiving messages between two connected devices.
- **Modular Implementation**: Each connection method is implemented as an independent module, making it easy to use and modify.

## Requisitos

- Godot Engine 4.4 o superior.
- Conexión a Internet y/o lolcalhost , ipv 4/6.
- Dos dispositivos compatibles con Godot (pueden ser ordenadores, smartphones, etc.).

## Métodos de Conexión

### ENet

ENet es una biblioteca de red confiable para la comunicación en tiempo real.
Es ideal para aplicaciones que requieren baja latencia y alta confiabilidad.
- Juegos en línea que necesitan comunicación en tiempo real con baja latencia.
- Aplicaciones de chat en tiempo real.
- Transferencia de archivos pequeños en redes locales.

### WebSocket and webrtc

WebSocket proporciona una comunicación bidireccional a través de una sola conexión TCP.
Es ideal para aplicaciones basadas en web que requieren una comunicación en tiempo real.
- Aplicaciones web interactivas que necesitan actualizaciones en tiempo real, como chats y colaboración en línea.
- Juegos multijugador basados en navegador.
- Aplicaciones IoT que requieren comunicación constante con un servidor web.

### TCP , UDP

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
