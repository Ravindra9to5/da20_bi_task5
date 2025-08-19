-------------------------TASK-5---------------------------

--HOTEL MANAGEMENT SYSTEM - COMPLETE SQL FILE

-- STEP 1: CREATE DATABASE

CREATE DATABASE expanded_indian_hotel_management;
----------------------------------------------------------
-- STEP 2: CREATE ALL TABLES WITH CONSTRAINTS

-- TABLE 1: HOTELS MASTER TABLE (50 records)

CREATE TABLE hotels (
    hotel_id SERIAL PRIMARY KEY,
    hotel_name VARCHAR(200) NOT NULL,
    address TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    country VARCHAR(50) DEFAULT 'India',
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    website VARCHAR(200),
    star_rating INTEGER CHECK (star_rating BETWEEN 1 AND 5),
    total_rooms INTEGER NOT NULL CHECK (total_rooms > 0),
    check_in_time TIME DEFAULT '14:00',
    check_out_time TIME DEFAULT '12:00',
    amenities TEXT,
    gst_number VARCHAR(15) UNIQUE NOT NULL,
    pan_number VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

------------------------------------------------------------------------------

-- TABLE 2: ROOMS TABLE (3,000 records)

CREATE TABLE rooms (
    room_id SERIAL PRIMARY KEY,
    hotel_id INTEGER NOT NULL REFERENCES hotels(hotel_id) ON DELETE CASCADE,
    room_number VARCHAR(10) NOT NULL,
    room_type VARCHAR(50) NOT NULL,
    bed_type VARCHAR(20),
    capacity INTEGER CHECK (capacity > 0),
    size_sqft INTEGER,
    base_price_inr DECIMAL(10,2) NOT NULL CHECK (base_price_inr > 0),
    current_status VARCHAR(20) DEFAULT 'Available' 
        CHECK (current_status IN ('Available', 'Occupied', 'Maintenance', 'Housekeeping', 'Out of Order')),
    floor_number INTEGER,
    view_type VARCHAR(50),
    amenities TEXT,
    gst_rate_percent DECIMAL(4,2) DEFAULT 12.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(hotel_id, room_number)
);

---------------------------------------------------------------------------------------------------------
-- TABLE 3: CUSTOMERS TABLE (8,000 records)

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    date_of_birth DATE,
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(50) DEFAULT 'India',
    pincode VARCHAR(6),
    id_proof_type VARCHAR(50),
    id_proof_number VARCHAR(50),
    loyalty_points INTEGER DEFAULT 0,
    membership_tier VARCHAR(20) DEFAULT 'None',
    preferred_language VARCHAR(20) DEFAULT 'English',
    nationality VARCHAR(50) DEFAULT 'Indian',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_visit DATE
);
-----------------------------------------------------------------------------------------
-- TABLE 4: BOOKINGS TABLE (5,000 records)

CREATE TABLE bookings (
    booking_id VARCHAR(10) PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
    hotel_id INTEGER NOT NULL REFERENCES hotels(hotel_id),
    room_id INTEGER NOT NULL REFERENCES rooms(room_id),
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    nights INTEGER GENERATED ALWAYS AS (check_out_date - check_in_date) STORED,
    adults INTEGER NOT NULL CHECK (adults > 0),
    children INTEGER DEFAULT 0 CHECK (children >= 0),
    total_guests INTEGER GENERATED ALWAYS AS (adults + children) STORED,
    booking_status VARCHAR(20) DEFAULT 'Confirmed' 
        CHECK (booking_status IN ('Confirmed', 'Pending', 'Checked In', 'Checked Out', 'Cancelled', 'No Show')),
    payment_status VARCHAR(20) DEFAULT 'Pending'
        CHECK (payment_status IN ('Paid', 'Partial', 'Pending', 'Refunded')),
    base_amount_inr DECIMAL(12,2) NOT NULL,
    gst_amount_inr DECIMAL(12,2) NOT NULL,
    total_amount_inr DECIMAL(12,2) NOT NULL,
    paid_amount_inr DECIMAL(12,2) DEFAULT 0,
    booking_date DATE NOT NULL,
    special_requests TEXT,
    booking_source VARCHAR(50),
    cancellation_policy TEXT DEFAULT '24 hours before check-in',
    guest_nationality VARCHAR(50) DEFAULT 'Indian',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CHECK (check_out_date > check_in_date),
    CHECK (total_amount_inr = base_amount_inr + gst_amount_inr)
);

