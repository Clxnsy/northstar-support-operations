# SLA Policies & Escalation Rules
**Project:** Northstar Support Operations System  
**Document Code:** JSM-SLA-401  

---

## 1. SLA Policy Specifications

### Time to First Response SLA
* **Goal:** Acknowledge customer inquiries, assign an agent, and initiate initial diagnostics.
* **P1 Urgent:** 15 Minutes (24/7 Calendar)
* **P2 High:** 30 Minutes (24/7 Calendar)
* **P3 Medium:** 2 Hours (Business Hours 8x5)
* **P4 Low:** 4 Hours (Business Hours 8x5)

### Time to Resolution SLA
* **Goal:** Fully resolve customer incident, deploy hotfix, or provide confirmed workaround.
* **P1 Urgent:** 2 Hours (24/7 Calendar)
* **P2 High:** 4 Hours (24/7 Calendar)
* **P3 Medium:** 8 Hours (Business Hours 8x5)
* **P4 Low:** 24 Hours (Business Hours 8x5)

---

## 2. SLA Calendar & Pause Rules
* **Calendar Schedule:** 
  * **24/7 Emergency Schedule:** Applies strictly to P1 Urgent and P2 High tickets.
  * **Standard Business Schedule:** 08:00 to 17:00 MT (Monday - Friday) applies to P3 Medium and P4 Low tickets.
* **Pause Conditions:** The SLA resolution timer automatically **PAUSES** when a ticket transitions to `Waiting for Customer` and **RESUMES** instantly when a customer adds a comment.

---

## 3. Escalation Rules & Automated Actions

```
+-----------------------------------------------------------------------+
|                       ESCALATION TIMELINE & ALERTS                    |
+-----------------------------------------------------------------------+
|  0% Elapsed    | Ticket Created & Assigned                            |
|  50% Elapsed   | Automated Slack Alert to `#support-p1-escalations`   |
|  75% Elapsed   | SMS Page to On-Call Support Lead (David Chen)        |
|  100% Elapsed  | SLA BREACH — Automated Email to VP Customer Success   |
+-----------------------------------------------------------------------+
```

### Tier 1 -> Tier 2 Escalation Criteria
* **Trigger:** Issue involves database state corruption, backend log analysis, complex SSO/SAML cert errors, or requires direct SQL query execution against replica DBs.
* **Handoff Protocol:** Tier 1 agent fills mandatory transition fields, updates status to `Escalated`, posts an Internal Note summarizing initial triage, and reassigns ticket to Tier 2 Application Support Analyst queue.

### Tier 2 -> Tier 3 Engineering Escalation Criteria
* **Trigger:** Verified software defect in core codebase requiring hotfix patch deployment, API endpoint bug, or server cluster infrastructure outage.
* **Handoff Protocol:** Tier 2 Analyst creates linked Jira Software bug issue (`BUG-XXX`), attaches step-by-step reproduction guide, attaches server stack traces, and updates support ticket to `Escalated`.
