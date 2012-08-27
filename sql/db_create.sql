CREATE TABLE "clients" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    "company_name" TEXT NOT NULL,
    "address_1" TEXT NOT NULL,
    "address_2" TEXT NOT NULL,
    "city" TEXT NOT NULL,
    "state" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "website" TEXT NOT NULL,
    "zip_code" INTEGER NOT NULL,
    "contact_fname" TEXT NOT NULL,
    "contact_lname" TEXT NOT NULL
);
CREATE TABLE "invoice_items" (
    "invoice_item_id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    "invoice_number" INTEGER NOT NULL,
    "description" TEXT NOT NULL,
    "order_num" INTEGER NOT NULL,
    "quantity" INTEGER NOT NULL,
    "price" INTEGER NOT NULL
);
CREATE TABLE "invoices" (
    "invoice_number" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    "client_id" INTEGER NOT NULL,
    "company_ship_id" INTEGER NOT NULL,
    "company_info_id" INTEGER NOT NULL
);
CREATE TABLE "company_info" (
    "company_info_id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    "company_name" TEXT NOT NULL,
    "address" TEXT NOT NULL,
    "address2" TEXT,
    "city" TEXT NOT NULL,
    "state" TEXT NOT NULL,
    "zipcode" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "fax" TEXT,
    "country" TEXT NOT NULL,
    "active" INTEGER,
    "modify_date" TEXT NOT NULL
);
CREATE TABLE "company_ship" (
    "company_ship_id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    "company_name" TEXT NOT NULL,
    "contact_name" TEXT NOT NULL,
    "address" TEXT NOT NULL,
    "address2" TEXT ,
    "city" TEXT NOT NULL,
    "state" TEXT NOT NULL,
    "zipcode" TEXT NOT NULL,
    "country" TEXT NOT NULL,
    "active" INTEGER,
    "modify_date" TEXT NOT NULL
);
