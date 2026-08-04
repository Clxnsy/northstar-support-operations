-- =============================================================================
-- Northstar Support Operations System - Relational Database Schema
-- File: schema.sql
-- Engine Compatibility: PostgreSQL / SQLite / MySQL (ANSI SQL Standard)
-- Author: Application Support Analyst / Business Systems Analyst
-- =============================================================================

-- Drop tables if they exist to allow clean re-execution
DROP TABLE IF EXISTS ticket_status_history;
DROP TABLE IF EXISTS ticket_updates;
DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS ticket_categories;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS agents;

-- 1. CUSTOMERS TABLE (B2B Client Organizations)
CREATE TABLE customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL,
    industry VARCHAR(50) NOT NULL,
    subscription_tier VARCHAR(20) NOT NULL CHECK (subscription_tier IN ('Starter', 'Professional', 'Enterprise')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active INT DEFAULT 1 CHECK (is_active IN (0, 1))
);

-- 2. ACCOUNTS TABLE (Billing and Subscription Account Profiles)
CREATE TABLE accounts (
    account_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    billing_email VARCHAR(100) NOT NULL,
    max_users INT NOT NULL DEFAULT 10,
    is_tax_exempt INT DEFAULT 0 CHECK (is_tax_exempt IN (0, 1)),
    monthly_mrr DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

-- 3. USERS TABLE (End-Users and Admins belonging to Customer Organizations)
CREATE TABLE users (
    user_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(30) NOT NULL DEFAULT 'User',
    is_mfa_enabled INT DEFAULT 1 CHECK (is_mfa_enabled IN (0, 1)),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

-- 4. AGENTS TABLE (Internal Northstar Technical Support Personnel)
CREATE TABLE agents (
    agent_id VARCHAR(20) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    support_tier VARCHAR(20) NOT NULL CHECK (support_tier IN ('Tier 1 Help Desk', 'Tier 2 App Support', 'Tier 3 Engineering', 'Support Lead')),
    specialization VARCHAR(50) NOT NULL
);

-- 5. TICKET_CATEGORIES TABLE (Request Types and Problem Taxonomy)
CREATE TABLE ticket_categories (
    category_id VARCHAR(20) PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    default_priority VARCHAR(20) NOT NULL CHECK (default_priority IN ('P1 - Urgent', 'P2 - High', 'P3 - Medium', 'P4 - Low')),
    target_sla_hours INT NOT NULL
);

-- 6. TICKETS TABLE (Core Support Incidents and Service Requests)
CREATE TABLE tickets (
    ticket_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    user_id VARCHAR(20) NOT NULL,
    category_id VARCHAR(20) NOT NULL,
    assigned_agent_id VARCHAR(20),
    summary VARCHAR(255) NOT NULL,
    priority VARCHAR(20) NOT NULL CHECK (priority IN ('P1 - Urgent', 'P2 - High', 'P3 - Medium', 'P4 - Low')),
    status VARCHAR(30) NOT NULL CHECK (status IN ('Open', 'In Progress', 'Waiting for Customer', 'Escalated', 'Resolved')),
    root_cause VARCHAR(100),
    created_at TIMESTAMP NOT NULL,
    resolved_at TIMESTAMP,
    resolution_time_minutes INT,
    sla_breached INT DEFAULT 0 CHECK (sla_breached IN (0, 1)),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (category_id) REFERENCES ticket_categories(category_id),
    FOREIGN KEY (assigned_agent_id) REFERENCES agents(agent_id)
);

-- 7. TICKET_UPDATES TABLE (Audit Log of Internal Notes and Customer Communications)
CREATE TABLE ticket_updates (
    update_id INT PRIMARY KEY,
    ticket_id VARCHAR(20) NOT NULL,
    author_type VARCHAR(20) NOT NULL CHECK (author_type IN ('Customer', 'Agent', 'System')),
    author_id VARCHAR(20) NOT NULL,
    is_internal INT NOT NULL CHECK (is_internal IN (0, 1)),
    update_text TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL,
    FOREIGN KEY (ticket_id) REFERENCES tickets(ticket_id) ON DELETE CASCADE
);

-- 8. TICKET_STATUS_HISTORY TABLE (State Machine Audit Trail for SLA and Workflow Analysis)
CREATE TABLE ticket_status_history (
    history_id INT PRIMARY KEY,
    ticket_id VARCHAR(20) NOT NULL,
    old_status VARCHAR(30),
    new_status VARCHAR(30) NOT NULL,
    changed_by_agent_id VARCHAR(20),
    changed_at TIMESTAMP NOT NULL,
    FOREIGN KEY (ticket_id) REFERENCES tickets(ticket_id) ON DELETE CASCADE,
    FOREIGN KEY (changed_by_agent_id) REFERENCES agents(agent_id)
);

-- Index Creation for Query Optimization
CREATE INDEX idx_tickets_customer ON tickets(customer_id);
CREATE INDEX idx_tickets_status ON tickets(status);
CREATE INDEX idx_tickets_priority ON tickets(priority);
CREATE INDEX idx_tickets_category ON tickets(category_id);
CREATE INDEX idx_tickets_agent ON tickets(assigned_agent_id);
