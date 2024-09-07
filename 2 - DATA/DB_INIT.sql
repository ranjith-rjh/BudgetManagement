DROP TABLE IF EXISTS CATEGORIE CASCADE;
DROP TABLE IF EXISTS FIXES CASCADE;
DROP TABLE IF EXISTS FLUX CASCADE;
DROP TABLE IF EXISTS PERIODE CASCADE;
DROP TABLE IF EXISTS TYPE_FLUX CASCADE;

DROP VIEW IF EXISTS vue_Periode CASCADE;
DROP VIEW IF EXISTS vue_Fixes CASCADE;
DROP VIEW IF EXISTS vue_Type_Flux CASCADE;
DROP VIEW IF EXISTS vue_Categorie CASCADE;
DROP VIEW IF EXISTS vue_Sous_Categorie CASCADE;
DROP VIEW IF EXISTS vue_Flux CASCADE;

/*==============================================================*/
/* Table : CATEGORIE                                            */
/*==============================================================*/
create table CATEGORIE (
   ID_CATEGORIE         INT4                 not null,
   CAT_ID_CATEGORIE     INT4,
   NAME_CATEGORIE       VARCHAR(50)          not null,
   constraint PK_CATEGORIE primary key (ID_CATEGORIE)
);

/*==============================================================*/
/* Table : FIXES                                                */
/*==============================================================*/
create table FIXES (
   ID_FIXES             INT4                 not null,
   NAME_FIXES           VARCHAR(20)          not null,
   constraint PK_FIXES primary key (ID_FIXES)
);

/*==============================================================*/
/* Table : FLUX                                                 */
/*==============================================================*/
create table FLUX (
   ID_FLUX              SERIAL                 not null,
   ID_PERIODE           INT4                 not null,
   ID_TYPE_FLUX         INT4                 not null,
   ID_FIXES             INT4                 not null,
   ID_CATEGORIE         INT4                 not null,
   DATE_FLUX            DATE                 not null,
   MONTANT              DECIMAL(10,5)        not null,
   TAGS                 VARCHAR(500)         null,
   DESCRIPTION          VARCHAR(1500)        null,
   constraint PK_FLUX primary key (ID_FLUX)
);

/*==============================================================*/
/* Table : PERIODE                                              */
/*==============================================================*/
create table PERIODE (
   ID_PERIODE           INT4                 not null,
   NAME_PERIODE          VARCHAR(20)         not null,
   constraint PK_PERIODE primary key (ID_PERIODE)
);

/*==============================================================*/
/* Table : TYPE_FLUX                                            */
/*==============================================================*/
create table TYPE_FLUX (
   ID_TYPE_FLUX         INT4                 not null,
   NAME_TYPE_FLUX       VARCHAR(20)          not null,
   constraint PK_TYPE_FLUX primary key (ID_TYPE_FLUX)
);

alter table CATEGORIE
   add constraint FK_CATEGORI_EST_ENFAN_CATEGORI foreign key (CAT_ID_CATEGORIE)
      references CATEGORIE (ID_CATEGORIE)
      on delete restrict on update restrict;

alter table FLUX
   add constraint FK_FLUX_CATEGORIS_CATEGORI foreign key (ID_CATEGORIE)
      references CATEGORIE (ID_CATEGORIE)
      on delete restrict on update restrict;

alter table FLUX
   add constraint FK_FLUX_EST_FIXES foreign key (ID_FIXES)
      references FIXES (ID_FIXES)
      on delete restrict on update restrict;

alter table FLUX
   add constraint FK_FLUX_EST_DE_TY_TYPE_FLU foreign key (ID_TYPE_FLUX)
      references TYPE_FLUX (ID_TYPE_FLUX)
      on delete restrict on update restrict;

alter table FLUX
   add constraint FK_FLUX_SE_PASSE_PERIODE foreign key (ID_PERIODE)
      references PERIODE (ID_PERIODE)
      on delete restrict on update restrict;

/*==============================================================*/
/* CREATE VIEWS                                                 */
/*==============================================================*/

