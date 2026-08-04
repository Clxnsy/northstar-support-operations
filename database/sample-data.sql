-- =============================================================================
-- Northstar Support Operations System - Sample Dataset
-- File: sample-data.sql
-- Description: Realistic B2B SaaS operational data matching 25 JSM tickets
-- =============================================================================

-- 1. POPULATE CUSTOMERS
INSERT INTO customers (customer_id, company_name, industry, subscription_tier, created_at, is_active) VALUES
('CUST-001', 'Acme Corp', 'Manufacturing', 'Enterprise', '2025-01-15 09:00:00', 1),
('CUST-002', 'Apex Logistics', 'Transportation', 'Enterprise', '2025-02-10 10:30:00', 1),
('CUST-003', 'Summit Financial', 'Financial Services', 'Enterprise', '2025-03-01 11:15:00', 1),
('CUST-004', 'Beacon Health', 'Healthcare', 'Enterprise', '2025-03-20 14:00:00', 1),
('CUST-005', 'Horizon Retail', 'E-Commerce', 'Professional', '2025-04-05 08:45:00', 1),
('CUST-006', 'Vanguard Tech', 'Software', 'Professional', '2025-05-12 16:20:00', 1),
('CUST-007', 'Crestview Real Estate', 'Real Estate', 'Starter', '2025-06-01 09:10:00', 1),
('CUST-008', 'Synergy Media', 'Digital Media', 'Starter', '2025-06-18 13:00:00', 1);

-- 2. POPULATE ACCOUNTS
INSERT INTO accounts (account_id, customer_id, billing_email, max_users, is_tax_exempt, monthly_mrr) VALUES
('ACC-001', 'CUST-001', 'billing@acme.com', 250, 1, 4500.00),
('ACC-002', 'CUST-002', 'ap@apexlogistics.com', 150, 0, 3200.00),
('ACC-003', 'CUST-003', 'finance@summitfinancial.com', 100, 0, 5000.00),
('ACC-004', 'CUST-004', 'accounts@beaconhealth.com', 300, 1, 6200.00),
('ACC-005', 'CUST-005', 'payables@horizonretail.com', 50, 0, 1500.00),
('ACC-006', 'CUST-006', 'billing@vanguardtech.io', 75, 0, 2200.00),
('ACC-007', 'CUST-007', 'admin@crestviewre.com', 20, 0, 800.00),
('ACC-008', 'CUST-008', 'finance@synergymedia.com', 15, 0, 600.00);

-- 3. POPULATE USERS
INSERT INTO users (user_id, customer_id, first_name, last_name, email, role, is_mfa_enabled, created_at) VALUES
('USER-101', 'CUST-001', 'John', 'Doe', 'john.doe@acme.com', 'Admin', 1, '2025-01-16 09:30:00'),
('USER-102', 'CUST-001', 'Jane', 'Smith', 'j.smith@acme.com', 'Admin', 1, '2025-01-16 10:00:00'),
('USER-103', 'CUST-002', 'Sarah', 'Connor', 's.connor@apexlogistics.com', 'Manager', 1, '2025-02-11 11:00:00'),
('USER-104', 'CUST-003', 'Robert', 'Taylor', 'r.taylor@summitfinancial.com', 'Analyst', 1, '2025-03-02 14:00:00'),
('USER-105', 'CUST-004', 'Emily', 'Watson', 'e.watson@beaconhealth.com', 'Compliance Officer', 1, '2025-03-21 09:00:00'),
('USER-106', 'CUST-005', 'Michael', 'Brown', 'm.brown@horizonretail.com', 'Store Manager', 0, '2025-04-06 10:15:00'),
('USER-107', 'CUST-006', 'David', 'Miller', 'd.miller@vanguardtech.io', 'Developer', 1, '2025-05-13 11:30:00'),
('USER-108', 'CUST-007', 'Amanda', 'White', 'a.white@crestviewre.com', 'Admin', 0, '2025-06-02 15:45:00'),
('USER-109', 'CUST-008', 'Mary', 'Jane', 'mary-jane@synergymedia.com', 'Editor', 1, '2025-06-19 08:30:00');

