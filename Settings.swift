//
//  File.swift
//  DrehscheibenRegelung
//
//  Created by Niklas Mischke on 26.04.22.
//

import Foundation
import SwiftUI

struct Settings: View {
	@Environment(\.presentationMode) var presentationMode
	
	@Binding var manager: BLEManager
	@Binding var tracks: [Angle]
	@State private var value: String = ""
	
	var body: some View {
		NavigationView {
			VStack {
//				BLE List
				List {
					Section {
						ForEach(manager.peripherals, id: \.self) { peripheral in
							if peripheral.name != nil {
								HStack {
									Text(peripheral.name!)
									
									Spacer()
									
									if peripheral.name == manager.connectedDevice?.name {
										Button {
											manager.disconnect()
										} label: {
											Text("Disconnect")
												.foregroundColor(Color.red)
										}
									} else {
										Button {
											if manager.connectedDevice != nil {
												manager.disconnect()
											}
											manager.connect(peripheral: peripheral)
										} label: {
											Text("Connect")
												.foregroundColor(Color.blue)
										}
									}
								}
							}
						}
					} header: {
						Text("Available devices:")
					}
				}
				
//				Track List
				List {
					Section {
						HStack {
							TextField("Value", text: $value)
								.keyboardType(.decimalPad)
							
							Button {
								if !value.isEmpty {
									let converted: Double = (Double(value) ?? 0.0).truncatingRemainder(dividingBy: 360.0)
									if !tracks.contains(Angle.degrees(converted)) {
										tracks.append(Angle.degrees(converted))
										tracks.sort()
									}
								}
							} label: {
								Text("Add Track")
							}
						}
						
						ForEach(tracks, id: \.self) { track in
							HStack {
								Text("\(String(round(track.degrees * 100) / 100))°")
								Spacer()
								
								Button {
									tracks.remove(at: tracks.firstIndex(of: track)!)
								} label: {
									Text("Remove").foregroundColor(Color.red)
								}
								
							}
						}
					} header: {
						Text("Tracks:")
					}
				}
			}.navigationTitle("Settings")
				.toolbar {
					Button {
						presentationMode.wrappedValue.dismiss()
					} label: {
						Label("", systemImage: "xmark.circle")
							.foregroundColor(Color.white)
					}
				}
		}
	}
}
