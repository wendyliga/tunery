//
//  MainViewController.swift
//  wwdc2020
//
//  Created by Wendy Liga on 06/05/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import UIKit

public final class MainViewController: UIViewController {
    // MARK: - Interface
    
    static let maxNoteOnSheet: Int = 10
    
    // MARK: - Values
    
    /**
     will hold timer animation when play is triggered
     */
    private var animationTimer = [Timer]()
    
    /**
     All available template
     */
    private let templates: [Template] = Template.allCases
    
    /**
     Current BPM
     */
    private var bpm: Int = 120
    
    /**
     Duration for how long note played and animated
     */
    private var noteDuration: TimeInterval {
        TimeInterval(60) / TimeInterval(bpm)
    }
    
    /**
     Current Instrument
     */
    private var instrument: MIDIInstrument = .grandPiano {
        didSet {
            MIDISequencer.shared.instrument = instrument
        }
    }
    
    // MARK: - Views
    
    private let menuView = MenuControlView ()
    
    fileprivate let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .paleSpringBud
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.bounces = false
        view.isScrollEnabled = false
        
        return view
    }()
    
    private let scrollIndicator = ScrollIndicatorView()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .center
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fill
        
        view.spacing = 8
        
        return view
    }()
    
    private var noteSheets = [NoteSheetView]()
    
    public init() {
        let notes = Template.default.notes
        super.init(nibName: nil, bundle: nil)
        
        MIDISequencer.shared.didFinishPlay = { [weak self] in
            self?.menuView.isPlaying = false
        }
        
        populateNoteViews(notes: notes)
        setupView()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollIndicator.delegate = self
        menuView.delegate = self
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        validateScrollIndicator()
    }
    
    // MARK: - Function
    
    private func setupView() {
        view.backgroundColor = .paleSpringBud
        
        view.addSubview(menuView)
        view.addSubview(scrollView)
        view.addSubview(scrollIndicator)
        scrollView.addSubview(stackView)
        
        // top scroll view
        view.bringSubviewToFront(menuView)
        
        NSLayoutConstraint.activate([
            menuView.topAnchor.constraint(equalTo: view.topAnchor),
            menuView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuView.heightAnchor.constraint(equalToConstant: 94),
            
            scrollView.topAnchor.constraint(equalTo: menuView.bottomAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollIndicator.topAnchor.constraint(equalTo: menuView.bottomAnchor),
            scrollIndicator.leadingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0)
        ])
        
        validateRemoveSheetButton()
    }
    
    private func showAlertInfo(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        self.present(alert, animated: true)
    }
    
    private func scrollIndicatorTo(_ offset: CGFloat) {
        let maxOffset = abs(scrollView.contentSize.height - scrollView.bounds.height)
        
        guard maxOffset > 0 else { return }
        
        scrollIndicator.scrollTo(offset/maxOffset)
    }
    
    private func populateNoteViews(notes: [Note]) {
        noteSheets.forEach { $0.removeFromSuperview()}
        noteSheets = notes.dividedTo(MainViewController.maxNoteOnSheet, filler: .none).enumerated().map { index, notes -> NoteSheetView in
            NoteSheetView(index: index, notes: notes)
        }
        
        noteSheets.forEach { view in
            stackView.addArrangedSubview(view)
        }
    }
    
    private func validateScrollIndicator() {
        scrollIndicator.isHidden = scrollView.contentSize.height < scrollView.frame.height
    }
    
    private func validateRemoveSheetButton() {
//        menuView.removeSheetButton.isEnabled = noteSheets.count == 1 ? false : true
    }
}

extension MainViewController: ScrollIndicatorDelegate {
    func scrollToBottom() {
        let screenOffset = scrollView.contentSize.height - scrollView.frame.height
        let offset = CGPoint(x: 0, y: screenOffset)
        
        scrollView.setContentOffset(offset, animated: true)
    }
    
    func scrollToTop() {
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    var screenOffset: CGFloat {
        let contentSizeHeight = self.scrollView.contentSize.height.clamp(self.scrollView.frame.height ... .infinity)
        
        return contentSizeHeight - self.scrollView.frame.height
    }
    
    func didScroll(to percentage: CGFloat) {
        
        let screenOffset = scrollView.contentSize.height - scrollView.frame.height
        let offsetHeight = screenOffset * percentage
        let offset = CGPoint(x: 0, y: offsetHeight)
        
        scrollView.setContentOffset(offset, animated: false)
    }
}

extension MainViewController: MenuDelegate {
    func template() {
        let saveOptionAlertController = UIAlertController(title: "Template", message: "Choose Template", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        
        templates.forEach { template in
            let jingle = UIAlertAction(title: template.title, style: .default, handler: { [weak self] _ in
                self?.populateNoteViews(notes: template.notes)
                self?.bpm = template.bpm
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                    self?.validateScrollIndicator()
                    self?.scrollIndicator.refreshScreenOffset()
                    self?.validateRemoveSheetButton()
                }
            })
            saveOptionAlertController.addAction(jingle)
        }
        
        saveOptionAlertController.addAction(cancelAction)
        saveOptionAlertController.popoverPresentationController?.sourceView = menuView.templateButton

        self.present(saveOptionAlertController, animated: true)
    }
    
