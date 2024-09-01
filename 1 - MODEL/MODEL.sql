drop table if exists CATEGORIE CASCADE;

drop table if exists FIXES CASCADE;

drop table if exists FLUX CASCADE;

drop table if exists PERIODE CASCADE;

drop table if exists TYPE_FLUX CASCADE;

/*==============================================================*/
/* Table : CATEGORIE                                            */
/*==============================================================*/
create table CATEGORIE (
   ID_CATEGORIE         INT4                 not null,
   CAT_ID_CATEGORIE     INT4                 not null,
   NAME_CATEGORIE       VARCHAR(50)          null,
   constraint PK_CATEGORIE primary key (ID_CATEGORIE)
);

/*==============================================================*/
/* Table : FIXES                                                */
/*==============================================================*/
create table FIXES (
   ID_FIXES             INT4                 not null,
   NAME_FIXES           VARCHAR(20)          null,
   constraint PK_FIXES primary key (ID_FIXES)
);

/*==============================================================*/
/* Table : FLUX                                                 */
/*==============================================================*/
create table FLUX (
   ID_FLUX              INT4                 not null,
   ID_TYPE_FLUX         INT4                 not null,
   ID_PERIODE           INT4                 not null,
   ID_FIXES             INT4                 not null,
   ID_CATEGORIE         INT4                 null,
   DATE_FLUX            DATE                 null,
   MONTANT              DECIMAL(10,5)        null,
   DESCRIPTION          VARCHAR(1500)        null,
   TAGS                 VARCHAR(500)         null,
   constraint PK_FLUX primary key (ID_FLUX)
);

/*==============================================================*/
/* Table : PERIODE                                              */
/*==============================================================*/
create table PERIODE (
   ID_PERIODE           INT4                 not null,
   NOM_PERIODE          VARCHAR(20)          null,
   constraint PK_PERIODE primary key (ID_PERIODE)
);

/*==============================================================*/
/* Table : TYPE_FLUX                                            */
/*==============================================================*/
create table TYPE_FLUX (
   ID_TYPE_FLUX         INT4                 not null,
   NAME_TYPE_FLUX       VARCHAR(20)          null,
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
