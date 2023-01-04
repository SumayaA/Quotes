//
//  ContentView.swift
//  Quotes
//
//  Created by Sara Alhumidi on 09/06/1444 AH.
//

import SwiftUI


import VisionKit

struct ContentView: View {
    
    @EnvironmentObject var vm: AppViewModel
    
    private let textContentTypes: [(title: String, textContentType: DataScannerViewController.TextContentType?)] = [
        ("All", .none),
       
    ]
    
    var body: some View {
        switch vm.dataScannerAccessStatus {
        case .scannerAvailable:
            mainView
        case .cameraNotAvailable:
            Text("Your device doesn't have a camera")
        case .scannerNotAvailable:
            Text("Your device doesn't have support for scanning barcode with this app")
        case .cameraAccessNotGranted:
            Text("Please provide access to the camera in settings")
        case .notDetermined:
            Text("Requesting camera access")
        }
    }
    
    private var mainView: some View {
        DataScannerView(
            recognizedItems: $vm.recognizedItems,
            recognizedDataType: vm.recognizedDataType,
            recognizesMultipleItems: vm.recognizesMultipleItems
        )
        .background { Color.gray.opacity(0.3) }
        .ignoresSafeArea()
        .id(vm.dataScannerViewId)
        .sheet(isPresented: .constant(true)) {
            bottomContainerView
                .background(.ultraThinMaterial)
                .presentationDetents([.fraction(0.12),.medium, .large])
                .presentationDragIndicator(.visible)
                .interactiveDismissDisabled()
                .onAppear {
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                          let controller = windowScene.windows.first?.rootViewController?.presentedViewController else {
                        return
                    }
                    controller.view.backgroundColor = .clear
                }
        }
        .onChange(of: vm.scanType) { _ in vm.recognizedItems = [] }
        .onChange(of: vm.textContentType) { _ in vm.recognizedItems = [] }
        .onChange(of: vm.recognizesMultipleItems) { _ in vm.recognizedItems = []}
    }
    
    private var headerView: some View {
        VStack {
            HStack {
//                Picker("Scan Type", selection: $vm.scanType) {
                  //  Text("Barcode").tag(ScanType.barcode)
                    Text("Quotes").tag(ScanType.text)
//                }.pickerStyle(.segmented)
//                Toggle("Scan multiple", isOn: $vm.recognizesMultipleItems)
            }.padding(.top)
            
            if vm.scanType == .text {
               // Picker("Text content type", selection: $vm.textContentType) {
                    ForEach(textContentTypes, id: \.self.textContentType) { option in
                         
                            Text(option.title).tag(option.textContentType)
                                           }
           //     }.pickerStyle(.segmented)
            }
            //here will show the   Recognized  count item(s)
            Text(vm.headerText).padding(.top)
        }.padding(.horizontal)
    }
    
    private var bottomContainerView: some View {
        VStack {
            headerView
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(vm.recognizedItems) { item in
                        switch item {
                        case .barcode(let barcode):
                            Text(barcode.payloadStringValue ?? "Unknown barcode")
                        case .text(let text):
                            ZStack {
                                RoundedRectangle(cornerRadius: 25, style: .continuous)
                                            .fill(.white)

                                        VStack {
                                            ScrollView {
                                                Text(text.transcript)
                                                    .font(.largeTitle)
                                                    .foregroundColor(.black)
                                            }
//                                            Text(text.transcript)
//                                                .font(.title)
//                                                .foregroundColor(.gray)
                                        }
                                        .padding(20)
                                        .multilineTextAlignment(.center)
                                    }
                            .frame(width:.infinity, height: 150)
                         
                             
                        @unknown default:
                            Text("Unknown")
                        }
                    }
                }
                .padding()
            }
        }
    }
}


//
//struct ContentView: View {
//    @State private var showingCredits = false
//    let heights = stride(from: 2.1, through: 4.0, by: 3.1).map { PresentationDetent.fraction($0) }
//
//      var body: some View {
//          Button("Show Credits") {
//              showingCredits.toggle()
//          }
//          .sheet(isPresented: $showingCredits) {
//              Text("Here is the \u{22}Quotes\u{22} go")
//                  .presentationDetents([.medium, .large])
//
//               //.prefersScrollingExpandsWhenScrolledToEdgefalse
//                 // .presentationDetents([.fraction(0.15)])
//
//          }
//      }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
