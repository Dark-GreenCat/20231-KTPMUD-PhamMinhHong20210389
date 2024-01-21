-- Drop foreign key constraints
ALTER TABLE PurchaseOrderDetail DROP CONSTRAINT IF EXISTS OrderDetail_MaterialVariant;
ALTER TABLE PurchaseOrderDetail DROP CONSTRAINT IF EXISTS OrderDetail_Order;
ALTER TABLE PurchaseOrder DROP CONSTRAINT IF EXISTS Order_Account;
ALTER TABLE PurchaseOrder DROP CONSTRAINT IF EXISTS Order_Supplier;
ALTER TABLE ProductMaterial DROP CONSTRAINT IF EXISTS Product_association_1;
ALTER TABLE SaleOrderDetail DROP CONSTRAINT IF EXISTS SaleOrderDetail_Product;
ALTER TABLE SaleOrderDetail DROP CONSTRAINT IF EXISTS SaleOrderDetail_SaleOrder;
ALTER TABLE SaleOrder DROP CONSTRAINT IF EXISTS SaleOrder_Account;
ALTER TABLE SaleOrder DROP CONSTRAINT IF EXISTS SaleOrder_Customer;
ALTER TABLE MaterialVariantPriceHistory DROP CONSTRAINT IF EXISTS MaterialVariantPriceHistory_MaterialVariant;
ALTER TABLE MaterialVariant DROP CONSTRAINT IF EXISTS MaterialVariant_Material;
ALTER TABLE ProductMaterial DROP CONSTRAINT IF EXISTS MaterialVariant_association_1;
ALTER TABLE MaterialVariantSupplier DROP CONSTRAINT IF EXISTS MaterialVariant_association_2;
ALTER TABLE MaterialVariantSupplier DROP CONSTRAINT IF EXISTS Supplier_association_1;

-- Drop tables
DROP TABLE IF EXISTS PurchaseOrderDetail;
DROP TABLE IF EXISTS PurchaseOrder;
DROP TABLE IF EXISTS ProductMaterial;
DROP TABLE IF EXISTS SaleOrderDetail;
DROP TABLE IF EXISTS SaleOrder;
DROP TABLE IF EXISTS MaterialVariantSupplier;
DROP TABLE IF EXISTS MaterialVariantPriceHistory;
DROP TABLE IF EXISTS MaterialVariant;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Material;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Account;
DROP TABLE IF EXISTS Supplier;

-- Drop sequences
DROP SEQUENCE IF EXISTS PurchaseOrderDetail_seq;
DROP SEQUENCE IF EXISTS PurchaseOrder_seq;
DROP SEQUENCE IF EXISTS ProductMaterial_seq;
DROP SEQUENCE IF EXISTS SaleOrderDetail_seq;
DROP SEQUENCE IF EXISTS SaleOrder_seq;
DROP SEQUENCE IF EXISTS MaterialVariantPriceHistory_seq;
DROP SEQUENCE IF EXISTS MaterialVariant_seq;
DROP SEQUENCE IF EXISTS Product_seq;
DROP SEQUENCE IF EXISTS Material_seq;
DROP SEQUENCE IF EXISTS Customer_seq;
DROP SEQUENCE IF EXISTS Account_seq;
DROP SEQUENCE IF EXISTS Supplier_seq;




-- tables
-- Table: Account
CREATE TABLE Account (
    AccountID int  NOT NULL,
    AccountName varchar(64)  NOT NULL,
    AccountEmail varchar(125)  NOT NULL,
    AccountPassword varchar(20)  NOT NULL,
    AccountRole int  NOT NULL,
    CONSTRAINT Account_pk PRIMARY KEY (AccountID)
);

-- Table: Customer
CREATE TABLE Customer (
    CustomerID int  NOT NULL,
    CustomerName varchar(100)  NOT NULL,
    CustomerPhone varchar(10)  NOT NULL,
    CONSTRAINT Customer_pk PRIMARY KEY (CustomerID)
);

-- Table: Material
CREATE TABLE Material (
    MaterialID int  NOT NULL,
    MaterialName varchar(70)  NOT NULL,
    MaterialDescription varchar(500)  NULL,
    CONSTRAINT Material_pk PRIMARY KEY (MaterialID)
);

-- Table: MaterialVariant
CREATE TABLE MaterialVariant (
    MaterialVariantID int  NOT NULL,
    MaterialVariantSKU varchar(13)  NOT NULL,
    MaterialVariantColor varchar(30)  NULL,
    MinimumStockLevel int  NULL,
    Material_MaterialID int  NOT NULL,
    CONSTRAINT MaterialVariant_pk PRIMARY KEY (MaterialVariantID)
);

