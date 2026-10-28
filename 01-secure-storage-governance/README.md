# Secure Cloud Storage Automation and SAS Governance Pipeline

## Overview
This project implements an automated, secure cloud storage architecture deployed via Azure Bicep. It establishes resource-level security guardrails, automated data tiering policies, and delegated access controls without requiring tenant-level administrative privileges.

## Architecture

```mermaid
flowchart TD
    subgraph Azure Subscription
        subgraph ResourceGroup[rg-storage-governance]
            SA[(Standard_LRS Storage)]
            subgraph BlobService[Blob Service]
                Container[secure-data Container<br/>Public Access: Denied]
                Blob[sample.txt]
            end
            Policy[Lifecycle Policy<br/>30d Cool / 90d Archive / 365d Delete]
        end
    end

    Client[External Client / App]

    SA --- BlobService
    BlobService --- Container
    Container --- Blob
    SA --- Policy

    Client -->|1. Public Access Blocked: HTTP 409| Container
    Client -->|2. Read SAS Token: HTTP 200 OK| Blob
    Client -->|3. Unauthorized Write: HTTP 403 Forbidden| Blob
```