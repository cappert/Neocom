//
//  NCFittingFleetViewController.swift
//  Neocom
//
//  Created by Artem Shimanski on 24.02.17.
//  Copyright © 2017 Artem Shimanski. All rights reserved.
//

import UIKit

class NCFleetMemberRow: TreeRow {
	lazy var type: NCDBInvType? = {
		return NCDatabase.sharedDatabase?.invTypes[self.ship.typeID]
	}()
	
	
	let pilot: NCFittingCharacter
	let ship: NCFittingShip
	init(pilot: NCFittingCharacter) {
		self.pilot = pilot
		self.ship = pilot.ship!
		super.init(prototype: NCDefaultTableViewCell.prototypes.default, accessoryButtonRoute: Router.Database.TypeInfo(ship.typeID))
	}
	
	override func configure(cell: UITableViewCell) {
		guard let cell = cell as? NCDefaultTableViewCell else {return}
		guard let type = type else {return}
		
		cell.titleLabel?.text = type.typeName
		cell.subtitleLabel?.text = ship.name
		cell.iconView?.image = type.icon?.image?.image ?? NCDBEveIcon.defaultType.image?.image
		cell.accessoryType = .detailButton
	}
	
	override var hashValue: Int {
		return pilot.hashValue
	}
	
	override func isEqual(_ object: Any?) -> Bool {
		return (object as? NCFleetMemberRow)?.hashValue == hashValue
	}
	
}


class NCFittingFleetViewController: UITableViewController, TreeControllerDelegate {
	@IBOutlet weak var treeController: TreeController!
	
	var engine: NCFittingEngine? {
		return (parent as? NCFittingEditorViewController)?.engine
	}
	
	var fleet: NCFittingFleet? {
		return (parent as? NCFittingEditorViewController)?.fleet
	}
	
	private var observer: NSObjectProtocol?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.estimatedRowHeight = tableView.rowHeight
		tableView.rowHeight = UITableViewAutomaticDimension
		treeController.delegate = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if self.treeController.rootNode == nil {
			self.treeController.rootNode = TreeNode()
			reload()
		}
		
		if observer == nil {
			observer = NotificationCenter.default.addObserver(forName: .NCFittingEngineDidUpdate, object: engine, queue: nil) { [weak self] (note) in
				self?.reload()
			}
		}
	}
	
	//MARK: - TreeControllerDelegate
	
	func treeController(_ treeController: TreeController, didSelectCellWithNode node: TreeNode) {
		if let route = (node as? TreeRow)?.route {
			route.perform(source: self, view: treeController.cell(for: node))
		}

		
		/*if let item = node as? NCImplantRow {
			if let slot = item.slot {
				guard let pilot = fleet?.active else {return}
				guard let typePickerViewController = typePickerViewController else {return}
				let category = NCDBDgmppItemCategory.category(categoryID: .implant, subcategory: slot)
				
				typePickerViewController.category = category
				typePickerViewController.completionHandler = { [weak typePickerViewController] (_, type) in
					let typeID = Int(type.typeID)
					self.engine?.perform {
						pilot.addImplant(typeID: typeID)
					}
					typePickerViewController?.dismiss(animated: true)
				}
				present(typePickerViewController, animated: true)
			}
		}
		else if let item = node as? NCBoosterRow {
			if let slot = item.slot {
				guard let pilot = fleet?.active else {return}
				guard let typePickerViewController = typePickerViewController else {return}
				let category = NCDBDgmppItemCategory.category(categoryID: .booster, subcategory: slot)
				
				typePickerViewController.category = category
				typePickerViewController.completionHandler = { [weak typePickerViewController] (_, type) in
					let typeID = Int(type.typeID)
					self.engine?.perform {
						pilot.addBooster(typeID: typeID)
					}
					typePickerViewController?.dismiss(animated: true)
				}
				present(typePickerViewController, animated: true)
			}
		}*/
	}
	
	func treeController(_ treeController: TreeController, accessoryButtonTappedWithNode node: TreeNode) {
		guard let route = (node as? TreeRow)?.accessoryButtonRoute else {return}
		
		route.perform(source: self, view: treeController.cell(for: node))
	}
	
	//MARK: - Private
	
	private func reload() {
		guard let fleet = self.fleet else {return}
		let route = Router.Fitting.FleetMemberPicker(fleet: fleet, completionHandler: { controller in
			_ = controller.navigationController?.popViewController(animated: true)
		})

		if fleet.pilots.count == 1 {
			let row = NCActionRow(prototype: "NCActionTableViewCell", title: NSLocalizedString("Create Fleet", comment: "").uppercased(), route: route)
			self.treeController.rootNode?.children = [row]
		}
		else {
			engine?.perform({
				var rows = [TreeNode]()
				for (pilot, _) in fleet.pilots {
					rows.append(NCFleetMemberRow(pilot: pilot))
				}
				
				rows.append(NCActionRow(prototype: "NCActionTableViewCell", title: NSLocalizedString("Add Pilot", comment: "").uppercased(), route: route))
				
				DispatchQueue.main.async {
					self.treeController.rootNode?.children = rows
				}
			})
		}
		return
		/*engine?.perform {
			guard let pilot = self.fleet?.active else {return}
			var sections = [TreeNode]()
			
			var implants = (0...9).map({NCImplantRow(dummySlot: $0 + 1)})
			
			for implant in pilot.implants.all {
				guard (1...10).contains(implant.slot) else {continue}
				implants[implant.slot - 1] = NCImplantRow(implant: implant)
			}
			
			var boosters = (0...3).map({NCBoosterRow(dummySlot: $0 + 1)})
			
			for booster in pilot.boosters.all {
				guard (1...4).contains(booster.slot) else {continue}
				boosters[booster.slot - 1] = NCBoosterRow(booster: booster)
			}
			
			sections.append(DefaultTreeSection(cellIdentifier: "NCHeaderTableViewCell", nodeIdentifier: "Implants", title: NSLocalizedString("Implants", comment: "").uppercased(), children: implants))
			sections.append(DefaultTreeSection(cellIdentifier: "NCHeaderTableViewCell", nodeIdentifier: "Boosters", title: NSLocalizedString("Boosters", comment: "").uppercased(), children: boosters))
			
			DispatchQueue.main.async {
				self.treeController.rootNode?.children = sections
			}
		}*/
	}
}