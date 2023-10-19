-----------------------------!!!!!!!!Consultas de Base de Datos Northwind!!!!!!!!!!------------------------------
--1. Obtener el nombre del producto y la cantidad vendida de cada producto.
SELECT Products.ProductName, SUM(OrderDetails.Quantity) AS TotalSold
FROM Products
INNER JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
GROUP BY Products.ProductName;


-- 2. Obtener los clientes que realizaron pedidos en 1997.
SELECT DISTINCT Customers.ContactName
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
WHERE YEAR(Orders.OrderDate) = 1997;

-- 3. Listar los productos y la cantidad total vendida de cada producto en 1997

SELECT Products.ProductName, SUM(OrderDetails.Quantity) AS TotalSold
FROM Products
INNER JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
INNER JOIN Orders ON OrderDetails.OrderID = Orders.OrderID
WHERE YEAR(Orders.OrderDate) = 1997
GROUP BY Products.ProductName;

-- 4. Mostrar los empleados y la cantidad de pedidos que realizaron cada uno.
SELECT Employees.EmployeeID, Employees.FirstName, Employees.LastName, COUNT(Orders.OrderID) AS TotalOrders
FROM Employees
INNER JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
GROUP BY Employees.EmployeeID, Employees.FirstName, Employees.LastName;


-- 5. Obtener el nombre de la categoría y la cantidad de productos en cada categoría.
SELECT Categories.CategoryName, COUNT(Products.ProductID) AS TotalProducts
FROM Categories
INNER JOIN Products ON Categories.CategoryID = Products.CategoryID
GROUP BY Categories.CategoryName;


-- 6. Listar los clientes y la cantidad total de pedidos que realizaron.
SELECT Customers.ContactName, COUNT(Orders.OrderID) AS TotalOrders
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.ContactName;


-- 7. Mostrar los productos y la cantidad de pedidos en los que se han incluido.
SELECT Products.ProductName, COUNT(OrderDetails.OrderID) AS TotalOrders
FROM Products
INNER JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
GROUP BY Products.ProductName;


-- 8. Obtener el nombre del empleado y la cantidad de pedidos que ha atendido como empleado de ventas.
SELECT Employees.FirstName, Employees.LastName, COUNT(Orders.OrderID) AS TotalOrders
FROM Employees
INNER JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
WHERE Employees.Title = 'Sales Representative'
GROUP BY Employees.FirstName, Employees.LastName;


-- 9. Listar los productos y la cantidad de pedidos pendientes para cada producto.
SELECT Products.ProductName, SUM(OrderDetails.Quantity - OrderDetails.Quantity) AS PendingOrders
FROM Products
INNER JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
GROUP BY Products.ProductName;


-- 10. Obtener el nombre del producto y la cantidad de unidades vendidas para los productos que han sido descontinuados.
SELECT Products.ProductName, SUM(OrderDetails.Quantity) AS TotalSold
FROM Products
INNER JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
WHERE Products.Discontinued = 1
GROUP BY Products.ProductName;


-- 11. Listar los empleados y la cantidad de productos diferentes que han sido vendidos por cada empleado.
SELECT Employees.EmployeeID, Employees.FirstName, Employees.LastName, COUNT(DISTINCT OrderDetails.ProductID) AS UniqueProductsSold
FROM Employees
INNER JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
GROUP BY Employees.EmployeeID, Employees.FirstName, Employees.LastName;


-- 12. Obtener los clientes y su cantidad total gastada en compras.
SELECT Customers.ContactName, SUM(Orders.TotalPrice) AS TotalSpent
FROM Customers
INNER JOIN (
    SELECT Orders.CustomerID, Orders.OrderID, SUM(OrderDetails.Quantity * OrderDetails.UnitPrice) AS TotalPrice
    FROM Orders
    INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
    GROUP BY Orders.CustomerID, Orders.OrderID
) AS Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.ContactName;


-- 13. Listar los productos y su disponibilidad actual en el almacén (considerando pedidos pendientes).
SELECT Products.ProductName, (Products.UnitsInStock - COALESCE(SUM(OrderDetails.Quantity - OrderDetails.Quantity), 0)) AS AvailableStock
FROM Products
LEFT JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
GROUP BY Products.ProductName, Products.UnitsInStock;


-- 14. Listar los productos y la cantidad total de unidades vendidas a clientes de un país específico.
SELECT Products.ProductName, Customers.Country, SUM(OrderDetails.Quantity) AS TotalSold
FROM Products
INNER JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
INNER JOIN Orders ON OrderDetails.OrderID = Orders.OrderID
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
WHERE Customers.Country = 'Spain'
GROUP BY Products.ProductName, Customers.Country;


