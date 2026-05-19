CREATE TABLE Client(
    SSN VARCHAR2(10) PRIMARY KEY,
    Fname VARCHAR2(20) NOT NULL,
    Mname VARCHAR2(20) NOT NULL,
    Lname VARCHAR2(20) NOT NULL,
    Phone VARCHAR2(15) NOT NULL,
    Nationality VARCHAR2(30),
    DOB DATE NOT NULL,
    Gender CHAR(1) CHECK (Gender IN ('M', 'F')) NOT NULL,
    Email VARCHAR2(50) NOT NULL,
    City VARCHAR2(20) NOT NULL,
    Street VARCHAR2(20) NOT NULL
);

CREATE TABLE Account(
    Account_NO VARCHAR2(16) PRIMARY KEY,
    Client_SSN VARCHAR2(10) NOT NULL REFERENCES Client (SSN) ON DELETE CASCADE,
    Account_Status VARCHAR2(8) CHECK (Account_Status IN ('Active', 'Inactive')) NOT NULL,
    Created_Date DATE NOT NULL,
    Account_Type VARCHAR2(10) CHECK (Account_Type IN ('Savings', 'Current', 'Business')) NOT NULL,
    Balance NUMBER(10, 2) DEFAULT 0 NOT NULL,
    Currency CHAR(3) NOT NULL,
    IBAN VARCHAR2(25) NOT NULL UNIQUE
);

CREATE TABLE Card(
    Card_NO VARCHAR2(16) PRIMARY KEY,
    Client_SSN VARCHAR2(10) NOT NULL REFERENCES Client (SSN) ON DELETE CASCADE,
    Card_Type VARCHAR2(7) CHECK (Card_Type IN ('Debit', 'Credit', 'Prepaid')) NOT NULL,
    PIN NUMBER(4) CHECK (PIN BETWEEN 1000 AND 9999) NOT NULL,
    CVC NUMBER(3) CHECK (CVC BETWEEN 100 AND 999) NOT NULL,
    Exp_Date DATE NOT NULL
);

CREATE TABLE loan(
    Loan_NO INTEGER PRIMARY KEY, 
    Client_SSN VARCHAR2(10) NOT NULL REFERENCES Client (SSN) ON DELETE CASCADE,
    Start_Date DATE NOT NULL,
    Repayment_term_Month INTEGER CHECK (Repayment_term_Month > 0) NOT NULL,
    Due_Date DATE NOT NULL,
    Loan_Amount NUMBER(10, 2) CHECK (Loan_Amount > 0) NOT NULL,
    Loan_Status VARCHAR2(9) CHECK (Loan_Status IN ('Active', 'Completed')) NOT NULL,
    Loan_Type VARCHAR2(50) CHECK (Loan_Type IN ('Personal Loan', 'Home Loan', 'Car Loan', 'Business Loan')) NOT NULL
);

CREATE TABLE Transaction(
    Transaction_NO VARCHAR2(12) PRIMARY KEY,
    Transaction_Type VARCHAR2(8) CHECK (Transaction_Type IN ('Withdraw', 'Deposit', 'Transfer')) NOT NULL,
    Transaction_Date DATE NOT NULL,
    Transaction_Amount NUMBER(10,2) CHECK (Transaction_Amount > 0) NOT NULL,
    Currency CHAR(3) NOT NULL,
    Sender_account VARCHAR2(16) REFERENCES Account (Account_No),
    Receiver_account VARCHAR2(16) REFERENCES Account (Account_No)
);

CREATE TABLE Employee(
    Emp_ID VARCHAR2(4) PRIMARY KEY,
    Branch_NO VARCHAR2(2) NOT NULL,
    Fname VARCHAR2(20) NOT NULL,
    Mname VARCHAR2(20) NOT NULL,
    Lname VARCHAR2(20) NOT NULL,
    SSN VARCHAR2(10) NOT NULL UNIQUE,
    Address VARCHAR2(100), 
    Phone VARCHAR2(15) NOT NULL,
    Nationality VARCHAR2(30),
    DOB DATE NOT NULL,
    "Position" VARCHAR2(50) NOT NULL,
    Gender CHAR(1) CHECK (Gender IN ('M', 'F')) NOT NULL,
    Salary NUMBER(10, 2) CHECK (Salary > 0) NOT NULL,
    Email VARCHAR2(50) NOT NULL UNIQUE
);

CREATE TABLE Branch(
    Branch_NO VARCHAR2(2) PRIMARY KEY,
    Branch_Address VARCHAR2(100) NOT NULL,
    Mgr_Id VARCHAR2(4) REFERENCES Employee (Emp_ID)
);

ALTER TABLE Employee ADD CONSTRAINT Employee_BranchNO FOREIGN KEY (Branch_NO) REFERENCES Branch (Branch_NO);

CREATE TABLE Branch_Phone (
    Branch_NO VARCHAR2(2) REFERENCES Branch (Branch_NO) ON DELETE CASCADE NOT NULL,
    Phone VARCHAR2(15) NOT NULL,
    PRIMARY KEY (Branch_NO, Phone)
);

CREATE TABLE  Branch_Offers_Loans(
    Branch_NO VARCHAR2(2) REFERENCES Branch (Branch_NO) NOT NULL,
    Loan_NO INTEGER REFERENCES Loan (Loan_NO) NOT NULL,
    PRIMARY KEY (Branch_NO, Loan_NO)
);

CREATE TABLE  Branch_Offers_Transactions(
    Branch_NO VARCHAR2(2) REFERENCES Branch (Branch_NO) NOT NULL,
    Transaction_NO VARCHAR2(12) REFERENCES Transaction (Transaction_NO) NOT NULL,
    PRIMARY KEY (Branch_NO, Transaction_NO)
);

CREATE TABLE  Client_Makes_Transactions(
    Client_SSN VARCHAR2(10) REFERENCES Client (SSN) NOT NULL,
    Transaction_NO VARCHAR2(12) REFERENCES Transaction (Transaction_NO) NOT NULL,
    PRIMARY KEY (Client_SSN, Transaction_NO)
);