--- TABLE TESTS ----------------------------------------
SELECT * FROM Address;
SELECT * FROM Person;
SELECT * FROM Employee;
SELECT * FROM EmployeeLeave;
SELECT * FROM JobPosition;
SELECT * FROM Restaurant;
SELECT * FROM EmployeePosition;
SELECT * FROM SalaryPayment;
SELECT * FROM EmployeeShift;
SELECT * FROM MenuItem;
SELECT * FROM Ingredient;
SELECT * FROM MenuItemRecipe;
SELECT * FROM CustomerTransaction;
SELECT * FROM TransactionDetail;
SELECT * FROM Customer;
SELECT * FROM CustomerRewardLog;
SELECT * FROM RewardPrize;
SELECT * FROM PrizeRedemption;
SELECT * FROM Supplier;
SELECT * FROM Inventory;
SELECT * FROM Feedback;
SELECT * FROM RestaurantReservation
SELECT * FROM EmployeeTraining
SELECT * FROM Certificates

--- VIEW TESTS ----------------------------------------
SELECT * FROM vw_CustomerFullInfo; -- Gives a full view of customers including current points balance
SELECT * FROM vw_EmployeeFullInfo; -- Employee Full Info View including next shift and current position
SELECT * FROM vw_FeedbackByRestaurant; -- Feedback by Restaurant View - Shows max, min and avg rating
SELECT * FROM vw_FeedbackByRecipe; -- Feedback by Recipe View - Shows max, min and avg rating
SELECT * FROM vw_FeedbackByCustomer; -- Feedback by Customer View - Shows max, min and avg rating
SELECT * FROM vw_CustomerWorkerDemographics; -- Customer and Worker Demographics View - Shows how many employees and customers per city
SELECT * FROM vw_AllergensPerRecipe; -- Allergens per Recipe View
SELECT * FROM vw_PrizeStats; -- Prize Stats View - Shows popularity of prizes
SELECT * FROM vw_ActiveRestaurants; -- Active Restaurants View
SELECT * FROM vw_MonthlySalesReport; -- Monthly Sales Report View

--- PROCEDURE TESTS ----------------------------------------

-- Calculate TotalTransaction Amount test:
DECLARE @Total DECIMAL(10,2);
EXEC @Total = usp_CalculateTotalTransactionAmount 1;
PRINT 'Total amount: ' + CAST(@Total AS VARCHAR(10));

-- GetEmployee Current Restaurant test
DECLARE @RestName NVARCHAR(100);
EXEC usp_GetEmployeeCurrentRestaurant 101, @RestName OUTPUT;  -- Pass the output variable
PRINT 'Restaurant: ' + @RestName;

-- Update Inventory test:
SELECT * FROM Inventory WHERE RestaurantID = 1 AND IngredientID = 1;
EXEC usp_UpdateInventory 1, 1, -5;
SELECT * FROM Inventory WHERE RestaurantID = 1 AND IngredientID = 1;

-- Get Menu Item ngredients test
EXEC usp_GetMenuItemIngredients 1;

-- Get Restaurant Sales test
DECLARE @Sales DECIMAL(10,2);
EXEC @Sales = usp_GetRestaurantSales 1, '2023-06-26', '2023-10-27'; -- Replace with valid IDs and dates
PRINT 'Total Sales: ' + CAST(@Sales AS VARCHAR(10));

--- Trigger Tests ----------------------------------------------

-- TR_EmployeePosition_AfterInsertUpdate test
INSERT INTO EmployeePosition (EmployeeID, JobID, RestaurantID, StartDate, Salary)
VALUES (101, 1, 1, '2023-07-01', 6000.00);  -- Salary is less than SalaryRangeMin

-- trg_CheckEmployeeLeaveBeforeShift test
INSERT INTO EmployeeShift (ShiftID, EmployeeID, RestaurantID, StartTime, EndTime)
VALUES (8, 101, 1, '2023-07-05 09:00', '2023-07-05 17:00');

--  trg_LowStockWarning test
UPDATE Inventory
SET Quantity = 4.00
WHERE InventoryID = 1;

-- rg_PreventInactiveRestaurantsInTransactions test
INSERT INTO CustomerTransaction (TransactionID, RestaurantID, TransactionDate)
VALUES (10, 3, GETDATE());

-- trg_UpdateInventoryAfterTransaction test
EXEC usp_UpdateInventory 1, 1, 200
EXEC usp_UpdateInventory 1, 2, 200

SELECT InventoryID, RestaurantID, IngredientID, Quantity
FROM Inventory
WHERE RestaurantID = 1 AND IngredientID IN (1, 2);

INSERT INTO CustomerTransaction (TransactionID, RestaurantID, TransactionDate)
VALUES (1004, 1, GETDATE());

INSERT INTO TransactionDetail (TransactionID, ItemID, Quantity, DiscountAmount)
VALUES (1004, 1, 1, 0.00);

SELECT InventoryID, RestaurantID, IngredientID, Quantity
FROM Inventory
WHERE RestaurantID = 1 AND IngredientID IN (1, 2);