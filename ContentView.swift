import SwiftUI

struct ContentView: View, BluetoothSerialDelegate{
	@State private var currentAngle: Angle = Angle.degrees(0)
	@State private var showingSettings: Bool = false
	@State private var manager: BLEManager = BLEManager()
	@State private var tracks: [Angle] = []
	
	func serialDidReceiveString(_ message: String) {
		currentAngle = Angle.degrees((Double(message) ?? 0).truncatingRemainder(dividingBy: 360.0))
	}
	
	func getCoordinates(angle: Angle) -> (CGPoint) {
		let radius = (width * 0.8 / 2) + 160
		let angleConv = (angle.degrees) * Double.pi / 180
		
		let x = widthCenter + (radius * sin(angleConv))
		let y = heightCenter + (radius * cos(angleConv))
		
		return CGPoint(x: x, y: y)
	}
	
	func calculateAngel(angle: Angle) {
		manager.sendMessageToDevice("\(angle.degrees - currentAngle.degrees)")
	}
	
    var body: some View {
		NavigationView {
			ZStack {
//				Turning Background
				Image("background")
					.frame(width: width * 0.8, height: width * 0.8)
					.clipShape( Circle() )
					.position(x: widthCenter, y: heightCenter)
					.rotationEffect(currentAngle)
					.brightness(-0.1)
				
//				remaining Tracks
				ForEach(tracks, id: \.self) { track in
					Image("track")
						.rotationEffect(Angle(degrees: 180) - track)
						.position(getCoordinates(angle: track))
						.onTapGesture { calculateAngel(angle: Angle(degrees: 180) - track) }
						.brightness(-0.1)
				}

//				Turning Track
				Image("track")
					.rotationEffect(currentAngle)
					.position(x: widthCenter, y: heightCenter)
//					.brightness(-0.1)
				
//				Circle
				Circle()
					.strokeBorder(Color.gray,lineWidth: 8)
					.shadow(radius: 20)
					.frame(width: width * 0.8, height: width * 0.8)
					.position(x: widthCenter, y: heightCenter)
			}
			.navigationTitle("\(String(round(currentAngle.degrees * 100) / 100))°")
				.toolbar {
					Button {
						showingSettings = true
					} label: {
						Label("", systemImage: "gear")
							.foregroundColor(Color.white)
					}
				}.background(
					Image("background")
						.resizable()
						.aspectRatio(contentMode: .fill)
						.edgesIgnoringSafeArea(.all)
						.brightness(-0.2)
				)
		}.sheet(isPresented: $showingSettings) {
			var temp: [Double] = [Double]()
			for x in tracks {
				temp.append(x.degrees)
			}
			defaults.set(temp, forKey: defaultsKey)
		} content: {
			Settings(manager: $manager, tracks: $tracks)
		}.onAppear {
			manager.enableReconnect()
			let temp: [Double] = defaults.object(forKey: defaultsKey) as? [Double] ?? [Double]()
			for x in temp {
				tracks.append(Angle(degrees: x))
			}
		}
	}
}
