# Repositorio de pruebas - Integración y despliegue continuo

## Ejecutar contenedores

Para la creación de imagenes, contenedores y despliegue de servicios ingrese el siguiente comando:

`docker-compose up -d`

Para unicamente crear las imagenes:

`docker-compose build`

Para detener los contenedores:

`docker-compose down`

## Ejecutar jenkins

Ingresar a la dirección ip del servidor por el puerto 8080 `http: // your_ip_or_domain:8080` e importar los jobs requeridos.