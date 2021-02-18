//
//  DetailVC.swift
//  MovieAssignment
//
//  Created by Ankur on 18/02/21.
//

import UIKit

class DetailVC: UIViewController
{
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var lblMovieTitle: UILabel!
    @IBOutlet weak var lblMovieRating: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgMovie: UIImageView!
    var arrActorListFullArray : [[JSON]] = []
    var actorList : [JSON] = []
    var movieId = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        movieDetailApi()
    }
    
    //MARK: - API CALL TO GET MOVIE DETAILS
    
    func movieDetailApi()
    {
        APIController.getMovieDetail(id: movieId) { (response) in
            print(response)
            if response["errorMessage"] == ""
            {
                let data = response.dictionaryValue
                let movieTitle = data["fullTitle"]?.stringValue
                let imdbRating = data["imDbRating"]?.stringValue
                let releaseDate = data["releaseDate"]?.stringValue
                let plot = data["plot"]?.stringValue
                let image = data["image"]?.stringValue
                let actorList = data["actorList"]?.arrayValue
                self.arrActorListFullArray.append(actorList ?? [])
                self.lblMovieTitle.text = movieTitle
                self.lblMovieRating.text = "IMDb rating: " + imdbRating!
                self.lblReleaseDate.text = "Release date: " + releaseDate!
                self.lblDescription.text = plot
                self.imgMovie.sd_setImage(with: URL(string: image ?? ""), placeholderImage: UIImage(named: "placeholder"))
            }
            self.actorList = self.arrActorListFullArray[0]
            print(self.arrActorListFullArray)
            print("sself.actorList", self.actorList)
            self.collView.reloadData()
        }
    }
    
}

extension DetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(actorList.count)
        return actorList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath) as! DetailCollectionViewCell
        cell.lblMovieName.text = actorList[indexPath.row]["name"].stringValue
        cell.imgMovie.sd_setImage(with: URL(string: actorList[indexPath.row]["image"].stringValue ), placeholderImage: UIImage(named: "placeholder"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width:80, height:collectionView.frame.height);
    }
}
