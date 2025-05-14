-- Trigger to enforce salary within defined range on EmployeePosition
CREATE TRIGGER TR_EmployeePosition_AfterInsertUpdate
ON EmployeePosition
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @ErrorMessage NVARCHAR(4000);

    -- Check for salary violations
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN JobPosition jp ON i.JobID = jp.JobID
        WHERE i.Salary < jp.SalaryRangeMin OR i.Salary > jp.SalaryRangeMax
    )
    BEGIN
        SET @ErrorMessage = 'Salary must be within the defined salary range for the job position.';
        RAISERROR(@ErrorMessage, 16, 1);
        -- The transaction will be rolled back due to the error severity level
    END
END;
GO

-- Check if the inserted or updated shift overlaps with any leave period
CREATE TRIGGER trg_CheckEmployeeLeaveBeforeShift
ON EmployeeShift
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN EmployeeLeave el ON i.EmployeeID = el.EmployeeID
        WHERE 
            (el.EndDate IS NULL AND i.StartTime >= el.StartDate) -- Ongoing leave
            OR 
            (i.StartTime BETWEEN el.StartDate AND el.EndDate) -- Shift starts during leave
            OR 
            (i.EndTime BETWEEN el.StartDate AND el.EndDate) -- Shift ends during leave
            OR 
            (el.StartDate BETWEEN i.StartTime AND i.EndTime) -- Leave starts during shift
    )
    BEGIN
        -- Raise an error if the shift overlaps with a leave period
        RAISERROR('Cannot assign shift to an employee who is on leave.', 16, 1);
        ROLLBACK TRANSACTION; -- Rollback the insert or update
    END
END;

-- Check for low stock items
CREATE TRIGGER trg_LowStockWarning
ON Inventory
AFTER UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE Quantity < 5)
    BEGIN
        RAISERROR('Low stock warning! One or more items have fallen below 5 units.', 16, 1) WITH LOG;

        -- Select the low stock items (for immediate viewing)
        SELECT r.Name AS RestaurantName, i.Name AS IngredientName, ins.Quantity
        FROM inserted ins
        JOIN Ingredient i ON ins.IngredientID = i.IngredientID
        JOIN Restaurant r ON ins.RestaurantID = r.RestaurantID
        WHERE ins.Quantity < 5;
    END
END;
GO

-- Prevents transactions from inactive restraunts
CREATE TRIGGER trg_PreventInactiveRestaurantsInTransactions
ON CustomerTransaction
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Restaurant r ON i.RestaurantID = r.RestaurantID
        WHERE r.IsActive = 0
    )
    BEGIN
        RAISERROR('Transactions cannot be made for inactive restaurants.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- Update inventory for each item in the transaction
CREATE TRIGGER trg_UpdateInventoryAfterTransaction
ON TransactionDetail
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Inventory
    SET Quantity = Inventory.Quantity - i.Quantity
    FROM inserted i
    JOIN CustomerTransaction ct ON i.TransactionID = ct.TransactionID
    JOIN MenuItemRecipe mir ON i.ItemID = mir.ItemID
    WHERE Inventory.RestaurantID = ct.RestaurantID
      AND Inventory.IngredientID = mir.IngredientID;

END;
GO
