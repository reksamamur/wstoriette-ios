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
    var faudio: String?
    
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
    
    var player: AVPlayer!
    
    let closeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "close"), for: .normal)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupClosebtn()
        setupFloatingControl()
        setupContent()
        fetchStory()
        setupActivityIndicator()
    }
    
    func fetchStory() {
        let post_url_string = "https://storiette-api.azurewebsites.net/story"
        guard let resourceURL = URL(string: post_url_string) else {return}
        
        var postRequest = URLRequest(url: resourceURL)
        postRequest.httpMethod = "POST"
        postRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        postRequest.httpBody = ("id=\(1)").data(using: .utf8)
        
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
                    self.setupAudio(urlres: result.audio)
                    
                }catch let jsonErr{
                    print(jsonErr)
                }
            }
        }.resume()
    }
    
    func setupContent() {
        tableView.register(ReadViewCell.self, forCellReuseIdentifier: contentCellId)
        isiContent.append(StoryContent(content: "New String"))
        isiContent.append(StoryContent(content: "New String"))
        isiContent.append(StoryContent(content: "New String"))
        isiContent.append(StoryContent(content: "New String"))
        isiContent.append(StoryContent(content: "New String"))
        isiContent.append(StoryContent(content: "New String"))
        isiContent.append(StoryContent(content: "New String"))
        isiContent.append(StoryContent(content: "New String"))
        isiContent.append(StoryContent(content: "New String"))
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
        tableView.contentInsetAdjustmentBehavior = .never
        let height = UIApplication.shared.statusBarFrame.height
        tableView.contentInset = .init(top: 90, left: 0, bottom: height, right: 0)
    }
    
    func setupFloatingControl() {
        let floatingContainerView = UIView()
        floatingContainerView.clipsToBounds = true
        floatingContainerView.layer.cornerRadius = 13
        view.addSubview(floatingContainerView)
        let bottomPadding = UIApplication.shared.statusBarFrame.height
        floatingContainerView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: bottomPadding, right: 16), size: .init(width: 0, height: 70))
        let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
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
        
        let titleBookLabel = UILabel(text: "Nama Book", font: .boldSystemFont(ofSize: 15))
        
        let stackView = UIStackView(arrangedSubviews: [
            titleBookLabel, UIView(), playButton, pauseButton
            ], customSpacing: 20)
        
        floatingContainerView.addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 20, left: 20, bottom: 20, right: 20))
        stackView.alignment = .center
    }
    
    func setupAudio(urlres: String) {
        let mainurl  = URL.init(string: urlres)
        print("url audio \(mainurl!)")
        
        let dummyURL = URL(string: "https://s108.123apps.com/aconv/d/s108YhjCuluR.mp3")
        
        let playerItem: AVPlayerItem = AVPlayerItem(url: dummyURL!)
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
        return isiContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: contentCellId, for: indexPath) as! ReadViewCell
        cell.contentStory.text = isiContent[indexPath.item].content
        return cell
    }
}
