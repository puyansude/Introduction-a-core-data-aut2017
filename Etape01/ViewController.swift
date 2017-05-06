//  ViewController.swift
//  Etape01
//  ------------------------------------------
//  Contenu:
// 
//  1 - Utilisation du pointeur vers le dataStore du projet
//  2 - Obtenir le contexte de la BD
//  3 - Création d'un objet de type 'classe entité'
//  4 - Renseigner les propriétés du l'objet
//  5 - Enregistrer l'objet dans la BD
//  6 - Obtenir tous les objets d'une entité puis les afficher

import UIKit

// MARK: contenu 1
import CoreData

class ViewController: UIViewController {

    // MARK: contenu 1
    var contexteDuModèleObjet: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: contenu 2 - Obtenir le contexte de la BD
        // Le contexte de la BD est disponible dans la classe 'AppDelegate.swift' du projet
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate  {
            contexteDuModèleObjet =  appDelegate.persistentContainer.viewContext
        } else
            { print("Erreur:  Impossible d'obtenir le contexte de la BD")
              return
        } // if let

        print("👻: ", contexteDuModèleObjet)
        
        //  MARK: 3 - Création d'un objet 'Cours' de type 'classe entité'
        //  Note: Xcode va automatiquement générer des classes
        //  à partir des entités du schéma de la BD du projet.
        let unCours = Cours(context: contexteDuModèleObjet)

        // MARK: 4 - Renseigner les propriétés de l'objet
        unCours.numero  = "📚 482-ICD-1"
        unCours.nom     = "Introduction à core data niveau 1"

        // MARK: 5 - Enregistrer l'objet dans la BD
        do  {
                try contexteDuModèleObjet.save()
            }
        catch
                let error as NSError
            {
                print("Impossible d'enregistrer les données. \(error), \(error.userInfo)")
            }

        // MARK: 6 - Obtenir tous les objets d'une entité puis les afficher
        // 6.1 - créer une requête d'intérogation
        let fetchRequest:NSFetchRequest<Cours> = Cours.fetchRequest()
        // 6.2 - exécuter la requête. Par defaut, la requete est 'select * from'
        do {
            // Création d'un tableau de cours, [Cours]
            let lesCours = try contexteDuModèleObjet.fetch(fetchRequest)
           
            // 6.3 - Afficher les cours
            for cours in lesCours {
                print (cours.numero!, cours.nom!)
            }
 
        } catch let error as NSError {
            print("Impossible de chercher les données. \(error), \(error.userInfo)")
        }

        // Ajouter des cours via une méthode
        ajouterDesCours(5)
        let lesCours = try! contexteDuModèleObjet.fetch(fetchRequest)
        
        // Afficher les cours
        print("----------------------------------------------")
        for cours in lesCours {
            print (cours.numero!, cours.nom!)
        }

        
    } // viewDidLoad


} // class ViewController

extension ViewController {

    func ajouterDesCours(_ nombre:Int){
        for i in 2...nombre + 1 {
            // print("i = \(i)")
            // Créer un cours
            let unCours = Cours(context: contexteDuModèleObjet)
            unCours.numero  = "📕 482-ICD-\(i)"
            unCours.nom     = "Introduction à core data niveau \(i)"
            
            // Enregistrer l'objet dans la BD
            do  {
                try contexteDuModèleObjet.save()
            }
            catch
                let error as NSError
            {
                print("Impossible d'enregistrer les données. \(error), \(error.userInfo)")
            }
        } // for
    } // ajouterDesCours
} // extension ViewController
