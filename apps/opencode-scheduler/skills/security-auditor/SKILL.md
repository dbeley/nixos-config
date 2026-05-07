---
name: security-auditor
description: Scans codebase for security vulnerabilities — exposed secrets, unsafe eval patterns, missing input validation, outdated cryptographic practices
---

## Purpose

Audit the codebase for common security issues that static analysis tools may miss.

## Instructions

1. Search for hardcoded secrets: API keys, tokens, passwords, private keys in source files
2. Check for unsafe eval/exec patterns (`eval()`, `exec()`, `os.system()`, `subprocess` with `shell=True`)
3. Look for missing input validation on user-facing endpoints/function parameters
4. Identify use of outdated cryptographic algorithms (MD5, SHA1, DES, RC4)
5. Check for SQL injection vectors (string concatenation in queries)
6. Flag files with overly permissive permissions (chmod 777, mode 0777)
7. Look for debug endpoints or logging of sensitive data

## When to Skip

- No code changes in this iteration
- Project has no security-sensitive paths (pure documentation repos)

## Commit Convention

- Prefix commit messages with `security:`
- Include file paths and issue type in the message

## Output

If issues found: open a PR with fixes. If none found: log "No security issues found" and exit.
