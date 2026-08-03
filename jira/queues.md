# Jira Service Management Queues Guide
**Project:** Northstar Support Operations System  
**Document Code:** JSM-QUEUE-301  

---

## 1. Queue Design Principle
Queues in Northstar JSM are structured to ensure high-priority incidents receive immediate visibility while routing specialized requests (e.g., Billing, Product Feedback) directly to domain specialists.

---

## 2. Configured Support Queues

| Queue Name | Target Audience / Role | JQL Filter Criteria | SLA Priority Focus |
| :--- | :--- | :--- | :--- |
| **01. P1 / Emergency Incidents** | All Support Agents / Leadership | `project = "NS" AND priority = "P1 - Urgent" AND status != "Resolved"` | P1 SLA (15m Response / 2h Resolution) |
| **02. Unassigned Triage** | Tier 1 Help Desk | `project = "NS" AND assignee IS EMPTY AND status = "Open"` | Initial Response SLA |
| **03. Authentication & Access** | Tier 1 & Tier 2 Security Team | `project = "NS" AND "Request Type" IN ("Login / Authentication", "Account Access") AND status IN ("Open", "In Progress")` | P1 / P2 SLAs |
| **04. Technical Bugs & Data** | Tier 2 Application Analysts | `project = "NS" AND "Request Type" IN ("Software Bug", "Data Issue") AND status IN ("In Progress", "Escalated")` | P2 / P3 SLAs |
| **05. Billing & Finance Ops** | Billing Specialists | `project = "NS" AND "Request Type" = "Billing / Account Issue" AND status != "Resolved"` | P2 / P3 SLAs |
| **06. Pending Customer Action** | Tier 1 Support Agents | `project = "NS" AND status = "Waiting for Customer"` | SLA Paused (Follow-up cron active) |
| **07. Tier 3 Engineering Escalations** | Lead Analysts & Engineering | `project = "NS" AND status = "Escalated"` | Tier 3 SLAs |
| **08. Product Feature Backlog** | Product Managers (Marcus Vance) | `project = "NS" AND "Request Type" = "Feature Request"` | Low Priority (Roadmap review) |
