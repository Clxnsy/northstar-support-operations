# Tiered Support Escalation & Handover Guide
**Project:** Northstar Support Operations System  
**Document Code:** SUPP-ESC-601  

---

## 1. Support Tier Operational Architecture

```
 +-------------------------------------------------------------------+
 |                   TIER 1 HELP DESK SUPPORT                        |
 | - First Contact & Triage                                          |
 | - Password Resets, Browser Caches, Basic User Provisioning       |
 | - Target Resolution: 60% of total ticket volume                   |
 +-------------------------------------------------------------------+
                                   |
                         (Requires DB / Logs)
                                   v
 +-------------------------------------------------------------------+
 |             TIER 2 APPLICATION SUPPORT ANALYSTS                   |
 | - SQL Read/Write Diagnostic Access against Replica & Staging DBs  |
 | - SSO/SAML Certificate Config, Data Ingestion Pipeline Replay     |
 | - Target Resolution: 30% of total ticket volume                   |
 +-------------------------------------------------------------------+
                                   |
                        (Code Defect / Outage)
                                   v
 +-------------------------------------------------------------------+
 |             TIER 3 ENGINEERING & PRODUCT TEAMS                    |
 | - Core Codebase Bug Patches, API Endpoint Fixes, Hotfix Deploys   |
 | - Product Feature Backlog & Architecture Scaling                 |
 | - Target Resolution: 10% of total ticket volume                   |
 +-------------------------------------------------------------------+
```

---

## 2. Tier 1 -> Tier 2 Escalation Protocols
* **Trigger Conditions:**
  1. Issue involves backend database state discrepancies (e.g., stuck tenant provisioning transactions, missing report data).
  2. SAML/SSO authentication signature failures requiring X.509 public key inspection.
  3. API rate limiting, webhook sync failures, or dead-letter queue replaying.
* **Mandatory Handoff Checklist:**
  * [x] Verify tenant account ID and affected user email.
  * [x] Confirm issue is reproducible across multiple browser sessions.
  * [x] Attach raw console log or HTTP error status code.
  * [x] Fill mandatory transition fields: `Diagnostic Summary` and `Escalation Reason`.

---

## 3. Tier 2 -> Tier 3 Engineering Escalation Protocols
* **Trigger Conditions:**
  1. Uncaught code exceptions (`NullPointerException`, JS syntax errors) requiring codebase patch deployment.
  2. Database schema constraint bugs or missing foreign key parameters in API endpoints.
  3. Infrastructure cluster node outages or server time drift.
* **Mandatory Handoff Checklist:**
  * [x] Create linked Jira Software Bug issue (`BUG-XXX`).
  * [x] Provide exact steps to reproduce in Staging environment.
  * [x] Include backend stack trace or SQL query log snippet.
  * [x] Quantify business impact (number of affected B2B tenants and MRR value).
