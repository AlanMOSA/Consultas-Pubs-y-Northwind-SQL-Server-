---------------------------------!!!!Consultas Base de datos Pubs!!!!!!------------------------------------
--1--Consulta de autores y sus libros publicados:
SELECT a.au_lname, a.au_fname, t.title
FROM authors AS a
INNER JOIN titleauthor AS ta ON a.au_id = ta.au_id
INNER JOIN titles AS t ON ta.title_id = t.title_id

--2--Consulta de autores y sus ingresos por regalías
SELECT a.au_lname, a.au_fname, SUM(t.price * ta.royaltyper / 100 * t.ytd_sales) AS IngresosPorRegalias
FROM authors AS a
INNER JOIN titleauthor AS ta ON a.au_id = ta.au_id
INNER JOIN titles AS t ON ta.title_id = t.title_id
GROUP BY a.au_lname, a.au_fname


--3--Consulta de autores y el número de libros que han publicado:
SELECT au_lname, au_fname, COUNT(ta.title_id) AS NumeroDeLibrosPublicados
FROM authors AS a
INNER JOIN titleauthor AS ta ON a.au_id = ta.au_id
GROUP BY au_lname, au_fname


--4--Consulta de autores con el número de libros publicados y su regalía total ganada:
SELECT a.au_lname, a.au_fname, COUNT(t.title_id) AS NumeroDeLibrosPublicados,
       SUM(t.price * ta.royaltyper / 100) AS RegaliaTotalGanada
FROM authors AS a
INNER JOIN titleauthor AS ta ON a.au_id = ta.au_id
INNER JOIN titles AS t ON ta.title_id = t.title_id
GROUP BY a.au_lname, a.au_fname



--5--Consulta de libros con su precio después de aplicar un descuento y redondear a dos decimales:-----------------------
SELECT t.title, 
       ROUND(t.price * (1 - d.discount / 100), 2) AS PrecioConDescuento
FROM titles AS t
INNER JOIN discounts AS d ON t.discounttype_id = d.discounttype_id


--6 Consulta de editoriales y el número de libros que han publicado en cada categoría:----------------------------
SELECT p.pub_name, c.category, COUNT(t.title_id) AS NumeroDeLibrosPublicados
FROM publishers AS p
INNER JOIN titles AS t ON p.pub_id = t.pub_id
INNER JOIN categories AS c ON t.type = c.type
GROUP BY p.pub_name, c.category


--7--Consulta de editoriales con su dirección completa en una sola columna:-------------------------------------------
SELECT p.pub_name, 
       CONCAT(pi.pub_address, ', ', pi.city, ', ', pi.state, ' ', pi.zip) AS DireccionCompleta
FROM publishers AS p
INNER JOIN pub_info AS pi ON p.pub_id = pi.pub_id


--8--Consulta de autores con la fecha del último libro publicado
SELECT a.au_lname, a.au_fname, MAX(t.pubdate) AS UltimaPublicacion
FROM authors AS a
INNER JOIN titleauthor AS ta ON a.au_id = ta.au_id
INNER JOIN titles AS t ON ta.title_id = t.title_id
GROUP BY a.au_lname, a.au_fname


--9--Consulta de empleados y su salario promedio en el departamento
SELECT e.emp_id, e.fname, e.lname, j.job_desc,
       AVG(e.job_lvl) AS SalarioPromedioDepartamento
FROM employee AS e
INNER JOIN jobs AS j ON e.job_id = j.job_id
GROUP BY e.emp_id, e.fname, e.lname, j.job_desc


--10--Consulta de editoriales y el país de origen en formato mayúsculas:-----------------------
SELECT p.pub_name, UPPER(pi.country) AS PaisDeOrigen
FROM publishers AS p
INNER JOIN pub_info AS pi ON p.pub_id = pi.pub_id


--11--Consulta de autores con el número total de libros publicados y su regalía promedio:
SELECT a.au_lname, a.au_fname, 
       COUNT(t.title_id) AS NumeroTotalLibros,
       AVG(t.price * ta.royaltyper / 100) AS RegaliaPromedio
FROM authors AS a
INNER JOIN titleauthor AS ta ON a.au_id = ta.au_id
INNER JOIN titles AS t ON ta.title_id = t.title_id
GROUP BY a.au_lname, a.au_fname