-- 4. POPULATE AGENTS
INSERT INTO agents (agent_id, full_name, email, support_tier, specialization) VALUES
('AGT-001', 'Sarah Jenkins', 's.jenkins@northstar.com', 'Tier 1 Help Desk', 'Authentication & Access'),
('AGT-002', 'Alex Rivera', 'a.rivera@northstar.com', 'Tier 1 Help Desk', 'General & Application Config'),
('AGT-003', 'Marcus Vance', 'm.vance@northstar.com', 'Tier 3 Engineering', 'Software Defects & Codebase'),
('AGT-004', 'Elena Rostova', 'e.rostova@northstar.com', 'Tier 2 App Support', 'Data Pipeline & Database Integrity'),
('AGT-005', 'David Chen', 'd.chen@northstar.com', 'Support Lead', 'Billing Operations & SLA Management');

-- 5. POPULATE TICKET CATEGORIES
INSERT INTO ticket_categories (category_id, category_name, default_priority, target_sla_hours) VALUES
('CAT-001', 'Login / Authentication', 'P1 - Urgent', 2),
('CAT-002', 'Account Access', 'P2 - High', 4),
('CAT-003', 'Software Bug', 'P2 - High', 4),
('CAT-004', 'Data Issue', 'P2 - High', 4),
('CAT-005', 'Billing / Account Issue', 'P3 - Medium', 8),
('CAT-006', 'Feature Request', 'P4 - Low', 24);