CREATE OR REPLACE VIEW vue_Periode AS
   SELECT ID_PERIODE AS "ID Periode", NAME_PERIODE as "Periode"
   FROM PERIODE;

CREATE OR REPLACE VIEW vue_Fixes AS
   SELECT ID_FIXES AS "ID Fixes", NAME_FIXES as "Fixes"
   FROM FIXES;

CREATE OR REPLACE VIEW vue_Type_Flux AS
   SELECT ID_TYPE_FLUX AS "ID Type Flux", NAME_TYPE_FLUX AS "Type Flux"
   FROM TYPE_FLUX;

CREATE OR REPLACE VIEW vue_Categorie AS
   SELECT ID_CATEGORIE AS "ID Categorie", NAME_CATEGORIE AS "Categorie"
   FROM CATEGORIE
   WHERE CAT_ID_CATEGORIE IS NULL;

CREATE OR REPLACE VIEW vue_Sous_Categorie AS
   SELECT c1.ID_CATEGORIE AS "ID Categorie", c2.NAME_CATEGORIE AS "Categorie", c1.NAME_CATEGORIE AS "Sous-Categorie"
   FROM CATEGORIE c1
      JOIN CATEGORIE c2 ON c1.CAT_ID_CATEGORIE = c2.ID_CATEGORIE
   WHERE c1.CAT_ID_CATEGORIE IS NOT NULL;

CREATE OR REPLACE VIEW vue_Flux AS
   SELECT f.id_flux AS "ID Flux", p.name_periode AS "Période", tf.name_type_flux AS "Type de flux", fi.name_fixes AS "Fixes", cp.name_categorie AS "Catégorie", c.name_categorie AS "Sous-catégorie", f.date_flux AS "Date", f.montant as "Montant", f.tags AS "Tags", f.description AS "Description"
   FROM flux f
      JOIN periode p ON f.id_periode = p.id_periode
      JOIN type_flux tf ON f.id_type_flux = tf.id_type_flux
      JOIN fixes fi ON f.id_fixes = fi.id_fixes
      JOIN categorie c ON f.id_categorie = c.id_categorie
      JOIN categorie cp ON c.cat_id_categorie = cp.id_categorie
   ORDER BY 1;

CREATE OR REPLACE VIEW vue_Flux_MAct AS
   SELECT f.id_flux AS "ID Flux", p.name_periode AS "Période", tf.name_type_flux AS "Type de flux", fi.name_fixes AS "Fixes", cp.name_categorie AS "Catégorie", c.name_categorie AS "Sous-catégorie", f.date_flux AS "Date", f.montant as "Montant", f.tags AS "Tags", f.description AS "Description"
   FROM flux f
      JOIN periode p ON f.id_periode = p.id_periode
      JOIN type_flux tf ON f.id_type_flux = tf.id_type_flux
      JOIN fixes fi ON f.id_fixes = fi.id_fixes
      JOIN categorie c ON f.id_categorie = c.id_categorie
      JOIN categorie cp ON c.cat_id_categorie = cp.id_categorie
   WHERE f.date_flux >= date_trunc('month', NOW())::date
   ORDER BY 1;


/*==============================================================*/
/* CREATE PROCEDURE                                             */
/*==============================================================*/