-- 15. Obtener el nombre de la categoría y la cantidad de productos vendidos de cada categoría.
SELECT Categories.CategoryName, SUM(OrderDetails.Quantity) AS TotalSold
FROM Categories
INNER JOIN Products ON Categories.CategoryID = Products.CategoryID
INNER JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
GROUP BY Categories.CategoryName;


-- 16. Listar los clientes y su última compra.
SELECT Customers.ContactName, MAX(Orders.OrderDate) AS LastPurchaseDate
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.ContactName;


-- 17. Mostrar los productos y la cantidad total de pedidos en los que se han vendido, agrupados por año.
SELECT Products.ProductName, YEAR(Orders.OrderDate) AS OrderYear, SUM(OrderDetails.Quantity) AS TotalSold
FROM Products
INNER JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
INNER JOIN Orders ON OrderDetails.OrderID = Orders.OrderID
GROUP BY Products.ProductName, YEAR(Orders.OrderDate);


--18. Obtener el nombre del empleado y el total de ventas que ha generado.
SELECT Employees.FirstName, Employees.LastName, SUM(OrderDetails.Quantity * OrderDetails.UnitPrice) AS TotalSales
FROM Employees
INNER JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
GROUP BY Employees.FirstName, Employees.LastName;


-- 19. Obtener el nombre del cliente y la cantidad total de dinero gastado en compras en cada país.
SELECT Customers.ContactName, Customers.Country, SUM(OrderDetails.Quantity * OrderDetails.UnitPrice) AS TotalSpent
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
GROUP BY Customers.ContactName, Customers.Country;


-- 20. Obtener los productos que nunca se han vendido.  ////////////////
SELECT Products.ProductName
FROM Products
LEFT JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
WHERE OrderDetails.ProductID IS NULL;


-- 21. Listar los clientes y su total de compras (incluyendo impuestos y envío).
SELECT Customers.ContactName, SUM(Orders.TotalPrice) AS TotalPurchases
FROM Customers
INNER JOIN (
    SELECT Orders.CustomerID, Orders.OrderID, SUM(OrderDetails.Quantity * OrderDetails.UnitPrice) AS TotalPrice
    FROM Orders
    INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
    GROUP BY Orders.CustomerID, Orders.OrderID
) AS Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.ContactName;


-- 22. Mostrar los empleados y su cantidad total de ventas, excluyendo ventas realizadas en 1996.
SELECT Employees.FirstName, Employees.LastName, SUM(OrderDetails.Quantity * OrderDetails.UnitPrice) AS TotalSales
FROM Employees
INNER JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
WHERE YEAR(Orders.OrderDate) <> 1996
GROUP BY Employees.FirstName, Employees.LastName;


-- 23. Obtener el nombre del producto y la cantidad de unidades vendidas a clientes de Canadá.
SELECT Products.ProductName, SUM(OrderDetails.Quantity) AS TotalSoldToCanada
FROM Products
INNER JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
INNER JOIN Orders ON OrderDetails.OrderID = Orders.OrderID
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
WHERE Customers.Country = 'Canada'
GROUP BY Products.ProductName;


-- 24. Listar los clientes y el número de pedidos realizados en cada categoría de productos.
SELECT Customers.ContactName, Categories.CategoryName, COUNT(Orders.OrderID) AS TotalOrders
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
INNER JOIN Products ON OrderDetails.ProductID = Products.ProductID
INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID
GROUP BY Customers.ContactName, Categories.CategoryName;


-- 25. Obtener el nombre del empleado y la cantidad de pedidos que ha gestionado como empleado de ventas.
SELECT Employees.FirstName, Employees.LastName, COUNT(Orders.OrderID) AS TotalOrders
FROM Employees
INNER JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
WHERE Employees.Title = 'Sales Representative'
GROUP BY Employees.FirstName, Employees.LastName;


-- 26. Mostrar los clientes y la fecha de su primer pedido.
SELECT Customers.ContactName, MIN(Orders.OrderDate) AS FirstPurchaseDate
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.ContactName;


-- 27. Listar los clientes y la cantidad de productos diferentes que han comprado.
SELECT Customers.ContactName, COUNT(DISTINCT OrderDetails.ProductID) AS DifferetProductsBought
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
GROUP BY Customers.ContactName;


