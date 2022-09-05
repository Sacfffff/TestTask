//
//  PlayerControls.swift
//  TestTask
//
//  Created by Aleks Kravtsova on 2.09.22.
//

import UIKit

protocol PlayerControlsViewDelegate : AnyObject {
    func playPauseDidTap()
    func nextButtonDidTap()
    func backwardButtonDidTap()
    
}

final class PlayerControlsView : UIView {
  
    weak var delegate : PlayerControlsViewDelegate?
    weak var dataSource : PlayerDataSource?
    
    private lazy var displayLink : CADisplayLink = CADisplayLink(target: self, selector: #selector(updatePlayBackStatus))
    private var isPlaying : Bool = true

    private let slider : UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0.0
        slider.isContinuous = false
        slider.isUserInteractionEnabled = false
        return slider
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22.0, weight: .semibold)
        return label
    }()
    
    private let subtitleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18.0, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let currentTimeLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12.0, weight: .thin)
        return label
    }()
    
    private let durationLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12.0, weight: .thin)
        return label
    }()
    
    private let backwardButton : UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30.0, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let nextButton : UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30.0, weight: .regular))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let playPauseButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray4
        button.tintColor = .label
        button.setImage(UIImage(
            systemName: "pause.fill",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 30.0,
                weight: .medium)), for: .normal)
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.cornerRadius = 30.0
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 10.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let progressView : UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupButtons()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()

    }

    
    func configure(with model: PlayerControlsModel){
        titleLabel.text = model.songName
        subtitleLabel.text = model.artistName
    }
    
    private func setup(){
        backgroundColor = .secondarySystemBackground
        addSubview(titleLabel)
        addSubview(slider)
        addSubview(subtitleLabel)
        addSubview(backwardButton)
        addSubview(nextButton)
        addSubview(playPauseButton)
        addSubview(currentTimeLabel)
        addSubview(durationLabel)
        clipsToBounds = true
        startUpdatingPlayBackStatus()
       

    }
    
    private func setupButtons(){
        backwardButton.addTarget(self, action: #selector(backwardButtonDidTap), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(playPauseButtonDidTap), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
 
    }
    
    @objc private func backwardButtonDidTap(){
        delegate?.backwardButtonDidTap()
    }
    
    @objc private func playPauseButtonDidTap(){
        isPlaying = !isPlaying
        delegate?.playPauseDidTap()
        updatePlayPauseButton()
     
    }
    
    @objc private func nextButtonDidTap(){
        delegate?.nextButtonDidTap()
        
    }
    
    private func updatePlayPauseButton(){
        let pause = UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25.0, weight: .regular))
        let play = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25.0, weight: .regular))
        
        playPauseButton.setImage(isPlaying ? pause : play, for: .normal)
    }
    
    private func startUpdatingPlayBackStatus() {
        displayLink.add(to: .main, forMode: .common)
    }
    
     private func stopUpdatingPlayBackStatus() {
        displayLink.invalidate()
        
    }
    
    @objc private func updatePlayBackStatus(){
        guard let dataSource = dataSource,
        dataSource.duration.isFinite,
        isPlaying else { return }
        let currentTime = dataSource.currentTime / dataSource.duration
        slider.setValue(currentTime, animated: true)
        durationLabel.text = (Int(dataSource.duration).milisecondsToString())
        currentTimeLabel.text = (Int(dataSource.currentTime).milisecondsToString())
        progressView.setProgress(currentTime, animated: true)
    }
    
    private func setupConstraints(){
      
        NSLayoutConstraint.activate(
            [
                
                //titleLabel
                titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0),
                titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5.0),
                titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5.0),
                

                //subtitleLabel
                subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.0),
                subtitleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5.0),
                subtitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5.0),
                
                
                //slider
                slider.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 10.0),
                slider.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10.0),
                slider.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10.0),
                slider.heightAnchor.constraint(equalToConstant: 44.0),
                
                //currentTimeLabel
                currentTimeLabel.topAnchor.constraint(equalTo: slider.bottomAnchor),
                currentTimeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8.0),
                
                //durationLabel
                durationLabel.topAnchor.constraint(equalTo: slider.bottomAnchor),
                durationLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8.0),
                
                //playPauseButton
                playPauseButton.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 20.0),
                playPauseButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                playPauseButton.heightAnchor.constraint(equalToConstant: 60.0),
                playPauseButton.widthAnchor.constraint(equalToConstant: 60.0),
                
                //backwardButton
                backwardButton.topAnchor.constraint(equalTo: playPauseButton.topAnchor),
                backwardButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20.0),
                backwardButton.rightAnchor.constraint(equalTo: playPauseButton.leftAnchor),
                backwardButton.heightAnchor.constraint(equalToConstant: 60.0),
                
                //nextButton
                nextButton.topAnchor.constraint(equalTo: playPauseButton.topAnchor),
                nextButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20.0),
                nextButton.leftAnchor.constraint(equalTo: playPauseButton.rightAnchor),
                nextButton.heightAnchor.constraint(equalToConstant: 60.0),
                
                
                
            ])
   }
}
