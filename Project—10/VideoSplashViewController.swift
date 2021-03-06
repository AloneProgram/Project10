//
//  VideoSplashViewController.swift
//  Project10
//
//  Created by iKnet on 16/7/15.
//  Copyright © 2016年 zzj. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit

public enum ScalingMode {
    case Resize
    case ResizeAspect
    case ResizeAspectFill
}

public class VideoSplashViewController: UIViewController {

    private let moviePlayer = AVPlayerViewController()
    private var moviePlayerSound: Float = 1.0
    public var contentURL: NSURL = NSURL(){
        didSet{
           setMoviePlayer(contentURL)
        }
    }
    public var videoFrame:CGRect = CGRect()
    public var startTime:CGFloat = 0.0
    public var durationTime:CGFloat = 0.0
    public var backgroundColor: UIColor = UIColor.blackColor() {
        didSet{
            view.backgroundColor = backgroundColor
        }
    }
    public var sound:Bool = true {
        didSet {
            if sound {
                moviePlayerSound = 1.0
            }else{
                moviePlayerSound = 0.0
            }
        }
    }
    public var alpha:CGFloat = CGFloat(){
        didSet{
            moviePlayer.view.alpha = alpha
        }
    }
    public var alwaysRepeat:Bool = true {
        didSet {
            if alwaysRepeat {
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VideoSplashViewController.playerItemDidRechshEnd), name: AVPlayerItemDidPlayToEndTimeNotification, object: moviePlayer.player?.currentItem)
            }
        }
    }
    public var fillMode:ScalingMode = .ResizeAspectFill {
        didSet {
            switch fillMode {
            case .Resize:
                moviePlayer.videoGravity = AVLayerVideoGravityResize
            case .ResizeAspect:
                moviePlayer.videoGravity = AVLayerVideoGravityResizeAspect
            case .ResizeAspectFill:
                moviePlayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                
            }
        }
    }
    
    override public func viewDidAppear(animated: Bool) {        
        moviePlayer.view.frame = videoFrame
        moviePlayer.showsPlaybackControls = false
        view.addSubview(moviePlayer.view)
        view.sendSubviewToBack(moviePlayer.view)
    }
    
    override public func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private func setMoviePlayer(url: NSURL)  {
        let videoCutter = VideoCutter()
        videoCutter.cropVideoWithUrl(videoUrl: url, stratTime: startTime, duration: durationTime) { (videoPath, error) -> Void in
            if let path = videoPath as NSURL? {
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()){
                        self.moviePlayer.player = AVPlayer(URL: path)
                        self.moviePlayer.player?.play()
                        self.moviePlayer.player?.volume = self.moviePlayerSound
                    }
                }
            }
        }
        
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func playerItemDidRechshEnd() {
        moviePlayer.player?.seekToTime(kCMTimeZero)
        moviePlayer.player?.play()
    }
}
