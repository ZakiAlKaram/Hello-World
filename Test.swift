import UIKit

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert: UIAlertController = UIAlertController(title: NSLocalizedString("Attention", comment: ""), message: NSLocalizedString("Any spend or financial transaction on this income and related to Regular Spend, Saving or Debt will not be deleted unless you delete it before delete the income.", comment: ""), preferredStyle: .alert)
            
            let deleteAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Delete this income", comment: ""), style: .destructive, handler: {(action: UIAlertAction) -> Void in
                self.selectedIncome = self.incomes[(indexPath as NSIndexPath).row]
                dbQueue.inDatabase{ db in
                    _ = try! self.selectedIncome.delete(db)
                    let columnIncomeId = Column("incomeId")
                    let columnCode = Column("code")
                    _ = try! Spend.filter(columnIncomeId == self.selectedIncome.id! && (columnCode == "n1-" || columnCode == "i1+")).deleteAll(db)
                    _ = try! Spend.filter(columnIncomeId == self.selectedIncome.id! && columnCode == "xr1-").deleteAll(db)
                    _ = try! Spend.filter(columnIncomeId == self.selectedIncome.id! && columnCode == "xrs1-").deleteAll(db)
                    _ = try! Spend.filter(columnIncomeId == self.selectedIncome.id! && columnCode == "xrdu1-").deleteAll(db)
                    _ = try! Spend.filter(columnIncomeId == self.selectedIncome.id! && columnCode == "xs1-").deleteAll(db)
                    _ = try! Spend.filter(columnIncomeId == self.selectedIncome.id! && columnCode == "xdt1+").deleteAll(db)
                    _ = try! Spend.filter(columnIncomeId == self.selectedIncome.id! && columnCode == "xdu1-").deleteAll(db)
                    
                    _ = try! db.execute("update spends set code = 'xr1-' where incomeId = \(self.selectedIncome!.id!) and code = 'r1-'")
                    _ = try! db.execute("update spends set code = 'xrs1-' where incomeId = \(self.selectedIncome!.id!) and code = 'rs1-'")
                    _ = try! db.execute("update spends set code = 'xrdu1-' where incomeId = \(self.selectedIncome!.id!) and code = 'rdu1-'")
                    _ = try! db.execute("update spends set code = 'xs1-' where incomeId = \(self.selectedIncome!.id!) and code = 's1-'")
                    _ = try! db.execute("update spends set code = 'xdt1+' where incomeId = \(self.selectedIncome!.id!) and code = 'dt1+'")
                    _ = try! db.execute("update spends set code = 'xdu1-' where incomeId = \(self.selectedIncome!.id!) and code = 'du1-'")
                    
                    _ = try! db.execute("update spends set incomeId = 0 where incomeId = \(self.selectedIncome!.id!)")
                }
                self.viewWillAppear(true)
            })
            
            let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
