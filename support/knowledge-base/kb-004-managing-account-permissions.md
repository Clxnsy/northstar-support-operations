# KB-004: Managing User Roles & Module Permissions

## Overview
Northstar utilizes Role-Based Access Control (RBAC) to enforce security boundaries across platform modules. This article explains how SaaS Admins can assign roles, grant granular module permissions, and transfer primary account ownership.

---

## Pre-Configured Platform Roles

| Role Name | Access Level / Permissions Scope |
| :--- | :--- |
| **Primary Owner** | Full administrative rights, billing management, contract modifications, ownership transfer. |
| **SaaS Admin** | User management, role assignment, system configuration, integration setup. |
| **Manager** | Read/write access to team analytics, resource scheduling, and operational dashboards. |
| **Standard User** | Standard operational workflow creation and data entry within assigned modules. |
| **Guest Tenant** | Restricted read-only access to specific shared tenant folders and document uploads. |

---

## How to Assign or Update a User Role
1. Log into Northstar as a **SaaS Admin**.
2. Navigate to `Admin Console -> User Management`.
3. Locate the target user and click the **Edit (Pencil)** icon.
4. Select the desired role from the **System Role** dropdown menu.
5. Click **Save Permissions**. The user will receive updated module access upon their next page refresh.
