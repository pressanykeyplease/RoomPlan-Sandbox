//
//  ViewController.swift
//  Room Plan
//
//  Created by Eduard on 23.09.2022.
//

import RoomPlan
import UIKit

class ViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private var rightBarButton: UIBarButtonItem!
    @IBOutlet private var cancelButton: UIBarButtonItem!

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRoomCaptureView()
        styleForDefaultMode()
    }

    override func viewWillDisappear(_ flag: Bool) {
        super.viewWillDisappear(flag)
        stopSession()
    }

    // MARK: - IBActions
    @IBAction func didTapRightBarButton(_ sender: UIBarButtonItem) {
        if isScanning {
            stopSession()
            showPlanViewer()
        } else {
            startSession()
        }
    }

    @IBAction func didTapCancelButton(_ sender: UIBarButtonItem) {
        if isScanning {
            stopSession()
        }
    }

    // MARK: - Private
    private var isScanning: Bool = false
    private var roomCaptureView: RoomCaptureView!
    private var roomCaptureSessionConfig: RoomCaptureSession.Configuration = RoomCaptureSession.Configuration()
    private var finalResults: CapturedRoom?
}

// MARK: - Private methods
private extension ViewController {
    func setupRoomCaptureView() {
        roomCaptureView = RoomCaptureView(frame: view.bounds)
        roomCaptureView.captureSession.delegate = self
        roomCaptureView.delegate = self
        view.insertSubview(roomCaptureView, at: 0)
    }

    private func startSession() {
        isScanning = true
        roomCaptureView?.captureSession.run(configuration: roomCaptureSessionConfig)
        styleForRecordingMode()
    }

    private func stopSession() {
        isScanning = false
        roomCaptureView?.captureSession.stop()
        styleForDefaultMode()
    }

    func showPlanViewer() {
        let storyboard = UIStoryboard(name: "PlanViewerViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PlanViewerViewController") as! PlanViewerViewController
        navigationController?.pushViewController(vc, animated: true)
        vc.configure(with: finalResults)
    }

    func styleForDefaultMode() {
        cancelButton.isHidden = true
        rightBarButton.isHidden = false
        rightBarButton.title = "Start"
    }

    func styleForRecordingMode() {
        cancelButton.isHidden = false
        rightBarButton.isHidden = false
        rightBarButton.title = "Done"
    }
}

// MARK: - RoomCaptureViewDelegate
extension ViewController: RoomCaptureViewDelegate {
    func captureView(shouldPresent roomDataForProcessing: CapturedRoomData, error: Error?) -> Bool {
        return true
    }

    // Access the final post-processed results.
    func captureView(didPresent processedResult: CapturedRoom, error: Error?) {
        finalResults = processedResult
    }
}

// MARK: - RoomCaptureSessionDelegate
extension ViewController: RoomCaptureSessionDelegate {
}
