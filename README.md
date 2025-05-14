# Restaurant Network - Database (Mateusz Markiewicz, Michał Lisicki, Jakub Nowak)

## 🎯 Project Goal

The goal is to create a **RestaurantNetwork** database to manage the operations of a restaurant chain. This system allows for monitoring key aspects such as restaurant locations, employee management, customer tracking, supplier coordination, inventory management, and transaction logging.

## 📋 Assumptions

* Storing information about restaurant locations (addresses, activity status)
* Managing employees (positions, salaries, transfers, training)
* Tracking customers (personal data, loyalty points)
* Ingredient management (allergens, unit prices)
* Monitoring menu items (dishes, ingredients, recipes)
* Storing customer reviews and ratings
* Logging transactions and order details

## ✨ Features

* Employee salary management
* Preventing schedule conflicts with employee leave
* Low stock level warnings
* Blocking transactions at inactive restaurants
* Automatic inventory updates after transactions

## 🚫 Limitations

* No multi-currency support
* No online order management
* No automated inventory replenishment

## 💾 Database Maintenance

To ensure data consistency and system continuity, the following maintenance procedures are recommended:

* **Daily backups** - differential backups every night
* **Full backups** - weekly during low-traffic hours
* **Data integrity monitoring** - regular consistency checks
* **Performance optimization** - refreshing indexes and statistics
* **Data retention policy** - defining rules for archiving old data

## 📂 Database Schema

### Main Tables:

* **Address** - stores address information for people and restaurants
* **Person** - stores basic information about employees and customers
* **Employee** - employment details of staff members
* **EmployeeLeave** - employee leave history
* **JobPosition** - job positions and salary ranges
* **Restaurant** - restaurant locations
* **EmployeePosition** - employment history of staff
* **SalaryPayment** - salary payment records
* **EmployeeShift** - employee work shifts
* **MenuItem** - available menu items
* **Ingredient** - ingredients used in menu items
* **MenuItemRecipe** - recipes for menu items
* **CustomerTransaction** - customer purchase records
* **TransactionDetail** - order details within each transaction
* **Customer** - customer information
* **CustomerRewardLog** - loyalty point logs
* **RewardPrize** - available loyalty rewards
* **PrizeRedemption** - reward redemption records
* **Supplier** - ingredient suppliers
* **Inventory** - inventory levels
* **Feedback** - customer feedback
* **RestaurantReservation** - table reservations
* **EmployeeTraining** - employee training records
* **Certificates** - employee certification details

## 🖥️ Views

* **vw\_CustomerFullInfo** - full customer information
* **vw\_EmployeeFullInfo** - full employee information
* **vw\_FeedbackByRestaurant** - customer feedback statistics by restaurant
* **vw\_FeedbackByRecipe** - customer feedback statistics by menu item
* **vw\_FeedbackByCustomer** - customer review summaries
* **vw\_CustomerWorkerDemographics** - customer and employee counts per city
* **vw\_AllergensPerRecipe** - allergens in menu items
* **vw\_PrizeStats** - loyalty prize redemption statistics
* **vw\_ActiveRestaurants** - list of active restaurants
* **vw\_MonthlySalesReport** - monthly sales reports for restaurants

## 📝 Stored Procedures

* **usp\_CalculateTotalTransactionAmount** - calculates transaction totals
* **usp\_GetEmployeeCurrentRestaurant** - returns current restaurant for an employee
* **usp\_UpdateInventory** - updates inventory levels after usage
* **usp\_GetMenuItemIngredients** - lists ingredients for a given menu item
* **usp\_GetRestaurantSales** - calculates total sales for a restaurant

## 🚦 Triggers

* **TR\_EmployeePosition\_AfterInsertUpdate** - ensures employee salaries are within job range
* **trg\_CheckEmployeeLeaveBeforeShift** - prevents assigning shifts during employee leave
* **trg\_LowStockWarning** - generates low inventory alerts
* **trg\_PreventInactiveRestaurantsInTransactions** - blocks transactions for inactive restaurants
* **trg\_UpdateInventoryAfterTransaction** - auto-updates inventory after transactions
