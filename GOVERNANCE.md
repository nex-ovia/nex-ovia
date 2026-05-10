# GOVERNANCE.md: The Nexovia Standard (NXS) Specification

## 1. The NXS Mission

The Nexovia Standard (NXS) is a **Governance Topology** designed for high-impact delivery. In the era of AI-accelerated development, NXS ensures that rapid delivery does not compromise architectural sovereignty. It provides a machine-readable "Source of Truth" that governs the relationship between intent and implementation.

### The Source of Truth

To ensure global consistency and eliminate local configuration drift, this project validates against the master NXS specification.

* **Standard Schema**

```toml

# ==============================================================================
# NXS Master Schema v1.2 - Software Domain Specification
# Location: https://nex-ovia.com/standards/v0.1/nxs_schema.toml
# Purpose: Formal structural definition for NXS Governance
# ==============================================================================

[nxs]
version = "0.1.0"
domain = "software"
description = "Universal topology for high-impact software delivery in the AI era."

# ------------------------------------------------------------------------------
# 1. TOPOLOGY SPECIFICATION (Functional Pillars)
# ------------------------------------------------------------------------------
[topology]
governance = { label = "Governance", color = "#ffffff", order = 1, description = "Policies, Manifests, and SOPs" }
orchestration = { label = "Orchestration", color = "#03a9f4", order = 2, description = "Control Logic, Agents, and Routing" }
execution = { label = "Execution", color = "#8bc34a", order = 3, description = "Domain Logic, Workers, and Human Steps" }
persistence = { label = "Persistence", color = "#ffc107", order = 4, description = "State Management and Data Storage" }
surface = { label = "Surface", color = "#9c27b0", order = 5, description = "API Handlers, UIs, and External Gateways" }

# ------------------------------------------------------------------------------
# 2. NODE SCHEMA DEFINITION (Key Metadata)
# This section tells the NX tools which keys are required in a project manifest.
# ------------------------------------------------------------------------------
[schema.node_keys]
layer = { type = "enum", status = "mandatory", label = "Functional Layer", description = "Must match a key in [topology]" }
type = { type = "enum", status = "mandatory", label = "Node Type", description = "Determines the functional identity of the node" }
runtime = { type = "string", status = "mandatory", label = "Runtime Environment", description = "The engine executing the logic (e.g., rust-2024)" }
path = { type = "path", status = "mandatory", label = "Physical Path", description = "Relative path to the source file or resource" }
criticality = { type = "enum", status = "mandatory", label = "Risk Level", description = "Impact assessment of node failure" }
dependencies = { type = "array", status = "optional", label = "Dependencies", description = "List of node IDs this node relies upon" }

# ------------------------------------------------------------------------------
# 3. ENUMERATION WHITELISTS
# ------------------------------------------------------------------------------
[constraints]
allowed_types = ["manifest", "entrypoint", "logic", "agent", "manual", "adapter", "ui"]
allowed_criticality = ["high", "medium", "low"]

# Whitelist for Local-First/Sovereign compliance
sovereign_runtimes = [
    "rust-2021", "rust-2024", 
    "python-3.11", "python-3.12", 
    "node-20", "node-22", 
    "docker-local", "human-in-loop"
]

# ------------------------------------------------------------------------------
# 4. GOVERNANCE VALIDATION RULES
# ------------------------------------------------------------------------------
[validation]
require_contracts = true      # Every node MUST have a [contracts] table
enforce_integrity = true      # Files on disk must match [path] in manifest
strict_sovereignty = true     # Alerts if runtime is not in sovereign_runtimes
prevent_layer_loops = true    # Disallows circular dependencies between layers

```

* **Validation:** The `nx` toolchain (including `nx-viz`) fetches this URI to verify that local nodes, runtimes, and layers comply with the NXS topology before any build or visualization.

## 2. The Universal Topology

Every NXS project must map its components to these five functional pillars. This topology allows human operators and AI agents to share a common mental model of the system.

* **Governance**: The "Constitution." Contains manifests, policies, build configurations, and SOPs.
* **Orchestration**: The "Controller." Contains agents, main entry points, routers, and global state.
* **Execution**: The "Worker." Contains business logic, background tasks, and manual human interventions.
* **Persistence**: The "Memory." Contains databases, local state, and persistence adapters.
* **Surface**: The "Interface." Contains API handlers, UIs, and external routing policies.

## 3. NXS Schema (v1.2) Data Dictionary

The following keys in the `project_manifest.toml` are the required metadata for NXS governance.

| Key | Type | Allowed Values (ENUM) | Meaning & Decision Logic |
| --- | --- | --- | --- |
| **`nxs.version`** | SemVer | `1.2.0` | Ensures project compatibility with the `nx` toolset. |
| **`nxs.domain`** | Enum | `software`, `agent`, `workflow` | Sets the validation ruleset for the governance engine. |
| **`node.layer`** | Enum | `governance`, `orchestration`, `execution`, `persistence`, `surface` | **Structural Logic:** Defines the functional pillar. Used to detect "Layer Violations" (e.g., Execution calling Surface). |
| **`node.type`** | Enum | `manifest`, `entrypoint`, `logic`, `agent`, `manual`, `adapter`, `ui` | **Identity Logic:** Distinguishes between automated logic, autonomous agents, and human steps. |
| **`node.runtime`** | String | e.g., `rust-2024`, `gpt-4o` | **Sovereignty Audit:** Used to track and flag dependencies on non-local runtimes. |
| **`node.path`** | Path | System file path | **Integrity Logic:** Links the manifest to the disk. Enables "Orphan Detection" for unmapped logic. |
| **`node.criticality`** | Enum | `high`, `medium`, `low` | **Risk Weight:** Drives visual glows in the HUD and determines audit priority. |

## 4. Delivery Gates & Enforcement

To maintain high-impact delivery, NXS enforces three mandatory gates:

### Gate 1: The Integrity Gate (Pre-Commit)

* **Rule:** The physical directory structure must match the declared manifest.
* **Action:** If `nx-viz` detects a file on disk that is not mapped in the TOML, the gate fails. No "Shadow Logic" is permitted.

### Gate 2: The Contract Gate (Structural Quality)

* **Rule:** Every node must have a `[nodes.ID.contracts]` table defining its interface.
* **Action:** A node cannot be marked as "Complete" or "Sovereign" until the stated contract requirements are satisfied.

### Gate 3: The Sovereignty Gate (Supply Chain)

* **Rule:** All external runtimes and dependencies must be explicitly declared.
* **Action:** Any node using a cloud-managed runtime in a "Sovereign" domain triggers a governance alert for review.

## 5. The Governance HUD (Visual Decision Matrix)

The `nx-viz` output serves as the **Governance HUD**. Use these cues for executive oversight:

* **Red Glowing Node**: A `high` criticality node has a broken path or failed contract. **Action: Block Deployment.**
* **Orange Node**: The node runtime violates the sovereignty target (e.g., external AI dependency). **Action: Executive Review.**
* **Red Connection Line**: Represents a **Layer Violation** (e.g., Persistence depending on Surface). **Action: Immediate Refactor.**
* **Ghost Node (Red Dotted)**: File detected on disk but missing from manifest. **Action: Standardize or Delete.**

## 6. Ownership & Accountability

Every functional pillar must have an **Accountable Owner**. This individual is responsible for the accuracy of the manifest within their pillar and signs off on the "Definition of Done."