-- Table: MaterialVariantPriceHistory
CREATE TABLE MaterialVariantPriceHistory (
    MaterialVariantPriceHistoryID int  NOT NULL,
    MaterialVariantPrice decimal(7,0)  NOT NULL,
    MaterialVariantPrice_EffectiveDate date  NOT NULL,
    MaterialVariant_MaterialVariantID int  NOT NULL,
    CONSTRAINT MaterialVariantPriceHistory_pk PRIMARY KEY (MaterialVariantPriceHistoryID)
);

-- Table: MaterialVariantSupplier
CREATE TABLE MaterialVariantSupplier (
    Supplier_SupplierID int  NOT NULL,
    MaterialVariant_MaterialVariantID int  NOT NULL,
    MaterialVariantPrice decimal(7,0)  NOT NULL,
    MaterialVariantQuantity int  NOT NULL,
    CONSTRAINT MaterialVariantSupplier_pk PRIMARY KEY (Supplier_SupplierID,MaterialVariant_MaterialVariantID)
);

-- Table: Product
CREATE TABLE Product (
    ProductID int  NOT NULL,
    ProductSKU varchar(8)  NOT NULL,
    ProductName varchar(70)  NOT NULL,
    ProductQuantity int  NOT NULL,
    ProductPrice decimal(7,0)  NOT NULL,
    MinimumStockLevel int  NULL,
    CONSTRAINT Product_pk PRIMARY KEY (ProductID)
);

-- Table: ProductMaterial
CREATE TABLE ProductMaterial (
    MaterialVariant_MaterialVariantID int  NOT NULL,
    Product_ProductID int  NOT NULL,
    ProductMaterialQuantity int  NOT NULL,
    CONSTRAINT ProductMaterial_pk PRIMARY KEY (MaterialVariant_MaterialVariantID,Product_ProductID)
);

-- Table: PurchaseOrder
CREATE TABLE PurchaseOrder (
    PurchaseOrderID int  NOT NULL,
    PurchaseOrderCode varchar(15)  NOT NULL,
    PurchaseOrderDate timestamp  NOT NULL,
    PurchaseOrderReceivedDate timestamp  NULL,
    Supplier_SupplierID int  NOT NULL,
    Account_AccountID int  NOT NULL,
    CONSTRAINT PurchaseOrder_pk PRIMARY KEY (PurchaseOrderID)
);

-- Table: PurchaseOrderDetail
CREATE TABLE PurchaseOrderDetail (
    PurchaseOrderDetailID int  NOT NULL,
    PurchaseOrderQuantity int  NOT NULL,
    PurchaseOrderPrice decimal(7,0)  NOT NULL,
    PurchaseOrder_PurchaseOrderID int  NOT NULL,
    MaterialVariant_MaterialVariantID int  NOT NULL,
    CONSTRAINT PurchaseOrderDetail_pk PRIMARY KEY (PurchaseOrderDetailID)
);

-- Table: SaleOrder
CREATE TABLE SaleOrder (
    SaleOrderID int  NOT NULL,
    SaleOrderCode varchar(15)  NOT NULL,
    SaleOrderDate timestamp  NOT NULL,
    Customer_CustomerID int  NOT NULL,
    Account_AccountID int  NOT NULL,
    CONSTRAINT SaleOrder_pk PRIMARY KEY (SaleOrderID)
);

-- Table: SaleOrderDetail
CREATE TABLE SaleOrderDetail (
    SaleOrderDetailID int  NOT NULL,
    SaleOrderQuantity int  NOT NULL,
    SaleOrderPrice decimal(7,0)  NOT NULL,
    SaleOrder_SaleOrderID int  NOT NULL,
    Product_ProductID int  NOT NULL,
    CONSTRAINT SaleOrderDetail_pk PRIMARY KEY (SaleOrderDetailID)
);

-- Table: Supplier
CREATE TABLE Supplier (
    SupplierID int  NOT NULL,
    SupplierName varchar(100)  NOT NULL,
    SupplierPhone varchar(10)  NULL,
    SupplierAddress varchar(100)  NULL,
    SupplierEmail varchar(125)  NULL,
    SupplierOtherContact varchar(100)  NULL,
    CONSTRAINT Supplier_pk PRIMARY KEY (SupplierID)
);

