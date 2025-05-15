
-- Script de creación de base de datos para Botella SRL

CREATE DATABASE botella_srl;
USE botella_srl;

-- Clientes
CREATE TABLE Clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo_electronico VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20)
);

-- Destinos
CREATE TABLE Destinos (
    id_destino INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    pais VARCHAR(50) NOT NULL
);

-- Paquetes
CREATE TABLE Paquetes (
    id_paquete INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,
    descripcion TEXT
);

-- Reservas
CREATE TABLE Reservas (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_destino INT NOT NULL,
    id_paquete INT NOT NULL,
    fecha_reserva DATE NOT NULL,
    cantidad_personas INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_destino) REFERENCES Destinos(id_destino),
    FOREIGN KEY (id_paquete) REFERENCES Paquetes(id_paquete)
);

-- Pagos
CREATE TABLE Pagos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_reserva INT NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    fecha DATE NOT NULL,
    metodo_pago VARCHAR(50),
    FOREIGN KEY (id_reserva) REFERENCES Reservas(id_reserva)
);
