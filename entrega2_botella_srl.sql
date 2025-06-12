
-- CREACIÓN DE TABLAS (resumen)
CREATE DATABASE IF NOT EXISTS botella_srl;
USE botella_srl;

CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    email VARCHAR(100),
    telefono VARCHAR(20)
);

CREATE TABLE paquetes (
    id_paquete INT AUTO_INCREMENT PRIMARY KEY,
    destino VARCHAR(100),
    precio DECIMAL(10,2),
    duracion_dias INT
);

CREATE TABLE reservas (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    id_paquete INT,
    fecha_inicio DATE,
    cantidad_personas INT,
    estado VARCHAR(20),
    fecha_pago DATE,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_paquete) REFERENCES paquetes(id_paquete)
);

-- INSERTS SIMPLES (hasta 20 registros por tabla)
INSERT INTO clientes (nombre, email, telefono) VALUES
('Juan Pérez', 'juanp@example.com', '1134567890'),
('Lucía Gómez', 'lucia.g@example.com', '1122233344'),
('María Rodríguez', 'maria.r@example.com', '1144556677');

INSERT INTO paquetes (destino, precio, duracion_dias) VALUES
('Bariloche', 150000.00, 7),
('Mendoza', 120000.00, 5),
('Iguazú', 135000.00, 6);

INSERT INTO reservas (id_cliente, id_paquete, fecha_inicio, cantidad_personas, estado, fecha_pago) VALUES
(1, 1, '2025-07-01', 2, 'Pendiente', NULL),
(2, 2, '2025-07-15', 4, 'Confirmada', '2025-06-01'),
(3, 3, '2025-08-10', 1, 'Cancelada', NULL);

-- VISTAS
CREATE VIEW vista_resumen_reservas AS
SELECT 
    c.nombre AS nombre_cliente,
    p.destino,
    r.fecha_inicio,
    r.estado
FROM reservas r
JOIN clientes c ON r.id_cliente = c.id_cliente
JOIN paquetes p ON r.id_paquete = p.id_paquete;

CREATE VIEW vista_ventas_por_destino AS
SELECT 
    p.destino,
    COUNT(*) AS cantidad_reservas
FROM reservas r
JOIN paquetes p ON r.id_paquete = p.id_paquete
GROUP BY p.destino;

-- FUNCIONES
DELIMITER //
CREATE FUNCTION calcular_total_reserva(id_reserva INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT p.precio * r.cantidad_personas
    INTO total
    FROM reservas r
    JOIN paquetes p ON r.id_paquete = p.id_paquete
    WHERE r.id_reserva = id_reserva;
    RETURN total;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION obtener_estado_reserva(id_reserva INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE estado_reserva VARCHAR(20);
    SELECT estado INTO estado_reserva FROM reservas WHERE id_reserva = id_reserva;
    RETURN estado_reserva;
END //
DELIMITER ;

-- STORED PROCEDURES
DELIMITER //
CREATE PROCEDURE registrar_nueva_reserva(
    IN p_id_cliente INT,
    IN p_id_paquete INT,
    IN p_fecha_inicio DATE,
    IN p_cantidad_personas INT
)
BEGIN
    INSERT INTO reservas (id_cliente, id_paquete, fecha_inicio, cantidad_personas, estado)
    VALUES (p_id_cliente, p_id_paquete, p_fecha_inicio, p_cantidad_personas, 'Pendiente');
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE cancelar_reserva(IN p_id_reserva INT)
BEGIN
    UPDATE reservas SET estado = 'Cancelada' WHERE id_reserva = p_id_reserva;
END //
DELIMITER ;

-- TRIGGER
DELIMITER //
CREATE TRIGGER trg_actualizar_fecha_pago
BEFORE UPDATE ON reservas
FOR EACH ROW
BEGIN
    IF NEW.estado = 'Confirmada' AND OLD.estado != 'Confirmada' THEN
        SET NEW.fecha_pago = CURDATE();
    END IF;
END //
DELIMITER ;
