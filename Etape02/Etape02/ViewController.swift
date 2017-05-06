//  ViewController.swift
//  Etape02
//  ----------------------------------------------------
//  Contenu:
//
//  Populer une entité à partir de données locales (fichier.plist)

import UIKit
import CoreData

class ViewController: UIViewController {
    var contexteDeLaBD: NSManagedObjectContext!
    
    @IBAction func viderEntitéCours(_ sender: Any) {
        print("viderEntitéCours")
        let fetchRequest:NSFetchRequest<Cours> = Cours.fetchRequest()
        let request = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        try! contexteDeLaBD.execute(request)
        afficherLesCours()
    } // viderEntitéCours
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Obtenir le contexte de la BD
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate  {
            contexteDeLaBD =  appDelegate.persistentContainer.viewContext
        } else
        { print("Erreur:  Impossible d'obtenir le contexte de la BD")
            return
        } // if let
        
        if entitéCoursVide() {
            print("L'entité 'cours' sera initialisée...")
            intialiserLesDonnéesDeLaBD()
        } else
        {
            print("😜, Il y a déja des données dans l'entité cours ...")
        }
        afficherLesCours()
    }
    
    func intialiserLesDonnéesDeLaBD(){
        var lesCours:Array<Dictionary<String,String>> = []
        
        // Obtenir les données du fichier local (plist)
        let pathFichierPlist = Bundle.main.path(forResource: "listeDesCours", ofType: "plist")!
        lesCours = NSArray(contentsOfFile: pathFichierPlist) as! Array
        
        for cours in lesCours {
            print(cours)
            let unCours = Cours(context: contexteDeLaBD)
            unCours.numero  = cours["numero"]!
            unCours.nom     = cours["nom"]
            try! contexteDeLaBD.save()
        }
        
        
    } // intialiserLesDonnéesDeLaBD
    
    func afficherLesCours() {
        // Préparer la requête
        let fetchRequest:NSFetchRequest<Cours> = Cours.fetchRequest()
        // Chercher les cours
        let lesCours = try! contexteDeLaBD.fetch(fetchRequest)
        // Afficher les cours
        guard lesCours.count > 0 else {
            print("🎭, il n'y a rien à afficher pour l'entité Cours")
            return
        }
        
        for cours in lesCours {
            print (cours.numero!, cours.nom!)
        }
    } // afficherLesCours()
    
    func entitéCoursVide() -> Bool {
        // Préparer la requête
        let fetchRequest:NSFetchRequest<Cours> = Cours.fetchRequest()
        // Chercher les cours
        let lesCours = try! contexteDeLaBD.fetch(fetchRequest)
        
        return lesCours.count == 0 ? true : false
    } // entitéCoursVide
    
    
}