--12--Consulta de editoriales con la cantidad de libros publicados en cada ciudad:----------------------------
SELECT pi.city, COUNT(t.title_id) AS CantidadLibrosPublicados
FROM pub_info AS pi
INNER JOIN publishers AS p ON pi.pub_id = p.pub_id
INNER JOIN titles AS t ON p.pub_id = t.pub_id
GROUP BY pi.city


--13--Consulta de autores con el número de libros publicados en una categoría específica:--------------------
SELECT a.au_lname, a.au_fname, c.category, COUNT(t.title_id) AS NumeroDeLibrosPublicados
FROM authors AS a
INNER JOIN titleauthor AS ta ON a.au_id = ta.au_id
INNER JOIN titles AS t ON ta.title_id = t.title_id
INNER JOIN categories AS c ON t.type = c.type
WHERE c.category = 'Fiction'
GROUP BY a.au_lname, a.au_fname, c.category


--14--Consulta de libros y su precio después de aplicar un descuento variable basado en la categoría:---------------
SELECT t.title, 
       CASE
           WHEN c.category = 'Mystery' THEN t.price * 0.9
           WHEN c.category = 'Science Fiction' THEN t.price * 0.85
           ELSE t.price
       END AS PrecioConDescuento
FROM titles AS t
INNER JOIN categories AS c ON t.type = c.type


--15--Consulta de empleados y su salario promedio por puesto de trabajo:
SELECT j.job_desc, AVG(e.job_lvl) AS SalarioPromedio
FROM employee AS e
INNER JOIN jobs AS j ON e.job_id = j.job_id
GROUP BY j.job_desc

--16--Consulta de editoriales y el país de origen en formato mayúsculas y abreviado:-------------------------------
SELECT p.pub_name, UPPER(LEFT(pi.country, 3)) AS PaisAbreviado
FROM publishers AS p
INNER JOIN pub_info AS pi ON p.pub_id = pi.pub_id


--17--Consulta de autores con el promedio de regalía ganada en libros de no ficción:-------------------------------
SELECT a.au_lname, a.au_fname, AVG(t.price * ta.royaltyper / 100) AS RegaliaPromedioNoFiccion
FROM authors AS a
INNER JOIN titleauthor AS ta ON a.au_id = ta.au_id
INNER JOIN titles AS t ON ta.title_id = t.title_id
INNER JOIN categories AS c ON t.type = c.type
WHERE c.category = 'Nonfiction'
GROUP BY a.au_lname, a.au_fname

--18--Consulta de editoriales con la cantidad de libros publicados en cada país:------------------------
SELECT pi.country, COUNT(t.title_id) AS CantidadLibrosPublicados
FROM pub_info AS pi
INNER JOIN publishers AS p ON pi.pub_id = p.pub_id
INNER JOIN titles AS t ON p.pub_id = t.pub_id
GROUP BY pi.country



--19--consulta de autores con la cantidad total de libros vendidos y su regalía total ganada:---------------------------------
SELECT a.au_lname, a.au_fname, 
       SUM(oi.qty) AS CantidadTotalLibrosVendidos,
       SUM(t.price * ta.royaltyper / 100 * oi.qty) AS RegaliaTotalGanada
FROM authors AS a
INNER JOIN titleauthor AS ta ON a.au_id = ta.au_id
INNER JOIN titles AS t ON ta.title_id = t.title_id
INNER JOIN sales AS s ON t.title_id = s.title_id
INNER JOIN orderitems AS oi ON s.ord_num = oi.ord_num
GROUP BY a.au_lname, a.au_fname


--20-Consulta de libros con su precio después de aplicar un descuento basado en el estado del almacén:-------------------------
SELECT t.title, 
       CASE
           WHEN s.state = 'CA' THEN t.price * 0.9
           WHEN s.state = 'NY' THEN t.price * 0.95
           ELSE t.price
       END AS PrecioConDescuento
FROM titles AS t
INNER JOIN stores AS s ON t.stor_id = s.stor_id


--21-Consulta de editoriales y el país de origen en formato mayúsculas y abreviado (máximo 3 caracteres):----------------------------
SELECT p.pub_name, UPPER(LEFT(pi.country, 3)) AS PaisAbreviado
FROM publishers AS p
INNER JOIN pub_info AS pi ON p.pub_id = pi.pub_id


