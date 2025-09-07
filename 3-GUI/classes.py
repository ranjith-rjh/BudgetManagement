import psycopg2

'''
This files defines the different entities of the databases in form of Python classes.
That way we are able to request query on the database and create Python objects.

Once done it will be easier to manipulate objects
'''

class Periode :
    
    def __init__(self, id_periode, name_periode) :
        self.id_periode = id_periode
        self.name_periode = name_periode


    def __str__(self) :
        return f'Objet de la classe Periode : ID --> {self.id_periode}; Name --> {self.name_periode}'

    def get_instances(cursor) :
        periode = []
        query = 'SELECT * FROM vue_Periode'

        cursor.execute(query)

        for row in cursor.fetchall() :
            id_periode, name_periode = row
            periode_instance = Periode(id_periode=id_periode, name_periode=name_periode)
            periode.append(periode_instance)
        
        return periode
    
    def get_id_by_name(name, list) :

        for row in list :
            if row.name_periode == name :
                return row.id_periode

    def get_name_by_id (id, list) :

        for row in list :
            if row.id_periode == id :
                return row.name_periode
            
    def get_names(list) :
        names = []
        for row in list :
            names.append(row.name_periode)
        return names

class Fixes : 

    def __init__(self, id_fixe, name_fixe) :
        self.id_fixe = id_fixe
        self.name_fixe = name_fixe
    
    def __str__(self) :
        return f'Objet de la classe Fixe : ID --> {self.id_fixe}; Name --> {self.name_fixe}'

    def get_instances(cursor) :
        fixes = []
        query = 'SELECT * FROM vue_Fixes'

        cursor.execute(query)

        for row in cursor.fetchall() :
            id_fixe, name_fixe = row
            fixes_instance = Fixes(id_fixe=id_fixe, name_fixe=name_fixe)
            fixes.append(fixes_instance)
        
        return fixes
    
    def get_id_by_name(name, list) :

        for row in list :
            if row.name_fixe == name :
                return row.id_fixe

    def get_name_by_id (id, list) :

        for row in list :
            if row.id_fixe == id :
                return row.name_fixe
            
    def get_names(list) :
        names = []
        for row in list :
            names.append(row.name_fixe)
        return names
            
class Type_Flux :
    
    def __init__(self, id_type_flux, name_type_flux) :
        self.id_type_flux = id_type_flux
        self.name_type_flux = name_type_flux


    def __str__(self) :
        return f'Objet de la classe Type Flux : ID --> {self.id_type_flux}; Name --> {self.name_type_flux}'

    def get_instances(cursor) :
        type_flux = []
        query = 'SELECT * FROM vue_Type_Flux'

        cursor.execute(query)

        for row in cursor.fetchall() :
            id_type_flux, name_type_flux = row
            type_flux_instance = Type_Flux(id_type_flux=id_type_flux, name_type_flux=name_type_flux)
            type_flux.append(type_flux_instance)
        
        return type_flux
    
    def get_id_by_name(name, list) :

        for row in list :
            if row.name_type_flux == name :
                return row.id_type_flux

    def get_name_by_id (id, list) :

        for row in list :
            if row.id_type_flux == id :
                return row.name_type_flux
            
    def get_names(list) :
        names = []
        for row in list :
            names.append(row.name_type_flux)
        return names
            

class Categorie : 

    def __init__(self, id_categorie, id_parent, name_categorie, target_categorie) :
        self.id_categorie = id_categorie
        self.id_parent = id_parent
        self.name_categorie = name_categorie
        self.target_categorie = target_categorie


    def __str__(self) :
        return f'Objet de la classe Categorie : ID --> {self.id_categorie}; Parent --> {self.id_parent}; Name --> {self.name_categorie}'
    
    def get_instances(cursor) :
        categorie = []
        query = 'SELECT * FROM categorie ORDER BY 1'

        cursor.execute(query)

        for row in cursor.fetchall() :
            id_categorie, id_parent, name_categorie, target_categorie = row
            categorie_instance = Categorie(id_categorie=id_categorie, id_parent=id_parent, name_categorie=name_categorie, target_categorie=target_categorie)
            categorie.append(categorie_instance)
        
        return categorie
    
    def get_parent_list(list) :
        categorie_parents = []
        for row in list : 
            if row.id_parent is None : 
                categorie_parents.append(row)
        return categorie_parents
    
    def get_child_list(list) :
        categorie_enfants = []
        for row in list : 
            if row.id_parent is not None : 
                categorie_enfants.append(row)
        return categorie_enfants
    
    def get_id_by_name(name, list) :
        res = []
        for row in list :
            if row.name_categorie == name :
                res.append(row.id_categorie)
        return res[-1]
            
    def get_name_by_id(id, list) :
        for row in list : 
            if row.id_categorie == id :
                return row.name_categorie
            
    def get_parent_id_by_child_id(id_child, list) :
        for row in list :
            if row.id_categorie == id_child :
                return row.id_parent
            
    def get_parent_name_by_child_id(id_child, list) :
        id_parent = Categorie.get_parent_id_by_child_id(id_child, list)
        return Categorie.get_name_by_id(id_parent, list)
    
    def get_child_list_by_parent_id(id_parent, list) :
        child_list = []
        for row in list:
            if row.id_parent == id_parent :
                child_list.append(row)
        return child_list
    
    def get_child_list_by_parent_name(name_parent, list) :
        child_list = []
        id_parent = Categorie.get_id_by_name(name_parent, list)
        return Categorie.get_child_list_by_parent_id(id_parent, list)
    
    def get_names(list) :
        names = []
        for row in list :
            names.append(row.name_categorie)
        return names
    

class Flux : 

    def __init__(
            self,
            id_periode,
            id_type_flux,
            id_fixes,
            id_categorie,
            date_flux,
            montant,
            tags = None,
            description = None,
    ) :
            self.id_periode = id_periode
            self.id_type_flux = id_type_flux
            self.id_fixes = id_fixes
            self.id_categorie = id_categorie
            self.date_flux = date_flux
            self.montant = montant
            self.tags = tags
            self.description = description

    def __str__(self) :
        res =  f'''Objet de la classe Flux : 
                id_periode --> {self.id_periode}
                id_type_flux --> {self.id_type_flux}
                id_fixes --> {self.id_fixes}
                id_categorie --> {self.id_categorie}
                date_flux --> {self.date_flux}
                montant --> {self.montant}
                tags --> {self.tags}
                description --> {self.description}
                '''
        return res
    
    def insert_flux(flux, cursor, conn) :
        try :

            query = 'SELECT MAX(id_flux) FROM Flux'

            cursor.execute(query)

            for row in cursor.fetchall() :
                id_flux_max = row[0]

            id_flux_max = id_flux_max + 1

            query = f"INSERT INTO FLUX (ID_PERIODE, ID_TYPE_FLUX, ID_FIXES, ID_CATEGORIE, DATE_FLUX, MONTANT, TAGS, DESCRIPTION) \
                VALUES ({flux.id_periode}, {flux.id_type_flux}, {flux.id_fixes}, {flux.id_categorie}, '{flux.date_flux}', {flux.montant}, '{flux.tags}', '{flux.description}');"

            cursor.execute(query)
            conn.commit()

            print(f'{id_flux_max} - INSERTED : {flux.description} ({flux.tags})')

            return True
        
        except Exception as e :

            print('Erreur : ' + str(e))
            return False