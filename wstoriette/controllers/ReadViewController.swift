//
//  ReadViewController.swift
//  wstoriette
//
//  Created by Reksa on 06/06/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import UIKit
import AVFoundation

class ReadViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate {
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    var isiContent = [StoryContent]()
    var timeContent = [StoryTime]()
    let contentCellId = "contentCellId"
    var fid: String?
    var player: AVPlayer!
    var ftitle: String?
    var imgURLTumb: String?
    let username = UserDefaults.standard.string(forKey: "username")
    
    var audioContent: Any?
    var contentArr = [String]()
    var counter = 0
    
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
        player.pause()
        player.seek(to: CMTimeMake(value: 0, timescale: 1))
    }
    
    func setupClosebtn() {
        view.addSubview(closeButton)
        closeButton.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        closeButton.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 55, left: 20, bottom: 0, right: 20), size: .init(width: 35, height: 35))
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
        let group = DispatchGroup()
        group.enter()
        fetchStory()
        group.leave()
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
                self.activityIndicatorView.stopAnimating()
                if let er = err {
                    print("ada error : \(er)")
                    return
                }
                
                guard let data = data else {return}
                
                do{
                    
                    let jDecoder = JSONDecoder()
                    let result = try jDecoder.decode(ReadStory.self, from: data)
                    
                    let audioArr = result.data
                
                    for iaudio in audioArr{
                        self.timeContent.append(StoryTime(time: iaudio.time))
                        print("time content dalem do \(self.timeContent.count)")
                    }
                    
                    self.setupAudio(url: result.audio)
                    
                    print(result.data.count)
                    
                    let content = result.content
                    let contentArr = content.components(separatedBy: "<span>")
                    
                    for item in contentArr {
                        self.isiContent.append(StoryContent(content: item ))
                    }
                    
                }catch let jsonErr{
                    print(jsonErr)
                    let alert = CAlert()
                    alert.initalertDismissNav(on: self, with: "Opps", message: "look's like something not good just happen")
                }
                
                self.tableView.reloadData()
            }
            
            }.resume()
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
        tableView.register(ReadViewCell.self, forCellReuseIdentifier: contentCellId)
        
        addToHistory(username: username ?? "", storyId: Int(self.fid!) ?? 0)
    }
    
    var playButton: UIButton!
    var pauseButton: UIButton!
    
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
        
        self.playButton = UIButton(type: .system)
        self.playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        self.playButton.tintColor = .black
        self.playButton.addTarget(self, action: #selector(playAudio), for: .touchUpInside)
        
        self.pauseButton = UIButton(type: .system)
        self.pauseButton.setImage(#imageLiteral(resourceName: "stop"), for: .normal)
        self.pauseButton.tintColor = .black
        self.pauseButton.addTarget(self, action: #selector(pauseAudio), for: .touchUpInside)
        
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
    
    func setupAudio(url: String) {
        
        let dummyURL = URL(string: url)
        
        let playerItem: AVPlayerItem = AVPlayerItem(url: dummyURL!)
        let duration:CMTime = playerItem.asset.duration
        let seconds: Float64 = CMTimeGetSeconds(duration)
        
        let minA = Int(seconds) % 60
        let secA = Int(seconds / 60)
        
        let audioTime = String(secA) + ":" + String(minA)
        
        print("audio time \(audioTime)")
        
        print("duration \(duration)")
        player = AVPlayer(playerItem: playerItem)
        print("play \(player.status.rawValue)")
        
        player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) in
            var titem: Float!
            if self.player.currentItem?.status == .readyToPlay {
                let time : Float64 = CMTimeGetSeconds(self.player.currentTime())
                titem = Float(time)
            }
            
            print(titem ?? 0)
            
//            let minA2 = Int(titem ?? 0) % 60
//            let secA2 = Int(titem ?? 0) / 60
            
           // let audioTime2 = (secA2) + ":" + String(minA2)
            
            //print("audio time \(audioTime2)")
            
            if titem >= self.timeContent[self.counter].time {
                print("ini akan jalan")
                print("isi counter \(self.counter)")
                
                let cell = self.tableView.cellForRow(at: IndexPath(row: self.counter, section: 0))
                cell?.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
                
                if self.counter != 0 {
                    let cellprev = self.tableView.cellForRow(at: IndexPath(row: self.counter-1, section: 0))
                    cellprev?.backgroundColor = .white
                }
                
                self.counter += 1
                self.tableView.reloadData()
            }
        }
        
    }
    
    @objc func playAudio() {
        if player.rate == 0 {
            player.play()
            self.playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }else{
            player.pause()
            self.playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        }
    }
    
    @objc func pauseAudio() {
        if player.rate == 0 {
            
        }else{
            player.pause()
            self.playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        }
        player.seek(to: CMTimeMake(value: 0, timescale: 1))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func addToHistory(username: String, storyId: Int) {
        let post_url_string = "https://storiette-api.azurewebsites.net/postUserFavorite"
        guard let resourceURL = URL(string: post_url_string) else {return}
        
        var postRequest = URLRequest(url: resourceURL)
        postRequest.httpMethod = "POST"
        postRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        postRequest.httpBody = ("username=\(username)&storyId=\(storyId)").data(using: .utf8)
        
        URLSession.shared.dataTask(with: postRequest) { (data, _, err) in
            DispatchQueue.main.async {
                print("finish fetching 2")
                if let er = err {
                    print("ada error : \(er)")
                    return
                }
                
                guard let data = data else {return}
                
                do{
                    
                    let jDecoder = JSONDecoder()
                    let result = try jDecoder.decode(UserHistoryResult.self, from: data)
                    print("status add to history \(result.status)")
                    
                }catch let jsonErr{
                    print(jsonErr)
                    let alert = CAlert()
                    alert.initalertDismissNav(on: self, with: "Woopss something wrong", message: "we don't know yet")
                }
            }
        }.resume()
    }
}