-- foreign keys
-- Reference: MaterialVariantPriceHistory_MaterialVariant (table: MaterialVariantPriceHistory)
ALTER TABLE MaterialVariantPriceHistory ADD CONSTRAINT MaterialVariantPriceHistory_MaterialVariant
    FOREIGN KEY (MaterialVariant_MaterialVariantID)
    REFERENCES MaterialVariant (MaterialVariantID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: MaterialVariant_Material (table: MaterialVariant)
ALTER TABLE MaterialVariant ADD CONSTRAINT MaterialVariant_Material
    FOREIGN KEY (Material_MaterialID)
    REFERENCES Material (MaterialID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: MaterialVariant_association_1 (table: ProductMaterial)
ALTER TABLE ProductMaterial ADD CONSTRAINT MaterialVariant_association_1
    FOREIGN KEY (MaterialVariant_MaterialVariantID)
    REFERENCES MaterialVariant (MaterialVariantID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: MaterialVariant_association_2 (table: MaterialVariantSupplier)
ALTER TABLE MaterialVariantSupplier ADD CONSTRAINT MaterialVariant_association_2
    FOREIGN KEY (MaterialVariant_MaterialVariantID)
    REFERENCES MaterialVariant (MaterialVariantID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: OrderDetail_MaterialVariant (table: PurchaseOrderDetail)
ALTER TABLE PurchaseOrderDetail ADD CONSTRAINT OrderDetail_MaterialVariant
    FOREIGN KEY (MaterialVariant_MaterialVariantID)
    REFERENCES MaterialVariant (MaterialVariantID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: OrderDetail_Order (table: PurchaseOrderDetail)
ALTER TABLE PurchaseOrderDetail ADD CONSTRAINT OrderDetail_Order
    FOREIGN KEY (PurchaseOrder_PurchaseOrderID)
    REFERENCES PurchaseOrder (PurchaseOrderID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Order_Account (table: PurchaseOrder)
ALTER TABLE PurchaseOrder ADD CONSTRAINT Order_Account
    FOREIGN KEY (Account_AccountID)
    REFERENCES Account (AccountID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Order_Supplier (table: PurchaseOrder)
ALTER TABLE PurchaseOrder ADD CONSTRAINT Order_Supplier
    FOREIGN KEY (Supplier_SupplierID)
    REFERENCES Supplier (SupplierID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Product_association_1 (table: ProductMaterial)
ALTER TABLE ProductMaterial ADD CONSTRAINT Product_association_1
    FOREIGN KEY (Product_ProductID)
    REFERENCES Product (ProductID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: SaleOrderDetail_Product (table: SaleOrderDetail)
ALTER TABLE SaleOrderDetail ADD CONSTRAINT SaleOrderDetail_Product
    FOREIGN KEY (Product_ProductID)
    REFERENCES Product (ProductID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: SaleOrderDetail_SaleOrder (table: SaleOrderDetail)
ALTER TABLE SaleOrderDetail ADD CONSTRAINT SaleOrderDetail_SaleOrder
    FOREIGN KEY (SaleOrder_SaleOrderID)
    REFERENCES SaleOrder (SaleOrderID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: SaleOrder_Account (table: SaleOrder)
ALTER TABLE SaleOrder ADD CONSTRAINT SaleOrder_Account
    FOREIGN KEY (Account_AccountID)
    REFERENCES Account (AccountID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: SaleOrder_Customer (table: SaleOrder)
ALTER TABLE SaleOrder ADD CONSTRAINT SaleOrder_Customer
    FOREIGN KEY (Customer_CustomerID)
    REFERENCES Customer (CustomerID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Supplier_association_1 (table: MaterialVariantSupplier)
ALTER TABLE MaterialVariantSupplier ADD CONSTRAINT Supplier_association_1
    FOREIGN KEY (Supplier_SupplierID)
    REFERENCES Supplier (SupplierID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- sequences
-- Sequence: Account_seq
CREATE SEQUENCE Account_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: Customer_seq
CREATE SEQUENCE Customer_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: MaterialVariantPriceHistory_seq
CREATE SEQUENCE MaterialVariantPriceHistory_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: MaterialVariant_seq
CREATE SEQUENCE MaterialVariant_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: Material_seq
CREATE SEQUENCE Material_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: Product_seq
CREATE SEQUENCE Product_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: PurchaseOrderDetail_seq
CREATE SEQUENCE PurchaseOrderDetail_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: PurchaseOrder_seq
CREATE SEQUENCE PurchaseOrder_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: SaleOrderDetail_seq
CREATE SEQUENCE SaleOrderDetail_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: SaleOrder_seq
CREATE SEQUENCE SaleOrder_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: Supplier_seq
CREATE SEQUENCE Supplier_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- End of file.

