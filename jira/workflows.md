# Jira Service Management Workflows Guide
**Project:** Northstar Support Operations System  
**Document Code:** JSM-WF-201  

---

## 1. Workflow Architecture Overview
The Northstar Support Operations workflow is designed to maintain strict state control while enabling seamless collaboration between Tier 1 Help Desk, Tier 2 Application Support, and Tier 3 Engineering.

```
 [Open] ------(Start Progress)------> [In Progress]
   |                                     |    ^
   |                                     |    |
 (Customer Reply)              (Request Info) (Customer Responds)
   |                                     |    |
   v                                     v    |
[Open] <---(Re-open)--- [Waiting for Customer]
   |                                     |
   |                                (Escalate)
   |                                     |
   +----------(Escalate)---------------->v
                                    [Escalated]
                                         |
                                     (Resolve)
                                         v
                                    [Resolved]
```

---

## 2. Workflow State Definitions

| State Name | Color Badge | Description | SLA Clock Status | Allowed User Roles |
| :--- | :--- | :--- | :--- | :--- |
| **Open** | Blue | Newly ingested ticket awaiting agent triage or initial assignment. | Active (Counting) | All Agents / System Ingestion |
| **In Progress** | Yellow | Ticket assigned to an agent and undergoing active investigation. | Active (Counting) | Tier 1, Tier 2, Tier 3 Agents |
| **Waiting for Customer** | Orange | Agent requested additional information, logs, or verification from user. | **PAUSED** | Assigned Agent |
| **Escalated** | Purple | Issue handed over to Tier 2 Application Support or Tier 3 Engineering. | Active (Adjusted SLA) | Tier 2, Tier 3, Support Lead |
| **Resolved** | Green | Fix deployed, workaround confirmed, or inquiry answered. | **STOPPED** | Assigned Agent / Tier 2 Lead |

---

## 3. Transition Rules & Validators

### Transition: `In Progress` -> `Waiting for Customer`
* **Trigger:** Agent posts a customer-facing comment requesting clarification.
* **Validator:** Comment field cannot be empty.
* **Post-Function:** Automatically pauses SLA Resolution Clock.

### Transition: `In Progress` / `Open` -> `Escalated`
* **Trigger:** Issue exceeds Tier 1 scope or requires database/code intervention.
* **Validator Enforced Fields:** 
  1. `Diagnostic Summary` (Text)
  2. `DB Query / Log Snippet` (Text)
  3. `Escalation Tier` (Dropdown: Tier 2 App Support / Tier 3 Engineering)
* **Post-Function:** Dispatches alert notification to target escalation team lead.

### Transition: Any State -> `Resolved`
* **Trigger:** Problem successfully remediated.
* **Validator Enforced Fields:**
  1. `Root Cause` (Mandatory Single-Select Dropdown)
  2. `Resolution Category` (Dropdown: Fixed, Workaround Provided, Duplicate, Cancelled)
  3. `Customer Resolution Summary` (Text)
* **Post-Function:** Stops SLA clocks and sends Customer Resolution Survey email.
