# Jira Service Management Configuration Guide
**Project:** Northstar Support Operations System  
**System:** Jira Service Management (JSM) Cloud / Data Center  
**Document Code:** JSM-CONFIG-101  

---

## 1. Project Setup & General Details
* **Project Name:** Northstar Support Operations
* **Project Key:** `NS`
* **Project Type:** Service Desk / IT Service Management
* **Project Lead:** David Chen (Support Operations Lead)
* **Default Assignee:** Unassigned (Auto-routed to Queue Owners)

---

## 2. Request Types & Portal Mapping

| Request Type Name | Portal Category | Issue Type | Description / Purpose | Mandatory Form Fields |
| :--- | :--- | :--- | :--- | :--- |
| **Login / Authentication** | Access & Identity | Incident | Troubleshoot password resets, MFA loops, SSO failures, and account lockouts. | Tenant ID, User Email, Error Code, MFA Method |
| **Account Access** | Access & Identity | Service Request | Manage user role provisioning, permissions, account owner transfers, and seats. | Account ID, Target User, Requested Role, Approval Doc |
| **Software Bug** | Technical Support | Bug | Report platform application errors, UI glitches, or broken workflows. | Module, Steps to Reproduce, Expected Behavior, Browser |
| **Data Issue** | Technical Support | Incident | Report corrupted data, missing reports, billing discrepancies, or pipeline delays. | Impacted Entity, Timestamp, Expected vs Actual Data |
| **Billing / Account Issue** | Finance & Billing | Service Request | Address invoices, payment gateway errors, tax exemptions, and subscription seats. | Invoice Number, Payment Gateway Error Code, Billing Contact |
| **Feature Request** | Product Feedback | New Feature | Submit platform enhancement requests and custom integration feedback. | Feature Area, Business Use Case, Expected Value |

---

## 3. Priority & Severity Matrix

| Priority Level | SLA First Response | SLA Resolution | Impact Criteria | Urgency Criteria | Escalation Trigger |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **P1 - Urgent** | 15 minutes | 2 hours | Whole tenant outage or critical security/data breach (>50 users affected). | Core business operation halted; no workaround available. | Auto-alert Slack `#support-p1` at 50% SLA elapsed. |
| **P2 - High** | 30 minutes | 4 hours | Major module failure affecting multiple users/workflows. | Significant operational impairment; temporary workaround difficult. | Page Tier 2 Lead if unassigned after 15 mins. |
| **P3 - Medium** | 2 hours | 8 hours | Single user issue or non-critical feature malfunction. | Moderate inconvenience; effective workaround exists. | Daily queue review by Tier 1 Lead. |
| **P4 - Low** | 4 hours | 24 hours | Cosmetic UI glitches, minor documentation questions, feature requests. | Minimal business impact; no workflow blockage. | Weekly product backlog review. |

---

## 4. Ticket Ownership & Communication Policies

### Ticket Ownership Rules
1. **First-Touch Ownership:** The agent who assigns a ticket from the queue owns the issue until resolution or formal escalation.
2. **Escalation Handover:** When escalating to Tier 2 or Tier 3, the originating agent remains tagged as `Watcher` to maintain customer communication continuity.

### Communication Guidelines
* **Internal Notes (Yellow Box):** Must be used for raw stack traces, SQL query snippets, database updates, internal security checks, and Tier 2/3 engineering comments.
* **Customer-Facing Responses (White Box):** Must be written in professional, empathetic, clear language. Avoid internal technical jargon or unverified engineering timelines.
