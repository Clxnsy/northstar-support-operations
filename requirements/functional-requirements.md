# Functional and Non-Functional Requirements Specification
**Project:** Northstar Support Operations System  
**Document Code:** FRS-NFR-101  

---

## 1. Functional Requirements (FR)

| Req ID | Category | Description | Priority | Target Module | Validation Method |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **FR-001** | Ticket Ingestion | System must provide a customer portal with 6 specific request types: Login/Auth, Account Access, Bug, Data Issue, Billing, Feature Request. | Must Have | JSM Portal | Portal Form Inspection |
| **FR-002** | Form Validation | System must enforce mandatory submission fields (Account ID, Severity, Steps to Reproduce) based on selected request type. | Must Have | JSM Portal | Automated Field Test |
| **FR-003** | Workflow States | Ticket workflow must strictly transition through: Open -> In Progress -> Waiting for Customer -> Escalated -> Resolved. | Must Have | JSM Workflow | State Machine Audit |
| **FR-004** | SLA Timers | System must run response and resolution SLA timers automatically based on priority level (P1 to P4). | Must Have | JSM SLA Engine | Time-lapse Simulation |
| **FR-005** | SLA Pause | SLA resolution timer must automatically pause when ticket state changes to 'Waiting for Customer'. | Must Have | JSM SLA Engine | Event Trigger Test |
| **FR-006** | Auto-Assignment | System must route incoming tickets to specialized queues based on Request Type (e.g., Billing to Finance Queue). | Must Have | JSM Queues | Ticket Routing Verification |
| **FR-007** | Escalation Alerts | System must trigger internal notifications (Slack/Email) when a P1 ticket reaches 50% SLA threshold without assignment. | Must Have | JSM Automation | Webhook Trigger Test |
| **FR-008** | Internal Comments | System must distinguish between public customer replies and internal agent notes (yellow callout in JSM). | Must Have | JSM Agent Interface | Visibility Permissions Test |
| **FR-009** | Knowledge Deflection| System must suggest relevant KB articles in real-time as users type words into the portal summary field. | Should Have | JSM Portal / KB | Search Index Query Test |
| **FR-010** | Database Schema | SQL Database must maintain relational tables for customers, users, accounts, agents, tickets, updates, categories, and status history. | Must Have | SQL Database | Schema DDL Integrity Check |
| **FR-011** | SQL Analytics | System must provide 25 pre-built SQL queries to calculate ATTR, SLA breaches, ticket frequency by category, and recurring account issues. | Must Have | SQL Analytics | Query Output Verification |
| **FR-012** | Root Cause Field | Agents must select a standardized Root Cause category (e.g., Code Defect, User Error, DB State) before setting status to Resolved. | Must Have | JSM Field Validation | Closure Transition Test |
| **FR-013** | Customer Canned Responses| System must provide reusable internal response macros for common diagnostic requests (e.g., Browser Cache Clear, MFA Reset). | Should Have | JSM Templates | Macro Execution Test |
| **FR-014** | Audit Logging | Database must log every status change, timestamp, and changing user in `ticket_status_history`. | Must Have | SQL DB Triggers / Logs | Database Trigger Audit |
| **FR-015** | CSV Export/Import | System must export and import support ticket metadata cleanly using standardized RFC 4180 CSV formats. | Must Have | JSM Data Import | CSV Schema Import Test |

---

## 2. Non-Functional Requirements (NFR)

| Req ID | Category | Metric / Specification | Target Threshold | Priority |
| :--- | :--- | :--- | :--- | :--- |
| **NFR-001** | Performance | Customer portal submission response time | < 1.5 seconds | Must Have |
| **NFR-002** | Availability | Support Portal & Knowledge Base uptime | 99.9% uptime (24/7) | Must Have |
| **NFR-003** | Security | Role-Based Access Control (RBAC) restricting customer ticket visibility strictly to their own organization tenant. | 100% Tenant Isolation | Must Have |
| **NFR-004** | Data Integrity | SQL Database foreign key constraints enforced with zero orphaned records. | 0 Data Anomalies | Must Have |
| **NFR-005** | Scalability | Database schema capable of supporting 100,000+ ticket records without query latency exceeding 500ms. | Query execution < 500ms | Should Have |
| **NFR-006** | Usability | Knowledge base articles formatted with clear headings, callouts, and step-by-step instructions. | Flesch Reading Ease > 60 | Should Have |
| **NFR-007** | Compliance | Support ticket attachments and logs scrubbed of plaintext customer credit card and password data. | 100% Data Scrubbing | Must Have |
| **NFR-008** | Recoverability | SQL database backup capability with Point-in-Time Recovery (PITR). | Recovery Point Objective < 1 hr | Should Have |
