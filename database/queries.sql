-- =============================================================================
-- Northstar Support Operations System - 25 Business Analysis SQL Queries
-- File: queries.sql
-- Engine Compatibility: PostgreSQL / SQLite / MySQL
-- Author: Business Systems Analyst / Application Support Specialist
-- =============================================================================

-- -----------------------------------------------------------------------------
-- QUERY 1: Which customers submit the most tickets overall?
-- Business Purpose: Identify high-volume B2B accounts requiring operational review.
-- Concepts Demonstrated: JOIN, GROUP BY, Aggregate COUNT, ORDER BY
-- -----------------------------------------------------------------------------
SELECT 
    c.customer_id,
    c.company_name,
    c.subscription_tier,
    COUNT(t.ticket_id) AS total_tickets_submitted
FROM customers c
JOIN tickets t ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.company_name, c.subscription_tier
ORDER BY total_tickets_submitted DESC;


-- -----------------------------------------------------------------------------
-- QUERY 2: Which ticket categories occur most frequently?
-- Business Purpose: Isolate top friction areas across the SaaS product platform.
-- Concepts Demonstrated: JOIN, GROUP BY, COUNT, Percentage Calculation
-- -----------------------------------------------------------------------------
SELECT 
    tc.category_name,
    COUNT(t.ticket_id) AS category_ticket_count,
    ROUND(COUNT(t.ticket_id) * 100.0 / (SELECT COUNT(*) FROM tickets), 2) AS percentage_of_total
FROM ticket_categories tc
JOIN tickets t ON tc.category_id = t.category_id
GROUP BY tc.category_name
ORDER BY category_ticket_count DESC;


-- -----------------------------------------------------------------------------
-- QUERY 3: What percentage of total tickets are categorized as P1 - Urgent?
-- Business Purpose: Monitor high-severity incident ratio for SLA budget planning.
-- Concepts Demonstrated: CASE, Aggregate COUNT, Subqueries, Mathematical Rounding
-- -----------------------------------------------------------------------------
SELECT 
    COUNT(ticket_id) AS total_tickets,
    SUM(CASE WHEN priority = 'P1 - Urgent' THEN 1 ELSE 0 END) AS urgent_p1_tickets,
    ROUND(SUM(CASE WHEN priority = 'P1 - Urgent' THEN 1 ELSE 0 END) * 100.0 / COUNT(ticket_id), 2) AS p1_percentage
FROM tickets;


-- -----------------------------------------------------------------------------
-- QUERY 4: Which customers repeatedly experience authentication issues?
-- Business Purpose: Identify accounts facing SSO/MFA instability for proactive outreach.
-- Concepts Demonstrated: JOIN, WHERE, GROUP BY, HAVING, Multiple Table Filters
-- -----------------------------------------------------------------------------
SELECT 
    c.company_name,
    tc.category_name,
    COUNT(t.ticket_id) AS auth_incident_count
FROM tickets t
JOIN customers c ON t.customer_id = c.customer_id
JOIN ticket_categories tc ON t.category_id = tc.category_id
WHERE tc.category_name = 'Login / Authentication'
GROUP BY c.company_name, tc.category_name
HAVING COUNT(t.ticket_id) >= 2
ORDER BY auth_incident_count DESC;


-- -----------------------------------------------------------------------------
-- QUERY 5: Which support agents resolve the most tickets?
-- Business Purpose: Measure individual agent throughput and workload distribution.
-- Concepts Demonstrated: JOIN, WHERE, GROUP BY, ORDER BY
-- -----------------------------------------------------------------------------
SELECT 
    a.agent_id,
    a.full_name,
    a.support_tier,
    COUNT(t.ticket_id) AS resolved_ticket_count
FROM agents a
JOIN tickets t ON a.agent_id = t.assigned_agent_id
WHERE t.status = 'Resolved'
GROUP BY a.agent_id, a.full_name, a.support_tier
ORDER BY resolved_ticket_count DESC;


