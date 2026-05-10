# NXS Universal Manifest Specification (v0.1)

The `project_manifest.toml` is the authoritative source of truth for the system.

## 1. Root Configuration

Every manifest must reference a remote standard to ensure zero-redundancy and instant validation.

- **`standard`**: URL to the NXS standard definition (e.g., `https://nex-ovia.com/standards/v0.1/nxs_schema.toml`).
- **`root_dir`**: The starting point for file-to-node linking.

## 2. Node Data Dictionary

| Key | Value Type | Allowed Values (Enums) |
| :--- | :--- | :--- |
| **`layer`** | Enum | `governance`, `orchestration`, `execution`, `persistence`, `surface` |
| **`type`** | Enum | `manifest`, `entrypoint`, `logic`, `agent`, `manual`, `adapter`, `ui` |
| **`runtime`** | String | e.g., `rust-2024`, `python-3.12`, `gpt-4o`, `human-in-loop` |
| **`criticality`**| Enum | `high`, `medium`, `low` |

## 3. Relationships & Links

- **`path`**: Links the node to the physical file or document. This enables the **Orphan Detector**.
- **`dependencies`**: Creates the directed graph of intent.
- **`contracts`**: Defines the "Action = Requirement" pair that acts as the gate for implementation.

## 4. Decision Logic Examples

- **Sovereignty Check**: If `runtime` is not in the "Local-First" whitelist, the project is flagged.
- **Risk Assessment**: If a `criticality: high` node depends on a `criticality: low` node, it is flagged as an architectural risk.