--22-Consulta de autores con el promedio de regalía ganada en libros de ciencia ficción:-------------------------------------------------
SELECT a.au_lname, a.au_fname, AVG(t.price * ta.royaltyper / 100) AS RegaliaPromedioCienciaFiccion
FROM authors AS a
INNER JOIN titleauthor AS ta ON a.au_id = ta.au_id
INNER JOIN titles AS t ON ta.title_id = t.title_id
INNER JOIN categories AS c ON t.type = c.type
WHERE c.category = 'Science Fiction'
GROUP BY a.au_lname, a.au_fname


--23-Consulta de autores con el título de su libro más reciente:
SELECT a.au_lname, a.au_fname, 
       MAX(t.title) AS UltimoTituloPublicado
FROM authors AS a
INNER JOIN titleauthor AS ta ON a.au_id = ta.au_id
INNER JOIN titles AS t ON ta.title_id = t.title_id
GROUP BY a.au_lname, a.au_fname


--24-Consulta de libros y su precio después de aplicar un descuento basado en la cantidad de stock disponible:
SELECT t.title, 
       CASE
           WHEN s.quantity > 100 THEN t.price * 0.9
           WHEN s.quantity <= 100 AND s.quantity > 50 THEN t.price * 0.95
           ELSE t.price
       END AS PrecioConDescuento
FROM titles AS t
INNER JOIN stock AS s ON t.title_id = s.title_id


--25-Consulta de editoriales con la longitud de su dirección completa:

SELECT p.pub_name, 
       LEN(CONCAT(pi.pub_address, ', ', pi.city, ', ', pi.state, ' ', pi.zip)) AS LongitudDireccionCompleta
FROM publishers AS p
INNER JOIN pub_info AS pi ON p.pub_id = pi.pub_id


--26-consulta de autores con el porcentaje promedio de regalía ganada:
SELECT a.au_lname, a.au_fname, 
       AVG(ta.royaltyper) AS RegaliaPromedio
FROM authors AS a
INNER JOIN titleauthor AS ta ON a.au_id = ta.au_id
GROUP BY a.au_lname, a.au_fname

--27-Consulta de autores con el título de su libro más vendido y la cantidad total vendida:
SELECT a.au_lname, a.au_fname, 
       t.title, MAX(oi.quantity) AS CantidadVendida
FROM authors AS a
INNER JOIN titleauthor AS ta ON a.au_id = ta.au_id
INNER JOIN titles AS t ON ta.title_id = t.title_id
INNER JOIN orderitems AS oi ON t.title_id = oi.title_id
GROUP BY a.au_lname, a.au_fname, t.title


--28-Consulta de editoriales con la dirección en formato invertido (código postal, estado, ciudad, dirección):
SELECT p.pub_name, 
       CONCAT(pi.zip, ', ', pi.state, ', ', pi.city, ', ', pi.pub_address) AS DireccionInvertida
FROM publishers AS p
INNER JOIN pub_info AS pi ON p.pub_id = pi.pub_id


--29-Consulta de editoriales con la cantidad de libros publicados en cada país y ciudad
SELECT pi.country, pi.city, COUNT(t.title_id) AS NumeroLibrosPublicados
FROM publishers AS p
INNER JOIN pub_info AS pi ON p.pub_id = pi.pub_id
INNER JOIN titles AS t ON p.pub_id = t.pub_id
GROUP BY pi.country, pi.city


--30-Consulta de autores con la fecha de publicación de su libro más antiguo:
SELECT a.au_lname, a.au_fname, 
       MIN(t.pubdate) AS FechaLibroMasAntiguo
FROM authors AS a
INNER JOIN titleauthor AS ta ON a.au_id = ta.au_id
INNER JOIN titles AS t ON ta.title_id = t.title_id
GROUP BY a.au_lname, a.au_fname


--31-Consulta de libros y su precio con un descuento basado en el nombre del autor (A-M reciben 10% de descuento, N-Z reciben 5% de descuento):
SELECT t.title, 
       CASE
           WHEN a.au_lname <= 'M' THEN t.price * 0.9
           ELSE t.price * 0.95
       END AS PrecioConDescuento
FROM titles AS t
INNER JOIN titleauthor AS ta ON t.title_id = ta.title_id
INNER JOIN authors AS a ON ta.au_id = a.au_id

--32-Consulta de editoriales con la longitud promedio de sus direcciones:
SELECT p.pub_name, 
       AVG(LEN(CONCAT(pi.pub_address, ', ', pi.city, ', ', pi.state, ' ', pi.zip))) AS LongitudPromedioDireccion
