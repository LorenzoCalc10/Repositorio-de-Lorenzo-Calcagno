CREATE DATABASE Retail_Pro_M5_DB;
USE Retail_Pro_M5_DB; 
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS territorios;

CREATE TABLE territorios (
id_territorio INT PRIMARY KEY,
region VARCHAR(50) NOT NULL,
pais VARCHAR(50) NOT NULL,
zona VARCHAR(50) NOT NULL,
);
CREATE TABLE categorias (
id_categoria INT PRIMARY KEY,
nombre_categoria VARCHAR(50) NOT NULL,
descripcion VARCHAR(200) 
);
CREATE TABLE clientes (
id_cliente INT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
email VARCHAR(100) UNIQUE,
ciudad VARCHAR(50),
fecha_registro DATE NOT NULL,
segmento VARCHAR(50)
);
CREATE TABLE productos (
id_producto INT PRIMARY KEY,
nombre_producto VARCHAR(100) NOT NULL,
id_categoria INT FOREIGN KEY REFERENCES categorias (id_categoria),
precio DECIMAL(10,2) NOT NULL,
stock INT DEFAULT 0,
activo TINYINT DEFAULT 1
);
CREATE TABLE ventas (
id_venta INT PRIMARY KEY,
id_cliente INT FOREIGN KEY REFERENCES clientes (id_cliente),
id_producto INT FOREIGN KEY REFERENCES productos (id_producto),
id_categoria INT FOREIGN KEY REFERENCES categorias (id_categoria),
id_territorio INT FOREIGN KEY REFERENCES territorios (id_territorio),
canal VARCHAR(50),
cantidad INT NOT NULL,
precio_unitario DECIMAL(10,2) NOT NULL,
fecha_venta DATE NOT NULL
);

INSERT INTO territorios
(id_territorio,region,pais,zona)
VALUES
(1,'AMBA','Argentina','CABA'),
(2, 'Litoral','Argentina','Rosario'),
(3, 'Cordoba','Argentina','Cordoba'),
(4, 'NOA','Argentina','Salta') ;

INSERT INTO categorias
(id_categoria,nombre_categoria,descripcion)
VALUES
(1, 'Computación', 'Laptops, PCs y monitores'),
(2, 'Accesorios', 'Periféricos y complementos'),
(3, 'Audio', 'Auriculares y parlantes'),
(4, 'Almacenamiento', 'Discos y memorias') ;

INSERT INTO clientes
(id_cliente,nombre,email,ciudad,fecha_registro,segmento)
VALUES
(1, 'María López',   'maria@mail.com',   'Buenos Aires', '2024-01-05','Mayorista'),
(2, 'Carlos Ruiz',   'carlos@mail.com',  'Rio Cuarto',      '2024-01-10','Mayorista'),
(3, 'Ana Gómez',     'ana@mail.com',     'Rosario',      '2024-02-01','Minorista'),
(4, 'Pedro Sanz',    'pedro@mail.com',   'Mendoza',      '2024-02-15','Mayorista'),
(5, 'Laura Torres',  'laura@mail.com',   'Tucumán',      '2024-03-01','Minorista');

INSERT INTO productos
(id_producto,nombre_producto,id_categoria,precio,stock,activo)
VALUES
(1, 'Laptop Pro 15',       1, 1200.00, 15, 1),
(2, 'Mouse Inalámbrico',   2,   28.00, 80, 1),
(3, 'Monitor 4K 27"',      1,  450.00, 12, 1),
(4, 'Auriculares BT Pro',  3,  120.00, 35, 1),
(5, 'SSD Externo 1TB',     4,  130.00, 18, 1),
(6, 'Teclado Mecánico',    2,   95.00, 40, 1);

INSERT INTO ventas
(id_venta,id_cliente,id_producto,id_categoria,id_territorio,canal,cantidad,precio_unitario,fecha_venta)
VALUES
 (1,  1, 1, 1, 1,'Online', 2,  1200.00, '2024-03-05'),
 (2,  2, 2, 2, 2 ,'Presencial',5,   28.00, '2024-03-06'),
 (3,  3, 3, 1, 3 ,'Online',1,  450.00, '2024-03-07'),
 (4,  1, 4, 3, 3 ,'Online',2,  120.00, '2024-03-08'),
 (5,  4, 4, 4, 3 ,'Online',3,  130.00, '2024-03-10'),
 (6,  2, 6, 2, 4 ,'Online',4,   95.00, '2024-03-11'),
 (7,  5, 1, 1, 4 ,'Online',1, 1200.00, '2024-03-12'),
 (8,  3, 2, 2, 1 ,'Presencial',8,   28.00, '2024-03-13'),
 (9,  4, 4, 3, 1 ,'Presencial',1,  120.00, '2024-03-14'),
 (10, 4, 3, 1, 3 ,'Online',2,  450.00, '2024-03-15');

SELECT * FROM territorios;
SELECT * FROM categorias;
SELECT * FROM clientes;
SELECT * FROM productos;
SELECT * FROM ventas;

SELECT
  v.fecha_venta,
  cl.nombre AS nombre_cliente,
  cl.segmento,
  t.region,
  p.nombre_producto,
  c.nombre_categoria,
  v.cantidad,
  v.precio_unitario,
  (v.cantidad * v.precio_unitario) AS total_venta,
  v.canal
FROM ventas v
INNER JOIN clientes cl
  ON cl.id_cliente = v.id_cliente
INNER JOIN productos p
  ON p.id_producto = v.id_producto
INNER JOIN categorias c
  ON c.id_categoria = p.id_categoria
INNER JOIN territorios t
  ON t.id_territorio = v.id_territorio;

  SELECT
  cl.nombre,
  cl.email,
  cl.fecha_registro
FROM clientes cl
LEFT JOIN ventas v
  ON v.id_cliente = cl.id_cliente
WHERE v.id_venta IS NULL;


SELECT
  p.nombre_producto,
  c.nombre_categoria,
  p.precio
FROM productos p
LEFT JOIN ventas v
  ON v.id_producto = p.id_producto
INNER JOIN categorias c
  ON c.id_categoria = p.id_categoria
WHERE v.id_venta IS NULL;

SELECT
  canal,
  SUM(cantidad * precio_unitario) AS total_venta
FROM (
  SELECT
    cantidad,
    precio_unitario,
    'Online' AS canal
  FROM ventas
  WHERE canal = 'Online'

  UNION ALL

  SELECT
    cantidad,
    precio_unitario,
    'Presencial' AS canal
  FROM ventas
  WHERE canal = 'Presencial'
) x
GROUP BY canal;
