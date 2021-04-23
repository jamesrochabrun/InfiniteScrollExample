//
//  SwiftUIView.swift
//  InfiniteScrollExample
//
//  Created by James Rochabrun on 4/22/21.
//

import SwiftUI
import UIKit

struct ViewControllerRepresentable<Content: UIViewController>: UIViewControllerRepresentable {
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ViewControllerRepresentable>) ->  UIViewController {
        let compController = Content()
        return UINavigationController(rootViewController: compController)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<ViewControllerRepresentable>) {
    }
}

struct SwiftUIView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerRepresentable<ViewController>().edgesIgnoringSafeArea(.all)
    }
}
