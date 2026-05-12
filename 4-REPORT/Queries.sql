SELECT *
FROM FLUX

SELECT * 
FROM vue_FLUX

SELECT *
FROM FLUX
ORDER BY 1 DESC

SELECT * 
FROM vue_FLUX
ORDER BY 1 DESC


SELECT *
FROM vue_FLUX
WHERE "Tags" = ''

SELECT *
FROM vue_FLUX
WHERE "Description" = ''

SELECT *
FROM vue_FLUX
WHERE "Tags" LIKE '%%'

SELECT *
FROM vue_FLUX
WHERE "Description" LIKE '%%'

UPDATE FLUX
SET montant = 0.00
WHERE id_flux = 0

UPDATE FLUX
SET description = ''
WHERE id_flux = 0

UPDATE FLUX
SET tags = ''
WHERE id_flux = 0

UPDATE FLUX
SET date = ''
WHERE id_flux = 0

UPDATE FLUX
SET id_categorie = 0
WHERE id_flux = 0