-- -----------------------------------------------------------------------------
-- QUERY 6: What is the overall average resolution time in minutes for resolved tickets?
-- Business Purpose: Benchmark core operational efficiency metric (ATTR).
-- Concepts Demonstrated: AVG, WHERE, Rounding
-- -----------------------------------------------------------------------------
SELECT 
    COUNT(ticket_id) AS total_resolved_tickets,
    ROUND(AVG(resolution_time_minutes), 1) AS avg_resolution_time_minutes,
    ROUND(AVG(resolution_time_minutes) / 60.0, 2) AS avg_resolution_time_hours
FROM tickets
WHERE status = 'Resolved';


-- -----------------------------------------------------------------------------
-- QUERY 7: Which issue categories have the longest resolution times?
-- Business Purpose: Isolate complex problem domains requiring Tier 2/3 enablement.
-- Concepts Demonstrated: JOIN, GROUP BY, AVG, ORDER BY
-- -----------------------------------------------------------------------------
SELECT 
    tc.category_name,
    COUNT(t.ticket_id) AS resolved_count,
    ROUND(AVG(t.resolution_time_minutes), 1) AS avg_resolution_minutes
FROM ticket_categories tc
JOIN tickets t ON tc.category_id = t.category_id
WHERE t.status = 'Resolved'
GROUP BY tc.category_name
ORDER BY avg_resolution_minutes DESC;


-- -----------------------------------------------------------------------------
-- QUERY 8: Which specific accounts generate repeated P1 or P2 high-severity incidents?
-- Business Purpose: Identify churn-risk accounts experiencing core platform disruptions.
-- Concepts Demonstrated: JOIN, WHERE, GROUP BY, HAVING, Multiple Column Grouping
-- -----------------------------------------------------------------------------
SELECT 
    c.company_name,
    c.subscription_tier,
    COUNT(t.ticket_id) AS high_severity_incident_count
FROM tickets t
JOIN customers c ON t.customer_id = c.customer_id
WHERE t.priority IN ('P1 - Urgent', 'P2 - High')
GROUP BY c.company_name, c.subscription_tier
HAVING COUNT(t.ticket_id) >= 2
ORDER BY high_severity_incident_count DESC;


-- -----------------------------------------------------------------------------
-- QUERY 9: What is the distribution of ticket status across all open/active queues?
-- Business Purpose: Real-time operational dashboard for Support Lead queue oversight.
-- Concepts Demonstrated: GROUP BY, COUNT, CASE Ordering
-- -----------------------------------------------------------------------------
SELECT 
    status,
    COUNT(ticket_id) AS ticket_count
FROM tickets
GROUP BY status
ORDER BY 
    CASE status
        WHEN 'Open' THEN 1
        WHEN 'In Progress' THEN 2
        WHEN 'Waiting for Customer' THEN 3
        WHEN 'Escalated' THEN 4
        WHEN 'Resolved' THEN 5
    END;


-- -----------------------------------------------------------------------------
-- QUERY 10: Which customers are at breach risk based on SLA performance?
-- Business Purpose: Audit compliance against contractual SLA terms.
-- Concepts Demonstrated: JOIN, SUM, Aggregate Percentage
-- -----------------------------------------------------------------------------
SELECT 
    c.company_name,
    COUNT(t.ticket_id) AS total_tickets,
    SUM(t.sla_breached) AS breached_tickets,
    ROUND(SUM(t.sla_breached) * 100.0 / COUNT(t.ticket_id), 2) AS breach_rate_percentage
FROM customers c
JOIN tickets t ON c.customer_id = t.customer_id
GROUP BY c.company_name
ORDER BY breach_rate_percentage DESC;


-- -----------------------------------------------------------------------------
-- QUERY 11: Common Root Causes analysis across all resolved incidents.
-- Business Purpose: Provide Product Engineering with bug trend prioritization.
-- Concepts Demonstrated: WHERE, GROUP BY, COUNT, Filter Nulls
-- -----------------------------------------------------------------------------
SELECT 
    root_cause,
    COUNT(ticket_id) AS incident_count
