# Support Process Flow Documentation
**Project:** Northstar Support Operations System  
**Document Code:** PF-301  

---

## 1. Executive Summary
This document contrasts Northstar Software's legacy **Current-State (As-Is)** support process with the newly engineered **Future-State (To-Be)** Jira Service Management workflow. The transformation introduces automated triage, strict SLA management, tiered escalation handoffs, and relational data capture.

---

## 2. Current-State Workflow (As-Is) — Manual & Unstructured

### Narrative Description
1. Customer encounters a problem (e.g., login failure or billing error) and sends a free-form email to `support@northstar.com` or contacts an employee via ad-hoc chat.
2. Inbound emails land in a shared, unindexed inbox monitored manually by Tier 1 agents.
3. No automated metadata capture exists. Agents manually reply asking for Tenant ID, Error Codes, or Screenshots.
4. Tickets are handled on a First-In, First-Out (FIFO) basis regardless of urgency. P1 System Outages wait behind P4 cosmetic requests.
5. Escalations occur via informal internal Slack messages ("Hey @dev-team, can someone look at DB error for Acme Corp?"). No tracking or SLA timers exist.
6. Issue resolution is communicated back via email. No root cause is logged, and no central database captures resolution metrics.

### Current-State Flowchart (ASCII)
```
[Customer] ---> Sends Email to support@northstar.com
                  |
                  v
       [Shared Inbox (Unindexed)]
                  |
         (Manual Review by Tier 1)
                  |
     +------------+------------+
     |                         |
(Missing Info)          (Technical Bug)
     |                         |
     v                         v
Asks for Tenant ID     Informal Slack Msg to Dev
Via Email Reply         "Can someone check this?"
     |                         |
     +------------+------------+
                  |
                  v
       Informal Email Reply
     (No Root Cause Logged)
```

---

## 3. Future-State Workflow (To-Be) — Automated JSM & SQL Operations

### Narrative Description
1. **Ingestion & Deflection:** Customer accesses the JSM Portal. Real-time KB article suggestions appear as the user types. If self-service fails, user selects 1 of 6 structured Request Types.
2. **Automated Triage & SLA Start:** Upon submission, JSM assigns Category ID, determines Priority (P1–P4) based on Impact/Urgency, routes to specialized Queue (e.g., Auth, Billing, Data), and starts SLA timers.
3. **Tier 1 Processing:** Tier 1 agent reviews queue. If issue is routine, agent executes Canned Response Macro. If resolved, agent selects Root Cause and closes ticket.
4. **Tier 2 / Tier 3 Escalation:** If complex, agent transitions status to `Escalated`. System enforces mandatory fields (Diagnostic Logs, DB Snippets). SLA clock adjusts. Tier 2/3 conducts SQL database investigation (`schema.sql`).
5. **Resolution & Analytics Sync:** Agent updates ticket to `Resolved`. JSM dispatches customer notification and logs transaction to SQL database (`tickets`, `ticket_updates`, `ticket_status_history`).

### Future-State Flowchart (Mermaid / ASCII)
```
[Customer Portal] ---> (1. Real-time KB Deflection)
        |
        v (If not deflected)
(2. Select Structured Request Type)
        |
        v
[Jira Service Management Ingestion Engine]
        |---> Calculate Priority (P1-P4) & Start SLA Clock
        |---> Auto-Route to Dedicated Queue
        |
        v
 [Tier 1 Triage Queue]
        |
        +---> [Resolved by T1 (Macro/KB)] ---> (Log Root Cause) -> [Closed]
        |
        +---> [Requires Tier 2 / Tier 3] 
                  |
                  v
      (Transition to 'Escalated')
      (Enforce Diagnostic Data Fields)
                  |
                  v
       [SQL DB Investigation]
                  |
                  v
     [Customer Communication & Resolve] ---> [Sync to SQL Data Warehouse]
```

---

## 4. Operational Comparison Matrix

| Workflow Dimension | Current-State (As-Is) | Future-State (To-Be) | Operational Impact |
| :--- | :--- | :--- | :--- |
| **Ingestion Channel** | Unstructured Email / Chat | Structured JSM Customer Portal | 100% standardized diagnostic metadata upfront |
| **Triage & Routing** | Manual inbox scanning | Automated Queue & Priority Rules | Eliminates 15 mins/ticket initial triage delay |
| **SLA Management** | None (FIFO) | Tiered SLAs (P1: 15m/2h, P4: 24h/5d) | 95%+ SLA compliance guarantee |
| **Escalation Path** | Ad-hoc Slack messages | Formal Transition States & Enforced Fields | Reduces Tier 3 investigation back-and-forth |
| **Analytics & BI** | Zero reporting | Relational SQL Warehouse (25 Queries) | Full leadership visibility into ATTR & Root Causes |
| **Self-Service** | None | Integrated Knowledge Base | 20% total ticket volume deflection |
