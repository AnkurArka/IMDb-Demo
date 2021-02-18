//
//  HomeVC.swift
//  MovieAssignment
//
//  Created by Ankur on 18/02/21.
//

import UIKit
import Alamofire
import CoreData
import SDWebImage

class HomeVC: UIViewController
{
    @IBOutlet weak var collview: UICollectionView!
    var arrMovieName : [String] = []
    var arrMovieImg : [String] = []
    var count = 0
    var movieCount = 50
    var movieList = [listOfMovies]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        movieListApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //MARK: - FETCH FROM CORE DATA
        
        self.movieList.removeAll()
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieList")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let datalist  = ["imDbRatingCount":data.value(forKey: "imDbRatingCount") as! String,"title":data.value(forKey: "title") as! String,"year":data.value(forKey: "year") as! String,"imDbRating":data.value(forKey: "imDbRating") as! String,"id":data.value(forKey: "id") as! String,"rank":data.value(forKey: "rank") as! String,"fullTitle":data.value(forKey: "fullTitle") as! String,"crew":data.value(forKey: "crew") as! String,"image":data.value(forKey: "image") as! String]
                self.movieList.append(listOfMovies(datalist))
                self.collview.reloadData()
          }
        } catch {
            movieListApi()
            print("Failed")
        }
    }
    
    //MARK: - API CALL TO GET MOVIES LIST
    
    func movieListApi()
    {
        APIController.getMovieList { (response) in
            self.movieList.removeAll()
            if response["errorMessage"] == ""
            {
                let data  = response["items"].arrayValue
                self.count = data.count
                
                //MARK: - APPEND TO CORE DATA
                let context = self.appDelegate.persistentContainer.viewContext
               _ = data.compactMap { (list) in
                    let entity = NSEntityDescription.entity(forEntityName: "MovieList", in: context)
                    let newUser = NSManagedObject(entity: entity!, insertInto: context)
                newUser.setValue(list["imDbRatingCount"].stringValue, forKey: "imDbRatingCount")
                newUser.setValue(list["title"].stringValue, forKey: "title")
                newUser.setValue(list["year"].stringValue, forKey: "year")
                newUser.setValue(list["imDbRating"].stringValue, forKey: "imDbRating")
                newUser.setValue(list["id"].stringValue, forKey: "id")
                newUser.setValue(list["rank"].stringValue, forKey: "rank")
                newUser.setValue(list["fullTitle"].stringValue, forKey: "fullTitle")
                newUser.setValue(list["crew"].stringValue, forKey: "crew")
                newUser.setValue(list["image"].stringValue, forKey: "image")
                let datalist  = ["imDbRatingCount":list["imDbRatingCount"].stringValue,"title":list["title"].stringValue,"year":list["year"].stringValue,"imDbRating":list["imDbRating"].stringValue,"id":list["id"].stringValue,"rank":list["rank"].stringValue,"fullTitle":list["fullTitle"].stringValue,"crew":list["crew"].stringValue,"image":list["image"].stringValue]
                self.movieList.append(listOfMovies(datalist))
                self.collview.reloadData()
                do {
                   try context.save()
                  } catch {
                   print("Failed saving")
                }
                }
            }
        }
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        count = movieList.count
        return movieCount + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collview.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
        let cellsec = collview.dequeueReusableCell(withReuseIdentifier: "LoadMoreCell", for: indexPath) as! LoadMoreCell
        cellsec.viewLoadMore.layer.borderWidth = 1.5
        cellsec.viewLoadMore.layer.borderColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1).cgColor
        if indexPath.row <= (movieCount - 1)
        {
            if count > 0
            {
                cell.lblMovieName.text = movieList[indexPath.item].fullTitle
                cell.imgThumb.sd_setImage(with: URL(string: movieList[indexPath.item].image ?? ""), placeholderImage: UIImage(named: "placeholder"))
            }
            
            return cell
        }else
        {
            return cellsec
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if indexPath.row < movieCount
        {
            return CGSize(width:collectionView.frame.width/2 - 5, height:collectionView.frame.width - (collectionView.frame.width/3))
        }
        else
        {
            if count == movieCount
            {
                return CGSize(width: 0, height: 0)
            }
            else
            {
                return CGSize(width: collectionView.frame.width, height: 80)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if indexPath.row == movieCount
        {
            movieCount = movieCount + 50
            collview.reloadData()
        }
        else
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
            vc.movieId = movieList[indexPath.item].id ?? ""
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