-- 6. POPULATE TICKETS (Matching 25 Tickets)
INSERT INTO tickets (ticket_id, customer_id, user_id, category_id, assigned_agent_id, summary, priority, status, root_cause, created_at, resolved_at, resolution_time_minutes, sla_breached) VALUES
('NS-1001', 'CUST-001', 'USER-101', 'CAT-001', 'AGT-001', 'MFA code rejection loop on primary admin account', 'P1 - Urgent', 'Resolved', 'Infrastructure / Server Time Drift', '2026-08-01 08:00:00', '2026-08-01 09:15:00', 75, 0),
('NS-1002', 'CUST-002', 'USER-103', 'CAT-002', 'AGT-002', 'Newly provisioned dispatch manager lacks role permissions', 'P2 - High', 'Resolved', 'Database State / Incomplete Transaction', '2026-08-01 09:30:00', '2026-08-01 11:45:00', 135, 0),
('NS-1003', 'CUST-003', 'USER-104', 'CAT-003', 'AGT-003', 'Q2 Expense Export crashes on CSV format selection', 'P2 - High', 'Escalated', 'Software Defect / Unhandled Null Pointer', '2026-08-01 10:15:00', NULL, NULL, 1),
('NS-1004', 'CUST-004', 'USER-105', 'CAT-004', 'AGT-004', 'Duplicate invoice records generated during monthly billing run', 'P1 - Urgent', 'Resolved', 'Software Defect / Lack of Billing Idempotency', '2026-08-01 11:00:00', '2026-08-01 12:50:00', 110, 0),
('NS-1005', 'CUST-005', 'USER-106', 'CAT-005', 'AGT-002', 'Update credit card details failing with gateway token error', 'P3 - Medium', 'Waiting for Customer', 'External Dependency / Stripe Token Expiration', '2026-08-01 13:20:00', NULL, NULL, 0),
('NS-1006', 'CUST-006', 'USER-107', 'CAT-006', 'AGT-005', 'Request for Webhook Notifications on Ticket Status Change', 'P4 - Low', 'Resolved', 'Product Capability Gap / Feature Enhancement', '2026-08-02 09:00:00', '2026-08-02 15:00:00', 360, 0),
('NS-1007', 'CUST-007', 'USER-108', 'CAT-001', 'AGT-004', 'SAML SSO assertion failure following Azure AD cert renewal', 'P1 - Urgent', 'Resolved', 'Customer Misconfiguration / Outdated SSO Certificate', '2026-08-02 10:00:00', '2026-08-02 11:30:00', 90, 0),
('NS-1008', 'CUST-008', 'USER-109', 'CAT-003', 'AGT-003', 'Bulk user import tool silently drops users with hyphens in email', 'P2 - High', 'In Progress', 'Software Defect / Overly Restrictive Regex', '2026-08-02 11:15:00', NULL, NULL, 0),
('NS-1009', 'CUST-001', 'USER-102', 'CAT-002', 'AGT-001', 'Transfer Primary Owner privileges from departed employee', 'P2 - High', 'Resolved', 'Administrative Request / Account Transfer', '2026-08-02 13:00:00', '2026-08-02 15:15:00', 135, 0),
('NS-1010', 'CUST-002', 'USER-103', 'CAT-004', 'AGT-002', 'Historical telemetry reporting missing data for July 14th', 'P3 - Medium', 'Resolved', 'Data Pipeline / Unprocessed Kafka Dead-Letter Queue', '2026-08-03 08:30:00', '2026-08-03 12:45:00', 255, 0),
('NS-1011', 'CUST-003', 'USER-104', 'CAT-005', 'AGT-005', 'Tiered user license seats not auto-expanding upon invitation', 'P3 - Medium', 'Resolved', 'CRM Integration Sync Failure', '2026-08-03 09:45:00', '2026-08-03 14:00:00', 255, 0),
('NS-1012', 'CUST-004', 'USER-105', 'CAT-001', 'AGT-004', 'Password reset token expires instantly upon generation', 'P1 - Urgent', 'Resolved', 'Customer Email Security Scanner (Link Pre-Fetching)', '2026-08-03 10:30:00', '2026-08-03 12:00:00', 90, 0),
('NS-1013', 'CUST-005', 'USER-106', 'CAT-003', 'AGT-003', 'Inventory sync widget displays blank white screen on Safari browser', 'P3 - Medium', 'In Progress', 'Software Defect / Frontend Browser Transpilation', '2026-08-03 14:00:00', NULL, NULL, 0),
('NS-1014', 'CUST-006', 'USER-107', 'CAT-004', 'AGT-004', 'Resource allocation report shows negative hour balances', 'P2 - High', 'Resolved', 'Data Discrepancy / Overlapping Timecard Records', '2026-08-04 09:00:00', '2026-08-04 12:15:00', 195, 0),
('NS-1015', 'CUST-007', 'USER-108', 'CAT-006', 'AGT-002', 'Custom branding options for tenant client portal', 'P4 - Low', 'Open', NULL, '2026-08-04 10:30:00', NULL, NULL, 0),
('NS-1016', 'CUST-008', 'USER-109', 'CAT-002', 'AGT-001', 'Bulk permission revoking failed midway through execution', 'P2 - High', 'Resolved', 'API Timeout / Batch Processing Constraint', '2026-08-04 11:45:00', '2026-08-04 14:30:00', 165, 0),
('NS-1017', 'CUST-002', 'USER-103', 'CAT-001', 'AGT-002', 'Session timeout enforcing logout every 5 minutes unexpectedly', 'P2 - High', 'Resolved', 'Application Configuration / Session Cookie Policy', '2026-08-04 13:15:00', '2026-08-04 16:00:00', 165, 0),
('NS-1018', 'CUST-001', 'USER-101', 'CAT-005', 'AGT-005', 'Tax exempt certificate not reflecting on automated invoice', 'P3 - Medium', 'Resolved', 'Third-Party Integration Cache / Tax Gateway', '2026-08-05 08:15:00', '2026-08-05 12:30:00', 255, 0),
('NS-1019', 'CUST-004', 'USER-105', 'CAT-003', 'AGT-003', 'Patient scheduling calendar shifts appointments by 1 hour (DST issue)', 'P2 - High', 'In Progress', 'Software Defect / Timezone Parsing Defect', '2026-08-05 09:30:00', NULL, NULL, 0),
('NS-1020', 'CUST-003', 'USER-104', 'CAT-004', 'AGT-004', 'GL Account Code mapping corrupted after nightly sync', 'P1 - Urgent', 'Resolved', 'Data Ingestion / Unescaped Delimiter In Input Data', '2026-08-05 10:45:00', '2026-08-05 12:15:00', 90, 0),
('NS-1021', 'CUST-005', 'USER-106', 'CAT-001', 'AGT-002', 'Active Directory LDAP sync dropping new store manager credentials', 'P2 - High', 'Resolved', 'Application Configuration / LDAP Search Path Constraint', '2026-08-05 13:00:00', '2026-08-05 15:45:00', 165, 0),
('NS-1022', 'CUST-004', 'USER-105', 'CAT-006', 'AGT-005', 'HIPAA Audit Trail Export with automated scheduled delivery', 'P3 - Medium', 'Open', NULL, '2026-08-06 09:00:00', NULL, NULL, 0),
('NS-1023', 'CUST-007', 'USER-108', 'CAT-003', 'AGT-002', 'Property document upload button disabled for guest tenant accounts', 'P3 - Medium', 'Resolved', 'Software Defect / Logic Check Bug', '2026-08-06 10:15:00', '2026-08-06 13:30:00', 195, 0),
('NS-1024', 'CUST-006', 'USER-107', 'CAT-002', 'AGT-004', 'API Key generation tool throws 500 error for non-superadmin users', 'P2 - High', 'Resolved', 'Software Defect / Missing Foreign Key Parameter in API Handler', '2026-08-06 11:30:00', '2026-08-06 14:15:00', 165, 0),
('NS-1025', 'CUST-008', 'USER-109', 'CAT-004', 'AGT-001', 'Analytics storage quota warning triggered in error', 'P3 - Medium', 'Resolved', 'Application Logic / Misconfigured Cron Quota Query', '2026-08-06 14:00:00', '2026-08-06 16:45:00', 165, 0);