FROM publishers AS p
INNER JOIN pub_info AS pi ON p.pub_id = pi.pub_id
GROUP BY p.pub_name

--33-Consulta de autores con la suma total de regalías ganadas en libros de cierta categoría (por ejemplo, 'Mystery'):
SELECT a.au_lname, a.au_fname, c.category, 
       SUM(t.price * ta.royaltyper / 100) AS RegaliasTotales
FROM authors AS a
INNER JOIN titleauthor AS ta ON a.au_id = ta.au_id
INNER JOIN titles AS t ON ta.title_id = t.title_id
INNER JOIN categories AS c ON t.type = c.type
WHERE c.category = 'Mystery'
GROUP BY a.au_lname, a.au_fname, c.category


--34-Consulta de empleados y su salario promedio por ciudad de residencia y departamento:
SELECT e.city, d.dept_name, AVG(e.salary) AS SalarioPromedio
FROM employee AS e
INNER JOIN department AS d ON e.dept_id = d.dept_id
GROUP BY e.city, d.dept_name


--35-Consulta de editoriales con el nombre de la ciudad en formato mayúsculas y el país en formato abreviado (por ejemplo, "NY, USA"):
SELECT UPPER(pi.city) AS CiudadEnMayusculas, LEFT(pi.country, 3) AS PaisAbreviado
FROM pub_info AS pi
INNER JOIN publishers AS p ON pi.pub_id = p.pub_id


--36-Consulta de autores con el porcentaje mínimo de regalía ganada en libros de no ficción:
SELECT a.au_lname, a.au_fname, 
       MIN(ta.royaltyper) AS RegaliaMinimaNoFiccion
FROM authors AS a
INNER JOIN titleauthor AS ta ON a.au_id = ta.au_id
INNER JOIN titles AS t ON ta.title_id = t.title_id
INNER JOIN categories AS c ON t.type = c.type
WHERE c.category = 'Nonfiction'
GROUP BY a.au_lname, a.au_fname



--37-Consulta de autores con la suma total de regalías ganadas en libros publicados en el último año:
SELECT a.au_lname, a.au_fname, 
       SUM(t.price * ta.royaltyper / 100) AS RegaliasTotalesUltimoAnio
FROM authors AS a
INNER JOIN titleauthor AS ta ON a.au_id = ta.au_id
INNER JOIN titles AS t ON ta.title_id = t.title_id
WHERE t.pubdate >= DATEADD(YEAR, -1, GETDATE())
GROUP BY a.au_lname, a.au_fname


--38-Consulta de libros y su precio con un descuento basado en el nombre del autor y el género del libro (autores que comienzan con A-M obtienen un 10% de descuento en misterio):
SELECT t.title, 
       CASE
           WHEN a.au_lname LIKE '[A-M]%' AND t.type = 'mystery' THEN t.price * 0.9
           ELSE t.price
       END AS PrecioConDescuento
FROM titles AS t
INNER JOIN titleauthor AS ta ON t.title_id = ta.title_id
INNER JOIN authors AS a ON ta.au_id = a.au_id


--39-Consulta de empleados y su salario promedio por estado de residencia y puesto de trabajo:
SELECT e.state, j.job_desc, AVG(e.salary) AS SalarioPromedio
FROM employee AS e
INNER JOIN jobs AS j ON e.job_id = j.job_id
GROUP BY e.state, j.job_desc



--40-Consulta de editoriales con la longitud promedio de sus direcciones en caracteres:
SELECT p.pub_name, 
       AVG(LEN(CONCAT(pi.pub_address, ', ', pi.city, ', ', pi.state, ' ', pi.zip))) AS LongitudPromedioDireccion
FROM publishers AS p
INNER JOIN pub_info AS pi ON p.pub_id = pi.pub_id
GROUP BY p.pub_name


--41-Consulta de autores con el porcentaje máximo de regalía ganada en libros de ciencia ficción publicados después de 2000:
SELECT a.au_lname, a.au_fname, 
       MAX(ta.royaltyper) AS RegaliaMaximaCienciaFiccion
FROM authors AS a
INNER JOIN titleauthor AS ta ON a.au_id = ta.au_id
INNER JOIN titles AS t ON ta.title_id = t.title_id
WHERE t.type = 'sf' AND YEAR(t.pubdate) > 2000
GROUP BY a.au_lname, a.au_fname



