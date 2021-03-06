//
//  MailView.swift
//  iShop
//
//  Created by Chris Filiatrault on 19/7/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI
import UIKit
import MessageUI

struct MailView: UIViewControllerRepresentable {

    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?

        init(presentation: Binding<PresentationMode>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _presentation = presentation
            _result = result
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation,
                           result: $result)
    }
   
   
   func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
      let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
      var OS: String = ""
      
      let userOS = UIDevice.current.userInterfaceIdiom
      
      if userOS == .phone { OS = "iOS" }
      else if userOS == .pad { OS = "iPadOS" }
      else if userOS == .mac { OS = "MacOS" }
      let osVersion = UIDevice.current.systemVersion
      
      let vc = MFMailComposeViewController()
       vc.setToRecipients(["ishop-groceries@outlook.com"])
       vc.setMessageBody("<p><br><br>Version: \(appVersion ?? "")<br>\(OS): \(osVersion)</p>", isHTML: true)
       vc.setSubject("iShop")
       vc.mailComposeDelegate = context.coordinator
      vc.navigationBar.tintColor = UIColor.systemBlue
       return vc
   }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {

    }
}
