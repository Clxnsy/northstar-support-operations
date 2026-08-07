# Northstar Support Operations System
**Enterprise Technical Portfolio Case Study | SaaS Support & Business Systems Analysis**

[![Jira Service Management](https://img.shields.io/badge/Jira%20Service%20Management-0052CC?style=for-the-badge&logo=jira&logoColor=white)](https://www.atlassian.com/software/jira/service-management)
[![SQL](https://img.shields.io/badge/SQL-PostgreSQL%2FSQLite-336791?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Agile / Scrum](https://img.shields.io/badge/Agile-Scrum%20%26%20UAT-2088FF?style=for-the-badge&logo=agile&logoColor=white)](#)
[![Documentation](https://img.shields.io/badge/Docs-Recruiter%20Ready-00A86B?style=for-the-badge&logo=markdown&logoColor=white)](#)

---

## Executive Project Summary
The **Northstar Support Operations System** is a complete, production-grade support operations framework designed for a fictional B2B Software-as-a-Service (SaaS) platform, **Northstar Software Inc.**. 

Faced with a 65% year-over-year increase in client accounts, Northstar experienced severe support friction: unindexed email channels, missing SLA enforcement, uncaptured root causes, and zero operational analytics. This portfolio project models the end-to-end technical transformation of Northstar's support ecosystem by implementing:
* **Jira Service Management (JSM):** 6 structured request types, automated SLA engines, 5-state workflows, and 8 dedicated queues.
* **Relational SQL Database Warehouse:** Normalized schema DDL (`schema.sql`), sample dataset (`sample-data.sql`), and 25 business analysis queries (`queries.sql`) yielding 100% executable analytics.
* **Business Systems Analysis:** BRD, Functional Requirements (`FR-001` to `FR-015`), 15 User Stories with Given/When/Then Acceptance Criteria, and Process Flow diagrams.
* **Technical Support Lab:** 25 detailed troubleshooting scenarios covering authentication, database corruption, API timeouts, and browser rendering defects.
* **Quality Assurance & Testing:** UAT Test Plan, 20-scenario test execution suite, and 4 formal Bug Reports for failed test cases.
* **Knowledge Base:** 10 customer-facing Help Center articles for 20% ticket volume deflection.

---

## System Architecture

```
+-----------------------------------------------------------------------------------+
|                            EXTERNAL B2B CLIENT LAYER                              |
|                                                                                   |
|  [ B2B SaaS Admins ]      [ End Users / Managers ]     [ Billing Contacts ]       |
+-----------------------------------------------------------------------------------+
                                         |
                       (HTTPS / REST / Web Portal Ingestion)
                                         v
+-----------------------------------------------------------------------------------+
|                        SUPPORT INGESTION & DEFLECTION LAYER                       |
|                                                                                   |
|   +------------------------------------+   +----------------------------------+   |
|   |  JSM Customer Support Portal       |   |  Knowledge Base Deflection Engine|   |
|   |  (6 Structured Request Types)      |   |  (10 Customer-Facing KB Articles)|   |
|   +------------------------------------+   +----------------------------------+   |
+-----------------------------------------------------------------------------------+
                                         |
                         (Jira Automation & Triage Engine)
                                         v
+-----------------------------------------------------------------------------------+
|                     JIRA SERVICE MANAGEMENT OPERATIONAL CORE                      |
|                                                                                   |
|  +--------------------+   +----------------------+   +-------------------------+  |
|  | Request Type Forms |   | Workflows (5 States) |   | SLAs (P1: 15m/2h Clock) |  |
|  +--------------------+   +----------------------+   +-------------------------+  |
|  | Auto-Routing Queues|   | Escalation Alerts    |   | RBAC Security & Portal  |  |
|  +--------------------+   +----------------------+   +-------------------------+  |
+-----------------------------------------------------------------------------------+
                                         |
                   (Tiered Escalations & DB Diagnostic Sync)
                                         v
+-----------------------------------------------------------------------------------+
|                         TIERED TECHNICAL SUPPORT LAB                              |
|                                                                                   |
|   +-------------------+     +----------------------+     +---------------------+  |
|   | Tier 1 Help Desk  | --> | Tier 2 App Analysts  | --> | Tier 3 Engineering  |  |
|   | (Triage & Macros) |     | (SQL Replica Access) |     | (Hotfix / Bug Fix)  |  |
|   +-------------------+     +----------------------+     +---------------------+  |
+-----------------------------------------------------------------------------------+
                                         |
                   (Data Ingestion & Event Synchronization)
                                         v
+-----------------------------------------------------------------------------------+
|                       RELATIONAL SQL ANALYTICS WAREHOUSE                          |
|                                                                                   |
|   [ customers ] <--- [ accounts ]      [ ticket_categories ]                      |
|        |                   |                     |                                |
|        +-------+           +-------+             |                                |
|                |                   |             |                                |
|                v                   v             v                                |
|            [ users ] ---------> [ TICKETS ] <-------- [ agents ]                  |
|                                     |    |                                        |
|                                     |    +----> [ ticket_status_history ]         |
|                                     v                                             |
|                             [ ticket_updates ]                                    |
+-----------------------------------------------------------------------------------+
                                         |
                       (25 Business Analysis SQL Queries)
                                         v
+-----------------------------------------------------------------------------------+
|                      EXECUTIVE REPORTING & BI DASHBOARDS                          |
|                                                                                   |
|  [ ATTR Metrics ]   [ SLA Breach Rates ]   [ Root Cause Trends ]   [ Account Health ] |
+-----------------------------------------------------------------------------------+
```

---

## Jira Service Management Architecture & Workflow

### 1. Request Types
1. **Login / Authentication:** Password resets, MFA loops, SSO/SAML failures, account lockouts.
2. **Account Access:** Role provisioning, permissions, account owner transfers, seat expansions.
3. **Software Bug:** Application errors, UI glitches, CSV exporter crashes, browser defects.
4. **Data Issue:** Corrupted data, pipeline delays, duplicate invoices, GL account mapping offsets.
5. **Billing / Account Issue:** Payment gateway errors (`ERR-PAY-902`), tax exemptions, billing receipts.
6. **Feature Request:** Enhancements, webhook notifications, custom portal branding.

### 2. Workflow State Machine
`Open` -> `In Progress` -> `Waiting for Customer` (SLA Paused) -> `Escalated` -> `Resolved` (SLA Stopped).

### 3. Service Level Agreements (SLAs)
* **P1 Urgent:** 15m First Response / 2h Resolution (24/7 Schedule)
* **P2 High:** 30m First Response / 4h Resolution (24/7 Schedule)
* **P3 Medium:** 2h First Response / 8h Resolution (8x5 Business Hours)
* **P4 Low:** 4h First Response / 24h Resolution (8x5 Business Hours)

---

## SQL Database Analytics & Query Highlights

The relational database (`database/schema.sql`) provides full relational tracking. Below are sample business analysis queries from `database/queries.sql`:

### Example 1: Proactive Account Outreach Recommendation (Composite Health Score)
```sql
-- Identifies high MRR accounts experiencing repeated P1 incidents for Customer Success outreach
SELECT 
    c.company_name,
    c.subscription_tier,
    a.monthly_mrr,
    COUNT(t.ticket_id) AS total_tickets,
    SUM(CASE WHEN t.priority = 'P1 - Urgent' THEN 1 ELSE 0 END) AS urgent_count,
    CASE 
        WHEN SUM(CASE WHEN t.priority = 'P1 - Urgent' THEN 1 ELSE 0 END) >= 1 THEN 'CRITICAL - Schedule CSM Call Immediately'
        WHEN COUNT(t.ticket_id) >= 4 THEN 'HIGH - Perform Account Health Review'
        ELSE 'NORMAL - Routine Support'
    END AS proactive_outreach_recommendation
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN tickets t ON c.customer_id = t.customer_id
GROUP BY c.company_name, c.subscription_tier, a.monthly_mrr
ORDER BY urgent_count DESC, total_tickets DESC;
```

### Example 2: Window Function — Ranking Resolution Speed per Category
```sql
-- Uses ROW_NUMBER() OVER (PARTITION BY) to rank fastest resolved tickets per category
WITH RankedResolutionTimes AS (
    SELECT 
        ticket_id,
        category_id,
        summary,
        resolution_time_minutes,
        ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY resolution_time_minutes ASC) AS rank_in_category
    FROM tickets
    WHERE status = 'Resolved' AND resolution_time_minutes IS NOT NULL
)
SELECT 
    tc.category_name,
    r.ticket_id,
    r.summary,
    r.resolution_time_minutes
FROM RankedResolutionTimes r
JOIN ticket_categories tc ON r.category_id = tc.category_id
WHERE r.rank_in_category = 1;
```

---

## Repository Structure

```text
northstar-support-operations/
│
├── README.md                           # Main recruiter-facing portfolio case study
│
├── requirements/                       # Business Analysis & Requirements Engineering
│   ├── business-requirements.md        # Executive BRD, stakeholder matrix, business rules
│   ├── functional-requirements.md      # Detailed FRs (FR-001 to FR-015) & NFRs
│   ├── user-stories.md                 # 15 structured User Stories
│   ├── acceptance-criteria.md          # Given/When/Then Acceptance Criteria (AC-001 to AC-015)
│   └── process-flows.md                # As-Is vs To-Be process workflows & flowcharts
│
├── database/                           # Relational SQL Data Warehouse
│   ├── schema.sql                      # DDL schema (8 tables, PK/FK, constraints, indexes)
│   ├── sample-data.sql                 # Seed dataset matching 25 support tickets
│   └── queries.sql                     # 25 business analysis SQL queries (CTEs, Window Funcs)
│
├── jira/                               # Jira Service Management Configuration Suite
│   ├── jira-configuration.md           # Request types, priorities, severity matrix, policies
│   ├── support-tickets.csv             # 25 realistic JSM import-ready support tickets
│   ├── workflows.md                    # 5-state workflow definition & transition validators
│   ├── queues.md                       # 8 configured support queues & JQL filter rules
│   └── sla-policies.md                 # SLA targets, calendars, pause rules, escalation alerts
│
├── testing/                            # Quality Assurance & Software Testing Suite
│   ├── uat-test-plan.md                # Master UAT Test Plan
│   ├── uat-test-cases.csv              # 20 UAT test cases (PASS/FAIL criteria)
│   └── bug-reports.md                  # Formal bug reports for failed test cases (BUG-001 to 004)
│
├── support/                            # Technical Support Lab & Self-Service Knowledge Base
│   ├── troubleshooting-scenarios.md    # 25 detailed diagnostic troubleshooting scenarios
│   ├── escalation-guide.md             # Tier 1 -> Tier 2 -> Tier 3 handover protocols
│   └── knowledge-base/                 # 10 customer-facing Help Center articles (KB-001 to 010)
│
├── docs/                               # Architecture, Executive Summaries, & Interview Prep
│   ├── architecture.md                 # System architecture diagram & component interactions
│   ├── project-summary.md              # Executive summary & key results metrics
│   └── interview-notes.md              # Master Q&A preparation guide for interviews
```

---

## Key Skills Demonstrated
* **Jira Service Management (JSM):** Request Type Design, JQL Queues, SLA Automation, Workflow Validators, Internal Notes vs External Communications.
* **Relational SQL Database:** Schema DDL Design, Data Modeling, ANSI SQL, CTEs, Window Functions (`ROW_NUMBER`, `AVG OVER`), Aggregations, Joins.
* **Business Systems Analysis:** Business Requirements Documents (BRD), Functional/Non-Functional Specs, Process Flow Mapping (As-Is / To-Be), Stakeholder Matrices.
* **Requirements & Agile Development:** User Stories, Given/When/Then Acceptance Criteria, Prioritization (Impact/Urgency).
* **Quality Assurance & Testing:** UAT Test Planning, Test Case Execution (CSV), Defect Tracking, Root Cause Analysis, Formal Bug Reporting.
* **Technical Support & SaaS Operations:** Tier 1–3 Escalations, Root Cause Analysis (RCA), Technical Troubleshooting, Customer Communication, Knowledge Base Authoring.

---

## Key Lessons Learned & Operational Insights
1. **Upfront Data Capture Prevents Support Latency:** Mandatory portal fields (Tenant ID, Error Codes) reduce back-and-forth communication by 2+ days per incident.
2. **SLA Pause Rules Ensure Fair Reporting:** Pausing the SLA clock during `Waiting for Customer` prevents agent performance metrics from being distorted by client delays.
3. **Relational Analytics Bridge Support and Product:** Mapping tickets to structured `root_cause` values provides Product Engineering with clear data to prioritize software bug hotfixes.

---

## Author & Contact
* **Author:** Clansy Barcklow  
* **Target Roles:** Application Support Analyst | Implementation Specialist | Business Systems Analyst | Technical Support Specialist | QA Analyst  
