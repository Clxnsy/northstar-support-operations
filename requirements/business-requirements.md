# Business Requirements Document (BRD)
## Project Name: Northstar Support Operations System
**Document Version:** 1.0  
**Author:** Application Support / Business Systems Analyst  
**Target Organization:** Northstar Software Inc.  

---

## 1. Executive Summary
Northstar Software Inc. is a growing B2B Software-as-a-Service (SaaS) provider delivering a cloud-based Business Operations Platform to small and mid-sized enterprises (SMBs). The platform unifies resource management, billing automation, customer analytics, and operational workflows. Following a 65% year-over-year expansion in B2B customer accounts, Northstar experienced severe support operational friction: fragmented customer channels, inconsistent SLA enforcement, manual incident triage, and unindexed support data.

This Business Requirements Document outlines the end-to-end transformation of Northstar's support ecosystem. By implementing a standardized **Jira Service Management (JSM)** instance paired with a relational SQL data warehouse, automated escalation protocols, and a centralized knowledge base, Northstar aims to reduce Average Time to Resolution (ATTR) by 40%, achieve a 95% SLA compliance rate, and establish proactive root-cause trend reporting.

---

## 2. Business Problem Statement
Prior to this initiative, Northstar Software managed customer inquiries via unmanaged email inboxes and ad-hoc chat channels. This legacy structure resulted in significant operational vulnerabilities:
1. **Unstructured Request Ingestion:** Support requests lacked standardized fields, requiring multiple back-and-forth email exchanges simply to collect environment specs or tenant IDs.
2. **Missing SLA Enforcement:** Critical system outages and data discrepancies were treated with equal urgency as cosmetic feature requests, resulting in breach of key customer contracts.
3. **Siloed Diagnostic Data:** Technical support agents lacked direct visibility into backend database states (e.g., stuck tenant provisioning jobs, MFA sync errors), leading to unnecessary escalations to engineering.
4. **Zero Trend Visibility:** Support leadership possessed no mechanism to track recurring software bugs, chronic customer authentication issues, or agent productivity metrics.

---

## 3. Project Objectives
* **Standardize Triage & Ingestion:** Deploy Jira Service Management with 6 distinct request types, capturing mandatory diagnostic metadata upon submission.
* **Enforce Tiered SLAs:** Establish time-to-first-response and time-to-resolution SLAs mapped directly to priority levels (P1 Urgent through P4 Low).
* **Enable SQL-Based Operational Analytics:** Build a relational database schema mirroring support operations to query ticket volume, recurring incident patterns, and agent performance.
* **Formalize Tier 1–3 Escalation Paths:** Define clear handoff procedures between Tier 1 (Help Desk), Tier 2 (Application Support Analysts), and Tier 3 (Engineering/Product).
* **Deflect Common Inquiries:** Author 10 customer-facing Knowledge Base articles integrated into the request portal to deflect 20% of repetitive Tier 1 tickets.

---

## 4. Project Scope

### In-Scope
* Design and configuration documentation for Jira Service Management (Request Types, Workflows, Queues, SLAs, Automation Rules).
* Relational database schema (`schema.sql`), sample dataset (`sample-data.sql`), and 25 analytical SQL queries (`queries.sql`).
* 15 detailed User Stories with formal Given/When/Then Acceptance Criteria.
* 25 logically consistent Jira support tickets (CSV import format and documented details).
* 25 technical troubleshooting scenarios with root-cause analysis and Jira internal/external note templates.
* User Acceptance Testing (UAT) plan, 20 test cases, and formal bug reports for failed test scenarios.
* 10 customer-facing Knowledge Base (KB) articles for self-service support.

### Out-of-Scope
* Live webhook integrations with real-time third-party payment gateways (Stripe API) or identity providers (Okta/SAML).
* Automated code execution or patch deployment directly from Jira to production repositories.
* Provisioning actual paid SaaS infrastructure on Jira Cloud (configuration is documented for production deployment).

---

## 5. Stakeholder Matrix
| Stakeholder | Role | Primary Responsibility | Interest / Focus |
| :--- | :--- | :--- | :--- |
| **Sarah Jenkins** | VP of Customer Success | Project Sponsor | Executive metrics, CSAT, SLA compliance |
| **David Chen** | Support Operations Lead | Business Owner | Workflow efficiency, queue management, team capacity |
| **Elena Rostova** | Lead Application Support Analyst | Subject Matter Expert | Technical troubleshooting, escalation rules, SQL analytics |
| **Marcus Vance** | Product Manager | Key Stakeholder | Feature request tracking, bug prioritization, software stability |
| **Alex Rivera** | Tier 1 Technical Support Agent | End User | Queue layout, ticket submission forms, KB search |
| **B2B SMB Customers** | External Users | Request Originator | Quick resolution, transparent communications, portal usability |

---

## 6. Business Rules
* **BR-001 (Priority Assignment):** Ticket priority must be calculated based on Impact (number of affected users/tenants) and Urgency (core workflow blockage vs. workaround available).
* **BR-002 (P1 Escalation Protocol):** Any P1 Urgent ticket unresolved after 60 minutes must automatically escalate to Tier 3 Engineering and notify the VP of Customer Success.
* **BR-003 (MFA Lockout Verification):** Agents must execute multi-factor identity verification before granting manual account/password overrides.
* **BR-004 (Customer Communication State):** Moving a ticket to "Waiting for Customer" pauses the resolution SLA clock until the customer responds.
* **BR-005 (Data Correction Approval):** Any SQL update query executed against production customer tables must receive explicit approval from a Tier 2 Lead or Senior BSA.

---

## 7. Assumptions, Constraints, Risks, and Dependencies

### Assumptions
* Northstar B2B customers access the platform via modern web browsers (Chrome, Firefox, Edge, Safari).
* Support agents possess read-only SQL access to staging and production replica databases for diagnostic verification.

### Constraints
* All customer data strictly adheres to enterprise privacy and security protocols (fictionalized data used in this implementation).
* SLA windows are calculated based on 24/7 coverage for P1 issues and 8x5 business hours for P2–P4 issues.

### Risks & Mitigations
* **Risk:** High ticket submission volume causes SLA breaches.  
  *Mitigation:* Implement KB self-service deflection and automated ticket routing queues.
* **Risk:** Inaccurate root-cause classification by Tier 1 agents skewing reporting.  
  *Mitigation:* Enforce mandatory `Root Cause` dropdown fields prior to ticket closure.

---

## 8. Document Sign-Off
* **Business Analyst:** Clansy Barcklow (Lead Analyst)
* **Support Lead:** David Chen
* **VP Customer Success:** Sarah Jenkins
