SELECT
  MONTH(fecha_venta) AS mes,
  SUM(cantidad * precio_unitario) AS total_facturado,
  COUNT(id_venta) AS cantidad_pedidos,
  SUM(cantidad * precio_unitario) / COUNT(id_venta) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;


SELECT TOP 5
  id_producto AS id_producto,
  SUM(cantidad) AS unidades_vendidas,
  SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;


SELECT
  id_cliente AS id_cliente,
  COUNT(*) AS cantidad_pedidos,
  SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_facturado DESC;

SELECT
  MONTH(v.fecha_venta) AS mes,
  SUM(v.cantidad * v.precio_unitario) AS total_facturado_mes,
  CASE
    WHEN SUM(v.cantidad * v.precio_unitario) >
      (
        SELECT AVG(total_facturado_mes)
        FROM (
          SELECT
            MONTH(v2.fecha_venta) AS mes_interno,
            SUM(v2.cantidad * v2.precio_unitario) AS total_facturado_mes
          FROM ventas v2
          GROUP BY MONTH(v2.fecha_venta)
        ) x
      )
    THEN 'Por encima'
    ELSE 'Por debajo'
  END AS etiqueta_vs_promedio
FROM ventas v
GROUP BY MONTH(v.fecha_venta)
ORDER BY mes;


--El total facturado en el mes 3 fue de 6444 y se tuvieron 10 pedidos
--El producto cuyo ID es el 1 fue el que logró el mayor monto total facturado dentro de todos los productos vendidos
--El producto cuyo ID es el 2 fue el que logró vender mayor cantidad de unidades pero sin embargo fue el de menor monto total facturado