    func save() {
        let notes = noteSheets
            .map ({ noteSheet -> [Note] in
                noteSheet.noteViews.map { $0.noteKey }
            })
            .flatMap{ $0 }
        
        let notesForExport = NoteExport(bpm: bpm, notes: notes)
        
        guard
            let jsonData = try? JSONEncoder().encode(notesForExport),
            let jsonString = String(data: jsonData, encoding: .utf8)
        else {
            self.showAlertInfo(title: "Error", message: "Failed to process the data")
            return
        }
        
        let saveOptionAlertController = UIAlertController(title: "Save", message: "Save will generate JSON that you can save and share to friends. This Generated JSON will be copy to your clipboard", preferredStyle: .actionSheet)
        let jsonAction = UIAlertAction(title: "Copy to my Clipboard", style: .default) { [weak self] _ in
            UIPasteboard.general.string = jsonString
            self?.showAlertInfo(title: "Success", message: "Your Saved JSON copied to your Clipboard")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        saveOptionAlertController.addAction(jsonAction)
        saveOptionAlertController.addAction(cancelAction)
        
        saveOptionAlertController.popoverPresentationController?.sourceView = menuView.saveButton
        
        self.present(saveOptionAlertController, animated: true)
    }
    
    func load() {
        let alertController = UIAlertController(title: "Load", message: "Will Load Generated JSON of Tunery, you need to Copy the Generated JSON to your clipboard", preferredStyle: .actionSheet)
        let jsonAction = UIAlertAction(title: "I've Copy to Clipboard", style: .default) { [weak self] _ in
            guard
                let jsonString = UIPasteboard.general.string,
                let jsonData = jsonString.data(using: .utf8)
            else {
                self?.showAlertInfo(title: "Error", message: "No Clipboard Found")
                return
            }
            
            guard let noteExport = try? JSONDecoder().decode(NoteExport.self, from: jsonData) else {
                self?.showAlertInfo(title: "Error", message: "JSON Data is Invalid")
                return
            }
            
            self?.populateNoteViews(notes: noteExport.notes)
            self?.bpm = noteExport.bpm
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.validateScrollIndicator()
                self?.scrollIndicator.refreshScreenOffset()
                self?.validateRemoveSheetButton()
            }
            
            self?.showAlertInfo(title: "Success", message: "Load Success")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(jsonAction)
        alertController.addAction(cancelAction)
        
        alertController.popoverPresentationController?.sourceView = menuView.saveButton
        
        self.present(alertController, animated: true)
    }
    
    func random() {
        
    }
    
    func adjust() {
        let viewController = AdjustViewController(sheet: noteSheets.count, bpm: bpm)
        viewController.delegate = self
        viewController.modalPresentationStyle = .popover
        viewController.preferredContentSize.height = 350
        viewController.popoverPresentationController?.sourceView = menuView.adjustButton
        
        self.present(viewController, animated: true)
    }
    
    
    
    func stop(_ menu: MenuControlView) {
        menu.isPlaying = false
        
        // stop all animation
        animationTimer.forEach { $0.invalidate() }
        animationTimer.removeAll()
        
        MIDISequencer.shared.stop()
    }
    
    func play(_ menu: MenuControlView) {
        menu.isPlaying = true
        
        DispatchQueue.global(qos: .background).async {
            // prepare Player
            MIDISequencer.shared.MIDIs = self.noteSheets
                .map ({ noteSheet -> [Note] in
                    noteSheet.noteViews
                        .map{ $0.noteKey }
                })
                .flatMap { $0 }
                .MIDIs(duration: self.noteDuration)
            
            // play animation
            self.animationTimer = self.noteSheets.enumerated()
                .map({ (section, sheet) -> [Timer] in
                    sheet.noteViews.enumerated().map { (index, note) -> Timer in
                        let accumulatePreviousSectionTime = Double(section * MainViewController.maxNoteOnSheet) * self.noteDuration
                        let time = (Double(index) * self.noteDuration) + accumulatePreviousSectionTime
    
                        return .init(timeInterval: time, repeats: false) { [weak self] _ in
                            if self?.scrollView.bounds.contains(sheet.frame) == false {
                                // calculate offset for scroll view base on current sheet
                                let offSet = (sheet.frame.maxY - (self?.scrollView.bounds.height ?? sheet.frame.maxY)).clamp(0 ... .infinity)
    
                                // animate and set scroll to spesific offset
                                self?.scrollView.setContentOffset(CGPoint(x: 0, y: offSet), animated: true)
                                self?.scrollIndicatorTo(offSet)
                            }
    
                            note.animateBeingPlayed()
                        }
                    }
                })
                .flatMap { $0 }
            
            DispatchQueue.main.async {
                MIDISequencer.shared.play()
                
                self.animationTimer.forEach { timer in
                    RunLoop.main.add(timer, forMode: .common)
                }
            }
        }
    }
}

extension MainViewController: AdjustDelegate {
    func didIncreaseSheetTo(_ sheet: Int) {
        let sheetViewIndex = noteSheets.endIndex
        let sheetView = NoteSheetView(index: sheetViewIndex)
        noteSheets.append(sheetView)
        stackView.addArrangedSubview(noteSheets[sheetViewIndex])
            
        // after view transcation finish
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.validateScrollIndicator()
            self?.scrollIndicator.refreshScreenOffset()
            self?.validateRemoveSheetButton()
        }
    }
    
    func didDecreaseSheetTo(_ sheet: Int) {
        let lastIndex = noteSheets.endIndex
        
        guard noteSheets[before: lastIndex] != nil else { return }
        
        noteSheets[lastIndex - 1].removeFromSuperview()
        noteSheets.remove(at: lastIndex - 1)
        
        // after view transcation finish
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.validateScrollIndicator()
            self?.scrollIndicator.refreshScreenOffset()
            self?.validateRemoveSheetButton()
        }
    }
    
    func didUpdate(bpm: Int) {
        self.bpm = bpm
    }
    
    func didUpdate(instrument: MIDIInstrument) {
        self.instrument = instrument
    }
}