--42-Consulta de editoriales con la cantidad de libros publicados en cada ciudad y país:
SELECT pi.city, pi.country, COUNT(t.title_id) AS NumeroLibrosPublicados
FROM pub_info AS pi
INNER JOIN publishers AS p ON pi.pub_id = p.pub_id
INNER JOIN titles AS t ON p.pub_id = t.pub_id
GROUP BY pi.city, pi.country



--43-Consulta de autores con la suma total de regalías ganadas en libros publicados después de 1990:
SELECT a.au_lname, a.au_fname, 
       SUM(t.price * ta.royaltyper / 100) AS RegaliasTotalesPost1990
FROM authors AS a
INNER JOIN titleauthor AS ta ON a.au_id = ta.au_id
INNER JOIN titles AS t ON ta.title_id = t.title_id
WHERE YEAR(t.pubdate) > 1990
GROUP BY a.au_lname, a.au_fname



--44-Consulta de autores con la regalía promedio en libros de no ficción publicados después de 2000:------
SELECT a.au_lname, a.au_fname, 
       AVG(ta.royaltyper) AS RegaliaPromedioNoFiccionPost2000
FROM authors AS a
INNER JOIN titleauthor AS ta ON a.au_id = ta.au_id
INNER JOIN titles AS t ON ta.title_id = t.title_id
WHERE t.type = 'NF' AND YEAR(t.pubdate) > 2000
GROUP BY a.au_lname, a.au_fname



--45-Consulta de autores con la fecha de publicación de su libro más reciente y la cantidad de copias vendidas de ese libro:
SELECT a.au_lname, a.au_fname, 
       t.title, t.pubdate, oi.quantity AS CopiasVendidas
FROM authors AS a
INNER JOIN titleauthor AS ta ON a.au_id = ta.au_id
INNER JOIN titles AS t ON ta.title_id = t.title_id
INNER JOIN sales AS s ON t.title_id = s.title_id
INNER JOIN orderitems AS oi ON s.ord_num = oi.ord_num
WHERE t.pubdate = (SELECT MAX(pubdate) FROM titles WHERE title_id = t.title_id)


--46-Consulta de libros y su precio con un descuento variable basado en el nombre del autor y la categoría del libro (autores que comienzan con A-M reciben 10% de descuento en no ficción):
SELECT t.title, 
       CASE
           WHEN a.au_lname LIKE '[A-M]%' AND c.category = 'Nonfiction' THEN t.price * 0.9
           ELSE t.price
       END AS PrecioConDescuento
FROM titles AS t
INNER JOIN titleauthor AS ta ON t.title_id = ta.title_id
INNER JOIN authors AS a ON ta.au_id = a.au_id
INNER JOIN categories AS c ON t.type = c.type


--47-Consulta de editoriales con la dirección completa en formato inverso (código postal, estado, ciudad, dirección):
SELECT p.pub_name, 
       CONCAT(pi.zip, ', ', pi.state, ', ', pi.city, ', ', pi.pub_address) AS DireccionInvertida
FROM publishers AS p
INNER JOIN pub_info AS pi ON p.pub_id = pi.pub_id



--48-Consulta de autores con el título de su libro más largo y el número de páginas de ese libro:
SELECT a.au_lname, a.au_fname, 
       t.title, MAX(t.pagecount) AS PaginasDelLibroMasLargo
FROM authors AS a
INNER JOIN titleauthor AS ta ON a.au_id = ta.au_id
INNER JOIN titles AS t ON ta.title_id = t.title_id
GROUP BY a.au_lname, a.au_fname, t.title


--49-Consulta de autores con la regalía promedio en libros de misterio o ciencia ficción:
SELECT a.au_lname, a.au_fname, 
       AVG(ta.royaltyper) AS RegaliaPromedio
FROM authors AS a
INNER JOIN titleauthor AS ta ON a.au_id = ta.au_id
INNER JOIN titles AS t ON ta.title_id = t.title_id
WHERE t.type IN ('mystery', 'sf')
GROUP BY a.au_lname, a.au_fname


--50-Consulta de editoriales con la cantidad de libros publicados en cada país y ciudad ordenados por país y ciudad:
SELECT pi.country, pi.city, COUNT(t.title_id) AS NumeroLibrosPublicados
FROM pub_info AS pi
INNER JOIN publishers AS p ON pi.pub_id = p.pub_id
INNER JOIN titles AS t ON p.pub_id = t.pub_id
GROUP BY pi.country, pi.city
ORDER BY pi.country, pi.city