-- 28. Mostrar los clientes y la fecha de su último pedido en cada país, excluyendo clientes de Estados Unidos.
SELECT Customers.Country, Customers.ContactName, MAX(Orders.OrderDate) AS LastPurchaseDate
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
WHERE Customers.Country <> 'USA'
GROUP BY Customers.Country, Customers.ContactName;


-- 29. Listar los productos y su costo total considerando descuentos aplicados en los pedidos.
SELECT Products.ProductName, SUM(OrderDetails.Quantity * OrderDetails.UnitPrice * (1 - OrderDetails.Discount)) AS TotalCostWithDiscounts
FROM Products
INNER JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
GROUP BY Products.ProductName;


-- 30. Mostrar los empleados y la cantidad de pedidos pendientes que tienen.
SELECT Employees.FirstName, Employees.LastName, COUNT(Orders.OrderID) AS PendingOrders
FROM Employees
INNER JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
WHERE Orders.ShippedDate IS NULL
GROUP BY Employees.FirstName, Employees.LastName;


-- 31. Listar los productos y la cantidad total de unidades vendidas a través de pedidos en línea.
SELECT Products.ProductName, SUM(OrderDetails.Quantity) AS TotalSoldOnline
FROM Products
INNER JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
INNER JOIN Orders ON OrderDetails.OrderID = Orders.OrderID
WHERE Orders.ShipVia = 2
GROUP BY Products.ProductName;


-- 32. Mostrar los clientes y la cantidad de pedidos que han realizado en cada país.
SELECT Customers.Country, COUNT(Orders.OrderID) AS TotalOrders
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.Country;


 --33. Listar los productos y la cantidad total de unidades vendidas en cada categoría.
SELECT Categories.CategoryName, Products.ProductName, SUM(OrderDetails.Quantity) AS TotalSold
FROM Categories
INNER JOIN Products ON Categories.CategoryID = Products.CategoryID
INNER JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
GROUP BY Categories.CategoryName, Products.ProductName;


-- 34. Mostrar los empleados y la cantidad total de pedidos pendientes para cada cliente asignado.
SELECT Employees.FirstName, Employees.LastName, Customers.ContactName, COUNT(Orders.OrderID) AS PendingOrders
FROM Employees
INNER JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
WHERE Orders.ShippedDate IS NULL
GROUP BY Employees.FirstName, Employees.LastName, Customers.ContactName;


-- 35. Obtener el nombre del producto y el número de veces que ha sido incluido en pedidos con envío a través de un transportista específico.
SELECT Products.ProductName, Shippers.CompanyName, COUNT(OrderDetails.OrderID) AS ShipperUsageCount
FROM Products
INNER JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
INNER JOIN Orders ON OrderDetails.OrderID = Orders.OrderID
INNER JOIN Shippers ON Orders.ShipVia = Shippers.ShipperID
WHERE Shippers.CompanyName = 'Speedy Express'
GROUP BY Products.ProductName, Shippers.CompanyName;


-- 36. Mostrar los empleados y la cantidad total de productos vendidos en cada categoría de productos.
SELECT Employees.FirstName, Employees.LastName, Categories.CategoryName, SUM(OrderDetails.Quantity) AS TotalSold
FROM Employees
INNER JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
INNER JOIN Products ON OrderDetails.ProductID = Products.ProductID
INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID
GROUP BY Employees.FirstName, Employees.LastName, Categories.CategoryName;



-- 37. Obtener el nombre del cliente y el total de dinero gastado en compras en cada país.
SELECT Customers.ContactName, Customers.Country, SUM(OrderDetails.Quantity * OrderDetails.UnitPrice) AS TotalSpent
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
GROUP BY Customers.ContactName, Customers.Country;


-- 38. Mostrar los clientes y la fecha de su primer pedido, excluyendo clientes de Francia.
SELECT Customers.ContactName, MIN(Orders.OrderDate) AS FirstPurchaseDate
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
WHERE Customers.Country <> 'France'
GROUP BY Customers.ContactName;


-- 39. Obtener el nombre del empleado y la cantidad de pedidos entregados en cada ciudad de envío.
SELECT Employees.FirstName, Employees.LastName, Suppliers.City, COUNT(Orders.OrderID) AS OrdersDelivered
FROM Employees
INNER JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
INNER JOIN Suppliers ON Orders.ShipVia = Suppliers.SupplierID
GROUP BY Employees.FirstName, Employees.LastName, Suppliers.City;


