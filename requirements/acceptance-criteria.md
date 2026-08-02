# Acceptance Criteria Specification
**Project:** Northstar Support Operations System  
**Document Code:** AC-2026  

---

## Overview
This document specifies formal **Given-When-Then** Acceptance Criteria for each User Story (`US-001` through `US-015`). These criteria define the exact verification steps required for User Acceptance Testing (UAT).

---

### AC-001: Request Type Portal Selection
**Linked User Story:** US-001

* **GIVEN** The user is logged into the Northstar Customer Support Portal.
* **WHEN** The user clicks 'New Request' and selects one of the 6 predefined request types (Login/Auth, Account Access, Bug, Data Issue, Billing, Feature Request).
* **THEN** The system displays the tailored submission form containing fields specific to that request type, and upon submission, routes the ticket directly to the corresponding functional queue.

---

### AC-002: Real-Time KB Article Deflection
**Linked User Story:** US-002

* **GIVEN** The customer is on the ticket submission portal page.
* **WHEN** The customer types keywords like 'password reset' or 'browser cache' into the Summary field.
* **THEN** The system displays a list of top 3 matching Knowledge Base articles below the summary field before submission.

---

### AC-003: Mandatory Metadata Collection on Auth Tickets
**Linked User Story:** US-003

* **GIVEN** An end user selects 'Login / Authentication' as their request type.
* **WHEN** The user attempts to submit the form without filling in the 'Tenant ID' or 'Error Code' fields.
* **THEN** The system blocks submission, highlights missing mandatory fields in red, and prompts the user to complete them.

---

### AC-004: Automated Queue Placement
**Linked User Story:** US-004

* **GIVEN** A ticket is submitted with request type 'Billing / Account Issue'.
* **WHEN** The system ingests the ticket.
* **THEN** The ticket is automatically assigned to the 'Billing & Financial Operations' queue and tagged with Category ID 'CAT-005'.

---

### AC-005: Internal Note Visibility Isolation
**Linked User Story:** US-005

* **GIVEN** A support agent is viewing an active ticket in the agent interface.
* **WHEN** The agent posts a comment using the 'Internal Note' tab (yellow background).
* **THEN** The note is saved to the internal audit history visible to agents, but remains strictly hidden from the customer portal view.

---

### AC-006: Structured Tier 3 Escalation Handoff
**Linked User Story:** US-006

* **GIVEN** A Tier 2 specialist determines a ticket requires Engineering investigation.
* **WHEN** The agent transitions status from 'In Progress' to 'Escalated' and tags Tier 3 Engineering.
* **THEN** The system prompts for mandatory fields 'Steps to Reproduce', 'DB Query Snippet', and 'Impacted Tenant ID' before permitting status change.

---

### AC-007: SLA Clock Pause on Customer Pending
**Linked User Story:** US-007

* **GIVEN** A ticket has an active Time to Resolution SLA countdown timer.
* **WHEN** The agent updates ticket status to 'Waiting for Customer'.
* **THEN** The SLA timer pauses immediately and displays 'PAUSED' badge until a customer reply is logged.

---

### AC-008: 50% SLA Threshold Breach Alert
**Linked User Story:** US-008

* **GIVEN** A P1 Urgent ticket is created with a 2-hour resolution SLA.
* **WHEN** Elapsed time reaches 60 minutes (50%) without an assigned agent.
* **THEN** An automated alert is sent to the `#support-p1-escalations` Slack channel and an email notification is dispatched to David Chen.

---

### AC-009: Mandatory Root Cause Selection on Close
**Linked User Story:** US-009

* **GIVEN** An agent is attempting to resolve an issue.
* **WHEN** The agent sets the status dropdown to 'Resolved'.
* **THEN** The system prompts for 'Root Cause' selection (e.g., Code Defect, Data Discrepancy, User Error) and prevents resolution if left blank.

---

### AC-010: Billing Queue Access Restriction
**Linked User Story:** US-010

* **GIVEN** A user with 'Tier 1 General Support' role attempts to access the Billing Queue.
* **WHEN** The user clicks on the Billing Queue tab.
* **THEN** Access is denied with message 'Insufficient Privileges — Financial Data Restricted' unless the user holds 'Billing Specialist' role.

---

### AC-011: Relational SQL Query Execution
**Linked User Story:** US-011

* **GIVEN** Support data is synced to the relational database.
* **WHEN** A Business Systems Analyst executes a SQL query joining `tickets`, `customers`, and `ticket_categories`.
* **THEN** The database executes the query in under 500ms and returns correct aggregated metrics matching Jira records.

---

### AC-012: Canned Response Macro Application
**Linked User Story:** US-012

* **GIVEN** An agent is responding to a user suffering from browser cache corruption.
* **WHEN** The agent selects macro `/canned-browser-clear`.
* **THEN** The response text box populates instantly with step-by-step cache clearing instructions tailored to Chrome, Firefox, and Edge.

---

### AC-013: Organization-Wide Portal Ticket Visibility
**Linked User Story:** US-013

* **GIVEN** A B2B SaaS Admin logs into the portal.
* **WHEN** The Admin navigates to 'My Organization's Requests'.
* **THEN** The Admin views all tickets submitted by any user belonging to their specific Account ID, with current status and assigned agent.

---

### AC-014: QA Bug Verification Linking
**Linked User Story:** US-014

* **GIVEN** A production defect bug ticket is closed by Engineering.
* **WHEN** The QA Analyst opens the linked Test Case ID in the UAT suite.
* **THEN** The status of the UAT bug record updates to 'Hotfix Deployed - Pending Retest'.

---

### AC-015: Top Ticket Generator Monthly Report
**Linked User Story:** US-015

* **GIVEN** The executive analytics cron job executes on the 1st of the month.
* **WHEN** The SQL analytics query aggregates ticket volume by `customer_id` for the previous 30 days.
* **THEN** A structured summary table listing top 5 ticket generating accounts is generated and emailed to Sarah Jenkins.

---

