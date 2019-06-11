//
//  ReadViewController.swift
//  wstoriette
//
//  Created by Reksa on 06/06/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import UIKit
import AVFoundation

class ReadViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    var isiContent = [StoryContent]()
    let contentCellId = "contentCellId"
    var fid: String?
    var player: AVPlayer!
    var ftitle: String?
    var imgURLTumb: String?
    
    /*struct newIsiContent {
        let ncontent: String
    }
    
    var ncontent = [newIsiContent]()
    
    var contentArr = [newIsiContent]()*/
    
    var contentArr = [String]()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.color = .darkGray
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    func setupActivityIndicator() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerInSuperview()
    }
    
    let closeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        btn.tintColor = .darkGray
        return btn
    }()
    
    let nightButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "night"), for: .normal)
        btn.tintColor = .darkGray
        return btn
    }()
    
    @objc func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupClosebtn() {
        view.addSubview(closeButton)
        closeButton.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        closeButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 55, left: 0, bottom: 0, right: 20), size: .init(width: 35, height: 35))
        closeButton.clipsToBounds = true
        closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    }
    
    func setupNightbtn() {
        view.addSubview(nightButton)
        nightButton.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        nightButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 55, left: 0, bottom: 0, right: 60), size: .init(width: 35, height: 35))
        nightButton.clipsToBounds = true
        nightButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupClosebtn()
        setupFloatingControl()
        fetchStory()
        setupActivityIndicator()
    }
    
    func fetchStory() {
        let post_url_string = "https://storiette-api.azurewebsites.net/story"
        guard let resourceURL = URL(string: post_url_string) else {return}
        
        var postRequest = URLRequest(url: resourceURL)
        postRequest.httpMethod = "POST"
        postRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let someID = Int(self.fid!) ?? 0
        postRequest.httpBody = ("id=\(someID)").data(using: .utf8)
        
        URLSession.shared.dataTask(with: postRequest) { (data, _, err) in
            DispatchQueue.main.async {
                print("finish fetching 2")
                self.tableView.reloadData()
                self.activityIndicatorView.stopAnimating()
                if let er = err {
                    print("ada error : \(er)")
                    return
                }
                
                guard let data = data else {return}
                
                do{
                    
                    let jDecoder = JSONDecoder()
                    let result = try jDecoder.decode(ReadStory.self, from: data)
                    
                    self.setupAudio(url: URL(string: result.audio)!)
                    
                    let content = result.content
                    let contentArr = content.components(separatedBy: "<span>")
                    
                    self.setupNCArr(contentArr: contentArr)
                    
                    
                }catch let jsonErr{
                    print(jsonErr)
                }
                
                /*self.ncontent = [newIsiContent(ncontent: self.contentar!)]
                print(self.ncontent)*/
            }
            
        }.resume()
    }
    
    func setupNCArr(contentArr: [String]) {
        print("Real one \(contentArr.count)")
        self.contentArr = contentArr
        setupContent(contentArr: contentArr)
    }
    
    func setupContent(contentArr: [String]) {
        print("parted \(contentArr)")
        for item in contentArr {
            print("lessen \(item)")
            isiin(item: item)
        }
    }
    
    func setupView() {
        view.backgroundColor = .darkGray
        
        view.clipsToBounds = true
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.indicatorStyle = .default
        tableView.contentInsetAdjustmentBehavior = .never
        let height = UIApplication.shared.statusBarFrame.height
        tableView.contentInset = .init(top: 100, left: 0, bottom: height, right: 0)
        
        //isiContent.append(StoryContent(content: "test"))
        
    }
    
    func isiin(item: String) {
        tableView.register(ReadViewCell.self, forCellReuseIdentifier: contentCellId)
        isiContent.append(StoryContent(content: item ))
    }
    
    func setupFloatingControl() {
        let floatingContainerView = UIView()
        floatingContainerView.clipsToBounds = true
        floatingContainerView.layer.cornerRadius = 13
        view.addSubview(floatingContainerView)
        let bottomPadding = UIApplication.shared.statusBarFrame.height
        floatingContainerView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: bottomPadding, right: 16), size: .init(width: 30, height: 70))
        let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
        floatingContainerView.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        
        let playButton = UIButton(type: .system)
        playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        playButton.tintColor = .black
        playButton.addTarget(self, action: #selector(playAudio), for: .touchUpInside)
        
        let pauseButton = UIButton(type: .system)
        pauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        pauseButton.tintColor = .black
        pauseButton.addTarget(self, action: #selector(pauseAudio), for: .touchUpInside)
        
        let titleBookLabel = UILabel(text: ftitle ?? "", font: .boldSystemFont(ofSize: 15))
        
        let bookImageView = UIImageView(cornerRadius: 5)
        bookImageView.constrainWidth(constant: 50)
        bookImageView.constrainHeight(constant: view.frame.height)
        bookImageView.sd_setImage(with: URL(string: imgURLTumb!))
        
        let stackView = UIStackView(arrangedSubviews: [
            bookImageView, titleBookLabel, UIView(), playButton, pauseButton
            ], customSpacing: 20)
        
        floatingContainerView.addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 15, left: 20, bottom: 15, right: 20))
        stackView.alignment = .center
    }
    
    func setupAudio(url: URL) {
        print(url)
        let playerItem: AVPlayerItem = AVPlayerItem(url: url)
        let duration = playerItem.asset.duration
        print("duration \(duration)")
        player = AVPlayer(playerItem: playerItem)
        
        print("play \(player.status)")
    }
    
    @objc func playAudio() {
        player.play()
    }
    
    @objc func pauseAudio() {
        player.pause()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*print(section)
        return section*/
        return isiContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: contentCellId, for: indexPath) as! ReadViewCell
        cell.contentStory.text = isiContent[indexPath.item].content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
