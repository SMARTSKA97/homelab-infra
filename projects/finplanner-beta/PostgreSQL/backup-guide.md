# PostgreSQL Backup Restore Formats Guide

PostgreSQL supports multiple backup formats.

The restore command depends on:
- backup format
- tool used during backup
- whether it is compressed
- whether it is plain SQL

---

# Common PostgreSQL Backup Formats

| Extension | Format Type | Restore Tool |
|---|---|---|
| `.backup` | Custom format | `pg_restore` |
| `.dump` | Custom format | `pg_restore` |
| `.tar` | Tar archive | `pg_restore` |
| `.sql` | Plain SQL script | `psql` |
| `.gz` | Compressed SQL/custom | depends |
| `.zip` | Archived backup | extract first |

---

# 1. Restore `.backup`

## Example

```text
sample_database.backup
```

## Restore Command

```powershell
docker exec -it postgres_db pg_restore -U postgres -d sample_database --no-owner --no-acl --clean --if-exists /backups/sample_database.backup
```

---

# 2. Restore `.dump`

`.dump` is usually identical to `.backup`.

## Example

```text
sample_database.dump
```

## Restore Command

```powershell
docker exec -it postgres_db pg_restore -U postgres -d sample_database --no-owner --no-acl --clean --if-exists /backups/sample_database.dump
```

---

# 3. Restore `.tar`

## Example

```text
sample_database.tar
```

## Restore Command

```powershell
docker exec -it postgres_db pg_restore -U postgres -d sample_database --no-owner --no-acl --clean --if-exists /backups/sample_database.tar
```

---

# 4. Restore `.sql`

A `.sql` backup is plain text SQL statements.

Use `psql`, NOT `pg_restore`.

## Example

```text
sample_database.sql
```

## Restore Command

```powershell
docker exec -i postgres_db psql -U postgres -d sample_database < D:\Workspace\Database\backups\sample_database.sql
```

---

# 5. Restore `.gz`

Compressed backups must usually be decompressed first.

---

## Option A — Extract First (Recommended)

Example:

```text
sample_database.sql.gz
```

Extract using:
- 7-Zip
- WinRAR
- gzip

After extraction:

```text
sample_database.sql
```

Then restore normally using `psql`.

---

## Option B — Restore Directly Inside Container

For compressed SQL:

```powershell
Get-Content D:\Workspace\Database\backups\sample_database.sql.gz -Encoding Byte
```

Not recommended on Windows.  
Too messy. Ancient terminal wizardry territory.

Extract first instead.

---

# 6. Restore `.zip`

Extract first.

Inside ZIP may contain:
- `.backup`
- `.sql`
- `.dump`

Restore according to extracted format.

---

# How to Identify Backup Type

Run:

```powershell
file sample_database.backup
```

Linux/macOS only.

On Windows:
- open with Notepad++
- if readable SQL → `.sql`
- if binary gibberish → custom format

---

# Important Difference

| Backup Type | Human Readable | Restore Tool |
|---|---|---|
| `.sql` | Yes | `psql` |
| `.backup` | No | `pg_restore` |
| `.dump` | No | `pg_restore` |
| `.tar` | No | `pg_restore` |

---

# Rule of Thumb

## Use `pg_restore` for:

- `.backup`
- `.dump`
- `.tar`

---

## Use `psql` for:

- `.sql`

---

# Recommended Backup Strategy

For professional workflows:

| Purpose | Format |
|---|---|
| Production backup | `.backup` |
| Migration/debugging | `.sql` |
| CI/CD restore | `.backup` |
| Human inspection | `.sql` |

---

# Recommended Backup Command

## Custom Format (Best)

```powershell
pg_dump -U postgres -F c -d sample_database -f sample_database.backup
```

Benefits:
- compressed
- smaller
- faster restore
- parallel restore support

---

# Recommended SQL Backup Command

```powershell
pg_dump -U postgres -d sample_database > sample_database.sql
```

Benefits:
- human-readable
- editable
- portable

Drawback:
- larger size
- slower restore

---

# Best Practice

Keep backups here:

```text
D:\Workspace\Database\backups
```

Organize by:

```text
backups
│
├── dev
├── staging
├── production
└── archive
```

---

# Example Production Naming Convention

```text
sample_database_20260506_1134am.backup
```

Benefits:
- sortable
- timestamped
- environment-safe
- automation-friendly
