# Northstar System & Support Architecture
**Project:** Northstar Support Operations System  
**Document Code:** ARCH-101  

---

## 1. System Architecture Diagram (ASCII)

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

## 2. Component Interaction Overview
1. **Ingestion & Deflection:** Customers access the JSM Portal. Real-time KB deflection suggests articles as users type. If un-deflected, a structured request type captures mandatory diagnostic metadata upfront.
2. **Workflow & SLA Automation:** JSM processes ticket priority, auto-routes to dedicated queues, and activates SLA countdown clocks.
3. **Diagnostic Investigation:** Tier 1 Help Desk applies Canned Response Macros for routine issues. Complex data/system discrepancies escalate to Tier 2 Application Support Analysts, who run read-only queries against the SQL replica.
4. **Data Warehouse Sync:** Ticket updates, status transitions, and root-cause metrics sync to the relational SQL database schema (`schema.sql`), powering executive analytics and BI reporting.