FROM tickets
WHERE root_cause IS NOT NULL
GROUP BY root_cause
ORDER BY incident_count DESC;


-- -----------------------------------------------------------------------------
-- QUERY 12: Monthly Ticket Volume & Resolution Trends
-- Business Purpose: Track operational workload scaling over time.
-- Concepts Demonstrated: DATE functions / Substring parsing, GROUP BY, COUNT
-- -----------------------------------------------------------------------------
SELECT 
    SUBSTR(created_at, 1, 7) AS ticket_month,
    COUNT(ticket_id) AS total_created,
    SUM(CASE WHEN status = 'Resolved' THEN 1 ELSE 0 END) AS total_resolved
FROM tickets
GROUP BY SUBSTR(created_at, 1, 7)
ORDER BY ticket_month ASC;


-- -----------------------------------------------------------------------------
-- QUERY 13: Average Resolution Time per Support Tier (Tier 1 vs Tier 2 vs Tier 3)
-- Business Purpose: Compare efficiency across technical escalation boundaries.
-- Concepts Demonstrated: JOIN, GROUP BY, AVG
-- -----------------------------------------------------------------------------
SELECT 
    a.support_tier,
    COUNT(t.ticket_id) AS resolved_count,
    ROUND(AVG(t.resolution_time_minutes), 1) AS avg_resolution_mins
FROM agents a
JOIN tickets t ON a.agent_id = t.assigned_agent_id
WHERE t.status = 'Resolved'
GROUP BY a.support_tier
ORDER BY avg_resolution_mins ASC;


-- -----------------------------------------------------------------------------
-- QUERY 14: Unassigned Tickets in Active Status (Queue Backlog Risk)
-- Business Purpose: Alert Support Lead to orphaned tickets needing assignment.
-- Concepts Demonstrated: WHERE IS NULL, Multiple Logical Conditions
-- -----------------------------------------------------------------------------
SELECT 
    ticket_id,
    summary,
    priority,
    created_at
FROM tickets
WHERE assigned_agent_id IS NULL AND status IN ('Open', 'In Progress');


-- -----------------------------------------------------------------------------
-- QUERY 15: Revenue-at-Risk Analysis (Connecting MRR to Open P1/P2 Tickets)
-- Business Purpose: Prioritize Enterprise accounts with high Monthly Recurring Revenue.
-- Concepts Demonstrated: JOIN, WHERE, GROUP BY, SUM MRR
-- -----------------------------------------------------------------------------
SELECT 
    c.company_name,
    c.subscription_tier,
    a.monthly_mrr,
    COUNT(t.ticket_id) AS active_high_priority_tickets
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN tickets t ON c.customer_id = t.customer_id
WHERE t.priority IN ('P1 - Urgent', 'P2 - High') AND t.status != 'Resolved'
GROUP BY c.company_name, c.subscription_tier, a.monthly_mrr
ORDER BY a.monthly_mrr DESC;


-- -----------------------------------------------------------------------------
-- QUERY 16: Customer Ticket Ratio per Paid Seat (Identifying Training Gaps)
-- Business Purpose: Determine if high ticket volume stems from poor user onboarding.
-- Concepts Demonstrated: JOIN, GROUP BY, Calculated Ratio Column
-- -----------------------------------------------------------------------------
SELECT 
    c.company_name,
    acc.max_users AS provisioned_seats,
    COUNT(t.ticket_id) AS total_tickets,
    ROUND(COUNT(t.ticket_id) * 1.0 / acc.max_users, 3) AS tickets_per_seat_ratio
FROM customers c
JOIN accounts acc ON c.customer_id = acc.customer_id
JOIN tickets t ON c.customer_id = t.customer_id
GROUP BY c.company_name, acc.max_users
ORDER BY tickets_per_seat_ratio DESC;