----------------------------------------------------------------------------------
-- TABLE 5: PAYMENTS TABLE (4,000 record)

CREATE TABLE payments (
    payment_id VARCHAR(10) PRIMARY KEY,
    booking_id VARCHAR(10) NOT NULL REFERENCES bookings(booking_id),
    payment_method VARCHAR(30) NOT NULL,
    transaction_id VARCHAR(50) UNIQUE NOT NULL,
    amount_inr DECIMAL(12,2) NOT NULL CHECK (amount_inr > 0),
    currency VARCHAR(3) DEFAULT 'INR',
    payment_date TIMESTAMP NOT NULL,
    payment_status VARCHAR(20) DEFAULT 'Pending'
        CHECK (payment_status IN ('Completed', 'Pending', 'Failed', 'Refunded')),
    gateway VARCHAR(30),
    gateway_response VARCHAR(50),
    upi_id VARCHAR(100),
    card_last_four VARCHAR(4),
    bank_name VARCHAR(50),
    refund_amount_inr DECIMAL(12,2) DEFAULT 0,
    refund_date DATE,
    gst_amount_inr DECIMAL(12,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

------------------------------------------------------------------------------------------
-- TABLE 6: STAFF TABLE (800 records)
CREATE TABLE staff (
    staff_id VARCHAR(8) PRIMARY KEY,
    hotel_id INTEGER NOT NULL REFERENCES hotels(hotel_id),
    employee_code VARCHAR(10) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    role VARCHAR(50) NOT NULL,
    department VARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL,
    salary_inr_monthly DECIMAL(10,2) NOT NULL CHECK (salary_inr_monthly > 0),
    salary_inr_annual DECIMAL(12,2) GENERATED ALWAYS AS (salary_inr_monthly * 12) STORED,
    status VARCHAR(20) DEFAULT 'Active'
        CHECK (status IN ('Active', 'On Leave', 'Terminated', 'Probation')),
    shift VARCHAR(30),
    emergency_contact VARCHAR(20),
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(100),
    pincode VARCHAR(6),
    pan_number VARCHAR(10),
    aadhaar_number VARCHAR(15), -- Masked for privacy
    bank_account VARCHAR(20),
    ifsc_code VARCHAR(11),
    pf_number VARCHAR(30),
    languages_known VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
---------------------------------------------------------------------------------------------------
-- TABLE 7: SERVICES TABLE (300 records)

CREATE TABLE services (
    service_id VARCHAR(8) PRIMARY KEY,
    hotel_id INTEGER NOT NULL REFERENCES hotels(hotel_id),
    service_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    description TEXT,
    price_inr DECIMAL(10,2) NOT NULL CHECK (price_inr >= 0),
    gst_rate_percent DECIMAL(4,2) DEFAULT 18.00,
    total_price_inr DECIMAL(10,2) GENERATED ALWAYS AS (price_inr * (1 + gst_rate_percent/100)) STORED,
    availability_hours VARCHAR(50),
    staff_required INTEGER DEFAULT 1,
    duration_minutes INTEGER,
    is_active BOOLEAN DEFAULT true,
    booking_required BOOLEAN DEFAULT false,
    advance_booking_hours INTEGER DEFAULT 2,
    seasonal_service BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-----------------------------------------------------------------------------------------
-- TABLE 8: BOOKING SERVICES TABLE (2,500 records)

CREATE TABLE booking_services (
    booking_service_id VARCHAR(10) PRIMARY KEY,
    booking_id VARCHAR(10) NOT NULL REFERENCES bookings(booking_id),
    service_id VARCHAR(8) NOT NULL REFERENCES services(service_id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price_inr DECIMAL(10,2) NOT NULL,
    base_amount_inr DECIMAL(12,2) GENERATED ALWAYS AS (unit_price_inr * quantity) STORED,
    gst_amount_inr DECIMAL(12,2) NOT NULL,
    total_price_inr DECIMAL(12,2) NOT NULL,
    service_date DATE NOT NULL,
    service_time TIME,
    status VARCHAR(20) DEFAULT 'Pending'
        CHECK (status IN ('Pending', 'Confirmed', 'In Progress', 'Completed', 'Cancelled')),
    staff_assigned VARCHAR(8) REFERENCES staff(staff_id),
    special_instructions TEXT,
    guest_rating INTEGER CHECK (guest_rating BETWEEN 1 AND 5),
    guest_feedback TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CHECK (total_price_inr = base_amount_inr + gst_amount_inr)
);



-----------------------------------------------------------------------------------------
-- TABLE 9: INVENTORY TABLE (1,000 records)
CREATE TABLE inventory (
    inventory_id VARCHAR(10) PRIMARY KEY,
    hotel_id INTEGER NOT NULL REFERENCES hotels(hotel_id),
    item_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    current_stock INTEGER NOT NULL CHECK (current_stock >= 0),
    minimum_stock INTEGER NOT NULL CHECK (minimum_stock >= 0),
    maximum_stock INTEGER NOT NULL CHECK (maximum_stock > minimum_stock),
    unit_of_measure VARCHAR(20) NOT NULL,
    unit_price_inr DECIMAL(10,2) NOT NULL CHECK (unit_price_inr > 0),
    total_value_inr DECIMAL(12,2) GENERATED ALWAYS AS (current_stock * unit_price_inr) STORED,
    gst_rate_percent DECIMAL(4,2) NOT NULL,
    supplier_name VARCHAR(100),
    supplier_contact VARCHAR(20),
    supplier_gst VARCHAR(15),
    last_ordered_date DATE,
    next_order_date DATE,
    expiry_date DATE,
    storage_location VARCHAR(50),
    hsn_code VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
----------------------------------------------------------------------------------------------
-- TABLE 10: MAINTENANCE TABLE (600 records)

CREATE TABLE maintenance (
    maintenance_id VARCHAR(10) PRIMARY KEY,
    hotel_id INTEGER NOT NULL REFERENCES hotels(hotel_id),
    room_id INTEGER REFERENCES rooms(room_id),
    issue_type VARCHAR(50) NOT NULL,
    priority VARCHAR(10) NOT NULL CHECK (priority IN ('Low', 'Medium', 'High', 'Critical')),
    description TEXT NOT NULL,
    reported_date TIMESTAMP NOT NULL,
    reported_by VARCHAR(8) NOT NULL REFERENCES staff(staff_id),
    assigned_staff VARCHAR(8) REFERENCES staff(staff_id),
    status VARCHAR(20) DEFAULT 'Open'
        CHECK (status IN ('Open', 'In Progress', 'Completed', 'On Hold', 'Cancelled')),
    completion_date TIMESTAMP,
    cost_inr DECIMAL(10,2) DEFAULT 0,
    gst_amount_inr DECIMAL(10,2) DEFAULT 0,
    total_cost_inr DECIMAL(10,2) GENERATED ALWAYS AS (cost_inr + gst_amount_inr) STORED,
    parts_used TEXT,
    vendor_involved VARCHAR(50),
    guest_impact VARCHAR(10) CHECK (guest_impact IN ('None', 'Minor', 'Major')),
    follow_up_required BOOLEAN DEFAULT false,
    warranty_applicable BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-------------------------------------------------------------------------------------------------
SELECT * FROM hotels;
SELECT * FROM rooms;
SELECT * FROM customers;
SELECT * FROM bookings;
SELECT * FROM payments;
SELECT * FROM staff;
SELECT * FROM services;
SELECT * FROM booking_services;
SELECT * FROM inventory;
SELECT * FROM maintenance;
---------------------------------------------------------------------------------------------------