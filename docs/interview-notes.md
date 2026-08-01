# Master Interview Preparation Guide
**Project:** Northstar Support Operations System  
**Document Code:** INT-NOTE-901  
**Target Roles:** Application Support Analyst | Implementation Specialist | Business Systems Analyst | Technical Support Specialist | QA Analyst  

---

## Executive Interview Elevator Pitch
> *"I designed and built the **Northstar Support Operations System**, a recruiter-ready technical portfolio case study that models end-to-end support operations for a fictional B2B SaaS platform. I configured a complete Jira Service Management environment with 6 structured request types, automated SLA timers, and tiered queues. I engineered a relational SQL database with 25 analytical queries to track ticket trends and root causes, authored 15 user stories with Given/When/Then acceptance criteria, executed a 20-scenario UAT suite with formal bug reporting, and wrote 25 detailed technical troubleshooting scenarios alongside 10 customer-facing knowledge base articles."*

---

## Section 1: System Architecture & Design Questions

### Q1: Can you walk me through the overall architecture of the Northstar system?
**Answer:**  
The architecture follows a 4-tier operational flow:
1. **Ingestion & Deflection:** Customers submit tickets via a JSM Portal with 6 structured request types. Real-time Knowledge Base search suggests relevant self-service articles before submission.
2. **JSM Operational Core:** JSM automatically calculates priority (P1–P4) based on Impact and Urgency, routes tickets to dedicated queues (Auth, Billing, Bugs), and starts SLA countdown clocks.
3. **Tiered Technical Support Lab:** Tier 1 Help Desk handles routine inquiries using Canned Macros. Complex data issues escalate to Tier 2 Application Support Analysts, who run read-only diagnostic SQL queries against replica databases. Code defects escalate to Tier 3 Engineering.
4. **Relational Analytics Warehouse:** Support data syncs to a relational database schema (`customers`, `users`, `accounts`, `agents`, `tickets`, `ticket_updates`, `ticket_categories`, `ticket_status_history`), enabling 25 custom analytical SQL queries for executive BI reporting.

---

## Section 2: Jira Service Management & Workflow Questions

### Q2: Why did you choose those 6 specific Jira request types?
**Answer:**  
To eliminate unstructured email triage and capture mandatory diagnostic metadata upfront:
* `Login / Authentication`: Captures Tenant ID, MFA Method, and Error Codes upfront.
* `Account Access`: Captures requested roles and approval documents for security RBAC changes.
* `Software Bug`: Captures module, steps to reproduce, browser version, and expected vs actual behavior.
* `Data Issue`: Captures impacted entities, timestamps, and data discrepancies.
* `Billing / Account Issue`: Captures invoice numbers and payment gateway error codes (`ERR-PAY-902`).
* `Feature Request`: Captures business use cases and expected value for Product Management backlog review.

### Q3: How do your SLA policies and pause rules function?
**Answer:**  
* **P1 Urgent:** 15-minute response / 2-hour resolution SLA running on a 24/7 calendar.
* **P2 High:** 30-minute response / 4-hour resolution SLA.
* **P3 Medium / P4 Low:** 2–4 hour response / 8–24 hour resolution SLAs running on an 8x5 business hour calendar.
* **SLA Pause Rule:** Transitioning a ticket to `Waiting for Customer` automatically pauses the resolution clock, ensuring agent SLA metrics reflect active work time accurately without being penalized while waiting for external user replies.

---

## Section 3: Relational SQL Database & Analytics Questions

### Q4: How is your database structured, and what relationships did you establish?
**Answer:**  
The schema consists of 8 normalized relational tables:
* `customers` (1) to `accounts` (1) and `users` (Many).
* `tickets` (Many) foreign keyed to `customers`, `users`, `ticket_categories`, and `agents`.
* `ticket_updates` (Many) and `ticket_status_history` (Many) linked to `tickets` with `ON DELETE CASCADE` for full audit trails.

### Q5: Can you explain an advanced SQL query you wrote for business analysis?
**Answer:**  
I wrote **Query 18** using a Window Function (`ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY resolution_time_minutes ASC)`) inside a Common Table Expression (CTE) to partition tickets by category and rank the fastest resolved tickets per category for operational benchmarking.

I also wrote **Query 25**, a composite health score query that joins `customers`, `accounts`, and `tickets` using complex `CASE` logic to flag high MRR Enterprise accounts experiencing repeated P1 incidents for immediate Customer Success proactive outreach.

---

## Section 4: Troubleshooting Methodology & Root-Cause Analysis

### Q6: What is your structured troubleshooting methodology when handling a technical support issue?
**Answer:**  
I follow a 6-step diagnostic protocol:
1. **Symptom Clarification:** Gather exact error codes, user IDs, page URLs, and timestamps.
2. **Environment & Scope Assessment:** Determine if the issue is isolated to one user, one tenant account, or widespread infrastructure.
3. **Reproduction & Diagnostics:** Attempt to replicate in Staging or inspect server logs / replica database tables.
4. **Root Cause Isolation:** Identify whether the cause stems from software code defects, data corruption, misconfiguration, or external dependencies.
5. **Remediation & Workaround:** Deploy fix or provide a confirmed temporary workaround.
6. **Documentation & Knowledge Transfer:** Post Jira internal notes, update the customer, log root cause, and author a KB article to deflect future occurrences.

---

## Section 5: Requirements, User Stories, and UAT Testing

### Q7: How did you structure your user stories and acceptance criteria?
**Answer:**  
I authored 15 user stories (`US-001` through `US-015`) representing personas across B2B SaaS Admins, End Users, Tier 1 Agents, Tier 2 Analysts, CSMs, and Executives. Each story includes persona, narrative, business value, priority, and links to formal **Given-When-Then** acceptance criteria (`AC-001` through `AC-015`).

### Q8: Tell me about your UAT testing strategy and how you handled failed test cases.
**Answer:**  
I created a UAT Test Plan (`uat-test-plan.md`) and executed a 20-scenario test suite (`uat-test-cases.csv`). 16 test cases passed, while 4 failed intentionally (`TC-004`, `TC-009`, `TC-014`, `TC-018`) to model real-world QA bug logging. For each failed test, I created a formal Bug Report (`BUG-001` through `BUG-004`) containing environment details, preconditions, reproduction steps, expected vs actual behavior, stack traces, business impact, and suggested code fixes.
