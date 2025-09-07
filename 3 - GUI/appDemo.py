# Importer les modules

import datetime as dt
import tkinter as tk
import customtkinter as ctk
import psycopg2
from classes import *

# Créer la classe App

class App(ctk.CTk) :
    def __init__(self, *args, **kwargs) :
        super().__init__(*args, **kwargs)

        self.title('My App')
        self.geometry('900x500')

        # -------------------------- Variables for later
        self.sous_categories_names = []
        self.sous_categories_text = ctk.StringVar(value='Choisir')

        # -------------------------- Input Periode
        self.periode_label = ctk.CTkLabel(self, text='Période :')
        self.periode_label.grid(
            row = 0, column = 0,
            padx = 20, pady = 20,
            sticky = 'ew'
        )

        self.periode_input = ctk.CTkComboBox(master=self, values=periode_names)
        self.periode_input.grid(
            row = 0, column = 1,
            sticky = 'ew'
        )

        # -------------------------- Input Type Flux
        self.type_flux_label = ctk.CTkLabel(self, text='Type Flux :')
        self.type_flux_label.grid(
            row = 0, column = 2,
            padx = 20, pady = 20,
            sticky = 'ew'
        )

        self.type_flux_input = ctk.CTkComboBox(master=self, values=type_flux_names)
        self.type_flux_input.grid(
            row = 0, column = 3,
            sticky = 'ew'
        )

        # -------------------------- Input Fixes
        self.fixes_label = ctk.CTkLabel(self, text='Fixes :')
        self.fixes_label.grid(
            row = 0, column = 4,
            padx = 20, pady = 20,
            sticky = 'ew'
        )

        self.fixes_input = ctk.CTkComboBox(master=self, values=fixes_names)
        self.fixes_input.grid(
            row = 0, column = 5,
            sticky = 'ew'
        )

        # -------------------------- Input Categorie

        self.categories_label = ctk.CTkLabel(self, text='Catégorie :')
        self.categories_label.grid(
            row = 1, column = 0,
            padx = 20, pady = 20,
            sticky = 'ew'
        )

        self.categories_input = ctk.CTkComboBox(master=self, values=categories_parents_names, command=self.refresh_sous_categories)
        self.categories_input.grid(
            row = 1, column = 1,
            sticky = 'ew'
        )

        # -------------------------- Input Sous-Categorie

        self.sous_categories_label = ctk.CTkLabel(self, text='Sous-Catégorie :')
        self.sous_categories_label.grid(
            row = 1, column = 2,
            padx = 20, pady = 20,
            sticky = 'ew'
        )

        self.sous_categories_input = ctk.CTkComboBox(master=self, values=self.sous_categories_names, variable=self.sous_categories_text)
        self.sous_categories_input.grid(
            row = 1, column = 3,
            sticky = 'ew'
        )

        # -------------------------- Input Date

        self.date_label = ctk.CTkLabel(self, text='Date :')
        self.date_label.grid(
            row = 2, column = 0,
            padx = 20, pady = 20,
            sticky = 'ew'
        )

        # self.date_input = ctk.CTkEntry(master=self, placeholder_text='DD-MM-YYYY')
        self.date_input = ctk.CTkEntry(master=self)
        self.date_input.insert(0, today_date)
        self.date_input.grid(
            row = 2, column = 1,
            sticky = 'ew'
        )

        # -------------------------- Input Montant

        self.montant_label = ctk.CTkLabel(self, text='Montant :')
        self.montant_label.grid(
            row = 2, column = 2,
            padx = 20, pady = 20,
            sticky = 'ew'
        )

        self.montant_input = ctk.CTkEntry(master=self, placeholder_text='XXXX.XX')
        self.montant_input.grid(
            row = 2, column = 3,
            sticky = 'ew'
        )

        # -------------------------- Input tags
            
        self.tags_label = ctk.CTkLabel(self, text='Tags :')
        self.tags_label.grid(
            row = 2, column = 4,
            padx = 20, pady = 20,
            sticky = 'ew'
        )

        self.tags_input = ctk.CTkEntry(master=self, placeholder_text='#topic')
        self.tags_input.grid(
            row = 2, column = 5,
            sticky = 'ew'
        )

        # -------------------------- Input Description
        
        self.description_label = ctk.CTkLabel(self, text='Description :')
        self.description_label.grid(
            row = 3, column = 0,
            padx = 20, pady = 20,
            sticky = 'ew'
        )

        self.description_input = ctk.CTkTextbox(master=self, width=500, height=150)
        self.description_input.grid(
            row = 3, column = 1, columnspan=6,
            padx = 20, pady = 30,
            sticky = 'nsew'
        )

        # -------------------------- Input Button

        self.insert_button = ctk.CTkButton(self, text='Ajouter', command=self.insert_flux)
        self.insert_button.grid(
            row = 4, column = 1, columnspan=6,
            padx = 20, pady  = 20,
            sticky = 'ew'
        )



    def refresh_sous_categories(self, event) :
        categorie_parent_id = Categorie.get_id_by_name(self.categories_input.get(), categorie_parents)
        sous_categories = Categorie.get_child_list_by_parent_id(categorie_parent_id, categories_instances)
        self.sous_categories_names = Categorie.get_names(sous_categories)
        self.sous_categories_input.configure(True, variable=self.sous_categories_text, values=self.sous_categories_names)


    def insert_flux(self) :

        # Get the values of Combo boxes to find the related ID numbers
        v_id_periode = Periode.get_id_by_name(self.periode_input.get(), periode_instances)
        v_id_type_flux = Type_Flux.get_id_by_name(self.type_flux_input.get(), type_flux_instances)
        v_id_fixes = Fixes.get_id_by_name(self.fixes_input.get(), fixes_instances)
        v_categories = Categorie.get_id_by_name(self.categories_input.get(), categorie_parents)
        categorie_enfants = Categorie.get_child_list_by_parent_id(v_categories, categories_instances)
        v_id_categorie = Categorie.get_id_by_name(self.sous_categories_input.get(), categorie_enfants)


        print(f'ID Parent : {v_categories} | ID Enfant : {v_id_categorie}')


        # Get the values of text boxes
        v_date_flux = self.date_input.get()
        v_montant = self.montant_input.get()
        v_tags = self.tags_input.get()
        v_description = self.description_input.get('1.0', 'end-1c')

        # Formatting to accept double quotes
        v_tags = v_tags.replace("'", "''")
        v_description = v_description.replace("'", "''")

        # Create a Flux object using the collected values
        flux = Flux(
            id_periode = v_id_periode,
            id_type_flux = v_id_type_flux,
            id_fixes = v_id_fixes,
            id_categorie = v_id_categorie,
            date_flux = v_date_flux,
            montant = v_montant,
            tags = v_tags,
            description = v_description,
        )

        query = f"INSERT INTO FLUX (ID_PERIODE, ID_TYPE_FLUX, ID_FIXES, ID_CATEGORIE, DATE_FLUX, MONTANT, TAGS, DESCRIPTION) \
            VALUES ({flux.id_periode}, {flux.id_type_flux}, {flux.id_fixes}, {flux.id_categorie}, '{flux.date_flux}', {flux.montant}, '{flux.tags}', '{flux.description}');"
        
        # print(query)

        Flux.insert_flux(flux, cursor, conn)



if __name__ == '__main__' :
    conn = ''

    try :
        conn = psycopg2.connect(
            host = "localhost",
            port = "5432",
            user = "postgres",
            password = "postgres",
            dbname = "BudgetDemo"
        )    

    except Exception as e: 
        print(e)

    # Connect to Database and get informations

    cursor = conn.cursor()

    periode_instances = Periode.get_instances(cursor)
    periode_names = Periode.get_names(periode_instances)

    type_flux_instances = Type_Flux.get_instances(cursor)
    type_flux_names = Type_Flux.get_names(type_flux_instances)

    fixes_instances = Fixes.get_instances(cursor)
    fixes_names = Fixes.get_names(fixes_instances)

    categories_instances = Categorie.get_instances(cursor)

    categorie_parents = Categorie.get_parent_list(categories_instances)
    categories_parents_names = Categorie.get_names(categorie_parents)

    today_date = dt.datetime.now().date().strftime('%d-%m-%Y')

    app = App()
    app.mainloop()