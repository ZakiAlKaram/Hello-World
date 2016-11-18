            if selectedIncome != nil {
                //check if the selectedIncome deleted
                selectedIncome = Income.fetchOne(db, key: selectedIncome!.id!)
                if selectedIncome == nil {
                    selectedIncome = Income.order(Column("recievedDate").desc).limit(1).fetchOne(db)
                }
            }
            else {
                //just open the app
                let lastSelectedIncomeId = defaults.integer(forKey: "lastSelectedIncomeId")
                if lastSelectedIncomeId > 0 {
                    selectedIncome = Income.fetchOne(db, key: lastSelectedIncomeId)
                }
                if (selectedIncome == nil) {
                    selectedIncome = Income.order(Column("recievedDate").desc).limit(1).fetchOne(db)
                }
            }
