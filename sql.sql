BEGIN
			SELECT *
			FROM (
				 SELECT
					  COUNT(*) AS pagos_realizados, -- Número de pagos realizados
				alu.tipodoc, -- Tipo de documento del alumno
				alu.nrodocumento, -- Número de documento del alumno
				CONCAT_WS(' ', alu.apepaterno, alu.apematerno, alu.nombres) AS 'Nombre_Alumno', -- Nombre completo del alumno
				cur.titulo, -- Título del curso
				calcular_edad(alu.fechaNac) as 'edad_alumno',
				IF(calcular_edad(alu.fechaNac) >= 18, alu.telefono, apo.telefono) AS 'telefono', -- Teléfono del alumno si es mayor de edad, de lo contrario, teléfono del apoderado
				IF(calcular_edad(alu.fechaNac) >= 18, alu.email, apo.email) AS correo_destino, -- Correo electrónico del alumno si es mayor de edad, de lo contrario, correo electrónico del apoderado
				CONCAT_WS(' ', apo.apepaterno, apo.apematerno, apo.nombres) AS 'Nombre_Apoderado', -- Nombre completo del apoderado
					  TIMESTAMPDIFF(MONTH, cur.fecha_inicio, CURDATE()) AS diferencia_meses_actual_inicio, -- Diferencia en meses entre la fecha de inicio del curso y la fecha actual
					  TIMESTAMPDIFF(MONTH, cur.fecha_inicio, cur.fecha_fin) AS diferencia_meses_inicio_fin, -- Diferencia en meses entre la fecha de inicio y la fecha de fin del curso
					  CASE
							WHEN COUNT(*) = TIMESTAMPDIFF(MONTH, cur.fecha_inicio, CURDATE()) THEN 0 -- Si el número de pagos realizados es igual a la diferencia en meses entre la fecha de inicio y la fecha actual, asigna 0
							WHEN COUNT(*) < TIMESTAMPDIFF(MONTH, cur.fecha_inicio, CURDATE()) THEN TIMESTAMPDIFF(MONTH, cur.fecha_inicio, CURDATE()) - COUNT(*) -- Si el número de pagos realizados es menor a la diferencia en meses entre la fecha de inicio y la fecha actual, calcula los pagos pendientes
							ELSE 0 -- De lo contrario, asigna 0
							-- ELSE CONCAT('Faltan ', TIMESTAMPDIFF(MONTH, cur.fecha_inicio, cur.fecha_fin) - COUNT(*), ' pagos por realizar')
					  END AS pagos_meses_pendientes, -- Número de pagos pendientes en meses
						TIMESTAMPDIFF(MONTH, cur.fecha_inicio, cur.fecha_fin) - COUNT(*) AS pagos_totales_pendientes -- Total de pagos pendientes en meses

				 FROM
					  pagos p
					  INNER JOIN matriculas m ON p.idmatricula = m.idmatricula
					  LEFT JOIN personas alu ON m.idalumno = alu.idpersona
					  LEFT JOIN personas apo ON m.idapoderado = apo.idpersona
					  INNER JOIN cursos cur ON m.idcurso = cur.idcurso
				 WHERE
					  cur.estado != 'E'  AND cur.estado != 'I' AND  YEAR(m.fechamatricula) = YEAR(NOW())  -- Excluir cursos con estado 'E' (eliminado) y 'I' (inactivo)
				 GROUP BY
					  alu.idpersona, cur.idcurso
			) AS subconsulta
			HAVING diferencia_meses_actual_inicio != 0 AND pagos_totales_pendientes != 0 -- Filtrar por diferencia en meses actual a inicio distinta de 0 y pagos totales pendientes distinto de 0
			ORDER BY pagos_realizados; -- Ordenar por número de pagos realizados
END */$$