-- -----------------------------------------------------------------------------
-- QUERY 17: CTE Analysis — Ranking Customers by Ticket Volume using CTE
-- Business Purpose: Classify accounts into Support Cost Tiers.
-- Concepts Demonstrated: Common Table Expression (CTE), Ranking Logic
-- -----------------------------------------------------------------------------
WITH CustomerTicketSummary AS (
    SELECT 
        c.company_name,
        c.subscription_tier,
        COUNT(t.ticket_id) AS ticket_count
    FROM customers c
    LEFT JOIN tickets t ON c.customer_id = t.customer_id
    GROUP BY c.company_name, c.subscription_tier
)
SELECT 
    company_name,
    subscription_tier,
    ticket_count,
    CASE 
        WHEN ticket_count >= 4 THEN 'High Touch / VIP Concern'
        WHEN ticket_count BETWEEN 2 AND 3 THEN 'Standard Touch'
        ELSE 'Low Touch / Stable'
    END AS support_health_classification
FROM CustomerTicketSummary
ORDER BY ticket_count DESC;


-- -----------------------------------------------------------------------------
-- QUERY 18: Window Function — Ranking Tickets by Resolution Speed within Category
-- Business Purpose: Identify fastest resolved ticket per category for benchmarking.
-- Concepts Demonstrated: Window Function (ROW_NUMBER OVER PARTITION BY)
-- -----------------------------------------------------------------------------
WITH RankedResolutionTimes AS (
    SELECT 
        ticket_id,
        category_id,
        summary,
        resolution_time_minutes,
        ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY resolution_time_minutes ASC) AS rank_in_category
    FROM tickets
    WHERE status = 'Resolved' AND resolution_time_minutes IS NOT NULL
)
SELECT 
    tc.category_name,
    r.ticket_id,
    r.summary,
    r.resolution_time_minutes
FROM RankedResolutionTimes r
JOIN ticket_categories tc ON r.category_id = tc.category_id
WHERE r.rank_in_category = 1;


-- -----------------------------------------------------------------------------
-- QUERY 19: Window Function — Cumulative Resolution Time per Support Agent
-- Business Purpose: Calculate running work duration per agent across ticket queue.
-- Concepts Demonstrated: Window Function (SUM() OVER ORDER BY)
-- -----------------------------------------------------------------------------
SELECT 
    t.ticket_id,
    a.full_name AS agent_name,
    t.resolution_time_minutes,
    SUM(t.resolution_time_minutes) OVER (
        PARTITION BY t.assigned_agent_id 
        ORDER BY t.resolved_at
    ) AS cumulative_agent_resolution_minutes
FROM tickets t
JOIN agents a ON t.assigned_agent_id = a.agent_id
WHERE t.status = 'Resolved' AND t.resolution_time_minutes IS NOT NULL;


-- -----------------------------------------------------------------------------
-- QUERY 20: Subquery — Finding Customers with Above-Average Ticket Volumes
-- Business Purpose: Flag accounts exceeding overall mean ticket volume.
-- Concepts Demonstrated: Subquery in HAVING clause
-- -----------------------------------------------------------------------------
SELECT 
    c.company_name,
    COUNT(t.ticket_id) AS customer_tickets
FROM customers c
JOIN tickets t ON c.customer_id = t.customer_id
GROUP BY c.company_name
HAVING COUNT(t.ticket_id) > (
    SELECT AVG(ticket_count) 
    FROM (
        SELECT COUNT(ticket_id) AS ticket_count 
        FROM tickets 
        GROUP BY customer_id
    ) AS sub
)
ORDER BY customer_tickets DESC;


-- -----------------------------------------------------------------------------
-- QUERY 21: Audit Trail Analysis — Count of Status Changes per Escalated Ticket
-- Business Purpose: Measure escalation friction and state transitions.
-- Concepts Demonstrated: JOIN, GROUP BY, COUNT
-- -----------------------------------------------------------------------------
SELECT 
    t.ticket_id,
    t.summary,
    COUNT(sh.history_id) AS total_status_transitions