-- 40. Obtener el nombre del cliente y el total de dinero gastado en compras, ordenados por el cliente que más gastó.
SELECT Customers.ContactName, SUM(OrderDetails.Quantity * OrderDetails.UnitPrice) AS TotalSpent
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
GROUP BY Customers.ContactName
ORDER BY TotalSpent DESC;


-- 41. Listar los productos y su cantidad total de unidades vendidas a clientes de Estados Unidos en 1997.
SELECT Products.ProductName, SUM(OrderDetails.Quantity) AS TotalSoldToUS
FROM Products
INNER JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
INNER JOIN Orders ON OrderDetails.OrderID = Orders.OrderID
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
WHERE Customers.Country = 'USA' AND YEAR(Orders.OrderDate) = 1997
GROUP BY Products.ProductName;


--42. Obtener el nombre del producto y la cantidad de unidades vendidas en pedidos realizados por clientes con un título específico.
SELECT Products.ProductName, SUM(OrderDetails.Quantity) AS TotalSold
FROM Products
INNER JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
INNER JOIN Orders ON OrderDetails.OrderID = Orders.OrderID
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
WHERE Customers.ContactTitle = 'Owner'
GROUP BY Products.ProductName;


-- 43. Mostrar los clientes y la fecha de su primer pedido en cada país, excluyendo clientes de Estados Unidos.
SELECT Customers.Country, Customers.ContactName, MIN(Orders.OrderDate) AS FirstPurchaseDate
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
WHERE Customers.Country <> 'USA'
GROUP BY Customers.Country, Customers.ContactName;


-- 44. Listar los productos y la cantidad total de unidades vendidas en cada año.
SELECT Products.ProductName, YEAR(Orders.OrderDate) AS OrderYear, SUM(OrderDetails.Quantity) AS TotalSold
FROM Products
INNER JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
INNER JOIN Orders ON OrderDetails.OrderID = Orders.OrderID
GROUP BY Products.ProductName, YEAR(Orders.OrderDate);


-- 45. Obtener el nombre del cliente y la cantidad total de dinero gastado en compras en cada año y mes.
SELECT Customers.ContactName, YEAR(Orders.OrderDate) AS OrderYear, MONTH(Orders.OrderDate) AS OrderMonth, SUM(OrderDetails.Quantity * OrderDetails.UnitPrice) AS TotalSpent
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
GROUP BY Customers.ContactName, YEAR(Orders.OrderDate), MONTH(Orders.OrderDate);


-- 46. Mostrar los empleados y la cantidad total de pedidos entregados en cada país.
SELECT Employees.FirstName, Employees.LastName, Customers.Country, COUNT(Orders.OrderID) AS OrdersDelivered
FROM Employees
INNER JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
WHERE Orders.ShippedDate IS NOT NULL
GROUP BY Employees.FirstName, Employees.LastName, Customers.Country;


-- 47. Obtener el nombre del producto y la cantidad de unidades vendidas en pedidos realizados por clientes de un país específico.
SELECT Products.ProductName, Customers.Country, SUM(OrderDetails.Quantity) AS TotalSold
FROM Products
INNER JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
INNER JOIN Orders ON OrderDetails.OrderID = Orders.OrderID
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
WHERE Customers.Country = 'Germany'
GROUP BY Products.ProductName, Customers.Country;


-- 48. Obtener el nombre del empleado y la cantidad total de ventas que ha generado en cada categoría de productos.
SELECT Employees.FirstName, Employees.LastName, Categories.CategoryName, SUM(OrderDetails.Quantity * OrderDetails.UnitPrice) AS TotalSales
FROM Employees
INNER JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
INNER JOIN Products ON OrderDetails.ProductID = Products.ProductID
INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID
GROUP BY Employees.FirstName, Employees.LastName, Categories.CategoryName;



-- 49. Mostrar los empleados y la cantidad total de ventas que han generado en cada mes de 1998.
SELECT Employees.FirstName, Employees.LastName, YEAR(Orders.OrderDate) AS OrderYear, MONTH(Orders.OrderDate) AS OrderMonth, SUM(OrderDetails.Quantity * OrderDetails.UnitPrice) AS TotalSales
FROM Employees
INNER JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
WHERE YEAR(Orders.OrderDate) = 1998
GROUP BY Employees.FirstName, Employees.LastName, YEAR(Orders.OrderDate), MONTH(Orders.OrderDate);


--50. Listar los productos que han sido vendidos más de 100 veces.
SELECT Products.ProductName, SUM(OrderDetails.Quantity) AS TotalSold
FROM Products
INNER JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
GROUP BY Products.ProductName
HAVING SUM(OrderDetails.Quantity) > 100;
