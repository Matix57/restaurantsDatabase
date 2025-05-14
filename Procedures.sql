-- Given a transactionID calculates the price
CREATE PROCEDURE usp_CalculateTotalTransactionAmount
    @TransactionID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TotalAmount DECIMAL(10,2) = 0; -- Initialize to 0
    DECLARE @ItemID INT;
    DECLARE @Quantity INT;
    DECLARE @Price DECIMAL(10,2);
    DECLARE @DiscountAmount DECIMAL(10,2); -- Store discount

    -- Declare a cursor to loop through transaction details
    DECLARE transaction_cursor CURSOR FOR
    SELECT ItemID, Quantity, DiscountAmount  -- Select needed columns
    FROM TransactionDetail
    WHERE TransactionID = @TransactionID;

    OPEN transaction_cursor;

    FETCH NEXT FROM transaction_cursor INTO @ItemID, @Quantity, @DiscountAmount;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Get the price of the item
        SELECT @Price = Price
        FROM MenuItem
        WHERE ItemID = @ItemID;

        -- Calculate the item total with discount
        SET @TotalAmount = @TotalAmount + (@Quantity *(@Price - @DiscountAmount));

        FETCH NEXT FROM transaction_cursor INTO @ItemID, @Quantity, @DiscountAmount;
    END

    CLOSE transaction_cursor;
    DEALLOCATE transaction_cursor;

    RETURN @TotalAmount;
END;
GO

-- Finds the restraunt to which an Employee is assigned
CREATE PROCEDURE usp_GetEmployeeCurrentRestaurant
    @EmployeeID INT,
    @RestaurantName NVARCHAR(100) OUTPUT
AS
BEGIN
    -- Check for current assignment of employee to a restaurant
    SELECT TOP 1 @RestaurantName = r.Name
    FROM EmployeePosition ep
    JOIN Restaurant r ON ep.RestaurantID = r.RestaurantID
    WHERE ep.EmployeeID = @EmployeeID AND ep.EndDate IS NULL;

    -- If no assignment is found, set the output to indicate no current assignment
    IF @RestaurantName IS NULL
    BEGIN
        SET @RestaurantName = 'Not currently assigned';
    END
END;
GO

-- Updates inventory item by a given quantity
CREATE PROCEDURE usp_UpdateInventory
    @RestaurantID INT,
    @IngredientID INT,
    @QuantityChange DECIMAL(10,2)
AS
BEGIN
    UPDATE Inventory
    SET Quantity = Quantity + @QuantityChange,
        LastUpdated = GETDATE()
    WHERE RestaurantID = @RestaurantID AND IngredientID = @IngredientID;

    -- Check for negative inventory and raise an error if needed
    IF (SELECT Quantity FROM Inventory WHERE RestaurantID = @RestaurantID AND IngredientID = @IngredientID) < 0
    BEGIN
        RAISERROR('Inventory level cannot be negative.', 16, 1)
        -- You could also log this error to a separate table for tracking.
    END
END;
GO

-- Gets ingredients for given menu item
CREATE PROCEDURE usp_GetMenuItemIngredients
    @ItemID INT
AS
BEGIN
    SELECT i.Name AS IngredientName, mir.Quantity -- Assuming you have a Units table
    FROM MenuItemRecipe mir
    JOIN Ingredient i ON mir.IngredientID = i.IngredientID
    WHERE mir.ItemID = @ItemID;
END;
GO

-- Returns total sales for a given restraunt in a given date range
CREATE PROCEDURE usp_GetRestaurantSales
    @RestaurantID INT,
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    DECLARE @TotalSales INT

    SELECT @TotalSales = ISNULL(SUM((td.Quantity * mi.Price) - td.DiscountAmount), 0)
    FROM CustomerTransaction ct
    JOIN TransactionDetail td ON ct.TransactionID = td.TransactionID
    JOIN MenuItem mi ON td.ItemID = mi.ItemID
    WHERE ct.RestaurantID = @RestaurantID AND ct.TransactionDate BETWEEN @StartDate AND @EndDate;

    RETURN @TotalSales;
END;
GO