CREATE OR REPLACE PROCEDURE ps_save_csv()
AS
$$
DECLARE
BEGIN 
   COPY PERIODE 
   TO 'R:\CODES\BudgetManagement\2 - DATA\BACKUP\PERIODE.csv' 
   WITH (FORMAT CSV, HEADER TRUE, DELIMITER ';', QUOTE '''');

   COPY TYPE_FLUX
   TO 'R:\CODES\BudgetManagement\2 - DATA\BACKUP\TYPE_FLUX.csv' 
   WITH (FORMAT CSV, HEADER TRUE, DELIMITER ';', QUOTE '''');

   COPY FIXES 
   TO 'R:\CODES\BudgetManagement\2 - DATA\BACKUP\FIXES.csv' 
   WITH (FORMAT CSV, HEADER TRUE, DELIMITER ';', QUOTE '''');

   COPY CATEGORIE
   TO 'R:\CODES\BudgetManagement\2 - DATA\BACKUP\CATEGORIE.csv' 
   WITH (FORMAT CSV, HEADER TRUE, DELIMITER ';', QUOTE '''');

   COPY FLUX 
   TO 'R:\CODES\BudgetManagement\2 - DATA\BACKUP\FLUX.csv' 
   WITH (FORMAT CSV, HEADER TRUE, DELIMITER ';', QUOTE '''');

   COPY (SELECT * FROM vue_Flux) 
   TO 'R:\CODES\BudgetManagement\2 - DATA\BACKUP\VUE_FLUX.csv' 
   WITH (FORMAT CSV, HEADER TRUE, DELIMITER ';', QUOTE '''');

   COPY (SELECT * FROM vue_Flux_MAct) 
   TO 'R:\CODES\BudgetManagement\2 - DATA\BACKUP\VUE_FLUX_MAct.csv' 
   WITH (FORMAT CSV, HEADER TRUE, DELIMITER ';', QUOTE '''');
END;
$$ LANGUAGE 'plpgsql';

/*==============================================================*/
/* INSERT DATA                                                  */
/*==============================================================*/

INSERT INTO FIXES(ID_FIXES, NAME_FIXES) VALUES (1, 'Fixe');
INSERT INTO FIXES(ID_FIXES, NAME_FIXES) VALUES (2, 'Variable');
INSERT INTO FIXES(ID_FIXES, NAME_FIXES) VALUES (3, 'Exceptionnel');


INSERT INTO TYPE_FLUX(ID_TYPE_FLUX, NAME_TYPE_FLUX) VALUES (1, 'Entrée');
INSERT INTO TYPE_FLUX(ID_TYPE_FLUX, NAME_TYPE_FLUX) VALUES (2, 'Sortie');
INSERT INTO TYPE_FLUX(ID_TYPE_FLUX, NAME_TYPE_FLUX) VALUES (3, 'Neutre');
INSERT INTO TYPE_FLUX(ID_TYPE_FLUX, NAME_TYPE_FLUX) VALUES (4, 'Réparation');

INSERT INTO PERIODE(ID_PERIODE, NAME_PERIODE) VALUES (1, 'Entreprise');
INSERT INTO PERIODE(ID_PERIODE, NAME_PERIODE) VALUES (2, 'Ecole');
INSERT INTO PERIODE(ID_PERIODE, NAME_PERIODE) VALUES (3, 'Vacances');

INSERT INTO CATEGORIE(ID_CATEGORIE, NAME_CATEGORIE) VALUES (1, 'Courses');
INSERT INTO CATEGORIE(ID_CATEGORIE, NAME_CATEGORIE) VALUES (2, 'Mode');
INSERT INTO CATEGORIE(ID_CATEGORIE, NAME_CATEGORIE) VALUES (3, 'Esthétique');
INSERT INTO CATEGORIE(ID_CATEGORIE, NAME_CATEGORIE) VALUES (4, 'Hygiène');
INSERT INTO CATEGORIE(ID_CATEGORIE, NAME_CATEGORIE) VALUES (5, 'Abonnement');
INSERT INTO CATEGORIE(ID_CATEGORIE, NAME_CATEGORIE) VALUES (6, 'Transports');
INSERT INTO CATEGORIE(ID_CATEGORIE, NAME_CATEGORIE) VALUES (7, 'Logement');
INSERT INTO CATEGORIE(ID_CATEGORIE, NAME_CATEGORIE) VALUES (8, 'Aide');
INSERT INTO CATEGORIE(ID_CATEGORIE, NAME_CATEGORIE) VALUES (9, 'Divertissement');
INSERT INTO CATEGORIE(ID_CATEGORIE, NAME_CATEGORIE) VALUES (10, 'Emprunt');
INSERT INTO CATEGORIE(ID_CATEGORIE, NAME_CATEGORIE) VALUES (11, 'Emploi');
INSERT INTO CATEGORIE(ID_CATEGORIE, NAME_CATEGORIE) VALUES (12, 'Epargne');
INSERT INTO CATEGORIE(ID_CATEGORIE, NAME_CATEGORIE) VALUES (13, 'Impôts');
INSERT INTO CATEGORIE(ID_CATEGORIE, NAME_CATEGORIE) VALUES (14, 'Santé');
INSERT INTO CATEGORIE(ID_CATEGORIE, NAME_CATEGORIE) VALUES (15, 'Autre');
INSERT INTO CATEGORIE(ID_CATEGORIE, NAME_CATEGORIE) VALUES (16, 'Cadeau');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (17, 1, 'Viandes');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (18, 1, 'Fromages');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (19, 1, 'Légumes');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (20, 1, 'Fruits');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (21, 1, 'Sauces');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (22, 1, 'Café');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (23, 1, 'Sucrerie');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (24, 1, 'Pain');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (25, 1, 'Desserts');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (26, 1, 'Féculents');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (27, 1, 'Epices');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (28, 1, 'Apéritifs');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (29, 1, 'Soda');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (30, 1, 'Alcool');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (31, 1, 'Jus');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (32, 1, 'Sirop');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (33, 1, 'Lait');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (34, 2, 'Haut');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (35, 2, 'T-shirt');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (36, 2, 'Bas');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (37, 2, 'Sous-Vêtements');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (38, 2, 'Chaussures');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (39, 2, 'Chaussettes');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (40, 2, 'Accessoires');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (41, 2, 'Pyjama');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (42, 3, 'Shampoing');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (43, 3, 'Gel');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (44, 3, 'Visage');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (45, 3, 'Dentaire');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (46, 3, 'Crème');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (47, 3, 'Coiffeur');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (48, 3, 'Savon');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (49, 4, 'Lessive');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (50, 4, 'Vaisselle');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (51, 4, 'Ménage');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (52, 4, 'Sanitaire');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (53, 4, 'Oreiller');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (54, 4, 'Taies oreiller');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (55, 4, 'Couette');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (56, 4, 'Housse de couette');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (57, 4, 'Drap Housse');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (58, 4, 'Protège Oreiller');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (59, 4, 'Protège Matelas');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (60, 5, 'Streaming');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (61, 5, 'Sports');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (62, 5, 'Internet');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (63, 5, 'Mobile');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (64, 6, 'Carburant');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (65, 6, 'Huile Moteur');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (66, 6, 'Assurance véhicule');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (67, 6, 'Garage');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (68, 6, 'Entretien véhicule');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (69, 6, 'Autoroute');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (70, 6, 'Bus');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (71, 6, 'Tram');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (72, 6, 'Train');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (73, 6, 'Avion');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (74, 6, 'Covoiturage');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (75, 6, 'Vélo');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (76, 6, 'Parking');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (77, 7, 'Loyer');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (78, 7, 'Eau');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (79, 7, 'Electricité');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (80, 7, 'Chauffage');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (81, 7, 'Assurance logement');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (82, 7, 'Copropriété');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (83, 8, 'APL');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (84, 8, 'CAF');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (85, 8, 'Mobili-Jeune');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (86, 9, 'Cinéma');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (87, 9, 'Restauration');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (88, 9, 'Cantine');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (89, 9, 'Brasserie');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (90, 9, 'Vacances');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (91, 9, 'Jeux-vidéos');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (92, 9, 'Café');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (93, 9, 'Boulangerie');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (94, 9, 'Informatique');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (95, 10, 'Famille');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (96, 10, 'Ami');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (97, 10, 'Bancaire');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (98, 11, 'Salaire');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (99, 11, 'Primes');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (100, 11, 'Chèques cadeaux');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (101, 11, 'Chèques vacances');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (102, 12, 'Livret A');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (103, 12, 'Revolut');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (104, 12, 'Espèces');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (105, 12, 'Actions');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (106, 12, 'BoursoBank');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (107, 13, 'Impôts');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (108, 14, 'Santé');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (109, 15, 'Autre');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (110, 16, 'Don');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (111, 16, 'Famille');
INSERT INTO CATEGORIE(ID_CATEGORIE, CAT_ID_CATEGORIE, NAME_CATEGORIE) VALUES (112, 16, 'Ami');