FROM tickets t
JOIN ticket_status_history sh ON t.ticket_id = sh.ticket_id
GROUP BY t.ticket_id, t.summary
HAVING COUNT(sh.history_id) >= 2;


-- -----------------------------------------------------------------------------
-- QUERY 22: Identifying Inactive Users Submitting High Support Volume
-- Business Purpose: Detect potential credential sharing or stale account activity.
-- Concepts Demonstrated: JOIN, WHERE, GROUP BY
-- -----------------------------------------------------------------------------
SELECT 
    u.email,
    u.first_name,
    u.last_name,
    c.company_name,
    COUNT(t.ticket_id) AS tickets_opened
FROM users u
JOIN customers c ON u.customer_id = c.customer_id
JOIN tickets t ON u.user_id = t.user_id
WHERE u.is_mfa_enabled = 0
GROUP BY u.email, u.first_name, u.last_name, c.company_name
ORDER BY tickets_opened DESC;


-- -----------------------------------------------------------------------------
-- QUERY 23: SLA Compliance Rate by Subscription Tier (Enterprise vs Starter)
-- Business Purpose: Verify if Enterprise tier receives superior SLA compliance.
-- Concepts Demonstrated: JOIN, SUM, Aggregate Percentages, GROUP BY
-- -----------------------------------------------------------------------------
SELECT 
    c.subscription_tier,
    COUNT(t.ticket_id) AS total_tickets,
    SUM(CASE WHEN t.sla_breached = 0 THEN 1 ELSE 0 END) AS compliant_tickets,
    ROUND(SUM(CASE WHEN t.sla_breached = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(t.ticket_id), 2) AS sla_compliance_rate
FROM customers c
JOIN tickets t ON c.customer_id = t.customer_id
GROUP BY c.subscription_tier
ORDER BY sla_compliance_rate DESC;


-- -----------------------------------------------------------------------------
-- QUERY 24: Correlating Update Volume to Resolution Time
-- Business Purpose: Determine if high update churn delays final issue resolution.
-- Concepts Demonstrated: JOIN, GROUP BY, COUNT Updates vs AVG Time
-- -----------------------------------------------------------------------------
SELECT 
    t.ticket_id,
    t.priority,
    COUNT(tu.update_id) AS total_updates,
    t.resolution_time_minutes
FROM tickets t
JOIN ticket_updates tu ON t.ticket_id = tu.ticket_id
WHERE t.status = 'Resolved'
GROUP BY t.ticket_id, t.priority, t.resolution_time_minutes
ORDER BY total_updates DESC;


-- -----------------------------------------------------------------------------
-- QUERY 25: Proactive Outreach Candidate Identification (Composite Health Score)
-- Business Purpose: Generate candidate list for Customer Success proactive check-ins.
-- Concepts Demonstrated: Multiple JOINs, Complex CASE logic, GROUP BY
-- -----------------------------------------------------------------------------
SELECT 
    c.company_name,
    c.subscription_tier,
    a.monthly_mrr,
    COUNT(t.ticket_id) AS total_tickets,
    SUM(CASE WHEN t.priority = 'P1 - Urgent' THEN 1 ELSE 0 END) AS urgent_count,
    CASE 
        WHEN SUM(CASE WHEN t.priority = 'P1 - Urgent' THEN 1 ELSE 0 END) >= 1 THEN 'CRITICAL - Schedule CSM Call Immediately'
        WHEN COUNT(t.ticket_id) >= 4 THEN 'HIGH - Perform Account Health Review'
        ELSE 'NORMAL - Routine Support'
    END AS proactive_outreach_recommendation
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN tickets t ON c.customer_id = t.customer_id
GROUP BY c.company_name, c.subscription_tier, a.monthly_mrr
ORDER BY urgent_count DESC, total_tickets DESC;