-- 7. POPULATE TICKET UPDATES (Audit Trail Sample)
INSERT INTO ticket_updates (update_id, ticket_id, author_type, author_id, is_internal, update_text, created_at) VALUES
(1, 'NS-1001', 'Customer', 'USER-101', 0, 'Cannot log in. MFA displays Invalid Token ERR-401.', '2026-08-01 08:00:00'),
(2, 'NS-1001', 'Agent', 'AGT-001', 1, 'Checked auth node auth-prod-02. Time drift detected on NTP server.', '2026-08-01 08:20:00'),
(3, 'NS-1001', 'Agent', 'AGT-001', 0, 'Resynced server clock. Please attempt login now.', '2026-08-01 09:15:00'),
(4, 'NS-1003', 'Customer', 'USER-104', 0, 'CSV export crashes with 500 error on Q2 report.', '2026-08-01 10:15:00'),
(5, 'NS-1003', 'Agent', 'AGT-003', 1, 'Replicated NullPointerException in staging due to NULL category.', '2026-08-01 10:45:00');

-- 8. POPULATE TICKET STATUS HISTORY
INSERT INTO ticket_status_history (history_id, ticket_id, old_status, new_status, changed_by_agent_id, changed_at) VALUES
(1, 'NS-1001', 'Open', 'In Progress', 'AGT-001', '2026-08-01 08:15:00'),
(2, 'NS-1001', 'In Progress', 'Resolved', 'AGT-001', '2026-08-01 09:15:00'),
(3, 'NS-1003', 'Open', 'In Progress', 'AGT-003', '2026-08-01 10:30:00'),
(4, 'NS-1003', 'In Progress', 'Escalated', 'AGT-003', '2026-08-01 11:00:00');
